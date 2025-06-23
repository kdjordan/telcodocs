<template>
  <span 
    :class="[
      'inline-flex items-center rounded-full px-2 py-1 text-xs font-medium',
      sizeClasses,
      statusClasses
    ]"
  >
    <span 
      v-if="showDot" 
      :class="['mr-1.5 h-1.5 w-1.5 rounded-full', dotClasses]"
    ></span>
    {{ displayText }}
  </span>
</template>

<script setup lang="ts">
interface Props {
  status: string
  size?: 'sm' | 'md' | 'lg'
  showDot?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  showDot: true
})

const statusConfig: Record<string, { text: string; classes: string; dotClasses: string }> = {
  'draft': {
    text: 'Draft',
    classes: 'bg-gray-500/20 text-gray-300',
    dotClasses: 'bg-gray-400'
  },
  'in_progress': {
    text: 'In Progress',
    classes: 'bg-blue-500/20 text-blue-300',
    dotClasses: 'bg-blue-400'
  },
  'pending_approval': {
    text: 'Pending Review',
    classes: 'bg-yellow-500/20 text-yellow-300',
    dotClasses: 'bg-yellow-400'
  },
  'requires_action': {
    text: 'Action Required',
    classes: 'bg-orange-500/20 text-orange-300',
    dotClasses: 'bg-orange-400'
  },
  'overdue': {
    text: 'Overdue',
    classes: 'bg-red-500/20 text-red-300',
    dotClasses: 'bg-red-400'
  },
  'approved': {
    text: 'Approved',
    classes: 'bg-green-500/20 text-green-300',
    dotClasses: 'bg-green-400'
  },
  'completed': {
    text: 'Completed',
    classes: 'bg-green-500/20 text-green-300',
    dotClasses: 'bg-green-400'
  },
  'rejected': {
    text: 'Rejected',
    classes: 'bg-red-500/20 text-red-300',
    dotClasses: 'bg-red-400'
  },
  'archived': {
    text: 'Archived',
    classes: 'bg-gray-500/20 text-gray-400',
    dotClasses: 'bg-gray-500'
  }
}

const sizeClasses = computed(() => {
  const sizes = {
    sm: 'text-xs px-1.5 py-0.5',
    md: 'text-xs px-2 py-1',
    lg: 'text-sm px-2.5 py-1.5'
  }
  return sizes[props.size]
})

const config = computed(() => 
  statusConfig[props.status] || statusConfig['draft']
)

const statusClasses = computed(() => config.value.classes)
const dotClasses = computed(() => config.value.dotClasses)
const displayText = computed(() => config.value.text)
</script>