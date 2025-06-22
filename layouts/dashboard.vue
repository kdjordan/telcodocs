<template>
  <div class="min-h-screen bg-black relative">
    <!-- Mobile Sidebar Overlay -->
    <div v-if="mobileMenuOpen" class="lg:hidden fixed inset-0 z-50">
      <div class="fixed inset-0 bg-black/50" @click="closeMobileMenu"></div>
      <div class="fixed left-0 top-0 bottom-0 w-64 bg-black border-r border-white/10">
        <MobileSidebar @close="closeMobileMenu" />
      </div>
    </div>

    <!-- Desktop Layout -->
    <div class="flex">
      <!-- Desktop Sidebar - Hidden on Mobile -->
      <aside 
        class="hidden lg:flex transition-all duration-300 ease-in-out bg-black border-r border-white/10 flex-col"
        :class="sidebarCollapsed ? 'w-16' : 'w-64'"
        style="height: 100vh;"
      >
        <!-- Sidebar Header -->
        <div class="flex items-center justify-between p-4 border-b border-white/10">
          <div v-if="!sidebarCollapsed" class="flex items-center space-x-3">
            <div class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center">
              <span class="text-white font-bold text-sm">T</span>
            </div>
            <h1 class="text-white font-bold text-lg">
              {{ tenant?.name || 'TeloDox' }}
            </h1>
          </div>
          <div v-else class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mx-auto">
            <span class="text-white font-bold text-sm">T</span>
          </div>
          
          <!-- Collapse Button -->
          <button 
            v-if="!sidebarCollapsed"
            @click="toggleSidebar"
            class="w-8 h-8 rounded-lg bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors"
          >
            <ChevronLeftIcon class="w-4 h-4 text-white" />
          </button>
        </div>

        <!-- Search Bar -->
        <div v-if="!sidebarCollapsed" class="p-4">
          <div class="relative">
            <MagnifyingGlassIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-white/40" />
            <input 
              type="text" 
              placeholder="Search..." 
              class="w-full pl-10 pr-4 py-2 bg-white/5 border border-white/10 rounded-lg text-white placeholder-white/40 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
            />
          </div>
        </div>

        <!-- Navigation -->
        <nav class="flex-1 p-4 space-y-2">
          <!-- Super Admin Navigation -->
          <template v-if="profile?.role === 'super_admin'">
            <NavItem
              to="/admin"
              :icon="HomeIcon"
              label="Platform"
              :collapsed="sidebarCollapsed"
            />
            <NavItem
              to="/admin/tenants"
              :icon="BuildingOfficeIcon"
              label="Tenants"
              :collapsed="sidebarCollapsed"
            />
            <NavItem
              to="/admin/users"
              :icon="UsersIcon"
              label="Users"
              :collapsed="sidebarCollapsed"
            />
            <NavItem
              to="/admin/analytics"
              :icon="ChartBarIcon"
              label="Analytics"
              :collapsed="sidebarCollapsed"
            />
          </template>
          
          <!-- Tenant Owner/End User Navigation -->
          <template v-else>
            <NavItem
              to="/dashboard"
              :icon="HomeIcon"
              label="Dashboard"
              :collapsed="sidebarCollapsed"
              active
            />
            <NavItem
              to="/dashboard/applications"
              :icon="InboxIcon"
              label="Inbox"
              :collapsed="sidebarCollapsed"
            />
            <NavItem
              v-if="profile?.role === 'tenant_owner'"
              to="/dashboard/forms"
              :icon="FolderIcon"
              label="Projects"
              :collapsed="sidebarCollapsed"
            />
            <NavItem
              to="/dashboard/calendar"
              :icon="CalendarIcon"
              label="Calendar"
              :collapsed="sidebarCollapsed"
            />
            <NavItem
              to="/dashboard/reports"
              :icon="ChartBarIcon"
              label="Reports"
              :collapsed="sidebarCollapsed"
            />
            <NavItem
              to="/dashboard/help"
              :icon="QuestionMarkCircleIcon"
              label="Help & Center"
              :collapsed="sidebarCollapsed"
            />
            <NavItem
              to="/dashboard/settings"
              :icon="Cog6ToothIcon"
              label="Settings"
              :collapsed="sidebarCollapsed"
            />
          </template>
        </nav>

        <!-- User Profile -->
        <div class="border-t border-white/10 p-4">
          <div v-if="profile" class="flex items-center space-x-3">
            <div class="relative">
              <button
                @click="toggleUserMenu"
                class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-full flex items-center justify-center hover:ring-2 hover:ring-white/20 transition-all"
              >
                <span class="text-white text-xs font-semibold">
                  {{ profile.full_name?.charAt(0).toUpperCase() }}
                </span>
              </button>
              
              <!-- User Menu Dropdown -->
              <div 
                v-if="userMenuOpen"
                class="absolute bottom-full left-0 mb-2 w-48 bg-black/90 backdrop-blur-md rounded-lg border border-white/10 py-1 z-50"
              >
                <div class="px-3 py-2 border-b border-white/10">
                  <p class="text-sm font-medium text-white">{{ profile.full_name }}</p>
                  <p class="text-xs text-white/60">{{ profile.role?.replace('_', ' ') }}</p>
                </div>
                <button
                  @click="handleLogout"
                  class="w-full text-left px-3 py-2 text-sm text-white hover:bg-white/10 transition-colors"
                >
                  Sign out
                </button>
              </div>
            </div>
            <div v-if="!sidebarCollapsed" class="flex-1 min-w-0">
              <p class="text-white text-sm font-medium truncate">{{ profile.full_name }}</p>
              <p class="text-white/60 text-xs truncate">{{ profile.role?.replace('_', ' ') }}</p>
            </div>
          </div>
        </div>
      </aside>

      <!-- Main Content Area -->
      <div class="flex-1 flex flex-col lg:ml-0">
        <!-- Mobile Header -->
        <header class="lg:hidden bg-black/80 backdrop-blur-md border-b border-white/10 p-4">
          <div class="flex items-center justify-between">
            <div class="flex items-center space-x-3">
              <button 
                @click="toggleMobileMenu"
                class="w-8 h-8 rounded-lg bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors"
              >
                <Bars3Icon class="w-5 h-5 text-white" />
              </button>
              <div class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center">
                <span class="text-white font-bold text-sm">T</span>
              </div>
              <h1 class="text-white font-bold text-lg">TeloDox</h1>
            </div>
            <UserMenuDropdown />
          </div>
        </header>

        <!-- Desktop Header -->
        <header class="hidden lg:block bg-black/80 backdrop-blur-md border-b border-white/10 h-16">
          <div class="flex items-center justify-between px-6 h-full">
            <!-- Left: Expand button + Welcome message -->
            <div class="flex items-center space-x-4">
              <button 
                v-if="sidebarCollapsed"
                @click="toggleSidebar"
                class="w-8 h-8 rounded-lg bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors"
              >
                <ChevronRightIcon class="w-4 h-4 text-white" />
              </button>
              <div class="text-white/60">
                Welcome back, {{ profile?.full_name?.split(' ')[0] || 'there' }}! 👋
              </div>
            </div>
            
            <!-- Right: Live indicator + User menu -->
            <div class="flex items-center space-x-4">
              <div class="flex items-center space-x-2">
                <div class="w-2 h-2 bg-green-400 rounded-full animate-pulse"></div>
                <span class="text-white/60 text-sm">Live</span>
              </div>
              <UserMenuDropdown />
            </div>
          </div>
        </header>

        <!-- Main content -->
        <main class="flex-1 p-4 lg:p-6 bg-black">
          <slot />
        </main>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { 
  HomeIcon,
  InboxIcon,
  FolderIcon,
  CalendarIcon,
  ChartBarIcon,
  QuestionMarkCircleIcon,
  Cog6ToothIcon,
  MagnifyingGlassIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  BuildingOfficeIcon,
  UsersIcon,
  Bars3Icon
} from '@heroicons/vue/24/outline'
import NavItem from '~/components/ui/NavItem.vue'
import UserMenuDropdown from '~/components/ui/UserMenuDropdown.vue'
import MobileSidebar from '~/components/ui/MobileSidebar.vue'

const route = useRoute()
const router = useRouter()
const { profile, logout } = useAuth()
const { tenant } = useTenant()

const sidebarCollapsed = ref(false)
const userMenuOpen = ref(false)
const mobileMenuOpen = ref(false)

const toggleSidebar = () => {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}

const closeMobileMenu = () => {
  mobileMenuOpen.value = false
}

const toggleUserMenu = () => {
  userMenuOpen.value = !userMenuOpen.value
}

const handleLogout = async () => {
  userMenuOpen.value = false
  await logout()
}

// Close menu when clicking outside
onMounted(() => {
  const handleClickOutside = (event: Event) => {
    const target = event.target as Element
    if (!target.closest('.relative')) {
      userMenuOpen.value = false
    }
  }
  document.addEventListener('click', handleClickOutside)
  
  onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside)
  })
})
</script>