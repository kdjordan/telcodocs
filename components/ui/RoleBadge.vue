<template>
  <span 
    :class="[
      'inline-flex items-center rounded-full font-medium',
      sizeClasses,
      roleClasses
    ]"
  >
    {{ displayText }}
  </span>
</template>

<script setup lang="ts">
interface Props {
  role: string
  size?: 'xs' | 'sm' | 'md'
}

const props = withDefaults(defineProps<Props>(), {
  size: 'sm'
})

const roleConfig: Record<string, { text: string; classes: string }> = {
  'super_admin': {
    text: 'Super Admin',
    classes: 'bg-red-500/20 text-red-300'
  },
  'tenant_owner': {
    text: 'Owner',
    classes: 'bg-purple-500/20 text-purple-300'
  },
  'admin': {
    text: 'Admin', 
    classes: 'bg-blue-500/20 text-blue-300'
  },
  'member': {
    text: 'Member',
    classes: 'bg-green-500/20 text-green-300'
  },
  'end_user': {
    text: 'Carrier',
    classes: 'bg-gray-500/20 text-gray-300'
  }
}

const sizeClasses = computed(() => {
  const sizes = {
    xs: 'text-xs px-1.5 py-0.5',
    sm: 'text-xs px-2 py-1', 
    md: 'text-sm px-2.5 py-1.5'
  }
  return sizes[props.size]
})

const config = computed(() => 
  roleConfig[props.role] || { text: props.role, classes: 'bg-gray-500/20 text-gray-300' }
)

const roleClasses = computed(() => config.value.classes)
const displayText = computed(() => config.value.text)
</script>