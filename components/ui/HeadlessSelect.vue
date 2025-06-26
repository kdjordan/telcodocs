<template>
  <Listbox v-model="selected" :disabled="disabled">
    <div class="relative">
      <ListboxButton
        class="relative w-full cursor-default rounded-lg bg-gray-800 py-2.5 pl-3 pr-10 text-left text-gray-200 shadow-sm ring-1 ring-inset ring-gray-700 focus:outline-none focus:ring-2 focus:ring-accent sm:text-sm sm:leading-6 disabled:opacity-50 disabled:cursor-not-allowed"
      >
        <span class="block truncate">{{ displayValue || placeholder }}</span>
        <span class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-2">
          <ChevronUpDownIcon class="h-5 w-5 text-gray-400" aria-hidden="true" />
        </span>
      </ListboxButton>

      <transition
        leave-active-class="transition ease-in duration-100"
        leave-from-class="opacity-100"
        leave-to-class="opacity-0"
      >
        <ListboxOptions
          class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-lg bg-gray-800 py-1 text-base shadow-lg ring-1 ring-gray-700 focus:outline-none sm:text-sm"
        >
          <ListboxOption
            v-for="option in options"
            :key="getOptionValue(option)"
            v-slot="{ active, selected }"
            :value="option"
            as="template"
          >
            <li
              :class="[
                active ? 'bg-gray-700 text-white' : 'text-gray-200',
                'relative cursor-default select-none py-2 pl-3 pr-9'
              ]"
            >
              <span :class="[selected ? 'font-semibold' : 'font-normal', 'block truncate']">
                {{ getOptionLabel(option) }}
              </span>

              <span
                v-if="selected"
                :class="[
                  active ? 'text-white' : 'text-accent',
                  'absolute inset-y-0 right-0 flex items-center pr-4'
                ]"
              >
                <CheckIcon class="h-5 w-5" aria-hidden="true" />
              </span>
            </li>
          </ListboxOption>
        </ListboxOptions>
      </transition>
    </div>
  </Listbox>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import {
  Listbox,
  ListboxButton,
  ListboxOptions,
  ListboxOption,
} from '@headlessui/vue'
import { CheckIcon, ChevronUpDownIcon } from '@heroicons/vue/20/solid'

interface Props {
  modelValue: any
  options: any[]
  placeholder?: string
  disabled?: boolean
  optionLabel?: string | ((option: any) => string)
  optionValue?: string | ((option: any) => any)
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Select an option',
  disabled: false,
  optionLabel: 'label',
  optionValue: 'value'
})

const emit = defineEmits<{
  'update:modelValue': [value: any]
}>()

const selected = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const getOptionLabel = (option: any): string => {
  if (!option) return ''
  if (typeof props.optionLabel === 'function') {
    return props.optionLabel(option)
  }
  if (typeof option === 'string') return option
  return option[props.optionLabel as string] || ''
}

const getOptionValue = (option: any): any => {
  if (!option) return null
  if (typeof props.optionValue === 'function') {
    return props.optionValue(option)
  }
  if (typeof option === 'string' || typeof option === 'number') return option
  return option[props.optionValue as string]
}

const displayValue = computed(() => {
  if (!selected.value) return ''
  return getOptionLabel(selected.value)
})
</script>