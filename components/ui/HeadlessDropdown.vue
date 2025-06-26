<template>
  <Menu as="div" class="relative inline-block text-left">
    <div>
      <MenuButton :class="buttonClass">
        <slot name="button">
          <span class="sr-only">Open options</span>
          <EllipsisVerticalIcon class="h-5 w-5" aria-hidden="true" />
        </slot>
      </MenuButton>
    </div>

    <transition
      enter-active-class="transition ease-out duration-100"
      enter-from-class="transform opacity-0 scale-95"
      enter-to-class="transform opacity-100 scale-100"
      leave-active-class="transition ease-in duration-75"
      leave-from-class="transform opacity-100 scale-100"
      leave-to-class="transform opacity-0 scale-95"
    >
      <MenuItems
        class="absolute z-10 mt-2 w-56 origin-top-right divide-y divide-gray-700 rounded-lg bg-gray-800 shadow-lg ring-1 ring-gray-700 focus:outline-none"
        :class="alignmentClass"
      >
        <div class="px-1 py-1">
          <slot />
        </div>
      </MenuItems>
    </transition>
  </Menu>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Menu, MenuButton, MenuItems } from '@headlessui/vue'
import { EllipsisVerticalIcon } from '@heroicons/vue/24/outline'

interface Props {
  align?: 'left' | 'right'
  buttonClass?: string
}

const props = withDefaults(defineProps<Props>(), {
  align: 'right',
  buttonClass: 'inline-flex w-full justify-center rounded-md bg-gray-800 px-3 py-2 text-sm font-medium text-gray-300 hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-accent focus:ring-offset-2 focus:ring-offset-gray-800'
})

const alignmentClass = computed(() => {
  return props.align === 'left' ? 'left-0' : 'right-0'
})
</script>