<template>
  <div>
    <!-- Loading state -->
    <div v-if="profileLoading" class="flex items-center justify-center min-h-[400px]">
      <div class="text-center">
        <svg class="animate-spin h-8 w-8 mx-auto text-primary" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="mt-2 text-textSecondary">Loading dashboard...</p>
      </div>
    </div>
    
    <!-- Main Dashboard -->
    <div v-else class="max-w-7xl mx-auto">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold font-heading text-textPrimary mb-2">
          Good {{ getTimeOfDay() }}, {{ getFirstName() }}!
        </h1>
        <p class="text-textSecondary">
          Here's what's happening with your carrier onboarding today.
        </p>
      </div>

      <!-- Bento Grid Layout -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Primary Stats -->
        <div class="bg-cardBg rounded-2xl shadow-card p-6 transition-all duration-300 ease-in-out hover:-translate-y-0.5 hover:shadow-lg min-h-[120px]">
          <div class="flex items-center justify-between mb-3">
            <div class="flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.196-2.121M9 6a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </div>
            <span class="text-xs text-textSecondary font-medium">Total</span>
          </div>
          <div class="metric text-textPrimary">{{ stats.totalApplicants }}</div>
          <p class="text-sm text-textSecondary mt-1">Active applicants</p>
        </div>

        <div class="bg-cardBg rounded-2xl shadow-card p-6 transition-all duration-300 ease-in-out hover:-translate-y-0.5 hover:shadow-lg min-h-[120px]">
          <div class="flex items-center justify-between mb-3">
            <div class="flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <span class="text-xs text-textPrimary font-medium">Pending</span>
          </div>
          <div class="metric">{{ stats.pendingApproval }}</div>
          <p class="text-sm text-textPrimary mt-1">Awaiting approval</p>
        </div>

        <div class="bg-cardBg rounded-2xl shadow-card p-6 transition-all duration-300 ease-in-out hover:-translate-y-0.5 hover:shadow-card-hover min-h-[120px]">
          <div class="flex items-center justify-between mb-3">
            <div class="flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <span class="text-xs text-textPrimary font-medium">Complete</span>
          </div>
          <div class="metric">{{ stats.completed }}</div>
          <p class="text-sm text-textPrimary mt-1">Fully onboarded</p>
        </div>

        <div class="bg-cardBg rounded-2xl shadow-card p-6 transition-all duration-300 ease-in-out hover:-translate-y-0.5 hover:shadow-card-hover min-h-[120px]">
          <div class="flex items-center justify-between mb-3">
            <div class="flex items-center justify-center">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
              </svg>
            </div>
            <span class="text-xs text-textSecondary font-medium">Active</span>
          </div>
          <div class="metric text-textPrimary">{{ stats.activeCarriers }}</div>
          <p class="text-sm text-textSecondary mt-1">Carrier partners</p>
        </div>
      </div>

      <!-- Secondary Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Recent Activity -->
        <div class="lg:col-span-2 bg-cardBg rounded-2xl shadow-card p-6 transition-all duration-300 ease-in-out hover:-translate-y-0.5 hover:shadow-card-hover min-h-[300px]">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold font-heading text-textPrimary">Recent Applicants</h2>
            <div class="flex items-center space-x-2">
              <button class="text-xs text-textSecondary hover:text-textPrimary transition-colors">
                View all
              </button>
              <svg class="w-4 h-4 text-textSecondary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </div>
          </div>
          
          <div v-if="loading" class="text-center py-12">
            <svg class="animate-spin h-6 w-6 mx-auto text-primary" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          </div>
          
          <div v-else-if="recentApplications.length > 0" class="space-y-4">
            <div v-for="app in recentApplications.slice(0, 5)" :key="app.id" 
                 class="flex items-center justify-between p-4 bg-cardBg rounded-2xl hover:bg-white/10 transition-colors">
              <div class="flex items-center space-x-4">
                <div class="avatar bg-gradient-to-br from-primary to-accent flex items-center justify-center text-textPrimary font-semibold">
                  {{ app.carrier_name.charAt(0).toUpperCase() }}
                </div>
                <div>
                  <h4 class="font-semibold text-textPrimary">{{ app.carrier_name }}</h4>
                  <p class="text-sm text-textSecondary">{{ app.carrier_email }}</p>
                </div>
              </div>
              
              <div class="text-right">
                <div class="flex items-center space-x-2 mb-1">
                  <span class="status-indicator" :class="getStatusIndicator(app.status)"></span>
                  <span class="text-sm font-medium text-textPrimary capitalize">{{ app.status.replace('_', ' ') }}</span>
                </div>
                <p class="text-xs text-textSecondary">{{ formatDate(app.created_at) }}</p>
              </div>
            </div>
          </div>
          
          <div v-else class="text-center py-12">
            <div class="w-16 h-16 bg-cardBg rounded-2xl flex items-center justify-center mx-auto mb-4">
              <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.196-2.121M9 6a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </div>
            <h3 class="text-lg font-semibold text-textPrimary mb-2">No applicants yet</h3>
            <p class="text-textSecondary">Your first carrier applications will appear here.</p>
          </div>
        </div>

        <!-- Trial Status & Quick Actions -->
        <div class="space-y-6">
          <!-- Trial Status Card -->
          <div class="bg-cardBg rounded-2xl shadow-card p-6 transition-all duration-300 ease-in-out hover:-translate-y-0.5 hover:shadow-card-hover">
            <div class="flex items-center justify-between mb-4">
              <h3 class="font-bold text-textPrimary">Trial Status</h3>
              <span class="text-xs text-textSecondary">{{ trialDaysLeft }} days left</span>
            </div>
            
            <div class="mb-4">
              <div class="progress-bar mb-2">
                <div class="progress-fill" :style="{ width: trialProgress + '%' }"></div>
              </div>
              <p class="text-sm text-textPrimary">{{ trialProgress }}% of trial used</p>
            </div>
            
            <button class="w-full bg-white/10 text-textPrimary font-semibold py-2.5 px-4 rounded-xl hover:bg-primary/20 transition-colors border border-white/20">
              Upgrade Plan
            </button>
          </div>

          <!-- Quick Actions -->
          <div class="bg-cardBg rounded-2xl shadow-card p-6 transition-all duration-300 ease-in-out hover:-translate-y-0.5 hover:shadow-card-hover">
            <h3 class="font-bold text-textPrimary mb-4">Quick Actions</h3>
            <div class="space-y-3">
              <button class="w-full text-left p-3 bg-cardBg rounded-xl hover:bg-white/10 transition-colors group">
                <div class="flex items-center space-x-3">
                  <div class="w-8 h-8 bg-primary/10 rounded-lg flex items-center justify-center group-hover:bg-primary/20 transition-colors">
                    <svg class="w-4 h-4 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                    </svg>
                  </div>
                  <span class="font-medium text-textPrimary">Create Form</span>
                </div>
              </button>
              
              <button class="w-full text-left p-3 bg-cardBg rounded-xl hover:bg-white/10 transition-colors group">
                <div class="flex items-center space-x-3">
                  <div class="w-8 h-8 bg-accent/10 rounded-lg flex items-center justify-center group-hover:bg-accent/20 transition-colors">
                    <svg class="w-4 h-4 text-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192L5.636 18.364" />
                    </svg>
                  </div>
                  <span class="font-medium text-textPrimary">Invite Carrier</span>
                </div>
              </button>
              
              <button class="w-full text-left p-3 bg-cardBg rounded-xl hover:bg-white/10 transition-colors group">
                <div class="flex items-center space-x-3">
                  <div class="w-8 h-8 bg-warning/10 rounded-lg flex items-center justify-center group-hover:bg-warning/20 transition-colors">
                    <svg class="w-4 h-4 text-warning" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </div>
                  <span class="font-medium text-textPrimary">Settings</span>
                </div>
              </button>
            </div>
          </div>
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

const supabase = useSupabaseClient()
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

const getStatusIndicator = (status: string) => {
  const classes = {
    'draft': 'status-info',
    'in_progress': 'status-info', 
    'pending_approval': 'status-warning',
    'approved': 'status-success',
    'rejected': 'status-warning',
    'completed': 'status-success'
  }
  return classes[status as keyof typeof classes] || 'status-info'
}

const getTimeOfDay = () => {
  const hour = new Date().getHours()
  if (hour < 12) return 'morning'
  if (hour < 17) return 'afternoon'
  return 'evening'
}

const getFirstName = () => {
  return profile.value?.full_name?.split(' ')[0] || 'there'
}

// Trial calculations
const trialDaysLeft = computed(() => {
  if (!tenant.value?.trial_ends_at) return 0
  const trialEnd = new Date(tenant.value.trial_ends_at)
  const now = new Date()
  const diffTime = trialEnd.getTime() - now.getTime()
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
  return Math.max(0, diffDays)
})

const trialProgress = computed(() => {
  if (!tenant.value?.trial_ends_at) return 0
  const trialEnd = new Date(tenant.value.trial_ends_at)
  const trialStart = new Date(trialEnd.getTime() - (7 * 24 * 60 * 60 * 1000)) // 7 days ago
  const now = new Date()
  const totalDuration = trialEnd.getTime() - trialStart.getTime()
  const usedDuration = now.getTime() - trialStart.getTime()
  return Math.min(100, Math.max(0, Math.round((usedDuration / totalDuration) * 100)))
})

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
    const { data: applications, error: appError } = await supabase
      .from('applications')
      .select('*')
      .eq('tenant_id', tenant.value.id)
      .order('created_at', { ascending: false })
      .limit(10)
    
    if (appError) throw appError
    recentApplications.value = applications || []
    
    // Calculate stats
    const { count: total } = await supabase
      .from('applications')
      .select('*', { count: 'exact', head: true })
      .eq('tenant_id', tenant.value.id)
    
    const { count: pending } = await supabase
      .from('applications')
      .select('*', { count: 'exact', head: true })
      .eq('tenant_id', tenant.value.id)
      .eq('status', 'pending_approval')
    
    const { count: completed } = await supabase
      .from('applications')
      .select('*', { count: 'exact', head: true })
      .eq('tenant_id', tenant.value.id)
      .eq('status', 'completed')
    
    const { count: carriers } = await supabase
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