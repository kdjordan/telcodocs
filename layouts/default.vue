<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <div class="flex-shrink-0 flex items-center">
              <h1 class="text-xl font-semibold text-gray-900">
                {{ tenant?.name || 'TelcoDocs' }}
              </h1>
            </div>
            
            <!-- Navigation Links -->
            <div v-if="profile" class="hidden sm:ml-8 sm:flex sm:space-x-8">
              <NuxtLink
                v-if="isEndUser()"
                to="/forms"
                class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-900 border-b-2"
                :class="route.path.startsWith('/forms') ? 'border-blue-500' : 'border-transparent hover:border-gray-300'"
              >
                My Applications
              </NuxtLink>
              
              <NuxtLink
                v-if="isTenantOwner()"
                to="/dashboard"
                class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-900 border-b-2"
                :class="route.path.startsWith('/dashboard') ? 'border-blue-500' : 'border-transparent hover:border-gray-300'"
              >
                Dashboard
              </NuxtLink>
              
              <NuxtLink
                v-if="isTenantOwner()"
                to="/dashboard/forms"
                class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-900 border-b-2"
                :class="route.path === '/dashboard/forms' ? 'border-blue-500' : 'border-transparent hover:border-gray-300'"
              >
                Form Builder
              </NuxtLink>
              
              <NuxtLink
                v-if="isSuperAdmin()"
                to="/admin"
                class="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-900 border-b-2"
                :class="route.path.startsWith('/admin') ? 'border-blue-500' : 'border-transparent hover:border-gray-300'"
              >
                Admin
              </NuxtLink>
            </div>
          </div>
          
          <!-- User Menu -->
          <div class="flex items-center">
            <div v-if="profile" class="ml-3 relative">
              <select 
                v-model="selectedMenuItem"
                @change="handleMenuAction"
                class="border border-gray-300 rounded-md px-3 py-2 bg-white"
              >
                <option value="">{{ profile.full_name }}</option>
                <option v-for="item in menuItems" :key="item.value" :value="item.value">
                  {{ item.label }}
                </option>
              </select>
            </div>
            
            <div v-else class="space-x-4">
              <NuxtLink to="/auth/login" class="text-gray-700 hover:text-gray-900">
                Sign in
              </NuxtLink>
              <NuxtLink to="/auth/register" class="btn-primary">
                Get Started
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <!-- Page Content -->
    <main>
      <slot />
    </main>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const { profile, logout, isSuperAdmin, isTenantOwner, isEndUser } = useAuth()
const { tenant } = useTenant()

const selectedMenuItem = ref('')

const menuItems = computed(() => [
  { label: 'Profile', value: 'profile' },
  { label: 'Settings', value: 'settings' },
  { label: 'Sign out', value: 'logout' }
])

const handleMenuAction = async (event: any) => {
  switch (event.value) {
    case 'profile':
      await router.push('/dashboard/profile')
      break
    case 'settings':
      await router.push('/dashboard/settings')
      break
    case 'logout':
      await logout()
      break
  }
  selectedMenuItem.value = ''
}

// Fetch user profile on mount
onMounted(async () => {
  const { fetchProfile } = useAuth()
  await fetchProfile()
})
</script>