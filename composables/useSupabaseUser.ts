export const useSupabaseUser = () => {
  const { $supabase } = useNuxtApp()
  const user = useState('supabase.user', () => null)

  // Get current user session
  const getCurrentUser = async () => {
    const { data: { user: currentUser } } = await $supabase.auth.getUser()
    user.value = currentUser
    return currentUser
  }

  // Listen for auth changes
  onMounted(() => {
    $supabase.auth.onAuthStateChange((event, session) => {
      user.value = session?.user || null
    })
    
    // Get initial user
    getCurrentUser()
  })

  return user
}