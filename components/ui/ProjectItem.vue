<template>
  <div class="flex items-center justify-between p-3 hover:bg-white/5 rounded-lg transition-colors">
    <div class="flex items-center space-x-3">
      <div class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center">
        <span class="text-white text-xs font-semibold">
          {{ project.carrier_name?.charAt(0).toUpperCase() || 'P' }}
        </span>
      </div>
      <div>
        <p class="text-white text-sm font-medium">{{ project.carrier_name || 'Project Name' }}</p>
        <div class="flex items-center space-x-2 mt-1">
          <div class="w-full bg-white/10 rounded-full h-1.5 max-w-[80px]">
            <div 
              class="bg-pink-500 h-1.5 rounded-full transition-all duration-300" 
              :style="{ width: `${progress}%` }"
            ></div>
          </div>
          <span class="text-white/60 text-xs">{{ progress }}%</span>
        </div>
      </div>
    </div>
    
    <div class="text-right">
      <div class="w-2 h-2 rounded-full" :class="statusColor"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  project: any
}

const props = defineProps<Props>()

const progress = computed(() => {
  const status = props.project.status || 'draft'
  const progressMap = {
    'draft': 10,
    'in_progress': 45,
    'pending_approval': 75,
    'approved': 90,
    'completed': 100,
    'rejected': 25
  }
  return progressMap[status as keyof typeof progressMap] || 10
})

const statusColor = computed(() => {
  const status = props.project.status || 'in_progress'
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
</script>