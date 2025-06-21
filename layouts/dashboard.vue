<template>
  <div class="min-h-screen bg-dark-gradient relative">
    <!-- Floating Sidebar -->
    <aside 
      class="fixed top-6 left-6 z-50 transition-all duration-300 ease-in-out bg-black/80 backdrop-blur-xl border border-white/10 rounded-2xl shadow-floating overflow-hidden flex flex-col"
      :class="sidebarCollapsed ? 'w-16' : 'w-64'"
      style="height: calc(100vh - 3rem);"
    >
      <!-- Logo/Brand -->
      <div class="flex items-center justify-between p-4 border-b border-white/10">
        <div v-if="!sidebarCollapsed" class="flex items-center space-x-3">
          <div class="w-8 h-8 bg-gradient-to-br from-primary to-accent rounded-lg flex items-center justify-center">
            <span class="text-white font-bold text-sm">T</span>
          </div>
          <h1 class="text-white font-bold font-heading">
            {{ tenant?.name || 'Telodox' }}
          </h1>
        </div>
        <div v-else class="w-8 h-8 bg-gradient-to-br from-primary to-accent rounded-lg flex items-center justify-center mx-auto">
          <span class="text-white font-bold text-sm">T</span>
        </div>
        
        <!-- Collapse Button -->
        <button 
          @click="toggleSidebar"
          class="w-8 h-8 rounded-lg bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors"
        >
          <svg 
            class="w-4 h-4 text-white transition-transform duration-300" 
            :class="sidebarCollapsed ? 'rotate-180' : ''"
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      </div>

      <!-- Navigation -->
      <nav class="flex-1 p-4 space-y-2">
        <!-- Super Admin Navigation -->
        <template v-if="profile?.role === 'super_admin'">
          <SidebarItem 
            to="/admin"
            icon="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
            label="Platform"
            :collapsed="sidebarCollapsed"
          />
          <SidebarItem 
            to="/admin/tenants"
            icon="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
            label="Tenants"
            :collapsed="sidebarCollapsed"
          />
          <SidebarItem 
            to="/admin/users"
            icon="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
            label="Users"
            :collapsed="sidebarCollapsed"
          />
          <SidebarItem 
            to="/admin/analytics"
            icon="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
            label="Analytics"
            :collapsed="sidebarCollapsed"
          />
        </template>
        
        <!-- Tenant Owner/End User Navigation -->
        <template v-else>
          <SidebarItem 
            to="/dashboard"
            icon="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
            label="Overview"
            :collapsed="sidebarCollapsed"
          />
          <SidebarItem 
            to="/dashboard/applications"
            icon="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
            label="Applications"
            :collapsed="sidebarCollapsed"
          />
          <SidebarItem 
            v-if="profile?.role === 'tenant_owner'"
            to="/dashboard/forms"
            icon="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"
            label="Forms"
            :collapsed="sidebarCollapsed"
          />
          <SidebarItem 
            v-if="profile?.role === 'tenant_owner'"
            to="/dashboard/users"
            icon="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
            label="Users"
            :collapsed="sidebarCollapsed"
          />
          <SidebarItem 
            to="/dashboard/settings"
            icon="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065zM15 12a3 3 0 11-6 0 3 3 0 016 0z"
            label="Settings"
            :collapsed="sidebarCollapsed"
          />
        </template>
      </nav>

      <!-- User Profile -->
      <div class="border-t border-white/10 p-4">
        <div v-if="profile" class="flex items-center space-x-3">
          <div class="w-8 h-8 bg-gradient-to-br from-accent to-primary rounded-full flex items-center justify-center">
            <span class="text-white text-xs font-semibold">
              {{ profile.full_name?.charAt(0).toUpperCase() }}
            </span>
          </div>
          <div v-if="!sidebarCollapsed" class="flex-1 min-w-0">
            <p class="text-white text-sm font-medium truncate">{{ profile.full_name }}</p>
            <p class="text-white/60 text-xs truncate">{{ profile.role?.replace('_', ' ') }}</p>
          </div>
          <div v-if="!sidebarCollapsed" class="relative">
            <select 
              v-model="selectedMenuItem"
              @change="handleMenuAction"
              class="appearance-none bg-transparent text-white text-xs cursor-pointer focus:outline-none"
            >
              <option value="" class="bg-slate-800">•••</option>
              <option v-for="item in menuItems" :key="item.value" :value="item.value" class="bg-slate-800">
                {{ item.label }}
              </option>
            </select>
          </div>
        </div>
      </div>
    </aside>

    <!-- Main content -->
    <main 
      class="min-h-screen transition-all duration-300 ease-in-out"
      :class="sidebarCollapsed ? 'pl-28' : 'pl-80'"
    >
      <div class="p-6">
        <slot />
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const { profile, logout } = useAuth()
const { tenant } = useTenant()

const selectedMenuItem = ref('')
const sidebarCollapsed = ref(false)

const menuItems = computed(() => [
  { label: 'Profile', value: 'profile' },
  { label: 'Settings', value: 'settings' },
  { label: 'Sign out', value: 'logout' }
])

const toggleSidebar = () => {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

const handleMenuAction = async () => {
  const action = selectedMenuItem.value
  
  switch (action) {
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
  
  // Reset the dropdown
  selectedMenuItem.value = ''
}
</script>