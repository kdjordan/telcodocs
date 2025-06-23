<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-white font-semibold text-lg">Pipeline Overview</h3>
      <button 
        class="text-pink-400 hover:text-pink-300 text-sm font-medium transition-colors"
        @click="$emit('view-full-pipeline')"
      >
        View All
      </button>
    </div>
    
    <div v-if="loading" class="text-center py-8">
      <svg class="animate-spin h-6 w-6 mx-auto text-pink-500" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>
    
    <div v-else class="space-y-4">
      <!-- Pipeline Stages -->
      <div 
        v-for="stage in stages" 
        :key="stage.key"
        @click="$emit('view-stage', stage.key)"
        class="flex items-center justify-between p-3 hover:bg-white/5 rounded-lg transition-colors cursor-pointer"
      >
        <div class="flex items-center space-x-3">
          <div :class="['w-8 h-8 rounded-lg flex items-center justify-center', stage.bgClass]">
            <component :is="stage.icon" :class="['w-4 h-4', stage.iconClass]" />
          </div>
          <div>
            <p class="text-white text-sm font-medium">{{ stage.name }}</p>
            <p class="text-white/60 text-xs">{{ stage.description }}</p>
          </div>
        </div>
        
        <div class="flex items-center space-x-2">
          <span class="text-white text-lg font-semibold">{{ stage.count }}</span>
          <ChevronRightIcon class="w-4 h-4 text-white/40" />
        </div>
      </div>
      
      <!-- Total Summary -->
      <div class="pt-4 border-t border-white/10">
        <div class="flex items-center justify-between">
          <span class="text-white/60 text-sm">Total Active Carriers</span>
          <span class="text-white font-semibold">{{ totalCarriers }}</span>
        </div>
        <div class="flex items-center justify-between mt-1">
          <span class="text-white/60 text-sm">Avg. Cycle Time</span>
          <span class="text-white font-semibold">{{ avgCycleTime }}d</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {
  IdentificationIcon,
  DocumentTextIcon,
  PencilSquareIcon,
  WifiIcon,
  ChevronRightIcon
} from '@heroicons/vue/24/outline'

interface PipelineData {
  kyc: number
  fusf: number
  msa: number
  interop: number
}

interface Props {
  pipelineData: PipelineData
  loading: boolean
}

defineProps<Props>()

defineEmits<{
  'view-stage': [stage: string]
  'view-full-pipeline': []
}>()

const stages = computed(() => [
  {
    key: 'kyc',
    name: 'KYC Verification',
    description: 'Know Your Customer documentation',
    count: props.pipelineData.kyc,
    icon: IdentificationIcon,
    bgClass: 'bg-blue-500/20',
    iconClass: 'text-blue-400'
  },
  {
    key: 'fusf',
    name: 'FUSF Documentation',
    description: 'Federal Universal Service Fund',
    count: props.pipelineData.fusf,
    icon: DocumentTextIcon,
    bgClass: 'bg-green-500/20',
    iconClass: 'text-green-400'
  },
  {
    key: 'msa',
    name: 'MSA Negotiation',
    description: 'Master Service Agreement',
    count: props.pipelineData.msa,
    icon: PencilSquareIcon,
    bgClass: 'bg-yellow-500/20',
    iconClass: 'text-yellow-400'
  },
  {
    key: 'interop',
    name: 'Interoperability',
    description: 'Technical integration testing',
    count: props.pipelineData.interop,
    icon: WifiIcon,
    bgClass: 'bg-purple-500/20',
    iconClass: 'text-purple-400'
  }
])

const totalCarriers = computed(() => 
  Object.values(props.pipelineData).reduce((sum, count) => sum + count, 0)
)

const avgCycleTime = computed(() => {
  // Mock calculation - would be based on actual data
  return 12
})
</script>