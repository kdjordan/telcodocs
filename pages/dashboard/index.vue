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
      <!-- Welcome Header -->
      <div v-if="isOwner" class="mb-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-white mb-1">
              Welcome back, Alicia !
            </h1>
            <p class="text-white/60">
              Here's what's happening at Perfect Vox today
            </p>
          </div>
          <div class="text-right">
            <ClientOnly>
              <p class="text-sm text-white/60 mb-1">{{ currentDate }}</p>
              <template #fallback>
                <p class="text-sm text-white/60 mb-1">Loading...</p>
              </template>
            </ClientOnly>
            <p class="text-xs text-pink-400">Enterprise Plan</p>
          </div>
        </div>
      </div>
      
      <!-- Organization Owner Dashboard -->
      <OwnerDashboardLayout
        v-if="isOwner"
        :metrics="dashboardMetrics"
        :urgent-carriers="urgentCarriers"
        :recent-activities="recentActivities"
        :pipeline-data="pipelineData"
        :team-members="teamMembers"
        :form-templates="formTemplates"
        :loading="loading"
        :activities-loading="activitiesLoading"
        :team-loading="teamLoading"
        :templates-loading="templatesLoading"
        @view-urgent="handleViewUrgent"
        @view-activities="handleViewActivities"
        @view-stage="handleViewStage"
        @manage-team="handleManageTeam"
        @invite-member="handleInviteMember"
        @create-template="handleCreateTemplate"
        @edit-template="handleEditTemplate"
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

// Inline mock data for screenshot
const mockDashboardData = {
  metrics: {
    activeCarriers: 47,
    pendingApprovals: 12,
    completedThisMonth: 23,
    teamEfficiency: 92
  },
  urgentCarriers: [
    {
      id: '1',
      tenant_id: 'mock-tenant',
      carrier_name: 'Verizon Business',
      carrier_company_name: 'Verizon Communications Inc.',
      carrier_email: 'enterprise@verizon.com',
      status: 'pending_approval',
      current_stage: 'msa',
      priority: 'high',
      assigned_to: 'sarah-id',
      assigned_at: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString(),
      created_at: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      last_activity_at: new Date(Date.now() - 3 * 60 * 60 * 1000).toISOString(),
      metadata: { dealValue: 450000 }
    },
    {
      id: '2',
      tenant_id: 'mock-tenant',
      carrier_name: 'AT&T Enterprise',
      carrier_company_name: 'AT&T Inc.',
      carrier_email: 'wholesale@att.com',
      status: 'requires_action',
      current_stage: 'fusf',
      priority: 'urgent',
      assigned_to: 'mike-id',
      assigned_at: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000).toISOString(),
      created_at: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000).toISOString(),
      last_activity_at: new Date(Date.now() - 1 * 60 * 60 * 1000).toISOString(),
      metadata: { dealValue: 325000 }
    }
  ],
  recentActivities: [
    {
      id: '1',
      type: 'approval_granted',
      user_name: 'Sarah Johnson',
      user_role: 'admin',
      description: 'Approved MSA redlines',
      carrier_name: 'Verizon Business',
      timestamp: new Date(Date.now() - 15 * 60 * 1000).toISOString(),
      metadata: { changeCount: 3 }
    },
    {
      id: '2',
      type: 'document_signed',
      user_name: 'Michael Chen',
      user_role: 'member',
      description: 'Completed FUSF documentation',
      carrier_name: 'AT&T Enterprise',
      timestamp: new Date(Date.now() - 32 * 60 * 1000).toISOString()
    }
  ],
  pipelineData: {
    kyc: 14,
    fusf: 12,
    msa: 15,
    interop: 6
  },
  teamMembers: [
    {
      id: 'sarah-id',
      name: 'Sarah Johnson',
      role: 'admin',
      email: 'sarah@teleconnect.com',
      assignedCarriers: 12,
      performance: 96,
      status: 'active'
    },
    {
      id: 'mike-id',
      name: 'Michael Chen',
      role: 'member',
      email: 'michael@teleconnect.com',
      assignedCarriers: 8,
      performance: 92,
      status: 'active'
    }
  ],
  formTemplates: [
    {
      id: '1',
      name: 'Know Your Customer (KYC)',
      stage: 'kyc',
      lastModified: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
      status: 'active',
      fields: 28,
      submissions: 156
    }
  ],
  revenueData: {
    mrr: 24500,
    growth: 28,
    seats: 8,
    churnRate: 2.3
  }
}

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth'
})

const supabase = useSupabaseClient()
const { profile, fetchProfile, logout } = useAuth()
const { tenant } = useTenant()

const loading = ref(false)
const profileLoading = ref(true)
const activitiesLoading = ref(false)
const teamLoading = ref(false)
const templatesLoading = ref(false)
const revenueLoading = ref(false)

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

// Date formatting for header
const currentDate = computed(() => {
  if (!process.client) return ''
  const now = new Date()
  return now.toLocaleDateString('en-US', { 
    weekday: 'long', 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  })
})

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
  // Immediately populate with impressive mock data for screenshot-ready dashboard
  dashboardMetrics.value = mockDashboardData.metrics
  urgentCarriers.value = mockDashboardData.urgentCarriers as Application[]
  recentActivities.value = mockDashboardData.recentActivities
  pipelineData.value = mockDashboardData.pipelineData
  teamMembers.value = mockDashboardData.teamMembers
  formTemplates.value = mockDashboardData.formTemplates
  revenueData.value = mockDashboardData.revenueData
  
  // All data is instantly available - no loading states needed
  console.log('Dashboard loaded with mock data:', {
    carriers: dashboardMetrics.value.activeCarriers,
    activities: recentActivities.value.length,
    team: teamMembers.value.length
  })
}


onMounted(async () => {
  // Load mock data immediately for instant display
  fetchOwnerDashboardData()
  
  try {
    await fetchProfile()
  } catch (error) {
    console.error('Error fetching profile:', error)
  } finally {
    profileLoading.value = false
  }
})
</script>