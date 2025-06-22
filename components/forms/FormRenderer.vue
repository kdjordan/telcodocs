<template>
  <div class="form-renderer">
    <!-- Form Header -->
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-gray-900 mb-2">{{ formTemplate.name }}</h1>
      <p v-if="formTemplate.description" class="text-gray-600">{{ formTemplate.description }}</p>
      
      <!-- Progress Bar -->
      <div v-if="showProgressBar" class="mt-4">
        <div class="flex justify-between text-sm text-gray-600 mb-2">
          <span>Progress</span>
          <span>{{ progressPercentage }}% complete</span>
        </div>
        <div class="w-full bg-gray-200 rounded-full h-2">
          <div 
            class="bg-blue-600 h-2 rounded-full transition-all duration-300"
            :style="{ width: progressPercentage + '%' }"
          />
        </div>
      </div>
    </div>

    <!-- Auto-save Status -->
    <div class="mb-4 flex justify-between items-center">
      <div class="flex items-center text-sm text-gray-500">
        <svg v-if="saving" class="animate-spin w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <svg v-else-if="lastSaved" class="w-4 h-4 mr-2 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
        <span v-if="saving">Saving...</span>
        <span v-else-if="lastSaved">Last saved {{ formatTime(lastSaved) }}</span>
        <span v-else>Ready to save</span>
      </div>
    </div>

    <!-- Form Fields -->
    <form @submit.prevent="submitForm" class="space-y-6">
      <div
        v-for="field in sortedFields"
        :key="field.id"
        :class="{ 'hidden': !isFieldVisible(field) }"
      >
        <FormField
          :field="field"
          :value="formData[field.name]"
          :error="errors[field.name]"
          @update:value="updateFieldValue(field.name, $event)"
          @update:file="handleFileUpload(field.name, $event)"
        />
      </div>

      <!-- Form Actions -->
      <div class="flex justify-between items-center pt-8 border-t border-gray-200">
        <div class="text-sm text-gray-500">
          {{ completedFieldsCount }} of {{ requiredFieldsCount }} required fields completed
        </div>
        
        <div class="flex gap-3">
          <button
            v-if="!isLastStep"
            type="button"
            @click="saveAsDraft"
            :disabled="saving"
            class="px-6 py-3 border border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-50 disabled:opacity-50"
          >
            Save as Draft
          </button>
          
          <button
            type="submit"
            :disabled="!canSubmit || submitting"
            class="px-6 py-3 bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed text-white font-medium rounded-lg transition-colors"
          >
            {{ submitting ? 'Submitting...' : isLastStep ? 'Submit Form' : 'Continue' }}
          </button>
        </div>
      </div>
    </form>

    <!-- Error Message -->
    <div v-if="submitError" class="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg">
      <p class="text-red-800">{{ submitError }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { FormTemplate, FormField as IFormField, FormSubmission } from '~/types'
import { debounce } from 'lodash-es'

const props = defineProps<{
  formTemplate: FormTemplate
  applicationId?: string
  submissionId?: string
}>()

const emit = defineEmits<{
  'submitted': [submission: FormSubmission]
  'saved': [submission: FormSubmission]
}>()

// Reactive state
const formData = ref<Record<string, any>>({})
const errors = ref<Record<string, string>>({})
const saving = ref(false)
const submitting = ref(false)
const lastSaved = ref<Date | null>(null)
const submitError = ref('')
const currentSubmissionId = ref(props.submissionId || null)

// Initialize form data
const initializeFormData = () => {
  const data: Record<string, any> = {}
  props.formTemplate.fields.forEach(field => {
    data[field.name] = getDefaultValue(field)
  })
  formData.value = data
}

const getDefaultValue = (field: IFormField) => {
  switch (field.type) {
    case 'checkbox':
      return false
    case 'radio':
    case 'select':
      return ''
    default:
      return ''
  }
}

// Computed properties
const sortedFields = computed(() => {
  return [...props.formTemplate.fields].sort((a, b) => a.order - b.order)
})

const showProgressBar = computed(() => {
  return props.formTemplate.settings.show_progress_bar
})

const progressPercentage = computed(() => {
  const totalFields = sortedFields.value.length
  const completedFields = sortedFields.value.filter(field => {
    const value = formData.value[field.name]
    return value !== '' && value !== null && value !== undefined && value !== false
  }).length
  
  return totalFields > 0 ? Math.round((completedFields / totalFields) * 100) : 0
})

const completedFieldsCount = computed(() => {
  return sortedFields.value.filter(field => {
    if (!field.required) return true
    const value = formData.value[field.name]
    return value !== '' && value !== null && value !== undefined && 
           (field.type !== 'checkbox' || value === true)
  }).length
})

const requiredFieldsCount = computed(() => {
  return sortedFields.value.filter(field => field.required).length
})

const canSubmit = computed(() => {
  return completedFieldsCount.value === requiredFieldsCount.value
})

const isLastStep = computed(() => {
  // For now, treating all forms as single-step
  // This will be enhanced for multi-step workflows
  return true
})

// Methods
const isFieldVisible = (field: IFormField) => {
  if (!field.conditional) return true
  
  const conditionField = formData.value[field.conditional.field]
  const conditionValue = field.conditional.value
  
  switch (field.conditional.operator) {
    case 'equals':
      return conditionField === conditionValue
    case 'not_equals':
      return conditionField !== conditionValue
    case 'contains':
      return String(conditionField).includes(String(conditionValue))
    case 'greater_than':
      return Number(conditionField) > Number(conditionValue)
    case 'less_than':
      return Number(conditionField) < Number(conditionValue)
    default:
      return true
  }
}

const updateFieldValue = (fieldName: string, value: any) => {
  formData.value[fieldName] = value
  
  // Clear error for this field
  if (errors.value[fieldName]) {
    delete errors.value[fieldName]
  }
  
  // Trigger auto-save
  debouncedAutoSave()
}

const handleFileUpload = async (fieldName: string, file: File) => {
  try {
    // Here you would upload the file to your storage (R2, S3, etc.)
    // For now, just store the file reference
    formData.value[fieldName] = {
      file,
      name: file.name,
      size: file.size,
      type: file.type
    }
    
    debouncedAutoSave()
  } catch (error) {
    console.error('File upload error:', error)
    errors.value[fieldName] = 'Failed to upload file'
  }
}

const validateForm = () => {
  const newErrors: Record<string, string> = {}
  
  sortedFields.value.forEach(field => {
    if (!isFieldVisible(field)) return
    
    const value = formData.value[field.name]
    
    // Required field validation
    if (field.required) {
      if (value === '' || value === null || value === undefined) {
        newErrors[field.name] = `${field.label} is required`
        return
      }
      
      if (field.type === 'checkbox' && value !== true) {
        newErrors[field.name] = `${field.label} must be checked`
        return
      }
    }
    
    // Type-specific validation
    if (value && field.validation) {
      const validation = field.validation
      
      if (validation.pattern && !new RegExp(validation.pattern).test(String(value))) {
        newErrors[field.name] = validation.customMessage || `${field.label} format is invalid`
      }
      
      if (validation.minLength && String(value).length < validation.minLength) {
        newErrors[field.name] = `${field.label} must be at least ${validation.minLength} characters`
      }
      
      if (validation.maxLength && String(value).length > validation.maxLength) {
        newErrors[field.name] = `${field.label} must be no more than ${validation.maxLength} characters`
      }
      
      if (validation.min && Number(value) < validation.min) {
        newErrors[field.name] = `${field.label} must be at least ${validation.min}`
      }
      
      if (validation.max && Number(value) > validation.max) {
        newErrors[field.name] = `${field.label} must be no more than ${validation.max}`
      }
    }
  })
  
  errors.value = newErrors
  return Object.keys(newErrors).length === 0
}

const autoSave = async () => {
  if (!props.formTemplate.settings.save_progress) return
  
  try {
    saving.value = true
    
    const { data } = await $fetch('/api/forms/auto-save', {
      method: 'POST',
      body: {
        form_template_id: props.formTemplate.id,
        application_id: props.applicationId,
        submission_id: currentSubmissionId.value,
        form_data: formData.value
      }
    })
    
    if (data.submission) {
      currentSubmissionId.value = data.submission.id
      lastSaved.value = new Date()
      emit('saved', data.submission)
    }
  } catch (error) {
    console.error('Auto-save error:', error)
  } finally {
    saving.value = false
  }
}

const debouncedAutoSave = debounce(autoSave, 1000)

const saveAsDraft = async () => {
  await autoSave()
}

const submitForm = async () => {
  if (!validateForm()) {
    submitError.value = 'Please correct the errors below'
    return
  }
  
  try {
    submitting.value = true
    submitError.value = ''
    
    const { data } = await $fetch('/api/forms/submit', {
      method: 'POST',
      body: {
        form_template_id: props.formTemplate.id,
        application_id: props.applicationId,
        submission_id: currentSubmissionId.value,
        form_data: formData.value
      }
    })
    
    if (data.submission) {
      emit('submitted', data.submission)
    }
  } catch (error: any) {
    console.error('Form submission error:', error)
    submitError.value = error.data?.message || 'Failed to submit form'
  } finally {
    submitting.value = false
  }
}

const formatTime = (date: Date) => {
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  const minutes = Math.floor(diff / 60000)
  
  if (minutes < 1) return 'just now'
  if (minutes < 60) return `${minutes}m ago`
  
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours}h ago`
  
  return date.toLocaleDateString()
}

// Load existing submission data if editing
const loadExistingSubmission = async () => {
  if (!props.submissionId) return
  
  try {
    const { data } = await $fetch(`/api/forms/submissions/${props.submissionId}`)
    if (data.submission) {
      formData.value = { ...formData.value, ...data.submission.form_data }
      currentSubmissionId.value = data.submission.id
    }
  } catch (error) {
    console.error('Error loading submission:', error)
  }
}

// Initialize
onMounted(() => {
  initializeFormData()
  loadExistingSubmission()
})
</script>

<style scoped>
.form-renderer {
  max-width: 4xl;
  margin: 0 auto;
}
</style>