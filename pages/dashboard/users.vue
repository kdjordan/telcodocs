<template>
  <div class="max-w-7xl mx-auto">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold font-heading text-gray-900 mb-2">
        Users
      </h1>
      <p class="text-gray-600">
        Manage users and permissions for your tenant.
      </p>
    </div>

    <!-- Coming Soon Card -->
    <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-12 text-center">
      <div class="w-16 h-16 bg-primary/20 rounded-2xl flex items-center justify-center mx-auto mb-4">
        <svg class="w-8 h-8 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
        </svg>
      </div>
      <h3 class="text-xl font-semibold text-gray-900 mb-2">User Management</h3>
      <p class="text-gray-600">User management functionality coming soon.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'dashboard',
  middleware: 'auth'
})
</script>