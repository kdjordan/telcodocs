<template>
  <div class="space-y-6">
    <!-- Carrier Pipeline Metrics Row -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 lg:gap-4">
      <CarrierMetricsCard 
        title="Active Carriers" 
        :value="metrics.activeCarriers" 
        change="+5% this month"
        :icon="BuildingOfficeIcon"
        variant="info"
        secondary-metric="In pipeline"
      />
      <CarrierMetricsCard 
        title="Pending Approvals" 
        :value="metrics.pendingApprovals" 
        change="+12% this month"
        :icon="ClockIcon"
        variant="warning"
        secondary-metric="Need review"
      />
      <CarrierMetricsCard 
        title="Completed This Month" 
        :value="metrics.completedThisMonth" 
        change="+23% vs last month"
        :icon="CheckCircleIcon"
        variant="success"
        secondary-metric="Onboarded"
      />
      <CarrierMetricsCard 
        title="Team Performance" 
        :value="metrics.teamEfficiency" 
        change="+8% this month"
        :icon="UsersIcon"
        variant="default"
        secondary-metric="Avg cycle time: 12d"
      />
    </div>

    <!-- Main Dashboard Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 lg:gap-6">
      <!-- Carriers Requiring Attention -->
      <div class="lg:col-span-1">
        <CarrierPipelineCard
          title="Requiring Attention"
          :carriers="urgentCarriers"
          :loading="loading"
          :max-display="5"
          empty-title="All caught up!"
          empty-message="No carriers need immediate attention."
          :empty-icon="CheckCircleIcon"
          @view-all="$emit('view-urgent')"
        />
      </div>
      
      <!-- Team Activity Feed -->
      <div class="lg:col-span-1">
        <TeamActivityFeed 
          :activities="recentActivities"
          :loading="activitiesLoading"
          @view-all="$emit('view-activities')"
        />
      </div>
      
      <!-- Right Column: Pipeline Overview + Team Management -->
      <div class="lg:col-span-1 space-y-4 lg:space-y-6">
        <PipelineOverview 
          :pipeline-data="pipelineData"
          :loading="loading"
          @view-stage="$emit('view-stage', $event)"
        />
        <TeamManagementCard 
          :team-members="teamMembers"
          :loading="teamLoading"
          @manage-team="$emit('manage-team')"
          @invite-member="$emit('invite-member')"
        />
      </div>
    </div>

    <!-- Secondary Grid: Form Templates + Revenue Analytics -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 lg:gap-6">
      <FormTemplatesCard 
        :templates="formTemplates"
        :loading="templatesLoading"
        @create-template="$emit('create-template')"
        @edit-template="$emit('edit-template', $event)"
      />
      <RevenueAnalytics 
        :revenue-data="revenueData"
        :loading="revenueLoading"
        @view-billing="$emit('view-billing')"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { 
  BuildingOfficeIcon,
  ClockIcon,
  CheckCircleIcon,
  UsersIcon
} from '@heroicons/vue/24/outline'

import CarrierMetricsCard from '~/components/dashboard/owner/CarrierMetricsCard.vue'
import CarrierPipelineCard from '~/components/dashboard/shared/CarrierPipelineCard.vue'
import TeamActivityFeed from '~/components/dashboard/owner/TeamActivityFeed.vue'
import PipelineOverview from '~/components/dashboard/owner/PipelineOverview.vue'
import TeamManagementCard from '~/components/dashboard/owner/TeamManagementCard.vue'
import FormTemplatesCard from '~/components/dashboard/owner/FormTemplatesCard.vue'
import RevenueAnalytics from '~/components/dashboard/owner/RevenueAnalytics.vue'

import type { Application } from '~/types'

interface DashboardMetrics {
  activeCarriers: number
  pendingApprovals: number
  completedThisMonth: number
  teamEfficiency: number
}

interface PipelineData {
  kyc: number
  fusf: number
  msa: number
  interop: number
}

interface TeamMember {
  id: string
  name: string
  role: string
  avatar?: string
  assignedCarriers: number
  performance: number
}

interface Activity {
  id: string
  type: string
  user_name: string
  user_role: string
  description: string
  carrier_name?: string
  timestamp: string
  metadata?: Record<string, any>
}

interface FormTemplate {
  id: string
  name: string
  stage: string
  lastModified: string
  status: 'active' | 'draft'
}

interface RevenueData {
  mrr: number
  growth: number
  seats: number
  churnRate: number
}

interface Props {
  metrics: DashboardMetrics
  urgentCarriers: Application[]
  recentActivities: Activity[]
  pipelineData: PipelineData
  teamMembers: TeamMember[]
  formTemplates: FormTemplate[]
  revenueData: RevenueData
  loading: boolean
  activitiesLoading: boolean
  teamLoading: boolean
  templatesLoading: boolean
  revenueLoading: boolean
}

defineProps<Props>()

defineEmits<{
  'view-urgent': []
  'view-activities': []
  'view-stage': [stage: string]
  'manage-team': []
  'invite-member': []
  'create-template': []
  'edit-template': [template: FormTemplate]
  'view-billing': []
}>()
</script>