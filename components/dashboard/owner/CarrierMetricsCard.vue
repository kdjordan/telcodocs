<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-4 lg:p-6 hover:bg-white/10 transition-colors">
    <div class="flex items-center justify-between">
      <div class="min-w-0 flex-1">
        <p class="text-white/60 text-xs lg:text-sm truncate">{{ title }}</p>
        <p class="text-white text-xl lg:text-2xl font-bold mt-1">{{ formattedValue }}</p>
        <div class="flex items-center space-x-2 mt-1">
          <p :class="['text-xs truncate', changeColorClass]">{{ change }}</p>
          <span v-if="secondaryMetric" class="text-white/40 text-xs">•</span>
          <p v-if="secondaryMetric" class="text-white/50 text-xs">{{ secondaryMetric }}</p>
        </div>
      </div>
      <div :class="['w-10 h-10 lg:w-12 lg:h-12 rounded-lg flex items-center justify-center ml-2', iconBgClass]">
        <component :is="icon" :class="['w-5 h-5 lg:w-6 lg:h-6', iconColorClass]" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  title: string
  value: number
  change: string
  icon: any
  variant?: 'default' | 'success' | 'warning' | 'danger' | 'info'
  secondaryMetric?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default'
})

const formattedValue = computed(() => {
  if (props.value >= 1000000) {
    return (props.value / 1000000).toFixed(1) + 'M'
  }
  if (props.value >= 1000) {
    return (props.value / 1000).toFixed(1) + 'K'
  }
  return props.value.toString()
})

const changeColorClass = computed(() => {
  const isPositive = props.change.startsWith('+')
  const isNegative = props.change.startsWith('-')
  
  if (isPositive) return 'text-green-400'
  if (isNegative) return 'text-red-400'
  return 'text-white/50'
})

const iconBgClass = computed(() => {
  const variants = {
    default: 'bg-pink-500/20',
    success: 'bg-green-500/20',
    warning: 'bg-yellow-500/20', 
    danger: 'bg-red-500/20',
    info: 'bg-blue-500/20'
  }
  return variants[props.variant]
})

const iconColorClass = computed(() => {
  const variants = {
    default: 'text-pink-400',
    success: 'text-green-400',
    warning: 'text-yellow-400',
    danger: 'text-red-400',
    info: 'text-blue-400'
  }
  return variants[props.variant]
})
</script>