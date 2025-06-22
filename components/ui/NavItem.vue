<template>
  <NuxtLink 
    :to="to" 
    class="flex items-center space-x-3 px-3 py-2 rounded-lg text-white/70 hover:text-white hover:bg-white/10 transition-all duration-200 group"
    :class="{ 'bg-white/10 text-white': active, 'justify-center': collapsed }"
  >
    <component 
      :is="icon" 
      class="w-5 h-5 flex-shrink-0"
      :class="{ 'text-pink-400': active }"
    />
    <span 
      v-if="!collapsed" 
      class="font-medium text-sm"
      :class="{ 'text-white': active }"
    >
      {{ label }}
    </span>
    
    <!-- Tooltip for collapsed state -->
    <div 
      v-if="collapsed" 
      class="absolute left-16 bg-black/90 backdrop-blur-md text-white text-sm px-2 py-1 rounded-lg border border-white/10 opacity-0 group-hover:opacity-100 transition-opacity duration-200 pointer-events-none whitespace-nowrap z-50"
    >
      {{ label }}
    </div>
  </NuxtLink>
</template>

<script setup lang="ts">
interface Props {
  to: string
  icon: any
  label: string
  collapsed?: boolean
  active?: boolean
}

defineProps<Props>()
</script>