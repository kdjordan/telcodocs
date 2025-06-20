<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Use default layout navigation -->
    <nav class="bg-white shadow-sm border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <div class="flex-shrink-0 flex items-center">
              <h1 class="text-xl font-semibold text-gray-900">
                {{ tenant?.name || 'TelcoDocs' }}
              </h1>
            </div>
          </div>
          
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
          </div>
        </div>
      </div>
    </nav>

    <div class="flex h-[calc(100vh-4rem)]">
      <!-- Sidebar -->
      <aside class="w-64 bg-white border-r border-gray-200">
        <nav class="mt-5 px-2">
          <NuxtLink
            to="/dashboard"
            class="group flex items-center px-2 py-2 text-sm font-medium rounded-md"
            :class="route.path === '/dashboard' ? 'bg-gray-100 text-gray-900' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'"
          >
            <svg class="mr-3 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
            </svg>
            Overview
          </NuxtLink>
          
          <NuxtLink
            to="/dashboard/applications"
            class="mt-1 group flex items-center px-2 py-2 text-sm font-medium rounded-md"
            :class="route.path.startsWith('/dashboard/applications') ? 'bg-gray-100 text-gray-900' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'"
          >
            <svg class="mr-3 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            Applications
          </NuxtLink>
          
          <NuxtLink
            to="/dashboard/forms"
            class="mt-1 group flex items-center px-2 py-2 text-sm font-medium rounded-md"
            :class="route.path.startsWith('/dashboard/forms') ? 'bg-gray-100 text-gray-900' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'"
          >
            <svg class="mr-3 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
            </svg>
            Form Builder
          </NuxtLink>
          
          <NuxtLink
            to="/dashboard/users"
            class="mt-1 group flex items-center px-2 py-2 text-sm font-medium rounded-md"
            :class="route.path.startsWith('/dashboard/users') ? 'bg-gray-100 text-gray-900' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'"
          >
            <svg class="mr-3 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
            </svg>
            Users
          </NuxtLink>
          
          <NuxtLink
            to="/dashboard/settings"
            class="mt-1 group flex items-center px-2 py-2 text-sm font-medium rounded-md"
            :class="route.path.startsWith('/dashboard/settings') ? 'bg-gray-100 text-gray-900' : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'"
          >
            <svg class="mr-3 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
            Settings
          </NuxtLink>
        </nav>
      </aside>

      <!-- Main content -->
      <main class="flex-1 overflow-y-auto">
        <div class="p-8">
          <slot />
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const { profile, logout } = useAuth()
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
</script>