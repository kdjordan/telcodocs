<template>
  <div>
    <!-- Loading state -->
    <div v-if="profileLoading" class="flex items-center justify-center min-h-[400px]">
      <div class="text-center">
        <svg class="animate-spin h-8 w-8 mx-auto text-pink-500" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <p class="mt-2 text-white/60">Loading dashboard...</p>
      </div>
    </div>
    
    <!-- Main Dashboard -->
    <div v-else class="space-y-6">

      <!-- Stats Cards Row -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 lg:gap-4">
        <StatsCard 
          title="Total Projects" 
          :value="stats.totalApplicants.toString()" 
          change="+5% this month"
          :icon="FolderIcon"
        />
        <StatsCard 
          title="Total Task" 
          :value="stats.pendingApproval.toString()" 
          change="+12% this month"
          :icon="ClockIcon"
        />
        <StatsCard 
          title="In Reviews" 
          :value="'23'" 
          change="+12% this month"
          :icon="EyeIcon"
        />
        <StatsCard 
          title="Completed Tasks" 
          :value="stats.completed.toString()" 
          change="+8% this month"
          :icon="CheckCircleIcon"
        />
      </div>

      <!-- Main Dashboard Grid - Mobile Optimized -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 lg:gap-6">
        <!-- Today's Tasks - Full width on mobile -->
        <div class="lg:col-span-1">
          <TodaysTasks :tasks="recentApplications" :loading="loading" />
        </div>
        
        <!-- Performance Chart - Full width on mobile -->
        <div class="lg:col-span-1">
          <PerformanceChart :stats="stats" />
        </div>
        
        <!-- Projects List + Upgrade - Full width on mobile -->
        <div class="lg:col-span-1 space-y-4 lg:space-y-6">
          <ProjectsList :projects="recentApplications" />
          <UpgradePrompt :trial-days-left="trialDaysLeft" :trial-progress="trialProgress" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Application } from '~/types'
import { 
  FolderIcon,
  ClockIcon,
  EyeIcon,
  CheckCircleIcon
} from '@heroicons/vue/24/outline'

// Explicit component imports to ensure resolution
import StatsCard from '~/components/ui/StatsCard.vue'
import TodaysTasks from '~/components/ui/TodaysTasks.vue'
import PerformanceChart from '~/components/ui/PerformanceChart.vue'
import ProjectsList from '~/components/ui/ProjectsList.vue'
import UpgradePrompt from '~/components/ui/UpgradePrompt.vue'

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth'
})

const supabase = useSupabaseClient()
const { profile, fetchProfile, logout } = useAuth()
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