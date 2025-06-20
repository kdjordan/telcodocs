export default defineNuxtRouteMiddleware(async (to, from) => {
  const { $supabase } = useNuxtApp()
  const user = useSupabaseUser()
  
  // Check if user is authenticated
  const { data: { session } } = await $supabase.auth.getSession()
  
  if (!session) {
    return navigateTo('/auth/login')
  }
  
  // Optionally check user role for specific routes
  if (to.meta.requiresRole) {
    const { data: profile } = await $supabase
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
})