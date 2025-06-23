<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-white font-semibold text-lg">Form Templates</h3>
      <button 
        @click="$emit('create-template')"
        class="text-pink-400 hover:text-pink-300 text-sm font-medium transition-colors"
      >
        Create New
      </button>
    </div>
    
    <div v-if="loading" class="text-center py-6">
      <svg class="animate-spin h-6 w-6 mx-auto text-pink-500" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>
    
    <div v-else-if="templates.length > 0" class="space-y-3">
      <div 
        v-for="template in displayTemplates"
        :key="template.id"
        @click="$emit('edit-template', template)"
        class="flex items-center justify-between p-3 hover:bg-white/5 rounded-lg transition-colors cursor-pointer"
      >
        <div class="flex items-center space-x-3 min-w-0 flex-1">
          <div class="w-8 h-8 bg-pink-500/20 rounded-lg flex items-center justify-center flex-shrink-0">
            <DocumentTextIcon class="w-4 h-4 text-pink-400" />
          </div>
          <div class="min-w-0 flex-1">
            <div class="flex items-center space-x-2">
              <p class="text-white text-sm font-medium truncate">{{ template.name }}</p>
              <StatusBadge :status="template.status" size="xs" />
            </div>
            <div class="flex items-center space-x-3 mt-0.5">
              <p class="text-white/60 text-xs">{{ getStageDisplay(template.stage) }}</p>
              <span class="text-white/40 text-xs">•</span>
              <p class="text-white/60 text-xs">{{ formatDate(template.lastModified) }}</p>
            </div>
          </div>
        </div>
        <ChevronRightIcon class="w-4 h-4 text-white/40" />
      </div>
      
      <div v-if="templates.length > maxDisplay" class="pt-3 border-t border-white/10">
        <button 
          class="w-full text-center text-pink-400 hover:text-pink-300 text-sm font-medium transition-colors"
        >
          View all {{ templates.length }} templates
        </button>
      </div>
    </div>
    
    <div v-else class="text-center py-6">
      <div class="w-12 h-12 bg-white/5 rounded-lg flex items-center justify-center mx-auto mb-3">
        <DocumentTextIcon class="w-6 h-6 text-white/40" />
      </div>
      <p class="text-white font-medium mb-2">No Form Templates</p>
      <p class="text-white/60 text-sm mb-4">Create your first form template to start onboarding carriers</p>
      <button 
        @click="$emit('create-template')"
        class="px-4 py-2 bg-pink-500 hover:bg-pink-600 text-white rounded-lg text-sm font-medium transition-colors"
      >
        Create Template
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { DocumentTextIcon, ChevronRightIcon } from '@heroicons/vue/24/outline'
import StatusBadge from '~/components/ui/StatusBadge.vue'

interface FormTemplate {
  id: string
  name: string
  stage: string
  lastModified: string
  status: 'active' | 'draft'
}

interface Props {
  templates: FormTemplate[]
  loading: boolean
  maxDisplay?: number
}

const props = withDefaults(defineProps<Props>(), {
  maxDisplay: 4
})

defineEmits<{
  'create-template': []
  'edit-template': [template: FormTemplate]
}>()

const displayTemplates = computed(() => 
  props.templates.slice(0, props.maxDisplay)
)

const getStageDisplay = (stage: string) => {
  const stageMap: Record<string, string> = {
    'kyc': 'KYC',
    'fusf': 'FUSF',
    'msa': 'MSA',
    'interop': 'Interop'
  }
  return stageMap[stage] || stage
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric'
  })
}
</script>