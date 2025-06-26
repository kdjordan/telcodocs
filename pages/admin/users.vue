<template>
  <div class="p-6 bg-gray-900 min-h-screen">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold text-white">User Management</h1>
      <GlowButton @click="showNewUserDialog = true">
        <PlusIcon class="h-4 w-4 mr-2" />
        Add User
      </GlowButton>
    </div>

    <DataTable 
      :data="users" 
      :columns="columns"
      :loading="loading"
      :searchFields="['email', 'full_name', 'role', 'tenant.name']"
      searchPlaceholder="Search users..."
      emptyText="No users found"
    >
      <template #header>
        <div></div>
      </template>

      <template #cell-role="{ value }">
        <RoleBadge :role="value" />
      </template>

      <template #cell-created_at="{ value }">
        {{ new Date(value).toLocaleDateString() }}
      </template>

      <template #cell-actions="{ item }">
        <div class="flex space-x-2">
          <button
            @click="editUser(item)"
            class="p-1 text-gray-400 hover:text-accent transition-colors"
            title="Edit user"
          >
            <PencilIcon class="h-4 w-4" />
          </button>
          <button
            @click="confirmDeleteUser(item)"
            class="p-1 text-gray-400 hover:text-red-400 transition-colors"
            title="Delete user"
          >
            <TrashIcon class="h-4 w-4" />
          </button>
        </div>
      </template>
    </DataTable>

    <HeadlessModal 
      v-model="showNewUserDialog" 
      title="Add New User"
      size="md"
    >
      <div class="space-y-4">
        <div>
          <label for="email" class="block text-sm font-medium text-gray-300 mb-2">Email</label>
          <input
            id="email"
            v-model="newUser.email"
            type="email"
            class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-accent focus:border-transparent"
            placeholder="user@example.com"
          />
        </div>
        <div>
          <label for="name" class="block text-sm font-medium text-gray-300 mb-2">Full Name</label>
          <input
            id="name"
            v-model="newUser.full_name"
            type="text"
            class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-accent focus:border-transparent"
            placeholder="John Doe"
          />
        </div>
        <div>
          <label for="role" class="block text-sm font-medium text-gray-300 mb-2">Role</label>
          <HeadlessSelect
            v-model="newUser.role"
            :options="roleOptions"
            placeholder="Select a role"
          />
        </div>
        <div>
          <label for="tenant" class="block text-sm font-medium text-gray-300 mb-2">Tenant</label>
          <HeadlessSelect
            v-model="newUser.tenant_id"
            :options="tenants"
            optionLabel="name"
            optionValue="id"
            placeholder="Select a tenant"
          />
        </div>
      </div>

      <template #footer>
        <div class="flex justify-end space-x-3">
          <button
            @click="showNewUserDialog = false"
            class="px-4 py-2 text-gray-400 hover:text-white transition-colors"
          >
            Cancel
          </button>
          <GlowButton @click="saveUser">
            Save User
          </GlowButton>
        </div>
      </template>
    </HeadlessModal>
  </div>
</template>

<script setup>
import { PlusIcon, PencilIcon, TrashIcon } from '@heroicons/vue/24/outline'
import { toast } from 'vue-sonner'

const { $supabase } = useNuxtApp()

const users = ref([])
const tenants = ref([])
const loading = ref(false)
const showNewUserDialog = ref(false)

const newUser = ref({
  email: '',
  full_name: '',
  role: 'organization_user',
  tenant_id: null
})

const roleOptions = [
  { value: 'platform_owner', label: 'Platform Owner' },
  { value: 'organization_user', label: 'Organization User' },
  { value: 'carrier', label: 'Carrier' }
]

const columns = [
  { key: 'email', header: 'Email', sortable: true },
  { key: 'full_name', header: 'Name', sortable: true },
  { key: 'role', header: 'Role', sortable: true },
  { key: 'tenant.name', header: 'Tenant', sortable: true },
  { key: 'created_at', header: 'Created', sortable: true },
  { key: 'actions', header: 'Actions', sortable: false }
]

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
    toast.error('Failed to fetch users')
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

const editUser = (user) => {
  // TODO: Implement edit functionality
  toast.info('Edit functionality coming soon')
}

const confirmDeleteUser = (user) => {
  // TODO: Implement delete confirmation
  toast.info('Delete functionality coming soon')
}

const saveUser = async () => {
  // TODO: Implement user creation
  toast.info('User creation coming soon')
  showNewUserDialog.value = false
}
</script>