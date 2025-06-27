export const useLaunchConfig = () => {
  const config = useRuntimeConfig()
  
  // Check if app is in "coming soon" mode (production before launch)
  const isComingSoon = computed(() => {
    // Use environment variable or default to true in production
    return config.public.comingSoonMode === 'true' || 
           (config.public.comingSoonMode !== 'false' && process.env.NODE_ENV === 'production')
  })
  
  // Get the appropriate auth routes based on mode
  const getAuthRoute = (type: 'login' | 'register') => {
    if (isComingSoon.value) {
      return '/early-access'
    }
    return `/auth/${type}`
  }
  
  return {
    isComingSoon,
    getAuthRoute
  }
}