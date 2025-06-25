<template>
  <div class="space-y-6">
    <!-- Carrier Pipeline Metrics Row -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-3 lg:gap-4">
      <CarrierMetricsCard 
        title="Active Carriers" 
        :value="metrics.activeCarriers" 
        change="+5% this month"
        :icon="BuildingOfficeIcon"
        variant="default"
      />
      <CarrierMetricsCard 
        title="Pending Approvals" 
        :value="metrics.pendingApprovals" 
        change="+12% this month"
        :icon="ClockIcon"
        variant="default"
      />
      <CarrierMetricsCard 
        title="Completed This Month" 
        :value="metrics.completedThisMonth" 
        change="+23% vs last month"
        :icon="CheckCircleIcon"
        variant="default"
      />
      <CarrierMetricsCard 
        title="Team Performance" 
        :value="metrics.teamEfficiency" 
        change="+8% this month"
        :icon="UsersIcon"
        variant="default"
      />
    </div>

    <!-- Half Width Dashboard Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 lg:gap-6">
      <!-- Carriers Requiring Attention -->
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
      
      <!-- Team Activity Feed -->
      <TeamActivityFeed 
        :activities="recentActivities"
        :loading="activitiesLoading"
        @view-all="$emit('view-activities')"
      />
      
      <!-- Pipeline Overview -->
      <PipelineOverview 
        :pipeline-data="pipelineData"
        :loading="loading"
        @view-stage="$emit('view-stage', $event)"
      />

      <!-- Team Management -->
      <TeamManagementCard 
        :team-members="teamMembers"
        :loading="teamLoading"
        @manage-team="$emit('manage-team')"
        @invite-member="$emit('invite-member')"
      />

      <!-- Form Templates - Span 2 columns -->
      <div class="lg:col-span-2">
        <FormTemplatesCard 
          :templates="formTemplates"
          :loading="templatesLoading"
          @create-template="$emit('create-template')"
          @edit-template="$emit('edit-template', $event)"
        />
      </div>
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

interface Props {
  metrics: DashboardMetrics
  urgentCarriers: Application[]
  recentActivities: Activity[]
  pipelineData: PipelineData
  teamMembers: TeamMember[]
  formTemplates: FormTemplate[]
  loading: boolean
  activitiesLoading: boolean
  teamLoading: boolean
  templatesLoading: boolean
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
}>()
</script>