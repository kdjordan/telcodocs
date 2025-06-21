<template>
  <NuxtLink
    :to="to"
    class="sidebar-item group flex items-center transition-all duration-200"
    :class="[
      collapsed ? 'w-12 h-12 justify-center' : 'px-3 py-2.5',
      isActive ? 'bg-white/10 text-white' : 'text-white/70 hover:text-white hover:bg-white/5'
    ]"
  >
    <div class="flex items-center justify-center w-6 h-6 flex-shrink-0">
      <svg 
        class="w-5 h-5 transition-colors" 
        fill="none" 
        stroke="currentColor" 
        viewBox="0 0 24 24"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="icon" />
      </svg>
    </div>
    
    <span 
      v-if="!collapsed" 
      class="ml-3 text-sm font-medium transition-opacity"
      :class="collapsed ? 'opacity-0' : 'opacity-100'"
    >
      {{ label }}
    </span>
    
    <!-- Tooltip for collapsed state -->
    <div 
      v-if="collapsed"
      class="absolute left-16 bg-slate-700 text-white text-xs px-2 py-1 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none z-50 whitespace-nowrap"
    >
      {{ label }}
    </div>
  </NuxtLink>
</template>

<script setup lang="ts">
interface Props {
  to: string
  icon: string
  label: string
  collapsed: boolean
}

const props = defineProps<Props>()
const route = useRoute()

const isActive = computed(() => {
  if (props.to === '/dashboard') {
    return route.path === '/dashboard'
  }
  return route.path.startsWith(props.to)
})
</script>

<style scoped>
.sidebar-item {
  border-radius: 0.75rem;
  position: relative;
}

.sidebar-item.router-link-active {
  background-color: rgba(255, 255, 255, 0.1);
  color: white;
}
</style>