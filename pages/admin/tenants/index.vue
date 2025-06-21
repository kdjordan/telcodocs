<template>
  <div class="min-h-screen bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="mb-8 flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Tenant Management</h1>
          <p class="text-gray-600 mt-2">Manage all telecom company accounts</p>
        </div>
        <NuxtLink 
          to="/admin/tenants/new"
          class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
        >
          Create New Tenant
        </NuxtLink>
      </div>

      <!-- Tenants Table -->
      <div class="bg-white shadow overflow-hidden sm:rounded-md">
        <div class="px-4 py-5 sm:p-6">
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Company
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Subdomain
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Users
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Applications
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Created
                  </th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="tenant in tenants" :key="tenant.id" class="hover:bg-gray-50">
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div>
                      <div class="text-sm font-medium text-gray-900">{{ tenant.name }}</div>
                      <div class="text-sm text-gray-500">{{ tenant.domain || 'No domain set' }}</div>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                      {{ tenant.subdomain }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ tenant.user_count || 0 }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ tenant.application_count || 0 }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(tenant.created_at) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                    <NuxtLink 
                      :to="`/admin/tenants/${tenant.id}`"
                      class="text-blue-600 hover:text-blue-900"
                    >
                      View
                    </NuxtLink>
                    <NuxtLink 
                      :to="`/admin/tenants/${tenant.id}/edit`"
                      class="text-green-600 hover:text-green-900"
                    >
                      Edit
                    </NuxtLink>
                    <button 
                      @click="confirmDeleteTenant(tenant)"
                      class="text-red-600 hover:text-red-900"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
                <tr v-if="loading">
                  <td colspan="6" class="px-6 py-4 text-center text-gray-500">
                    Loading tenants...
                  </td>
                </tr>
                <tr v-if="!loading && tenants.length === 0">
                  <td colspan="6" class="px-6 py-4 text-center text-gray-500">
                    No tenants found. Create your first tenant to get started.
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
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

const tenants = ref<any[]>([])
const loading = ref(true)

// Fetch tenants with user and application counts
const fetchTenants = async () => {
  loading.value = true
  try {
    const { data, error } = await $supabase
      .from('tenants')
      .select(`
        *,
        user_count:users(count),
        application_count:applications(count)
      `)
      .order('created_at', { ascending: false })

    if (error) throw error

    // Process the counts (Supabase returns them as arrays)
    tenants.value = (data || []).map(tenant => ({
      ...tenant,
      user_count: tenant.user_count?.[0]?.count || 0,
      application_count: tenant.application_count?.[0]?.count || 0
    }))
  } catch (error) {
    console.error('Error fetching tenants:', error)
  } finally {
    loading.value = false
  }
}

// Delete tenant confirmation
const confirmDeleteTenant = (tenant: any) => {
  if (confirm(`Are you sure you want to delete "${tenant.name}"? This action cannot be undone.`)) {
    deleteTenant(tenant.id)
  }
}

// Delete tenant
const deleteTenant = async (tenantId: string) => {
  try {
    const { error } = await $supabase
      .from('tenants')
      .delete()
      .eq('id', tenantId)

    if (error) throw error

    // Refresh the list
    await fetchTenants()
  } catch (error) {
    console.error('Error deleting tenant:', error)
    alert('Error deleting tenant. Please try again.')
  }
}

// Format date helper
const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString()
}

// Load tenants on mount
onMounted(() => {
  fetchTenants()
})
</script>