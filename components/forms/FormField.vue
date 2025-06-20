<template>
  <div class="mb-4">
    <label 
      v-if="field.label"
      :for="fieldId"
      class="block text-sm font-medium text-gray-700 mb-1"
    >
      {{ field.label }}
      <span v-if="field.required" class="text-red-500">*</span>
    </label>
    
    <!-- Text Input -->
    <input
      v-if="field.type === 'text' || field.type === 'email' || field.type === 'phone'"
      :id="fieldId"
      v-model="localValue"
      :type="field.type"
      :placeholder="field.placeholder"
      :required="field.required"
      class="form-input"
      @input="updateValue"
    >
    
    <!-- Number Input -->
    <input
      v-else-if="field.type === 'number'"
      :id="fieldId"
      v-model.number="localValue"
      type="number"
      :placeholder="field.placeholder"
      :required="field.required"
      :min="field.validation?.min"
      :max="field.validation?.max"
      class="form-input"
      @input="updateValue"
    >
    
    <!-- Textarea -->
    <textarea
      v-else-if="field.type === 'textarea'"
      :id="fieldId"
      v-model="localValue"
      :placeholder="field.placeholder"
      :required="field.required"
      :rows="4"
      class="form-input"
      @input="updateValue"
    />
    
    <!-- Select -->
    <select
      v-else-if="field.type === 'select'"
      :id="fieldId"
      v-model="localValue"
      :required="field.required"
      class="form-input"
      @change="updateValue"
    >
      <option value="">{{ field.placeholder || 'Select an option' }}</option>
      <option
        v-for="option in field.options"
        :key="option.value"
        :value="option.value"
      >
        {{ option.label }}
      </option>
    </select>
    
    <!-- Radio Buttons -->
    <div v-else-if="field.type === 'radio'" class="space-y-2">
      <label
        v-for="option in field.options"
        :key="option.value"
        class="flex items-center"
      >
        <input
          v-model="localValue"
          type="radio"
          :name="fieldId"
          :value="option.value"
          :required="field.required"
          class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300"
          @change="updateValue"
        >
        <span class="ml-2 text-sm text-gray-700">{{ option.label }}</span>
      </label>
    </div>
    
    <!-- Checkbox -->
    <div v-else-if="field.type === 'checkbox'" class="flex items-center">
      <input
        :id="fieldId"
        v-model="localValue"
        type="checkbox"
        :required="field.required"
        class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
        @change="updateValue"
      >
      <label :for="fieldId" class="ml-2 text-sm text-gray-700">
        {{ field.placeholder || field.label }}
      </label>
    </div>
    
    <!-- Date -->
    <input
      v-else-if="field.type === 'date'"
      :id="fieldId"
      v-model="localValue"
      type="date"
      :required="field.required"
      class="form-input"
      @change="updateValue"
    >
    
    <!-- File Upload -->
    <div v-else-if="field.type === 'file'" class="space-y-2">
      <input
        :id="fieldId"
        type="file"
        :required="field.required"
        class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
        @change="handleFileUpload"
      >
      <div v-if="uploadedFile" class="text-sm text-gray-600">
        Uploaded: {{ uploadedFile.name }}
      </div>
    </div>
    
    <!-- Signature -->
    <div v-else-if="field.type === 'signature'" class="border border-gray-300 rounded-lg p-4">
      <SignatureCapture
        :field-id="fieldId"
        @update="updateSignature"
      />
    </div>
    
    <!-- Validation Error -->
    <p v-if="error" class="mt-1 text-sm text-red-600">
      {{ error }}
    </p>
  </div>
</template>

<script setup lang="ts">
import type { FormField } from '~/types'

const props = defineProps<{
  field: FormField
  value: any
  error?: string
}>()

const emit = defineEmits<{
  'update:value': [value: any]
  'update:file': [file: File]
}>()

const fieldId = computed(() => `field-${props.field.id}`)
const localValue = ref(props.value)
const uploadedFile = ref<File | null>(null)

watch(() => props.value, (newValue) => {
  localValue.value = newValue
})

const updateValue = () => {
  emit('update:value', localValue.value)
}

const handleFileUpload = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (file) {
    uploadedFile.value = file
    emit('update:file', file)
  }
}

const updateSignature = (signatureData: string) => {
  emit('update:value', signatureData)
}
</script>