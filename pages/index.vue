<template>
  <div class="min-h-screen bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="text-center">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">
          Welcome to TelcoDocs
        </h1>
        <p class="text-xl text-gray-600 mb-8">
          Multi-Tenant Telecom Document Management System
        </p>
        
        <div v-if="tenant" class="bg-white rounded-lg shadow p-6 mb-8">
          <h2 class="text-2xl font-semibold text-gray-900 mb-2">
            {{ tenant.name }}
          </h2>
          <p class="text-gray-600">
            You're viewing the {{ tenant.subdomain }} tenant
          </p>
        </div>
        
        <div v-else class="bg-blue-50 rounded-lg p-6 mb-8">
          <h2 class="text-xl font-semibold text-blue-900 mb-2">
            Main Portal
          </h2>
          <p class="text-blue-700">
            Access your tenant at: {{ tenantAccessUrl }}
          </p>
        </div>
        
        <div class="space-y-4">
          <div v-if="!user">
            <NuxtLink to="/auth/login" class="btn-primary mr-4">
              Sign In
            </NuxtLink>
            <NuxtLink to="/auth/register" class="btn-secondary">
              Register
            </NuxtLink>
          </div>
          
          <div v-else>
            <NuxtLink to="/dashboard" class="btn-primary">
              Go to Dashboard
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { tenant } = useTenant()
const user = useSupabaseUser()
const config = useRuntimeConfig()

// Compute the tenant access URL based on environment
const tenantAccessUrl = computed(() => {
  const appDomain = config.public.appDomain || 'localhost:3000'
  
  // For localhost, always use the base domain from config
  if (appDomain.includes('localhost') || appDomain.includes('127.0.0.1')) {
    return `yourcompany.localhost:3000`
  }
  
  // Production domain
  return `yourcompany.${appDomain}`
})
</script>