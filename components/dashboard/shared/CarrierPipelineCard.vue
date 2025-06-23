<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-white font-semibold text-lg">{{ title }}</h3>
      <div class="flex items-center space-x-2">
        <button class="p-2 hover:bg-white/10 rounded-lg transition-colors">
          <MagnifyingGlassIcon class="w-4 h-4 text-white/60" />
        </button>
        <button class="p-2 hover:bg-white/10 rounded-lg transition-colors">
          <FunnelIcon class="w-4 h-4 text-white/60" />
        </button>
      </div>
    </div>
    
    <div v-if="loading" class="text-center py-12">
      <svg class="animate-spin h-6 w-6 mx-auto text-pink-500" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>
    
    <div v-else-if="carriers.length > 0" class="space-y-3">
      <CarrierApplicationItem 
        v-for="carrier in displayCarriers" 
        :key="carrier.id"
        :application="carrier"
        :show-team-member="showTeamMember"
      />
      
      <div v-if="carriers.length > maxDisplay" class="pt-2 border-t border-white/10">
        <button 
          @click="$emit('view-all')"
          class="w-full text-center text-pink-400 hover:text-pink-300 text-sm font-medium transition-colors"
        >
          View all {{ carriers.length }} carriers
        </button>
      </div>
    </div>
    
    <div v-else class="text-center py-12">
      <div class="w-16 h-16 bg-white/5 rounded-xl flex items-center justify-center mx-auto mb-4">
        <component :is="emptyIcon" class="w-8 h-8 text-white/40" />
      </div>
      <h3 class="text-lg font-semibold text-white mb-2">{{ emptyTitle }}</h3>
      <p class="text-white/60">{{ emptyMessage }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { 
  MagnifyingGlassIcon, 
  FunnelIcon,
  CheckCircleIcon,
  ClockIcon
} from '@heroicons/vue/24/outline'
import CarrierApplicationItem from '~/components/dashboard/shared/CarrierApplicationItem.vue'
import type { Application } from '~/types'

interface Props {
  title: string
  carriers: Application[]
  loading: boolean
  maxDisplay?: number
  showTeamMember?: boolean
  emptyTitle?: string
  emptyMessage?: string
  emptyIcon?: any
}

const props = withDefaults(defineProps<Props>(), {
  maxDisplay: 5,
  showTeamMember: true,
  emptyTitle: 'All caught up!',
  emptyMessage: 'No pending applications.',
  emptyIcon: CheckCircleIcon
})

defineEmits<{
  'view-all': []
}>()

const displayCarriers = computed(() => 
  props.carriers.slice(0, props.maxDisplay)
)
</script>