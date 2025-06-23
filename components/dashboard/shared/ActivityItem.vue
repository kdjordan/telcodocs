<template>
  <div class="flex items-start space-x-3 p-3 hover:bg-white/5 rounded-lg transition-colors">
    <!-- Activity Icon -->
    <div :class="['w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0', iconBgClass]">
      <component :is="activityIcon" :class="['w-4 h-4', iconColorClass]" />
    </div>
    
    <!-- Activity Content -->
    <div class="min-w-0 flex-1">
      <div class="flex items-center justify-between">
        <p class="text-white text-sm">
          <span class="font-medium">{{ activity.user_name }}</span>
          <span class="text-white/60"> {{ actionText }}</span>
          <span v-if="activity.carrier_name" class="font-medium text-pink-400">
            {{ activity.carrier_name }}
          </span>
        </p>
        <div class="flex items-center space-x-2 ml-2">
          <RoleBadge :role="activity.user_role" size="xs" />
          <span class="text-white/40 text-xs">{{ formatTime(activity.timestamp) }}</span>
        </div>
      </div>
      
      <p v-if="activity.description" class="text-white/60 text-xs mt-1">
        {{ activity.description }}
      </p>
      
      <!-- Metadata Display -->
      <div v-if="hasMetadata" class="flex items-center space-x-2 mt-2">
        <template v-for="(value, key) in displayMetadata" :key="key">
          <span class="inline-flex items-center px-2 py-0.5 rounded text-xs bg-white/5 text-white/70">
            {{ key }}: {{ value }}
          </span>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  DocumentTextIcon,
  PencilSquareIcon,
  UserPlusIcon,
  CheckCircleIcon,
  ChatBubbleLeftRightIcon,
  ArrowPathIcon
} from '@heroicons/vue/24/outline'
import RoleBadge from '~/components/ui/RoleBadge.vue'

interface Activity {
  id: string
  type: 'carrier_update' | 'document_signed' | 'assignment_changed' | 'approval_granted' | 'message_sent' | 'status_changed'
  user_name: string
  user_role: string
  description: string
  carrier_name?: string
  timestamp: string
  metadata?: Record<string, any>
}

interface Props {
  activity: Activity
}

defineProps<Props>()

const activityConfig = {
  carrier_update: {
    icon: PencilSquareIcon,
    text: 'updated carrier',
    bgClass: 'bg-blue-500/20',
    iconClass: 'text-blue-400'
  },
  document_signed: {
    icon: DocumentTextIcon,
    text: 'signed document for',
    bgClass: 'bg-green-500/20',
    iconClass: 'text-green-400'
  },
  assignment_changed: {
    icon: UserPlusIcon,
    text: 'reassigned',
    bgClass: 'bg-purple-500/20',
    iconClass: 'text-purple-400'
  },
  approval_granted: {
    icon: CheckCircleIcon,
    text: 'approved',
    bgClass: 'bg-green-500/20',
    iconClass: 'text-green-400'
  },
  message_sent: {
    icon: ChatBubbleLeftRightIcon,
    text: 'sent message to',
    bgClass: 'bg-yellow-500/20',
    iconClass: 'text-yellow-400'
  },
  status_changed: {
    icon: ArrowPathIcon,
    text: 'changed status for',
    bgClass: 'bg-orange-500/20',
    iconClass: 'text-orange-400'
  }
}

const config = computed(() => 
  activityConfig[props.activity.type as keyof typeof activityConfig] || activityConfig.carrier_update
)

const activityIcon = computed(() => config.value.icon)
const iconBgClass = computed(() => config.value.bgClass)
const iconColorClass = computed(() => config.value.iconClass)
const actionText = computed(() => config.value.text)

const formatTime = (timestamp: string) => {
  const date = new Date(timestamp)
  const now = new Date()
  const diffMs = now.getTime() - date.getTime()
  const diffMinutes = Math.floor(diffMs / (1000 * 60))
  const diffHours = Math.floor(diffMs / (1000 * 60 * 60))
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24))
  
  if (diffDays > 0) return `${diffDays}d`
  if (diffHours > 0) return `${diffHours}h`
  if (diffMinutes > 0) return `${diffMinutes}m`
  return 'now'
}

const hasMetadata = computed(() => 
  props.activity.metadata && Object.keys(props.activity.metadata).length > 0
)

const displayMetadata = computed(() => {
  if (!props.activity.metadata) return {}
  
  // Only show relevant metadata keys
  const relevantKeys = ['stage', 'document_type', 'previous_assignee']
  const filtered: Record<string, any> = {}
  
  for (const key of relevantKeys) {
    if (props.activity.metadata[key]) {
      filtered[key] = props.activity.metadata[key]
    }
  }
  
  return filtered
})
</script>