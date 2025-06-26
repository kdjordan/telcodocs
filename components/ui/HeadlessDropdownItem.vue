<template>
  <MenuItem v-slot="{ active }">
    <component
      :is="as"
      :class="[
        active ? 'bg-gray-700 text-white' : 'text-gray-300',
        'group flex w-full items-center rounded-md px-2 py-2 text-sm transition-colors',
        disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'
      ]"
      :disabled="disabled"
      @click="!disabled && $emit('click')"
    >
      <slot name="icon" :active="active" />
      <slot />
    </component>
  </MenuItem>
</template>

<script setup lang="ts">
import { MenuItem } from '@headlessui/vue'

interface Props {
  as?: string
  disabled?: boolean
}

withDefaults(defineProps<Props>(), {
  as: 'button',
  disabled: false
})

defineEmits<{
  click: []
}>()
</script>