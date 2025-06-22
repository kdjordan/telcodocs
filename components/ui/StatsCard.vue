<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-4 lg:p-6 hover:bg-white/10 transition-colors">
    <div class="flex items-center justify-between">
      <div class="min-w-0 flex-1">
        <p class="text-white/60 text-xs lg:text-sm truncate">{{ title }}</p>
        <p class="text-white text-xl lg:text-2xl font-bold mt-1">{{ value }}</p>
        <p class="text-white/50 text-xs mt-1 truncate">{{ change }}</p>
      </div>
      <div class="w-10 h-10 lg:w-12 lg:h-12 bg-pink-500/20 rounded-lg flex items-center justify-center ml-2">
        <component :is="icon" class="w-5 h-5 lg:w-6 lg:h-6 text-pink-400" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  title: string
  value: string
  change: string
  icon: any
}

defineProps<Props>()
</script>