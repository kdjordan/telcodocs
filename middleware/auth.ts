export default defineNuxtRouteMiddleware(async (to, from) => {
  try {
    const supabase = useSupabaseClient()
    const user = useSupabaseUser()
    
    // Check if user is authenticated
    const { data: { session }, error } = await supabase.auth.getSession()
    
    if (error) {
      console.error('Auth session error:', error)
      return navigateTo('/auth/login')
    }
    
    if (!session) {
      // Preserve the intended destination
      return navigateTo(`/auth/login?redirect=${encodeURIComponent(to.fullPath)}`)
    }
  
  // Optionally check user role for specific routes
  if (to.meta.requiresRole) {
    const { data: profile } = await supabase
      .from('users')
      .select('role')
      .eq('id', user.value?.id)
      .single()
    
    if (!profile || !to.meta.requiresRole.includes(profile.role)) {
      throw createError({
        statusCode: 403,
        statusMessage: 'Access denied'
      })
    }
  }
  } catch (error) {
    console.error('Auth middleware error:', error)
    // On error, redirect to login with intended destination
    return navigateTo(`/auth/login?redirect=${encodeURIComponent(to.fullPath)}`)
  }
})