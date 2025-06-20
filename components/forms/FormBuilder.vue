<template>
  <div class="form-builder grid grid-cols-12 gap-6">
    <!-- Field Palette -->
    <div class="col-span-3">
      <div class="card sticky top-0">
        <h3 class="text-lg font-semibold mb-4">Field Types</h3>
        
        <div class="space-y-2">
          <div
            v-for="fieldType in fieldTypes"
            :key="fieldType.type"
            draggable="true"
            @dragstart="handleDragStart($event, fieldType)"
            class="p-3 bg-gray-50 rounded-lg cursor-move hover:bg-gray-100 transition-colors"
          >
            <div class="flex items-center">
              <component :is="fieldType.icon" class="w-5 h-5 mr-2 text-gray-600" />
              <span class="font-medium">{{ fieldType.label }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Form Canvas -->
    <div class="col-span-6">
      <div class="card">
        <div class="mb-4">
          <input
            v-model="formName"
            type="text"
            placeholder="Form Name"
            class="text-xl font-semibold border-0 border-b-2 border-gray-200 focus:border-blue-500 focus:outline-none w-full pb-2"
          >
          <textarea
            v-model="formDescription"
            placeholder="Form description (optional)"
            class="mt-2 w-full border-0 focus:outline-none resize-none"
            rows="2"
          />
        </div>
        
        <div
          @dragover.prevent
          @drop="handleDrop"
          class="min-h-[400px] border-2 border-dashed border-gray-300 rounded-lg p-4"
          :class="{ 'border-blue-400 bg-blue-50': isDragging }"
        >
          <div v-if="fields.length === 0" class="text-center py-12 text-gray-500">
            Drag fields here to start building your form
          </div>
          
          <draggable
            v-model="fields"
            group="fields"
            @start="drag = true"
            @end="drag = false"
            item-key="id"
            class="space-y-4"
          >
            <template #item="{ element, index }">
              <div
                class="bg-white border border-gray-200 rounded-lg p-4 cursor-move hover:shadow-md transition-shadow"
                @click="selectField(element)"
                :class="{ 'ring-2 ring-blue-500': selectedField?.id === element.id }"
              >
                <div class="flex justify-between items-start mb-2">
                  <h4 class="font-medium">{{ element.label || `${element.type} field` }}</h4>
                  <button
                    @click.stop="removeField(index)"
                    class="text-red-500 hover:text-red-700"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
                
                <FormField
                  :field="element"
                  :value="null"
                  disabled
                />
              </div>
            </template>
          </draggable>
        </div>
      </div>
    </div>
    
    <!-- Field Properties -->
    <div class="col-span-3">
      <div class="card sticky top-0">
        <h3 class="text-lg font-semibold mb-4">Field Properties</h3>
        
        <div v-if="selectedField" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Label
            </label>
            <input
              v-model="selectedField.label"
              type="text"
              class="form-input"
            >
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Field Name
            </label>
            <input
              v-model="selectedField.name"
              type="text"
              class="form-input"
            >
          </div>
          
          <div v-if="showPlaceholder">
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Placeholder
            </label>
            <input
              v-model="selectedField.placeholder"
              type="text"
              class="form-input"
            >
          </div>
          
          <div>
            <label class="flex items-center">
              <input
                v-model="selectedField.required"
                type="checkbox"
                class="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
              >
              <span class="ml-2 text-sm text-gray-700">Required field</span>
            </label>
          </div>
          
          <!-- Options for select, radio -->
          <div v-if="hasOptions" class="space-y-2">
            <label class="block text-sm font-medium text-gray-700 mb-1">
              Options
            </label>
            <div
              v-for="(option, idx) in selectedField.options"
              :key="idx"
              class="flex gap-2"
            >
              <input
                v-model="option.label"
                type="text"
                placeholder="Label"
                class="form-input flex-1"
              >
              <input
                v-model="option.value"
                type="text"
                placeholder="Value"
                class="form-input flex-1"
              >
              <button
                @click="removeOption(idx)"
                class="text-red-500 hover:text-red-700"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            <button
              @click="addOption"
              class="text-sm text-blue-600 hover:text-blue-700"
            >
              + Add Option
            </button>
          </div>
        </div>
        
        <div v-else class="text-gray-500 text-center py-8">
          Select a field to edit its properties
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { VueDraggableNext as draggable } from 'vue-draggable-next'
import type { FormField, FieldType } from '~/types'

const emit = defineEmits<{
  'update:form': [form: { name: string; description: string; fields: FormField[] }]
}>()

const formName = ref('')
const formDescription = ref('')
const fields = ref<FormField[]>([])
const selectedField = ref<FormField | null>(null)
const isDragging = ref(false)
const drag = ref(false)

const fieldTypes = [
  { type: 'text', label: 'Text Input', icon: 'div' },
  { type: 'email', label: 'Email', icon: 'div' },
  { type: 'phone', label: 'Phone', icon: 'div' },
  { type: 'number', label: 'Number', icon: 'div' },
  { type: 'textarea', label: 'Text Area', icon: 'div' },
  { type: 'select', label: 'Dropdown', icon: 'div' },
  { type: 'radio', label: 'Radio Buttons', icon: 'div' },
  { type: 'checkbox', label: 'Checkbox', icon: 'div' },
  { type: 'date', label: 'Date', icon: 'div' },
  { type: 'file', label: 'File Upload', icon: 'div' },
  { type: 'signature', label: 'Signature', icon: 'div' }
]

const showPlaceholder = computed(() => 
  selectedField.value && ['text', 'email', 'phone', 'number', 'textarea', 'select'].includes(selectedField.value.type)
)

const hasOptions = computed(() => 
  selectedField.value && ['select', 'radio'].includes(selectedField.value.type)
)

const handleDragStart = (event: DragEvent, fieldType: any) => {
  event.dataTransfer!.effectAllowed = 'copy'
  event.dataTransfer!.setData('fieldType', JSON.stringify(fieldType))
  isDragging.value = true
}

const handleDrop = (event: DragEvent) => {
  event.preventDefault()
  isDragging.value = false
  
  const fieldTypeData = event.dataTransfer!.getData('fieldType')
  if (!fieldTypeData) return
  
  const fieldType = JSON.parse(fieldTypeData)
  const newField: FormField = {
    id: Date.now().toString(),
    type: fieldType.type as FieldType,
    name: `field_${fields.value.length + 1}`,
    label: fieldType.label,
    placeholder: '',
    required: false,
    order: fields.value.length,
    options: ['select', 'radio'].includes(fieldType.type) 
      ? [{ label: 'Option 1', value: 'option1' }] 
      : undefined
  }
  
  fields.value.push(newField)
  selectField(newField)
}

const selectField = (field: FormField) => {
  selectedField.value = field
}

const removeField = (index: number) => {
  fields.value.splice(index, 1)
  if (selectedField.value?.id === fields.value[index]?.id) {
    selectedField.value = null
  }
}

const addOption = () => {
  if (selectedField.value?.options) {
    selectedField.value.options.push({
      label: `Option ${selectedField.value.options.length + 1}`,
      value: `option${selectedField.value.options.length + 1}`
    })
  }
}

const removeOption = (index: number) => {
  if (selectedField.value?.options) {
    selectedField.value.options.splice(index, 1)
  }
}

// Watch for changes and emit update
watch([formName, formDescription, fields], () => {
  emit('update:form', {
    name: formName.value,
    description: formDescription.value,
    fields: fields.value
  })
}, { deep: true })
</script>