<template>
  <div class="bg-gray-800 rounded-2xl overflow-hidden shadow-lg">
    <!-- Header with search and actions -->
    <div v-if="$slots.header || searchable" class="p-4 border-b border-gray-700">
      <div class="flex justify-between items-center">
        <div v-if="searchable" class="relative">
          <MagnifyingGlassIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
          <input
            v-model="searchQuery"
            type="text"
            :placeholder="searchPlaceholder"
            class="pl-10 pr-4 py-2 bg-gray-700 border border-gray-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-accent focus:border-transparent"
          />
        </div>
        <slot name="header" />
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="loading" class="p-8 text-center">
      <div class="flex items-center justify-center">
        <svg class="animate-spin h-6 w-6 text-accent mr-3" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <span class="text-gray-300">Loading...</span>
      </div>
    </div>

    <!-- Table -->
    <div v-else class="overflow-x-auto">
      <table class="w-full">
        <thead class="bg-gray-700">
          <tr>
            <th
              v-for="column in columns"
              :key="column.key"
              class="px-4 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider cursor-pointer hover:bg-gray-600 transition-colors"
              @click="column.sortable ? toggleSort(column.key) : null"
            >
              <div class="flex items-center space-x-1">
                <span>{{ column.header }}</span>
                <div v-if="column.sortable" class="flex flex-col">
                  <ChevronUpIcon 
                    :class="['h-3 w-3', sortKey === column.key && sortOrder === 'asc' ? 'text-accent' : 'text-gray-500']" 
                  />
                  <ChevronDownIcon 
                    :class="['h-3 w-3 -mt-1', sortKey === column.key && sortOrder === 'desc' ? 'text-accent' : 'text-gray-500']" 
                  />
                </div>
              </div>
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-700">
          <tr
            v-for="(item, index) in paginatedData"
            :key="index"
            class="hover:bg-gray-700 transition-colors"
          >
            <td
              v-for="column in columns"
              :key="column.key"
              class="px-4 py-3 whitespace-nowrap text-sm text-gray-300"
            >
              <slot 
                :name="`cell-${column.key}`" 
                :item="item" 
                :value="getNestedValue(item, column.key)"
                :index="index"
              >
                {{ formatCellValue(item, column) }}
              </slot>
            </td>
          </tr>
          <tr v-if="paginatedData.length === 0">
            <td :colspan="columns.length" class="px-4 py-8 text-center text-gray-500">
              {{ emptyText }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div v-if="paginated && filteredData.length > pageSize" class="p-4 border-t border-gray-700 flex items-center justify-between">
      <div class="text-sm text-gray-400">
        Showing {{ (currentPage - 1) * pageSize + 1 }} to {{ Math.min(currentPage * pageSize, filteredData.length) }} of {{ filteredData.length }} results
      </div>
      <div class="flex items-center space-x-2">
        <button
          @click="currentPage--"
          :disabled="currentPage === 1"
          class="px-3 py-1 rounded bg-gray-700 text-gray-300 hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          Previous
        </button>
        <span class="text-sm text-gray-400">
          Page {{ currentPage }} of {{ totalPages }}
        </span>
        <button
          @click="currentPage++"
          :disabled="currentPage === totalPages"
          class="px-3 py-1 rounded bg-gray-700 text-gray-300 hover:bg-gray-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          Next
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { MagnifyingGlassIcon, ChevronUpIcon, ChevronDownIcon } from '@heroicons/vue/24/outline'

interface Column {
  key: string
  header: string
  sortable?: boolean
  formatter?: (value: any, item: any) => string
}

interface Props {
  data: any[]
  columns: Column[]
  loading?: boolean
  searchable?: boolean
  searchPlaceholder?: string
  searchFields?: string[]
  paginated?: boolean
  pageSize?: number
  emptyText?: string
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  searchable: true,
  searchPlaceholder: 'Search...',
  searchFields: () => [],
  paginated: true,
  pageSize: 10,
  emptyText: 'No data available'
})

const searchQuery = ref('')
const sortKey = ref<string>('')
const sortOrder = ref<'asc' | 'desc'>('asc')
const currentPage = ref(1)

// Get nested object value using dot notation (e.g., 'tenant.name')
const getNestedValue = (obj: any, path: string): any => {
  return path.split('.').reduce((current, key) => current?.[key], obj)
}

// Format cell value using column formatter or default display
const formatCellValue = (item: any, column: Column): string => {
  const value = getNestedValue(item, column.key)
  if (column.formatter) {
    return column.formatter(value, item)
  }
  if (value === null || value === undefined) return ''
  if (value instanceof Date) return value.toLocaleDateString()
  return String(value)
}

// Filter data based on search query
const filteredData = computed(() => {
  if (!searchQuery.value) return props.data

  const query = searchQuery.value.toLowerCase()
  const searchFields = props.searchFields.length > 0 
    ? props.searchFields 
    : props.columns.map(col => col.key)

  return props.data.filter(item => {
    return searchFields.some(field => {
      const value = getNestedValue(item, field)
      return String(value || '').toLowerCase().includes(query)
    })
  })
})

// Sort filtered data
const sortedData = computed(() => {
  if (!sortKey.value) return filteredData.value

  return [...filteredData.value].sort((a, b) => {
    const aVal = getNestedValue(a, sortKey.value)
    const bVal = getNestedValue(b, sortKey.value)

    let comparison = 0
    if (aVal < bVal) comparison = -1
    if (aVal > bVal) comparison = 1

    return sortOrder.value === 'desc' ? -comparison : comparison
  })
})

// Paginate sorted data
const paginatedData = computed(() => {
  if (!props.paginated) return sortedData.value

  const start = (currentPage.value - 1) * props.pageSize
  const end = start + props.pageSize
  return sortedData.value.slice(start, end)
})

const totalPages = computed(() => {
  return Math.ceil(filteredData.value.length / props.pageSize)
})

// Toggle sort order for a column
const toggleSort = (key: string) => {
  if (sortKey.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortKey.value = key
    sortOrder.value = 'asc'
  }
}

// Reset pagination when search changes
watch(searchQuery, () => {
  currentPage.value = 1
})
</script>