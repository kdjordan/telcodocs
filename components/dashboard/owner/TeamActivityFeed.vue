<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-white font-semibold text-lg">Team Activity</h3>
      <div class="flex items-center space-x-2">
        <select 
          v-model="timeFilter"
          class="bg-white/5 border border-white/10 rounded-lg px-3 py-1.5 text-white text-sm focus:outline-none focus:ring-2 focus:ring-pink-500"
        >
          <option value="today">Today</option>
          <option value="week">This Week</option>
          <option value="month">This Month</option>
        </select>
      </div>
    </div>
    
    <div v-if="loading" class="text-center py-8">
      <svg class="animate-spin h-6 w-6 mx-auto text-pink-500" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>
    
    <div v-else-if="filteredActivities.length > 0" class="space-y-4">
      <ActivityItem
        v-for="activity in displayActivities"
        :key="activity.id"
        :activity="activity"
      />
      
      <div v-if="filteredActivities.length > maxDisplay" class="pt-4 border-t border-white/10">
        <button 
          @click="$emit('view-all')"
          class="w-full text-center text-pink-400 hover:text-pink-300 text-sm font-medium transition-colors"
        >
          View all activity
        </button>
      </div>
    </div>
    
    <div v-else class="text-center py-8">
      <div class="w-12 h-12 bg-white/5 rounded-lg flex items-center justify-center mx-auto mb-3">
        <ClockIcon class="w-6 h-6 text-white/40" />
      </div>
      <p class="text-white/60 text-sm">No team activity {{ timeFilterText }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ClockIcon } from '@heroicons/vue/24/outline'
import ActivityItem from '~/components/dashboard/shared/ActivityItem.vue'

interface Activity {
  id: string
  type: 'carrier_update' | 'document_signed' | 'assignment_changed' | 'approval_granted' | 'message_sent'
  user_name: string
  user_role: string
  description: string
  carrier_name?: string
  timestamp: string
  metadata?: Record<string, any>
}

interface Props {
  activities: Activity[]
  loading: boolean
  maxDisplay?: number
}

const props = withDefaults(defineProps<Props>(), {
  maxDisplay: 8
})

defineEmits<{
  'view-all': []
}>()

const timeFilter = ref('today')

const timeFilterText = computed(() => {
  const filterMap = {
    today: 'today',
    week: 'this week', 
    month: 'this month'
  }
  return filterMap[timeFilter.value as keyof typeof filterMap]
})

const filteredActivities = computed(() => {
  const now = new Date()
  const filterDate = new Date()
  
  switch (timeFilter.value) {
    case 'today':
      filterDate.setHours(0, 0, 0, 0)
      break
    case 'week':
      filterDate.setDate(now.getDate() - 7)
      break
    case 'month':
      filterDate.setMonth(now.getMonth() - 1)
      break
  }
  
  return props.activities.filter(activity => 
    new Date(activity.timestamp) >= filterDate
  ).sort((a, b) => 
    new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime()
  )
})

const displayActivities = computed(() => 
  filteredActivities.value.slice(0, props.maxDisplay)
)
</script>