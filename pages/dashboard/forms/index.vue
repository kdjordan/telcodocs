<template>
  <div class="max-w-7xl mx-auto">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold font-heading text-gray-900 mb-2">
        Forms
      </h1>
      <p class="text-gray-600">
        Create and manage your carrier onboarding forms.
      </p>
    </div>

    <!-- Coming Soon Card -->
    <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-12 text-center">
      <div class="w-16 h-16 bg-accent/20 rounded-2xl flex items-center justify-center mx-auto mb-4">
        <svg class="w-8 h-8 text-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
        </svg>
      </div>
      <h3 class="text-xl font-semibold text-gray-900 mb-2">Form Builder</h3>
      <p class="text-gray-600">Form builder functionality coming soon.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'dashboard',
  middleware: 'auth'
})
</script>