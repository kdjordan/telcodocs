<template>
  <NuxtLink 
    :to="to" 
    @click="$emit('click')"
    class="flex items-center space-x-3 px-3 py-3 rounded-lg text-white/70 hover:text-white hover:bg-white/10 transition-all duration-200"
    :class="{ 'bg-white/10 text-white': active }"
  >
    <component 
      :is="icon" 
      class="w-5 h-5 flex-shrink-0"
      :class="{ 'text-pink-400': active }"
    />
    <span 
      class="font-medium text-sm"
      :class="{ 'text-white': active }"
    >
      {{ label }}
    </span>
  </NuxtLink>
</template>

<script setup lang="ts">
interface Props {
  to: string
  icon: any
  label: string
  active?: boolean
}

defineProps<Props>()
defineEmits(['click'])
</script>