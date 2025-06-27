<template>
  <div class="min-h-screen bg-black flex items-center justify-center">
    <div class="text-center">
      <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-pink-500 mx-auto mb-4"></div>
      <p class="text-white">Verifying your email...</p>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false,
  auth: false
})

const router = useRouter()
const route = useRoute()
const { handlePostConfirmation } = useAuth()

onMounted(async () => {
  // Handle the email confirmation
  const { error } = route.query
  
  if (error) {
    console.error('Email verification error:', error)
    // Redirect to login with error message
    await router.push('/auth/login?error=verification_failed')
  } else {
    // Email verified successfully
    // Check if we need to complete registration
    await handlePostConfirmation()
    
    // Show success message and redirect to login
    if (typeof window !== 'undefined') {
      // You could use vue-sonner here to show a success toast
      console.log('Email verified successfully! Please log in.')
    }
    
    // Redirect to login
    await router.push('/auth/login?verified=true')
  }
})
</script>