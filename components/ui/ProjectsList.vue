<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-white font-semibold text-lg">List Projects</h3>
      <button class="p-2 hover:bg-white/10 rounded-lg transition-colors">
        <EllipsisHorizontalIcon class="w-4 h-4 text-white/60" />
      </button>
    </div>
    
    <div class="space-y-4">
      <ProjectItem 
        v-for="project in projects.slice(0, 3)" 
        :key="project.id"
        :project="project"
      />
      
      <!-- Show placeholder if no projects -->
      <div v-if="projects.length === 0" class="text-center py-8">
        <FolderIcon class="w-8 h-8 text-white/40 mx-auto mb-2" />
        <p class="text-white/60 text-sm">No projects yet</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { EllipsisHorizontalIcon, FolderIcon } from '@heroicons/vue/24/outline'
import ProjectItem from '~/components/ui/ProjectItem.vue'

interface Props {
  projects: any[]
}

defineProps<Props>()
</script>