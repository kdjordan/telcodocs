<template>
  <div class="min-h-screen bg-gray-50 py-12">
    <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-4">
          Set Up Your Company
        </h1>
        <p class="text-lg text-gray-600">
          Create your carrier onboarding portal and start with a 7-day free trial
        </p>
      </div>

      <div class="bg-white shadow rounded-lg">
        <div class="px-6 py-4 border-b border-gray-200">
          <h3 class="text-lg font-medium text-gray-900">Company Information</h3>
        </div>
        
        <form @submit.prevent="createTenant" class="p-6 space-y-6">
          <div>
            <label for="companyName" class="block text-sm font-medium text-gray-700">
              Company Name *
            </label>
            <input
              id="companyName"
              v-model="form.companyName"
              type="text"
              required
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              placeholder="Acme Telecom Inc."
            >
          </div>

          <div>
            <label for="subdomain" class="block text-sm font-medium text-gray-700">
              Choose Your Subdomain *
            </label>
            <div class="mt-1 flex rounded-md shadow-sm">
              <input
                id="subdomain"
                v-model="form.subdomain"
                type="text"
                required
                pattern="[a-z0-9-]+"
                class="flex-1 min-w-0 block w-full px-3 py-2 border border-gray-300 rounded-l-md focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                placeholder="acme"
                @input="checkSubdomainAvailability"
                @blur="validateSubdomain"
              >
              <span class="inline-flex items-center px-3 py-2 border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-sm rounded-r-md">
                .{{ config.public.appDomain }}
              </span>
            </div>
            <p class="mt-2 text-sm text-gray-500">
              Only lowercase letters, numbers, and hyphens allowed. This will be your carrier portal URL.
            </p>
            <p v-if="subdomainStatus === 'checking'" class="mt-1 text-sm text-yellow-600">
              Checking availability...
            </p>
            <p v-if="subdomainStatus === 'available'" class="mt-1 text-sm text-green-600">
              ✓ Subdomain is available
            </p>
            <p v-if="subdomainStatus === 'taken'" class="mt-1 text-sm text-red-600">
              ✗ Subdomain is already taken
            </p>
            <p v-if="subdomainError" class="mt-1 text-sm text-red-600">{{ subdomainError }}</p>
          </div>

          <div>
            <label for="contactEmail" class="block text-sm font-medium text-gray-700">
              Contact Email
            </label>
            <input
              id="contactEmail"
              v-model="form.contactEmail"
              type="email"
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              placeholder="admin@acme.com"
            >
            <p class="mt-2 text-sm text-gray-500">
              This email will be used for billing and important notifications
            </p>
          </div>

          <!-- Free Plan Info -->
          <div class="bg-blue-50 rounded-lg p-6">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
              </div>
              <div class="ml-3">
                <h3 class="text-sm font-medium text-blue-800">
                  Starting with 7-Day Free Trial
                </h3>
                <div class="mt-2 text-sm text-blue-700">
                  <ul class="space-y-1">
                    <li>• 7 days free trial - no credit card required</li>
                    <li>• Unlimited carrier onboardings</li>
                    <li>• Unlimited custom forms</li>
                    <li>• Full platform access</li>
                    <li>• Email support</li>
                  </ul>
                  <p class="mt-2 font-medium">
                    Select a subscription plan before your trial ends to keep your portal active.
                  </p>
                </div>
              </div>
            </div>
          </div>

          <div v-if="error" class="rounded-md bg-red-50 p-4">
            <div class="text-sm text-red-800">{{ error }}</div>
          </div>

          <div class="flex justify-end space-x-3 pt-6 border-t border-gray-200">
            <button
              type="submit"
              :disabled="loading || !isFormValid"
              class="px-6 py-3 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {{ loading ? 'Creating...' : 'Create My Portal' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false,
  middleware: 'auth'
})

const { $supabase } = useNuxtApp()
const { profile } = useAuth()
const router = useRouter()
const config = useRuntimeConfig()

const form = reactive({
  companyName: '',
  subdomain: '',
  contactEmail: ''
})

const loading = ref(false)
const error = ref('')
const subdomainStatus = ref<'idle' | 'checking' | 'available' | 'taken'>('idle')
const subdomainError = ref('')
const checkTimeout = ref<NodeJS.Timeout>()

// Auto-fill contact email with user's email
onMounted(() => {
  if (profile.value?.email) {
    form.contactEmail = profile.value.email
  }
})

// Form validation
const isFormValid = computed(() => {
  return form.companyName.trim() && 
         form.subdomain.trim() && 
         !subdomainError.value &&
         subdomainStatus.value === 'available'
})

// Validate subdomain format
const validateSubdomain = () => {
  const subdomain = form.subdomain.toLowerCase()
  
  if (!subdomain) {
    subdomainError.value = ''
    return
  }
  
  // Check format
  if (!/^[a-z0-9-]+$/.test(subdomain)) {
    subdomainError.value = 'Only lowercase letters, numbers, and hyphens allowed'
    return
  }
  
  // Check length
  if (subdomain.length < 2 || subdomain.length > 30) {
    subdomainError.value = 'Subdomain must be between 2 and 30 characters'
    return
  }
  
  // Check reserved words
  const reserved = ['www', 'api', 'admin', 'app', 'mail', 'ftp', 'localhost', 'telodox']
  if (reserved.includes(subdomain)) {
    subdomainError.value = 'This subdomain is reserved'
    return
  }
  
  subdomainError.value = ''
  form.subdomain = subdomain
}

// Check subdomain availability with debouncing
const checkSubdomainAvailability = () => {
  validateSubdomain()
  
  if (subdomainError.value || !form.subdomain) {
    subdomainStatus.value = 'idle'
    return
  }

  // Clear existing timeout
  if (checkTimeout.value) {
    clearTimeout(checkTimeout.value)
  }

  subdomainStatus.value = 'checking'

  // Debounce the API call
  checkTimeout.value = setTimeout(async () => {
    try {
      const { data } = await $fetch('/api/tenants/check-subdomain', {
        method: 'POST',
        body: { subdomain: form.subdomain }
      })

      subdomainStatus.value = data.available ? 'available' : 'taken'
    } catch (err) {
      console.error('Error checking subdomain:', err)
      subdomainStatus.value = 'idle'
    }
  }, 500)
}

// Create tenant
const createTenant = async () => {
  loading.value = true
  error.value = ''
  
  try {
    const { data } = await $fetch('/api/tenants/create-free', {
      method: 'POST',
      body: {
        companyName: form.companyName,
        subdomain: form.subdomain,
        contactEmail: form.contactEmail || profile.value?.email
      }
    })
    
    if (data?.tenant) {
      // Redirect to dashboard
      await router.push('/dashboard')
    }
  } catch (err: any) {
    error.value = err.data?.message || 'Failed to create company'
  } finally {
    loading.value = false
  }
}
</script>