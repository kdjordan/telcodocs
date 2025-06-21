<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8 text-center">
      <div>
        <h2 class="mt-6 text-3xl font-extrabold text-gray-900">
          Check your email
        </h2>
        <p class="mt-2 text-sm text-gray-600">
          We've sent you a verification link to confirm your email address.
        </p>
      </div>
      
      <div class="mt-8">
        <NuxtLink
          to="/auth/login"
          class="font-medium text-blue-600 hover:text-blue-500"
        >
          Return to sign in
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false
})
</script>