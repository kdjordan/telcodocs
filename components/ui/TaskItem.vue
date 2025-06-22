<template>
  <div class="flex items-center justify-between p-3 hover:bg-white/5 rounded-lg transition-colors">
    <div class="flex items-center space-x-3">
      <div class="w-3 h-3 rounded-full" :class="statusColor"></div>
      <div>
        <p class="text-white text-sm font-medium">{{ task.carrier_name || 'Review Application' }}</p>
        <p class="text-white/60 text-xs">{{ task.carrier_email || 'Application' }} • {{ formatDate(task.created_at) }}</p>
      </div>
    </div>
    <div class="flex items-center space-x-2">
      <span class="text-xs text-white/50">{{ getTimeAgo(task.created_at) }}</span>
      <button class="p-1 hover:bg-white/10 rounded transition-colors">
        <EllipsisHorizontalIcon class="w-4 h-4 text-white/60" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { EllipsisHorizontalIcon } from '@heroicons/vue/24/outline'

interface Props {
  task: any
}

const props = defineProps<Props>()

const statusColor = computed(() => {
  const status = props.task.status || 'in_progress'
  const colors = {
    'draft': 'bg-blue-400',
    'in_progress': 'bg-blue-400',
    'pending_approval': 'bg-orange-400',
    'approved': 'bg-green-400',
    'completed': 'bg-green-400',
    'rejected': 'bg-red-400'
  }
  return colors[status as keyof typeof colors] || 'bg-blue-400'
})

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric'
  })
}

const getTimeAgo = (date: string) => {
  const now = new Date()
  const taskDate = new Date(date)
  const diffInHours = Math.floor((now.getTime() - taskDate.getTime()) / (1000 * 60 * 60))
  
  if (diffInHours < 1) return 'Now'
  if (diffInHours < 24) return `${diffInHours}h`
  const diffInDays = Math.floor(diffInHours / 24)
  return `${diffInDays}d`
}
</script>