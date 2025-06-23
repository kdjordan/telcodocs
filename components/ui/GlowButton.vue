<template>
  <div class="relative inline-block">
    <!-- Rotating border -->
    <div 
      ref="borderRef"
      class="absolute inset-0 rounded-lg"
      :style="borderStyle"
    ></div>
    
    <!-- Main button -->
    <component 
      :is="tag"
      :to="to"
      :href="href"
      :type="type"
      :disabled="disabled"
      @click="handleClick"
      class="relative bg-black hover:bg-white/40 text-white hover:text-black font-semibold rounded-lg transition-all duration-300 flex items-center justify-center gap-2"
      :class="[buttonSize, buttonClasses]"
      :style="buttonStyle"
    >
      <slot />
    </component>
  </div>
</template>

<script setup lang="ts">
interface Props {
  // Component type
  tag?: 'button' | 'NuxtLink' | 'a'
  
  // Link props
  to?: string
  href?: string
  
  // Button props
  type?: 'button' | 'submit' | 'reset'
  disabled?: boolean
  
  // Size variants
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  
  // Animation speed (degrees per frame)
  speed?: number
}

const props = withDefaults(defineProps<Props>(), {
  tag: 'button',
  type: 'button',
  size: 'md',
  speed: 3
})

const emit = defineEmits<{
  click: [event: Event]
}>()

const borderRef = ref<HTMLElement>()
const angle = ref(0)

const handleClick = (event: Event) => {
  if (!props.disabled) {
    emit('click', event)
  }
}

// Size configurations
const sizeConfig = {
  xs: { button: 'px-3 py-1.5 text-xs', border: '1px' },
  sm: { button: 'px-4 py-2 text-sm', border: '2px' },
  md: { button: 'px-6 py-3 text-base', border: '2px' },
  lg: { button: 'px-8 py-4 text-lg', border: '2px' },
  xl: { button: 'px-12 py-6 text-xl', border: '3px' }
}

const buttonSize = computed(() => sizeConfig[props.size].button)

const buttonClasses = computed(() => {
  const classes = []
  
  if (props.disabled) {
    classes.push('opacity-50 cursor-not-allowed')
  }
  
  return classes.join(' ')
})

const borderStyle = computed(() => ({
  background: `conic-gradient(from ${angle.value}deg, #ec4899, #a855f7, #3b82f6, #ec4899)`,
  padding: sizeConfig[props.size].border
}))

const buttonStyle = computed(() => ({
  margin: sizeConfig[props.size].border
}))

// Animation
let animationId: number

const animate = () => {
  angle.value = (angle.value + props.speed) % 360
  animationId = requestAnimationFrame(animate)
}

onMounted(() => {
  animate()
})

onBeforeUnmount(() => {
  if (animationId) {
    cancelAnimationFrame(animationId)
  }
})
</script>