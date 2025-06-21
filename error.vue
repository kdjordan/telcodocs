<template>
  <div class="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
    <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
      <div class="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10 text-center">
        <div class="mb-6">
          <h1 class="text-6xl font-bold text-gray-300">{{ error.statusCode }}</h1>
          <h2 class="mt-2 text-2xl font-semibold text-gray-900">
            {{ error.statusCode === 404 ? 'Page Not Found' : 'Error' }}
          </h2>
          <p class="mt-2 text-gray-600">
            {{ error.statusMessage || getErrorMessage(error.statusCode) }}
          </p>
        </div>
        
        <div class="mt-6 space-y-3">
          <NuxtLink
            v-if="user"
            to="/dashboard"
            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          >
            Go to Dashboard
          </NuxtLink>
          
          <NuxtLink
            v-else
            to="/auth/login"
            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          >
            Sign In
          </NuxtLink>
          
          <NuxtLink
            to="/"
            class="w-full flex justify-center py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          >
            Go to Home
          </NuxtLink>
        </div>
        
        <div class="mt-6 text-sm text-gray-500">
          <p>Need help? Contact support at support@telodox.com</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  error: {
    statusCode: number
    statusMessage?: string
  }
}>()

const user = useSupabaseUser()

const getErrorMessage = (statusCode: number) => {
  const messages: Record<number, string> = {
    404: "The page you're looking for doesn't exist.",
    403: "You don't have permission to access this resource.",
    401: "Please sign in to continue.",
    500: "Something went wrong on our end.",
    503: "Service temporarily unavailable."
  }
  
  return messages[statusCode] || "An unexpected error occurred."
}
</script>