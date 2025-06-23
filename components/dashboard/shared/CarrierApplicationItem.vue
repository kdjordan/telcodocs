<template>
  <div class="flex items-center justify-between p-3 hover:bg-white/5 rounded-lg transition-colors">
    <div class="flex items-center space-x-3 min-w-0 flex-1">
      <!-- Carrier Company Icon -->
      <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center flex-shrink-0">
        <span class="text-white text-xs font-semibold">
          {{ getCarrierInitials(application.carrier_company_name) }}
        </span>
      </div>
      
      <div class="min-w-0 flex-1">
        <div class="flex items-center space-x-2">
          <p class="text-white text-sm font-medium truncate">
            {{ application.carrier_company_name || 'Unknown Carrier' }}
          </p>
          <StatusBadge :status="application.status" size="sm" />
        </div>
        
        <div class="flex items-center space-x-4 mt-1">
          <p class="text-white/60 text-xs truncate">
            {{ getStageDisplay(application.current_stage) }}
          </p>
          <span class="text-white/40 text-xs">•</span>
          <p class="text-white/60 text-xs">
            {{ formatRelativeTime(application.updated_at) }}
          </p>
          
          <!-- Team Member Assignment -->
          <template v-if="showTeamMember && application.assigned_to">
            <span class="text-white/40 text-xs">•</span>
            <p class="text-white/60 text-xs truncate">
              {{ getAssignedMemberName(application.assigned_to) }}
            </p>
          </template>
        </div>
      </div>
    </div>
    
    <!-- Quick Actions -->
    <div class="flex items-center space-x-1 ml-2">
      <button 
        @click="$emit('view-details', application)"
        class="p-1.5 hover:bg-white/10 rounded-md transition-colors"
        :title="`View ${application.carrier_company_name} details`"
      >
        <EyeIcon class="w-4 h-4 text-white/60" />
      </button>
      
      <button 
        v-if="needsAttention(application)"
        @click="$emit('take-action', application)"
        class="p-1.5 hover:bg-pink-500/20 bg-pink-500/10 rounded-md transition-colors"
        title="Requires attention"
      >
        <ExclamationTriangleIcon class="w-4 h-4 text-pink-400" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { 
  EyeIcon,
  ExclamationTriangleIcon
} from '@heroicons/vue/24/outline'
import StatusBadge from '~/components/ui/StatusBadge.vue'
import type { Application } from '~/types'

interface Props {
  application: Application
  showTeamMember?: boolean
}

defineProps<Props>()

defineEmits<{
  'view-details': [application: Application]
  'take-action': [application: Application]
}>()

const getCarrierInitials = (companyName: string | null) => {
  if (!companyName) return '?'
  return companyName
    .split(' ')
    .map(word => word.charAt(0).toUpperCase())
    .slice(0, 2)
    .join('')
}

const getStageDisplay = (stage: string | null) => {
  const stageMap: Record<string, string> = {
    'kyc': 'KYC Verification',
    'fusf': 'FUSF Documentation',
    'msa': 'MSA Negotiation',
    'interop': 'Interoperability Testing',
    'completed': 'Completed'
  }
  return stageMap[stage || ''] || 'Initial Review'
}

const formatRelativeTime = (dateString: string) => {
  const date = new Date(dateString)
  const now = new Date()
  const diffMs = now.getTime() - date.getTime()
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24))
  const diffHours = Math.floor(diffMs / (1000 * 60 * 60))
  const diffMinutes = Math.floor(diffMs / (1000 * 60))
  
  if (diffDays > 0) return `${diffDays}d ago`
  if (diffHours > 0) return `${diffHours}h ago`
  if (diffMinutes > 0) return `${diffMinutes}m ago`
  return 'Just now'
}

const getAssignedMemberName = (userId: string) => {
  // TODO: This would come from a team members lookup
  return 'Team Member'
}

const needsAttention = (application: Application) => {
  // Determine if application needs immediate attention
  const urgentStatuses = ['pending_approval', 'requires_action', 'overdue']
  return urgentStatuses.includes(application.status)
}
</script>