export const useSupabaseUser = () => {
  const user = useState('supabase.user', () => null)

  // Only run client-side
  if (process.client) {
    const { $supabase } = useNuxtApp()
    
    if (!$supabase) {
      console.warn('Supabase client not available')
      return user
    }

    // Get current user session
    const getCurrentUser = async () => {
      try {
        const { data: { user: currentUser } } = await $supabase.auth.getUser()
        user.value = currentUser
        return currentUser
      } catch (error) {
        console.error('Error getting user:', error)
        return null
      }
    }

    // Listen for auth changes
    onMounted(() => {
      if ($supabase && $supabase.auth) {
        $supabase.auth.onAuthStateChange((event, session) => {
          user.value = session?.user || null
        })
        
        // Get initial user
        getCurrentUser()
      }
    })
  }

  return user
}