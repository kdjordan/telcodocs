<template>
  <div class="min-h-screen bg-bgLight py-12 px-6">
    <div class="max-w-2xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-8">
        <div class="w-20 h-20 bg-gradient-to-br from-primary to-accent rounded-2xl flex items-center justify-center mx-auto mb-6">
          <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
          </svg>
        </div>
        <h1 class="text-3xl font-bold font-heading text-textPrimary mb-4">
          Set Up Your Company
        </h1>
        <p class="text-lg text-textSecondary">
          Create your carrier onboarding portal and start with a 7-day free trial
        </p>
      </div>

      <!-- Main Card -->
      <div class="bento-card-lg">
        <div class="mb-6">
          <h2 class="text-xl font-bold font-heading text-textPrimary">Company Information</h2>
          <p class="text-textSecondary mt-1">Tell us about your telecom company</p>
        </div>
        
        <form @submit.prevent="createTenant" class="space-y-6">
          <div>
            <label for="companyName" class="block text-sm font-medium text-textPrimary mb-2">
              Company Name *
            </label>
            <input
              id="companyName"
              v-model="form.companyName"
              type="text"
              required
              class="form-input"
              placeholder="Acme Telecom Inc."
            >
          </div>

          <div>
            <label for="subdomain" class="block text-sm font-medium text-textPrimary mb-2">
              Choose Your Subdomain *
            </label>
            <div class="flex rounded-xl overflow-hidden border border-gray-200 bg-white">
              <input
                id="subdomain"
                v-model="form.subdomain"
                type="text"
                required
                pattern="[a-z0-9-]+"
                class="flex-1 px-4 py-3 border-0 focus:outline-none focus:ring-0"
                placeholder="acme"
                @input="checkSubdomainAvailability"
                @blur="validateSubdomain"
              >
              <div class="bg-gray-50 px-4 py-3 text-textSecondary text-sm border-l border-gray-200">
                .{{ config.public.appDomain }}
              </div>
            </div>
            <p class="mt-2 text-sm text-textSecondary">
              Only lowercase letters, numbers, and hyphens allowed. This will be your carrier portal URL.
            </p>
            <div v-if="subdomainStatus === 'checking'" class="mt-2 flex items-center text-sm text-primary">
              <svg class="animate-spin w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Checking availability...
            </div>
            <div v-if="subdomainStatus === 'available'" class="mt-2 flex items-center text-sm text-green-600">
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              Subdomain is available
            </div>
            <div v-if="subdomainStatus === 'taken'" class="mt-2 flex items-center text-sm text-red-600">
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
              Subdomain is already taken
            </div>
            <p v-if="subdomainError" class="mt-2 text-sm text-red-600">{{ subdomainError }}</p>
          </div>

          <div>
            <label for="contactEmail" class="block text-sm font-medium text-textPrimary mb-2">
              Contact Email
            </label>
            <input
              id="contactEmail"
              v-model="form.contactEmail"
              type="email"
              class="form-input"
              placeholder="admin@acme.com"
            >
            <p class="mt-2 text-sm text-textSecondary">
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