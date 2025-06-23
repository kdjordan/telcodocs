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
    
    <!-- Role-Based Dashboard -->
    <div v-else>
      <!-- Organization Owner Dashboard -->
      <OwnerDashboardLayout
        v-if="isOwner"
        :metrics="dashboardMetrics"
        :urgent-carriers="urgentCarriers"
        :recent-activities="recentActivities"
        :pipeline-data="pipelineData"
        :team-members="teamMembers"
        :form-templates="formTemplates"
        :revenue-data="revenueData"
        :loading="loading"
        :activities-loading="activitiesLoading"
        :team-loading="teamLoading"
        :templates-loading="templatesLoading"
        :revenue-loading="revenueLoading"
        @view-urgent="handleViewUrgent"
        @view-activities="handleViewActivities"
        @view-stage="handleViewStage"
        @manage-team="handleManageTeam"
        @invite-member="handleInviteMember"
        @create-template="handleCreateTemplate"
        @edit-template="handleEditTemplate"
        @view-billing="handleViewBilling"
      />
      
      <!-- TODO: Add other role dashboards -->
      <!-- AdminDashboardLayout v-else-if="isAdmin" -->
      <!-- MemberDashboardLayout v-else-if="isMember" -->
      <!-- CarrierDashboardLayout v-else-if="isCarrier" -->
      
      <!-- Fallback for unrecognized roles -->
      <div v-else class="text-center py-12">
        <p class="text-white/60">Dashboard not available for your role.</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Application } from '~/types'

// Import role-specific dashboard components
import OwnerDashboardLayout from '~/components/dashboard/owner/OwnerDashboardLayout.vue'

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth'
})

const supabase = useSupabaseClient()
const { profile, fetchProfile, logout } = useAuth()
const { tenant } = useTenant()

const loading = ref(true)
const profileLoading = ref(true)
const activitiesLoading = ref(true)
const teamLoading = ref(true)
const templatesLoading = ref(true)
const revenueLoading = ref(true)

// Organization Owner specific data
const dashboardMetrics = ref({
  activeCarriers: 0,
  pendingApprovals: 0,
  completedThisMonth: 0,
  teamEfficiency: 85
})

const urgentCarriers = ref<Application[]>([])
const recentActivities = ref<any[]>([])
const pipelineData = ref({
  kyc: 0,
  fusf: 0,
  msa: 0,
  interop: 0
})
const teamMembers = ref<any[]>([])
const formTemplates = ref<any[]>([])
const revenueData = ref({
  mrr: 0,
  growth: 0,
  seats: 1,
  churnRate: 5
})

// Role detection
const isOwner = computed(() => 
  profile.value?.role === 'tenant_owner' || 
  profile.value?.organization_role === 'owner'
)
const isAdmin = computed(() => 
  profile.value?.organization_role === 'admin'
)
const isMember = computed(() => 
  profile.value?.organization_role === 'member'
)
const isCarrier = computed(() => 
  profile.value?.role === 'end_user' && !profile.value?.organization_role
)

// Event handlers for Organization Owner dashboard
const handleViewUrgent = () => {
  navigateTo('/dashboard/applications?filter=urgent')
}

const handleViewActivities = () => {
  navigateTo('/dashboard/activities')
}

const handleViewStage = (stage: string) => {
  navigateTo(`/dashboard/applications?stage=${stage}`)
}

const handleManageTeam = () => {
  navigateTo('/dashboard/team')
}

const handleInviteMember = () => {
  navigateTo('/dashboard/team/invite')
}

const handleCreateTemplate = () => {
  navigateTo('/dashboard/forms/create')
}

const handleEditTemplate = (template: any) => {
  navigateTo(`/dashboard/forms/${template.id}/edit`)
}

const handleViewBilling = () => {
  navigateTo('/dashboard/billing')
}

const fetchOwnerDashboardData = async () => {
  if (!tenant.value) {
    loading.value = false
    return
  }
  
  loading.value = true
  
  try {
    // Fetch applications for metrics and urgent carriers
    const { data: applications, error: appError } = await supabase
      .from('applications')
      .select('*')
      .eq('tenant_id', tenant.value.id)
      .order('created_at', { ascending: false })
    
    if (appError) throw appError
    const apps = applications || []
    
    // Calculate metrics
    const now = new Date()
    const thisMonth = now.getMonth()
    const thisYear = now.getFullYear()
    
    dashboardMetrics.value = {
      activeCarriers: apps.filter(app => !['completed', 'archived'].includes(app.status)).length,
      pendingApprovals: apps.filter(app => app.status === 'pending_approval').length,
      completedThisMonth: apps.filter(app => {
        const createdDate = new Date(app.created_at)
        return app.status === 'completed' && 
               createdDate.getMonth() === thisMonth && 
               createdDate.getFullYear() === thisYear
      }).length,
      teamEfficiency: 85 // Mock calculation
    }
    
    // Get urgent carriers (requiring attention)
    urgentCarriers.value = apps.filter(app => 
      ['pending_approval', 'requires_action', 'overdue'].includes(app.status)
    ).slice(0, 10)
    
    // Calculate pipeline data
    pipelineData.value = {
      kyc: apps.filter(app => app.current_stage === 'kyc').length,
      fusf: apps.filter(app => app.current_stage === 'fusf').length,
      msa: apps.filter(app => app.current_stage === 'msa').length,
      interop: apps.filter(app => app.current_stage === 'interop').length
    }
    
    // Mock data for other sections (would come from actual API calls)
    recentActivities.value = [
      {
        id: '1',
        type: 'carrier_update',
        user_name: 'John Smith',
        user_role: 'admin',
        description: 'Updated KYC documentation',
        carrier_name: 'TeleCarrier Inc',
        timestamp: new Date().toISOString()
      }
    ]
    
    teamMembers.value = [
      {
        id: '1',
        name: 'Sarah Johnson',
        role: 'admin',
        assignedCarriers: 5,
        performance: 92,
        status: 'active'
      }
    ]
    
    formTemplates.value = [
      {
        id: '1',
        name: 'KYC Verification Form',
        stage: 'kyc',
        lastModified: new Date().toISOString(),
        status: 'active'
      }
    ]
    
    revenueData.value = {
      mrr: 149,
      growth: 15,
      seats: 1,
      churnRate: 3
    }
    
  } catch (error) {
    console.error('Error fetching owner dashboard data:', error)
  } finally {
    loading.value = false
    activitiesLoading.value = false
    teamLoading.value = false
    templatesLoading.value = false
    revenueLoading.value = false
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
  
  // Fetch role-appropriate dashboard data
  if (isOwner.value) {
    await fetchOwnerDashboardData()
  }
  // TODO: Add other role data fetching
})
</script>