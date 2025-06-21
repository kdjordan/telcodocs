import type { User, UserRole } from '~/types'

export const useAuth = () => {
  const { $supabase } = useNuxtApp()
  const user = useSupabaseUser()
  const profile = useState<User | null>('profile', () => null)
  
  const login = async (email: string, password: string) => {
    const { data, error } = await $supabase.auth.signInWithPassword({
      email,
      password
    })
    
    if (error) throw error
    
    await fetchProfile()
    return data
  }
  
  const register = async (email: string, password: string, fullName: string, tenantId?: string) => {
    console.log('Attempting registration for:', email)
    
    const { data: authData, error: authError } = await $supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName,
          tenant_id: tenantId,
          role: 'end_user'
        }
      }
    })
    
    console.log('Registration response:', { authData, authError })
    
    if (authError) throw authError
    
    return authData
  }
  
  const logout = async () => {
    await $supabase.auth.signOut()
    profile.value = null
    await navigateTo('/auth/login')
  }
  
  const fetchProfile = async () => {
    if (!user.value) return null
    
    const { data, error } = await $supabase
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
  
  return {
    user: readonly(user),
    profile: readonly(profile),
    login,
    register,
    logout,
    fetchProfile,
    hasRole,
    isSuperAdmin,
    isTenantOwner,
    isEndUser
  }
}