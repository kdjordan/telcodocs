<template>
  <div>
    <!-- Loading state while profile is being fetched -->
    <div v-if="profileLoading" class="flex items-center justify-center min-h-[400px]">
      <div class="text-center">
        <svg class="animate-spin h-8 w-8 mx-auto text-blue-600" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="mt-2 text-gray-600">Loading dashboard...</p>
      </div>
    </div>
    
    <!-- Main content -->
    <div v-else>
      <div class="mb-8">
        <h1 class="text-2xl font-bold text-gray-900">Dashboard Overview</h1>
        <p class="mt-1 text-sm text-gray-600">
          Welcome back{{ profile?.full_name ? ', ' + profile.full_name : '' }}
        </p>
      </div>
    
    <!-- Stats Cards -->
    <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 mb-8">
      <div class="card">
        <div class="flex items-center">
          <div class="flex-shrink-0 p-3 bg-blue-100 rounded-lg">
            <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
          <div class="ml-5 w-0 flex-1">
            <dl>
              <dt class="text-sm font-medium text-gray-500 truncate">
                Total Applicants
              </dt>
              <dd class="text-lg font-semibold text-gray-900">
                {{ stats.totalApplicants }}
              </dd>
            </dl>
          </div>
        </div>
      </div>
      
      <div class="card">
        <div class="flex items-center">
          <div class="flex-shrink-0 p-3 bg-yellow-100 rounded-lg">
            <svg class="w-6 h-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div class="ml-5 w-0 flex-1">
            <dl>
              <dt class="text-sm font-medium text-gray-500 truncate">
                Pending Approval
              </dt>
              <dd class="text-lg font-semibold text-gray-900">
                {{ stats.pendingApproval }}
              </dd>
            </dl>
          </div>
        </div>
      </div>
      
      <div class="card">
        <div class="flex items-center">
          <div class="flex-shrink-0 p-3 bg-green-100 rounded-lg">
            <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div class="ml-5 w-0 flex-1">
            <dl>
              <dt class="text-sm font-medium text-gray-500 truncate">
                Completed
              </dt>
              <dd class="text-lg font-semibold text-gray-900">
                {{ stats.completed }}
              </dd>
            </dl>
          </div>
        </div>
      </div>
      
      <div class="card">
        <div class="flex items-center">
          <div class="flex-shrink-0 p-3 bg-purple-100 rounded-lg">
            <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
          </div>
          <div class="ml-5 w-0 flex-1">
            <dl>
              <dt class="text-sm font-medium text-gray-500 truncate">
                Active Carriers
              </dt>
              <dd class="text-lg font-semibold text-gray-900">
                {{ stats.activeCarriers }}
              </dd>
            </dl>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Recent Applicants -->
    <div class="card">
      <h2 class="text-lg font-semibold mb-4">Recent Applicants</h2>
      
      <div v-if="loading" class="text-center py-8">
        <div class="inline-flex items-center">
          <svg class="animate-spin h-5 w-5 mr-3 text-gray-500" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          Loading...
        </div>
      </div>
      
      <div v-else-if="recentApplications.length > 0" class="overflow-hidden">
        <table class="min-w-full divide-y divide-gray-200">
          <thead>
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Carrier
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Stage
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Status
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Created
              </th>
              <th class="relative px-6 py-3">
                <span class="sr-only">Actions</span>
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="app in recentApplications" :key="app.id">
              <td class="px-6 py-4 whitespace-nowrap">
                <div>
                  <div class="text-sm font-medium text-gray-900">
                    {{ app.carrier_name }}
                  </div>
                  <div class="text-sm text-gray-500">
                    {{ app.carrier_email }}
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span class="text-sm text-gray-900">{{ app.current_stage.toUpperCase() }}</span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span
                  class="inline-flex px-2 py-1 text-xs font-semibold rounded-full"
                  :class="getStatusClass(app.status)"
                >
                  {{ app.status }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ formatDate(app.created_at) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <NuxtLink
                  :to="`/dashboard/applications/${app.id}`"
                  class="text-blue-600 hover:text-blue-900"
                >
                  View
                </NuxtLink>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div v-else class="text-center py-8 text-gray-500">
        No applicants yet
      </div>
    </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Application } from '~/types'

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth'
})

const { $supabase } = useNuxtApp()
const { profile, fetchProfile } = useAuth()
const { tenant } = useTenant()

const loading = ref(true)
const profileLoading = ref(true)
const recentApplications = ref<Application[]>([])
const stats = ref({
  totalApplicants: 0,
  pendingApproval: 0,
  completed: 0,
  activeCarriers: 0
})

const getStatusClass = (status: string) => {
  const classes = {
    'draft': 'bg-gray-100 text-gray-800',
    'in_progress': 'bg-blue-100 text-blue-800',
    'pending_approval': 'bg-yellow-100 text-yellow-800',
    'approved': 'bg-green-100 text-green-800',
    'rejected': 'bg-red-100 text-red-800',
    'completed': 'bg-green-100 text-green-800'
  }
  return classes[status as keyof typeof classes] || 'bg-gray-100 text-gray-800'
}

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const fetchDashboardData = async () => {
  // Allow dashboard to load even without tenant
  loading.value = true
  
  try {
    if (!tenant.value) {
      // Set empty state if no tenant
      recentApplications.value = []
      stats.value = {
        totalApplicants: 0,
        pendingApproval: 0,
        completed: 0,
        activeCarriers: 0
      }
      loading.value = false
      return
    }
    
    // Fetch recent applications
    const { data: applications, error: appError } = await $supabase
      .from('applications')
      .select('*')
      .eq('tenant_id', tenant.value.id)
      .order('created_at', { ascending: false })
      .limit(10)
    
    if (appError) throw appError
    recentApplications.value = applications || []
    
    // Calculate stats
    const { count: total } = await $supabase
      .from('applications')
      .select('*', { count: 'exact', head: true })
      .eq('tenant_id', tenant.value.id)
    
    const { count: pending } = await $supabase
      .from('applications')
      .select('*', { count: 'exact', head: true })
      .eq('tenant_id', tenant.value.id)
      .eq('status', 'pending_approval')
    
    const { count: completed } = await $supabase
      .from('applications')
      .select('*', { count: 'exact', head: true })
      .eq('tenant_id', tenant.value.id)
      .eq('status', 'completed')
    
    const { count: carriers } = await $supabase
      .from('applications')
      .select('carrier_email', { count: 'exact', head: true })
      .eq('tenant_id', tenant.value.id)
    
    stats.value = {
      totalApplicants: total || 0,
      pendingApproval: pending || 0,
      completed: completed || 0,
      activeCarriers: carriers || 0
    }
  } catch (error) {
    console.error('Error fetching dashboard data:', error)
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  try {
    await fetchProfile()
  } catch (error) {
    console.error('Error fetching profile:', error)
  } finally {
    profileLoading.value = false
  }
  
  await fetchDashboardData()
})
</script>