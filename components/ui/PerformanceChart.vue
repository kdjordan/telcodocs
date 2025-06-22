<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-white font-semibold text-lg">Performance</h3>
      <select class="bg-white/5 border border-white/10 rounded-lg px-3 py-1 text-white text-sm focus:outline-none focus:ring-2 focus:ring-pink-500">
        <option>This Week</option>
        <option>This Month</option>
        <option>This Year</option>
      </select>
    </div>
    
    <!-- Performance Circle -->
    <div class="relative h-48 mb-4 flex items-center justify-center">
      <div class="relative">
        <!-- Background Circle -->
        <svg class="w-32 h-32 transform -rotate-90" viewBox="0 0 36 36">
          <path
            class="text-white/10"
            stroke="currentColor"
            stroke-width="3"
            fill="none"
            d="M18 2.0845
              a 15.9155 15.9155 0 0 1 0 31.831
              a 15.9155 15.9155 0 0 1 0 -31.831"
          />
          <!-- Progress Circle -->
          <path
            class="text-pink-500"
            stroke="currentColor"
            stroke-width="3"
            fill="none"
            stroke-linecap="round"
            :stroke-dasharray="`${performancePercentage}, 100`"
            d="M18 2.0845
              a 15.9155 15.9155 0 0 1 0 31.831
              a 15.9155 15.9155 0 0 1 0 -31.831"
          />
        </svg>
        
        <!-- Center Text -->
        <div class="absolute inset-0 flex items-center justify-center">
          <div class="text-center">
            <div class="text-3xl font-bold text-white">{{ performancePercentage }}%</div>
            <div class="text-white/60 text-sm">+8% vs last week</div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Performance Metrics -->
    <div class="grid grid-cols-5 gap-2 text-center">
      <div v-for="metric in metrics" :key="metric.label">
        <div class="text-white/40 text-xs">{{ metric.label }}</div>
        <div class="text-white text-sm font-medium">{{ metric.value }}</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  stats: {
    totalApplicants: number
    pendingApproval: number
    completed: number
    activeCarriers: number
  }
}

const props = defineProps<Props>()

const performancePercentage = computed(() => {
  const total = props.stats.totalApplicants
  const completed = props.stats.completed
  return total > 0 ? Math.round((completed / total) * 100) : 86
})

const metrics = computed(() => [
  { label: 'Mon', value: '12' },
  { label: 'Tue', value: '19' },
  { label: 'Wed', value: '15' },
  { label: 'Thu', value: '23' },
  { label: 'Fri', value: '18' }
])
</script>