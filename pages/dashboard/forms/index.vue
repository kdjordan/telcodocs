<template>
  <div>
    <div class="mb-8 flex justify-between items-center">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Form Templates</h1>
        <p class="mt-1 text-sm text-gray-600">
          Create and manage your onboarding forms
        </p>
      </div>
      <NuxtLink
        to="/dashboard/forms/new"
        class="btn-primary"
      >
        Create New Form
      </NuxtLink>
    </div>
    
    <!-- Form Types Tabs -->
    <div class="border-b border-gray-200 mb-6">
      <nav class="-mb-px flex space-x-8">
        <button
          v-for="type in formTypes"
          :key="type.value"
          @click="selectedType = type.value"
          class="whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm"
          :class="selectedType === type.value 
            ? 'border-blue-500 text-blue-600' 
            : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'"
        >
          {{ type.label }}
        </button>
      </nav>
    </div>
    
    <!-- Forms List -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-flex items-center">
        <svg class="animate-spin h-5 w-5 mr-3 text-gray-500" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        Loading forms...
      </div>
    </div>
    
    <div v-else-if="filteredForms.length > 0" class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
      <div
        v-for="form in filteredForms"
        :key="form.id"
        class="card hover:shadow-lg transition-shadow cursor-pointer"
        @click="navigateTo(`/dashboard/forms/${form.id}`)"
      >
        <div class="flex justify-between items-start mb-4">
          <div>
            <h3 class="text-lg font-semibold text-gray-900">{{ form.name }}</h3>
            <p class="text-sm text-gray-500 mt-1">{{ form.description || 'No description' }}</p>
          </div>
          <span
            class="inline-flex px-2 py-1 text-xs font-semibold rounded-full"
            :class="form.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
          >
            {{ form.is_active ? 'Active' : 'Inactive' }}
          </span>
        </div>
        
        <div class="text-sm text-gray-600 space-y-1">
          <div>Type: <span class="font-medium">{{ form.form_type.toUpperCase() }}</span></div>
          <div>Fields: <span class="font-medium">{{ form.fields.length }}</span></div>
          <div>Version: <span class="font-medium">{{ form.version }}</span></div>
        </div>
        
        <div class="mt-4 flex justify-between items-center">
          <span class="text-xs text-gray-500">
            Updated {{ formatDate(form.updated_at) }}
          </span>
          <div class="flex space-x-2">
            <button
              @click.stop="duplicateForm(form)"
              class="text-blue-600 hover:text-blue-700"
              title="Duplicate"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
              </svg>
            </button>
            <button
              @click.stop="toggleFormStatus(form)"
              class="text-gray-600 hover:text-gray-700"
              :title="form.is_active ? 'Deactivate' : 'Activate'"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path v-if="form.is_active" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <div v-else class="text-center py-12">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z" />
      </svg>
      <h3 class="mt-2 text-sm font-medium text-gray-900">No forms</h3>
      <p class="mt-1 text-sm text-gray-500">Get started by creating a new form.</p>
      <div class="mt-6">
        <NuxtLink
          to="/dashboard/forms/new"
          class="btn-primary"
        >
          Create New Form
        </NuxtLink>
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
const { tenant } = useTenant()
const router = useRouter()

const loading = ref(true)
const forms = ref<FormTemplate[]>([])
const selectedType = ref<string>('all')

const formTypes = [
  { value: 'all', label: 'All Forms' },
  { value: 'kyc', label: 'KYC' },
  { value: 'fusf', label: 'FUSF' },
  { value: 'msa', label: 'MSA' },
  { value: 'interop', label: 'Interop' },
  { value: 'custom', label: 'Custom' }
]

const filteredForms = computed(() => {
  if (selectedType.value === 'all') {
    return forms.value
  }
  return forms.value.filter(form => form.form_type === selectedType.value)
})

const formatDate = (date: string) => {
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const fetchForms = async () => {
  if (!tenant.value) return
  
  try {
    const { data, error } = await $supabase
      .from('form_templates')
      .select('*')
      .eq('tenant_id', tenant.value.id)
      .order('updated_at', { ascending: false })
    
    if (error) throw error
    forms.value = data || []
  } catch (error) {
    console.error('Error fetching forms:', error)
  } finally {
    loading.value = false
  }
}

const duplicateForm = async (form: FormTemplate) => {
  try {
    const newForm = {
      ...form,
      id: undefined,
      name: `${form.name} (Copy)`,
      version: 1,
      created_at: undefined,
      updated_at: undefined
    }
    
    const { data, error } = await $supabase
      .from('form_templates')
      .insert(newForm)
      .select()
      .single()
    
    if (error) throw error
    
    if (data) {
      forms.value.unshift(data)
    }
  } catch (error) {
    console.error('Error duplicating form:', error)
  }
}

const toggleFormStatus = async (form: FormTemplate) => {
  try {
    const { error } = await $supabase
      .from('form_templates')
      .update({ is_active: !form.is_active })
      .eq('id', form.id)
    
    if (error) throw error
    
    form.is_active = !form.is_active
  } catch (error) {
    console.error('Error toggling form status:', error)
  }
}

onMounted(() => {
  fetchForms()
})
</script>