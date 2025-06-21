<template>
  <div class="min-h-screen bg-gray-50">
    <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="mb-8">
        <div class="flex items-center space-x-4 mb-4">
          <NuxtLink to="/admin/tenants" class="text-gray-500 hover:text-gray-700">
            ← Back to Tenants
          </NuxtLink>
        </div>
        <h1 class="text-3xl font-bold text-gray-900">Create New Tenant</h1>
        <p class="text-gray-600 mt-2">Set up a new telecom company account</p>
      </div>

      <div class="bg-white shadow rounded-lg">
        <div class="px-6 py-4 border-b border-gray-200">
          <h3 class="text-lg font-medium text-gray-900">Tenant Information</h3>
        </div>
        
        <form @submit.prevent="createTenant" class="p-6 space-y-6">
          <div>
            <label for="name" class="block text-sm font-medium text-gray-700">
              Company Name *
            </label>
            <input
              id="name"
              v-model="form.name"
              type="text"
              required
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              placeholder="Acme Telecom Inc."
            >
          </div>

          <div>
            <label for="subdomain" class="block text-sm font-medium text-gray-700">
              Subdomain *
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
                @input="validateSubdomain"
              >
              <span class="inline-flex items-center px-3 py-2 border border-l-0 border-gray-300 bg-gray-50 text-gray-500 text-sm rounded-r-md">
                .telcodocs.com
              </span>
            </div>
            <p class="mt-2 text-sm text-gray-500">
              Only lowercase letters, numbers, and hyphens allowed. This will be your unique URL.
            </p>
            <p v-if="subdomainError" class="mt-1 text-sm text-red-600">{{ subdomainError }}</p>
          </div>

          <div>
            <label for="domain" class="block text-sm font-medium text-gray-700">
              Custom Domain (optional)
            </label>
            <input
              id="domain"
              v-model="form.domain"
              type="text"
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              placeholder="portal.acme.com"
            >
            <p class="mt-2 text-sm text-gray-500">
              Optional custom domain for this tenant's portal
            </p>
          </div>

          <div>
            <label for="primaryColor" class="block text-sm font-medium text-gray-700">
              Primary Brand Color
            </label>
            <input
              id="primaryColor"
              v-model="form.settings.primary_color"
              type="color"
              class="mt-1 block w-16 h-10 border border-gray-300 rounded-md"
            >
          </div>

          <div class="border-t border-gray-200 pt-6">
            <h4 class="text-lg font-medium text-gray-900 mb-4">Workflow Settings</h4>
            
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700">Form Release Mode</label>
                <select
                  v-model="form.settings.workflow_settings.drip_mode"
                  class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="sequential">Sequential (one at a time)</option>
                  <option value="multiple">Multiple (after each approval)</option>
                  <option value="all">All at once</option>
                </select>
              </div>

              <div class="flex items-center">
                <input
                  id="requireApproval"
                  v-model="form.settings.workflow_settings.require_approval"
                  type="checkbox"
                  class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                >
                <label for="requireApproval" class="ml-2 block text-sm text-gray-900">
                  Require owner approval between stages
                </label>
              </div>
            </div>
          </div>

          <div v-if="error" class="rounded-md bg-red-50 p-4">
            <div class="text-sm text-red-800">{{ error }}</div>
          </div>

          <div class="flex justify-end space-x-3 pt-6 border-t border-gray-200">
            <NuxtLink
              to="/admin/tenants"
              class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </NuxtLink>
            <button
              type="submit"
              :disabled="loading || !!subdomainError"
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
            >
              {{ loading ? 'Creating...' : 'Create Tenant' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'admin',
  layout: 'dashboard'
})

const { $supabase } = useNuxtApp()
const router = useRouter()

const form = reactive({
  name: '',
  subdomain: '',
  domain: '',
  settings: {
    primary_color: '#0066cc',
    workflow_settings: {
      drip_mode: 'sequential',
      require_approval: true
    }
  }
})

const loading = ref(false)
const error = ref('')
const subdomainError = ref('')

// Validate subdomain
const validateSubdomain = () => {
  const subdomain = form.subdomain.toLowerCase()
  
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
  const reserved = ['www', 'api', 'admin', 'app', 'mail', 'ftp', 'localhost', 'telcodocs']
  if (reserved.includes(subdomain)) {
    subdomainError.value = 'This subdomain is reserved'
    return
  }
  
  subdomainError.value = ''
  form.subdomain = subdomain
}

// Create tenant
const createTenant = async () => {
  loading.value = true
  error.value = ''
  
  try {
    // Check if subdomain is already taken
    const { data: existingTenant } = await $supabase
      .from('tenants')
      .select('id')
      .eq('subdomain', form.subdomain)
      .single()
    
    if (existingTenant) {
      error.value = 'This subdomain is already taken'
      loading.value = false
      return
    }
    
    // Create the tenant
    const { data, error: createError } = await $supabase
      .from('tenants')
      .insert({
        name: form.name,
        subdomain: form.subdomain,
        domain: form.domain || null,
        settings: form.settings
      })
      .select()
      .single()
    
    if (createError) throw createError
    
    // Redirect to tenant list
    await router.push('/admin/tenants')
  } catch (err: any) {
    error.value = err.message || 'Failed to create tenant'
  } finally {
    loading.value = false
  }
}
</script>