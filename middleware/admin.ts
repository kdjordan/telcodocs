export default defineNuxtRouteMiddleware(async (to, from) => {
  const { profile, fetchProfile } = useAuth()
  
  // Ensure user is authenticated
  const user = useSupabaseUser()
  if (!user.value) {
    console.log('No authenticated user, redirecting to login')
    return navigateTo('/auth/login')
  }
  
  // Fetch profile if not already loaded
  if (!profile.value) {
    console.log('Fetching user profile...')
    await fetchProfile()
  }
  
  console.log('User profile:', profile.value)
  
  // Check if user is super admin
  if (!profile.value || profile.value.role !== 'super_admin') {
    console.log('User role:', profile.value?.role)
    throw createError({
      statusCode: 403,
      statusMessage: 'Super admin access required'
    })
  }
})