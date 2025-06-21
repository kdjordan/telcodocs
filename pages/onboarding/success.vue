<template>
  <div class="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8 text-center">
      <div v-if="loading">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
        <h2 class="mt-6 text-2xl font-bold text-gray-900">
          Processing your payment...
        </h2>
        <p class="mt-2 text-gray-600">
          Please wait while we set up your account.
        </p>
      </div>

      <div v-else-if="success">
        <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100">
          <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
          </svg>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">
          Payment Successful!
        </h2>
        <p class="mt-2 text-gray-600">
          Welcome to TelcoDocs! Now let's set up your company.
        </p>
        <div class="mt-8">
          <button
            @click="startOnboarding"
            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          >
            Set Up My Company
          </button>
        </div>
      </div>

      <div v-else-if="error">
        <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
          <svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">
          Payment Error
        </h2>
        <p class="mt-2 text-gray-600">
          {{ error }}
        </p>
        <div class="mt-8">
          <NuxtLink
            to="/pricing"
            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
          >
            Try Again
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false,
  middleware: 'auth'
})

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const success = ref(false)
const error = ref('')

const verifyPayment = async () => {
  const sessionId = route.query.session_id as string
  
  if (!sessionId) {
    error.value = 'No session ID provided'
    loading.value = false
    return
  }

  try {
    const { data } = await $fetch('/api/stripe/verify-session', {
      method: 'POST',
      body: { sessionId }
    })

    if (data?.success) {
      success.value = true
    } else {
      error.value = 'Payment verification failed'
    }
  } catch (err: any) {
    error.value = err.data?.message || 'Payment verification failed'
  } finally {
    loading.value = false
  }
}

const startOnboarding = () => {
  router.push('/onboarding/company-setup')
}

onMounted(() => {
  verifyPayment()
})
</script>