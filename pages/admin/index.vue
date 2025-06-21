<template>
  <div class="min-h-screen bg-gray-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Super Admin Dashboard</h1>
        <p class="text-gray-600 mt-2">Platform-wide overview and management</p>
      </div>

      <!-- Stats Overview -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
        <div class="bg-white overflow-hidden shadow rounded-lg">
          <div class="p-5">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center">
                  <span class="text-white text-sm font-semibold">T</span>
                </div>
              </div>
              <div class="ml-5 w-0 flex-1">
                <dl>
                  <dt class="text-sm font-medium text-gray-500 truncate">Total Tenants</dt>
                  <dd class="text-lg font-medium text-gray-900">{{ stats.totalTenants }}</dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div class="bg-white overflow-hidden shadow rounded-lg">
          <div class="p-5">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center">
                  <span class="text-white text-sm font-semibold">U</span>
                </div>
              </div>
              <div class="ml-5 w-0 flex-1">
                <dl>
                  <dt class="text-sm font-medium text-gray-500 truncate">Total Users</dt>
                  <dd class="text-lg font-medium text-gray-900">{{ stats.totalUsers }}</dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div class="bg-white overflow-hidden shadow rounded-lg">
          <div class="p-5">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-purple-500 rounded-full flex items-center justify-center">
                  <span class="text-white text-sm font-semibold">A</span>
                </div>
              </div>
              <div class="ml-5 w-0 flex-1">
                <dl>
                  <dt class="text-sm font-medium text-gray-500 truncate">Total Applications</dt>
                  <dd class="text-lg font-medium text-gray-900">{{ stats.totalApplications }}</dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div class="bg-white overflow-hidden shadow rounded-lg">
          <div class="p-5">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-orange-500 rounded-full flex items-center justify-center">
                  <span class="text-white text-sm font-semibold">F</span>
                </div>
              </div>
              <div class="ml-5 w-0 flex-1">
                <dl>
                  <dt class="text-sm font-medium text-gray-500 truncate">Form Templates</dt>
                  <dd class="text-lg font-medium text-gray-900">{{ stats.totalFormTemplates }}</dd>
                </dl>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Recent Tenants -->
        <div class="bg-white shadow rounded-lg">
          <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-lg font-medium text-gray-900">Recent Tenants</h3>
            <NuxtLink to="/admin/tenants" class="text-blue-600 hover:text-blue-800 text-sm font-medium">
              View all →
            </NuxtLink>
          </div>
          <div class="overflow-hidden">
            <ul class="divide-y divide-gray-200">
              <li v-for="tenant in recentTenants" :key="tenant.id" class="px-6 py-4 hover:bg-gray-50">
                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-sm font-medium text-gray-900">{{ tenant.name }}</p>
                    <p class="text-sm text-gray-500">{{ tenant.subdomain }}.telodox.com</p>
                  </div>
                  <div class="text-right">
                    <p class="text-xs text-gray-500">
                      {{ formatDate(tenant.created_at) }}
                    </p>
                  </div>
                </div>
              </li>
              <li v-if="recentTenants.length === 0" class="px-6 py-8 text-center text-gray-500">
                No tenants yet
              </li>
            </ul>
          </div>
        </div>

        <!-- Quick Actions -->
        <div class="bg-white shadow rounded-lg">
          <div class="px-6 py-4 border-b border-gray-200">
            <h3 class="text-lg font-medium text-gray-900">Quick Actions</h3>
          </div>
          <div class="p-6">
            <div class="space-y-4">
              <NuxtLink 
                to="/admin/tenants/new" 
                class="w-full flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
              >
                Create New Tenant
              </NuxtLink>
              
              <NuxtLink 
                to="/admin/users" 
                class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
              >
                Manage Users
              </NuxtLink>
              
              <NuxtLink 
                to="/admin/analytics" 
                class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
              >
                View Analytics
              </NuxtLink>
            </div>
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

interface AdminStats {
  totalTenants: number
  totalUsers: number
  totalApplications: number
  totalFormTemplates: number
}

const { $supabase } = useNuxtApp()

const stats = ref<AdminStats>({
  totalTenants: 0,
  totalUsers: 0,
  totalApplications: 0,
  totalFormTemplates: 0
})

const recentTenants = ref<any[]>([])

// Fetch dashboard data
const fetchDashboardData = async () => {
  try {
    // Get stats
    const [tenantsResult, usersResult, applicationsResult, formTemplatesResult] = await Promise.all([
      $supabase.from('tenants').select('id', { count: 'exact', head: true }),
      $supabase.from('users').select('id', { count: 'exact', head: true }),
      $supabase.from('applications').select('id', { count: 'exact', head: true }),
      $supabase.from('form_templates').select('id', { count: 'exact', head: true })
    ])

    stats.value = {
      totalTenants: tenantsResult.count || 0,
      totalUsers: usersResult.count || 0,
      totalApplications: applicationsResult.count || 0,
      totalFormTemplates: formTemplatesResult.count || 0
    }

    // Get recent tenants
    const { data: tenants } = await $supabase
      .from('tenants')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(5)

    recentTenants.value = tenants || []
  } catch (error) {
    console.error('Error fetching dashboard data:', error)
  }
}

// Format date helper
const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString()
}

// Load data on mount
onMounted(() => {
  fetchDashboardData()
})
</script>