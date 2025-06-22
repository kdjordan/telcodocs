<template>
  <div class="max-w-7xl mx-auto">
    <!-- Header -->
    <div class="mb-8 flex justify-between items-center">
      <div>
        <h1 class="text-3xl font-bold font-heading text-gray-900 mb-2">
          Forms
        </h1>
        <p class="text-gray-600">
          Create and manage your carrier onboarding forms.
        </p>
      </div>
      <button
        @click="showBuilder = !showBuilder"
        class="bg-dark hover:bg-dark/90 text-white font-semibold px-6 py-3 rounded-xl transition-colors"
      >
        {{ showBuilder ? 'View Forms List' : 'Create New Form' }}
      </button>
    </div>

    <!-- Form Builder -->
    <div v-if="showBuilder" class="mb-8">
      <div class="bg-white rounded-2xl shadow-card p-6">
        <div class="mb-6 flex justify-between items-center">
          <h2 class="text-xl font-bold text-gray-900">Form Builder</h2>
          <div class="flex gap-3">
            <button
              @click="saveForm"
              :disabled="!canSave || saving"
              class="bg-green-600 hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed text-white font-medium px-4 py-2 rounded-lg transition-colors"
            >
              {{ saving ? 'Saving...' : 'Save Form' }}
            </button>
            <button
              @click="cancelBuilder"
              class="bg-gray-500 hover:bg-gray-600 text-white font-medium px-4 py-2 rounded-lg transition-colors"
            >
              Cancel
            </button>
          </div>
        </div>
        
        <FormBuilder @update:form="updateForm" />
        
        <div v-if="error" class="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg">
          <p class="text-red-800">{{ error }}</p>
        </div>
      </div>
    </div>

    <!-- Forms List -->
    <div v-else>
      <div v-if="loading" class="text-center py-12">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-dark mx-auto"></div>
        <p class="mt-4 text-gray-600">Loading forms...</p>
      </div>
      
      <div v-else-if="forms.length === 0" class="bg-white rounded-2xl shadow-card p-12 text-center">
        <div class="w-16 h-16 bg-dark/20 rounded-2xl flex items-center justify-center mx-auto mb-4">
          <svg class="w-8 h-8 text-dark" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
        </div>
        <h3 class="text-xl font-semibold text-gray-900 mb-2">No Forms Yet</h3>
        <p class="text-gray-600 mb-6">Get started by creating your first carrier onboarding form.</p>
        <button
          @click="showBuilder = true"
          class="bg-dark hover:bg-dark/90 text-white font-semibold px-6 py-3 rounded-xl transition-colors"
        >
          Create Your First Form
        </button>
      </div>
      
      <div v-else class="grid gap-6">
        <div
          v-for="form in forms"
          :key="form.id"
          class="bg-white rounded-2xl shadow-card p-6 hover:shadow-lg transition-shadow"
        >
          <div class="flex justify-between items-start mb-4">
            <div>
              <h3 class="text-lg font-semibold text-gray-900 mb-1">{{ form.name }}</h3>
              <p v-if="form.description" class="text-gray-600 text-sm mb-2">{{ form.description }}</p>
              <div class="flex items-center gap-4 text-sm text-gray-500">
                <span class="flex items-center gap-1">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                  {{ form.fields.length }} fields
                </span>
                <span class="capitalize">{{ form.form_type }}</span>
                <span>{{ formatDate(form.updated_at) }}</span>
              </div>
            </div>
            <div class="flex items-center gap-2">
              <span
                :class="form.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
                class="px-2 py-1 rounded-full text-xs font-medium"
              >
                {{ form.is_active ? 'Active' : 'Draft' }}
              </span>
              <button
                @click="editForm(form)"
                class="text-gray-400 hover:text-gray-600 p-2 rounded-lg hover:bg-gray-100"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { FormTemplate } from '~/types'

definePageMeta({
  layout: 'dashboard',
  middleware: 'auth'
})

const { $supabase } = useNuxtApp()
const { profile } = useAuth()

// Reactive state
const showBuilder = ref(false)
const loading = ref(true)
const saving = ref(false)
const error = ref('')
const forms = ref<FormTemplate[]>([])
const currentForm = ref<{
  name: string
  description: string
  fields: any[]
} | null>(null)
const editingForm = ref<FormTemplate | null>(null)

// Computed properties
const canSave = computed(() => {
  return currentForm.value?.name && currentForm.value.fields.length > 0
})

// Load forms on mount
onMounted(() => {
  loadForms()
})

// Methods
const loadForms = async () => {
  if (!profile.value?.tenant_id) return
  
  try {
    loading.value = true
    const { data, error: fetchError } = await $supabase
      .from('form_templates')
      .select('*')
      .eq('tenant_id', profile.value.tenant_id)
      .order('updated_at', { ascending: false })

    if (fetchError) throw fetchError
    forms.value = data || []
  } catch (err: any) {
    console.error('Error loading forms:', err)
    error.value = 'Failed to load forms'
  } finally {
    loading.value = false
  }
}

const updateForm = (formData: { name: string; description: string; fields: any[] }) => {
  currentForm.value = formData
  error.value = ''
}

const saveForm = async () => {
  if (!currentForm.value || !profile.value?.tenant_id) return
  
  try {
    saving.value = true
    error.value = ''

    const formTemplate = {
      tenant_id: profile.value.tenant_id,
      name: currentForm.value.name,
      description: currentForm.value.description,
      form_type: 'custom' as const,
      fields: currentForm.value.fields,
      settings: {
        save_progress: true,
        show_progress_bar: false
      },
      version: 1,
      is_active: false,
      created_by: profile.value.id
    }

    if (editingForm.value) {
      // Update existing form
      const { error: updateError } = await $supabase
        .from('form_templates')
        .update({
          ...formTemplate,
          version: editingForm.value.version + 1,
          updated_at: new Date().toISOString()
        })
        .eq('id', editingForm.value.id)

      if (updateError) throw updateError
    } else {
      // Create new form
      const { error: createError } = await $supabase
        .from('form_templates')
        .insert(formTemplate)

      if (createError) throw createError
    }

    // Reload forms and close builder
    await loadForms()
    cancelBuilder()
  } catch (err: any) {
    console.error('Error saving form:', err)
    error.value = err.message || 'Failed to save form'
  } finally {
    saving.value = false
  }
}

const editForm = (form: FormTemplate) => {
  editingForm.value = form
  currentForm.value = {
    name: form.name,
    description: form.description || '',
    fields: form.fields
  }
  showBuilder.value = true
}

const cancelBuilder = () => {
  showBuilder.value = false
  currentForm.value = null
  editingForm.value = null
  error.value = ''
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}
</script>