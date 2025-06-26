<template>
  <Combobox v-model="selected" :disabled="disabled">
    <div class="relative">
      <div class="relative w-full cursor-default overflow-hidden rounded-lg bg-gray-800 text-left shadow-sm ring-1 ring-inset ring-gray-700 focus-within:ring-2 focus-within:ring-accent sm:text-sm">
        <ComboboxInput
          class="w-full border-none bg-transparent py-2.5 pl-3 pr-10 text-sm leading-5 text-gray-200 placeholder-gray-500 focus:outline-none disabled:cursor-not-allowed disabled:opacity-50"
          :displayValue="(item) => getOptionLabel(item)"
          @change="query = $event.target.value"
          :placeholder="placeholder"
        />
        <ComboboxButton class="absolute inset-y-0 right-0 flex items-center pr-2">
          <ChevronUpDownIcon class="h-5 w-5 text-gray-400" aria-hidden="true" />
        </ComboboxButton>
      </div>
      <TransitionRoot
        leave="transition ease-in duration-100"
        leaveFrom="opacity-100"
        leaveTo="opacity-0"
        @after-leave="query = ''"
      >
        <ComboboxOptions
          class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-lg bg-gray-800 py-1 text-base shadow-lg ring-1 ring-gray-700 focus:outline-none sm:text-sm"
        >
          <div
            v-if="filteredOptions.length === 0 && query !== ''"
            class="relative cursor-default select-none py-2 px-4 text-gray-400"
          >
            {{ emptyText }}
          </div>

          <div v-if="loading" class="relative cursor-default select-none py-2 px-4 text-gray-400">
            <div class="flex items-center">
              <svg class="animate-spin h-4 w-4 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Loading...
            </div>
          </div>

          <ComboboxOption
            v-for="option in filteredOptions"
            as="template"
            :key="getOptionValue(option)"
            :value="option"
            v-slot="{ selected, active }"
          >
            <li
              class="relative cursor-default select-none py-2 pl-10 pr-4"
              :class="{
                'bg-gray-700 text-white': active,
                'text-gray-200': !active,
              }"
            >
              <span
                class="block truncate"
                :class="{ 'font-medium': selected, 'font-normal': !selected }"
              >
                {{ getOptionLabel(option) }}
              </span>
              <span
                v-if="selected"
                class="absolute inset-y-0 left-0 flex items-center pl-3"
                :class="{ 'text-white': active, 'text-accent': !active }"
              >
                <CheckIcon class="h-5 w-5" aria-hidden="true" />
              </span>
            </li>
          </ComboboxOption>
        </ComboboxOptions>
      </TransitionRoot>
    </div>
  </Combobox>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import {
  Combobox,
  ComboboxInput,
  ComboboxButton,
  ComboboxOptions,
  ComboboxOption,
  TransitionRoot,
} from '@headlessui/vue'
import { CheckIcon, ChevronUpDownIcon } from '@heroicons/vue/20/solid'

interface Props {
  modelValue: any
  options: any[]
  placeholder?: string
  disabled?: boolean
  loading?: boolean
  emptyText?: string
  optionLabel?: string | ((option: any) => string)
  optionValue?: string | ((option: any) => any)
  filterFunction?: (options: any[], query: string) => any[]
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Search...',
  disabled: false,
  loading: false,
  emptyText: 'Nothing found.',
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

const query = ref('')

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

const filteredOptions = computed(() => {
  if (props.filterFunction) {
    return props.filterFunction(props.options, query.value)
  }
  
  if (query.value === '') {
    return props.options
  }

  return props.options.filter((option) => {
    const label = getOptionLabel(option).toLowerCase()
    return label.includes(query.value.toLowerCase())
  })
})
</script>