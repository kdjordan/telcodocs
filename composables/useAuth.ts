import type { User, UserRole } from '~/types'

export const useAuth = () => {
  const user = useSupabaseUser()
  const profile = useState<User | null>('profile', () => null)
  
  const supabase = useSupabaseClient()
  
  const login = async (email: string, password: string) => {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    })
    
    if (error) throw error
    
    await fetchProfile()
    return data
  }
  
  const register = async (email: string, password: string, fullName: string, tenantId?: string) => {
    console.log('Attempting registration for:', email)
    
    const { data: authData, error: authError } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName
        }
      }
    })
    
    console.log('Registration response:', { authData, authError })
    
    if (authError) throw authError
    
    // If signup successful, store registration data for post-confirmation setup
    if (authData.user) {
      // Store user registration data in localStorage to handle after email confirmation
      if (typeof window !== 'undefined') {
        const registrationData = {
          userId: authData.user.id,
          email,
          fullName,
          tenantId,
          role: 'organization_user',
          organizationRole: 'owner'
        }
        localStorage.setItem('pendingRegistration', JSON.stringify(registrationData))
      }
      
      // If immediately confirmed (no email confirmation required), create profile now
      if (authData.session) {
        try {
          await completeRegistration(authData.user.id, email, fullName, tenantId)
        } catch (profileError) {
          console.error('Error creating user profile:', profileError)
          // Don't throw here - user is created in auth, we can handle profile creation later
        }
      }
    }
    
    return authData
  }
  
  const completeRegistration = async (userId: string, email: string, fullName: string, tenantId?: string) => {
    // For organization owners signing up from homepage, create temporary tenant
    let finalTenantId = tenantId
    
    if (!tenantId) {
      const tempTenant = await createTemporaryTenant(userId, email)
      finalTenantId = tempTenant.id
    }
    
    await createUserProfile(userId, {
      email,
      full_name: fullName,
      role: 'organization_user',
      organization_role: 'owner',
      tenant_id: finalTenantId
    })
    
    // Clear pending registration data
    if (typeof window !== 'undefined') {
      localStorage.removeItem('pendingRegistration')
    }
    
    return finalTenantId
  }
  
  const createTemporaryTenant = async (userId: string, email: string) => {
    // Generate a temporary subdomain
    const tempSubdomain = `temp-${userId.slice(0, 8)}`
    
    // Calculate trial end date (7 days from now)
    const trialEndsAt = new Date()
    trialEndsAt.setDate(trialEndsAt.getDate() + 7)
    
    const { data, error } = await supabase
      .from('tenants')
      .insert({
        name: 'Temporary Tenant',
        subdomain: tempSubdomain,
        trial_ends_at: trialEndsAt.toISOString(),
        subscription_status: 'trial',
        settings: {
          contact_email: email,
          workflow_settings: {
            drip_mode: 'sequential',
            require_approval: true
          }
        }
      })
      .select()
      .single()
    
    if (error) throw error
    return data
  }
  
  const createUserProfile = async (userId: string, profileData: {
    email: string
    full_name: string
    role: string
    organization_role: string
    tenant_id?: string
  }) => {
    const { data, error } = await supabase
      .from('users')
      .insert({
        id: userId,
        email: profileData.email,
        full_name: profileData.full_name,
        role: profileData.role,
        organization_role: profileData.organization_role,
        tenant_id: profileData.tenant_id
      })
      .select()
      .single()
    
    if (error) throw error
    return data
  }
  
  const logout = async () => {
    await supabase.auth.signOut()
    profile.value = null
    await navigateTo('/auth/login')
  }
  
  const fetchProfile = async () => {
    if (!user.value) return null
    
    const { data, error } = await supabase
      .from('users')
      .select('*, tenant:tenants(*)')
      .eq('id', user.value.id)
      .single()
    
    if (!error && data) {
      profile.value = data
    }
    
    return data
  }
  
  const hasRole = (role: UserRole | UserRole[]) => {
    if (!profile.value) return false
    
    const roles = Array.isArray(role) ? role : [role]
    return roles.includes(profile.value.role)
  }
  
  const isSuperAdmin = () => hasRole('super_admin')
  const isTenantOwner = () => hasRole('tenant_owner')
  const isEndUser = () => hasRole('end_user')
  
  const handlePostConfirmation = async () => {
    // Check if there's pending registration data
    if (typeof window !== 'undefined') {
      const pendingData = localStorage.getItem('pendingRegistration')
      if (pendingData && user.value) {
        try {
          const data = JSON.parse(pendingData)
          await completeRegistration(data.userId, data.email, data.fullName, data.tenantId)
          console.log('Successfully completed post-confirmation setup')
        } catch (error) {
          console.error('Error completing post-confirmation setup:', error)
        }
      }
    }
  }

  return {
    user: readonly(user),
    profile: readonly(profile),
    login,
    register,
    logout,
    fetchProfile,
    createUserProfile,
    createTemporaryTenant,
    completeRegistration,
    handlePostConfirmation,
    hasRole,
    isSuperAdmin,
    isTenantOwner,
    isEndUser
  }
}