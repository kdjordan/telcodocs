<template>
  <div 
    class="flex items-center justify-between p-3 hover:bg-white/5 rounded-lg transition-colors cursor-pointer"
    @click="$emit('view-details', member)"
  >
    <div class="flex items-center space-x-3 min-w-0 flex-1">
      <!-- Avatar -->
      <div class="relative flex-shrink-0">
        <img 
          v-if="member?.avatar" 
          :src="member.avatar"
          :alt="member?.name || 'Team member'"
          class="w-8 h-8 rounded-full object-cover"
        />
        <div 
          v-else
          class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center"
        >
          <span class="text-white text-xs font-semibold">
            {{ getInitials(member?.name || 'U') }}
          </span>
        </div>
        
        <!-- Status Indicator -->
        <div 
          :class="[
            'absolute -bottom-0.5 -right-0.5 w-2.5 h-2.5 rounded-full border border-black/20',
            statusColor
          ]"
        ></div>
      </div>
      
      <!-- Member Info -->
      <div class="min-w-0 flex-1">
        <div class="flex items-center space-x-2">
          <p class="text-white text-sm font-medium truncate">{{ member?.name || 'Unknown' }}</p>
          <RoleBadge :role="member?.role || 'member'" size="xs" />
        </div>
        <div class="flex items-center space-x-3 mt-0.5">
          <p class="text-white/60 text-xs">
            {{ member?.assignedCarriers || 0 }} carriers
          </p>
          <span class="text-white/40 text-xs">•</span>
          <p class="text-white/60 text-xs">
            {{ member?.performance || 0 }}% performance
          </p>
        </div>
      </div>
    </div>
    
    <!-- Performance Indicator -->
    <div class="flex items-center space-x-2 ml-2">
      <div class="w-12 h-1.5 bg-white/10 rounded-full overflow-hidden">
        <div 
          :style="{ width: `${member?.performance || 0}%` }"
          :class="[
            'h-full rounded-full transition-all duration-300',
            performanceColor
          ]"
        ></div>
      </div>
      <ChevronRightIcon class="w-4 h-4 text-white/40" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChevronRightIcon } from '@heroicons/vue/24/outline'
import RoleBadge from '~/components/ui/RoleBadge.vue'

interface TeamMember {
  id: string
  name: string
  role: string
  avatar?: string
  assignedCarriers: number
  performance: number
  status: 'active' | 'inactive' | 'pending'
}

interface Props {
  member: TeamMember
}

const props = defineProps<Props>()

defineEmits<{
  'view-details': [member: TeamMember]
}>()

const getInitials = (name: string) => {
  return name
    .split(' ')
    .map(word => word.charAt(0).toUpperCase())
    .slice(0, 2)
    .join('')
}

const statusColor = computed(() => {
  const colors = {
    active: 'bg-green-400',
    inactive: 'bg-gray-400',
    pending: 'bg-yellow-400'
  }
  return colors[props.member?.status || 'active']
})

const performanceColor = computed(() => {
  const performance = props.member?.performance || 0
  if (performance >= 80) return 'bg-green-400'
  if (performance >= 60) return 'bg-yellow-400'
  return 'bg-red-400'
})
</script>