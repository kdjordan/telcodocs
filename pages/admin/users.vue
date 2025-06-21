<template>
  <div class="p-6">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold">User Management</h1>
      <Button label="Add User" icon="pi pi-plus" @click="showNewUserDialog = true" />
    </div>

    <DataTable :value="users" :loading="loading" paginator :rows="10" 
               :globalFilterFields="['email', 'full_name', 'role', 'tenant.name']"
               showGridlines>
      <template #header>
        <div class="flex justify-between">
          <span class="p-input-icon-left">
            <i class="pi pi-search" />
            <InputText v-model="filters.global" placeholder="Search users..." />
          </span>
        </div>
      </template>

      <Column field="email" header="Email" sortable></Column>
      <Column field="full_name" header="Name" sortable></Column>
      <Column field="role" header="Role" sortable>
        <template #body="slotProps">
          <Tag :severity="getRoleSeverity(slotProps.data.role)" :value="slotProps.data.role" />
        </template>
      </Column>
      <Column field="tenant.name" header="Tenant" sortable></Column>
      <Column field="created_at" header="Created" sortable>
        <template #body="slotProps">
          {{ new Date(slotProps.data.created_at).toLocaleDateString() }}
        </template>
      </Column>
      <Column header="Actions" style="width: 10rem">
        <template #body="slotProps">
          <Button icon="pi pi-pencil" class="p-button-text p-button-sm" @click="editUser(slotProps.data)" />
          <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm" 
                  @click="confirmDeleteUser(slotProps.data)" />
        </template>
      </Column>
    </DataTable>

    <Dialog v-model:visible="showNewUserDialog" :style="{width: '450px'}" header="Add New User" :modal="true">
      <div class="flex flex-col gap-4">
        <div>
          <label for="email" class="block text-sm font-medium mb-2">Email</label>
          <InputText id="email" v-model="newUser.email" class="w-full" />
        </div>
        <div>
          <label for="name" class="block text-sm font-medium mb-2">Full Name</label>
          <InputText id="name" v-model="newUser.full_name" class="w-full" />
        </div>
        <div>
          <label for="role" class="block text-sm font-medium mb-2">Role</label>
          <Dropdown id="role" v-model="newUser.role" :options="roles" class="w-full" />
        </div>
        <div>
          <label for="tenant" class="block text-sm font-medium mb-2">Tenant</label>
          <Dropdown id="tenant" v-model="newUser.tenant_id" :options="tenants" 
                    optionLabel="name" optionValue="id" class="w-full" />
        </div>
      </div>
      <template #footer>
        <Button label="Cancel" icon="pi pi-times" @click="showNewUserDialog = false" class="p-button-text" />
        <Button label="Save" icon="pi pi-check" @click="saveUser" />
      </template>
    </Dialog>
  </div>
</template>

<script setup>
const { $supabase } = useNuxtApp()
const toast = useToast()

const users = ref([])
const tenants = ref([])
const loading = ref(false)
const showNewUserDialog = ref(false)
const filters = ref({ global: '' })

const newUser = ref({
  email: '',
  full_name: '',
  role: 'end_user',
  tenant_id: null
})

const roles = ['super_admin', 'tenant_owner', 'end_user']

onMounted(() => {
  fetchUsers()
  fetchTenants()
})

const fetchUsers = async () => {
  loading.value = true
  try {
    const { data, error } = await $supabase
      .from('users')
      .select('*, tenant:tenants(name)')
      .order('created_at', { ascending: false })
    
    if (error) throw error
    users.value = data
  } catch (error) {
    toast.add({ severity: 'error', summary: 'Error', detail: 'Failed to fetch users', life: 3000 })
  } finally {
    loading.value = false
  }
}

const fetchTenants = async () => {
  try {
    const { data, error } = await $supabase
      .from('tenants')
      .select('id, name')
      .order('name')
    
    if (error) throw error
    tenants.value = data
  } catch (error) {
    console.error('Failed to fetch tenants:', error)
  }
}

const getRoleSeverity = (role) => {
  switch (role) {
    case 'super_admin': return 'danger'
    case 'tenant_owner': return 'warning'
    default: return 'info'
  }
}

const editUser = (user) => {
  // TODO: Implement edit functionality
  toast.add({ severity: 'info', summary: 'Not implemented', detail: 'Edit functionality coming soon', life: 3000 })
}

const confirmDeleteUser = (user) => {
  // TODO: Implement delete confirmation
  toast.add({ severity: 'info', summary: 'Not implemented', detail: 'Delete functionality coming soon', life: 3000 })
}

const saveUser = async () => {
  // TODO: Implement user creation
  toast.add({ severity: 'info', summary: 'Not implemented', detail: 'User creation coming soon', life: 3000 })
  showNewUserDialog.value = false
}
</script>