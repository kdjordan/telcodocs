<template>
  <div class="flex flex-col h-full">
    <!-- Mobile Sidebar Header -->
    <div class="flex items-center justify-between p-4 border-b border-white/10">
      <div class="flex items-center space-x-3">
        <div class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center">
          <span class="text-white font-bold text-sm">T</span>
        </div>
        <h1 class="text-white font-bold text-lg">
          {{ tenant?.name || 'TeloDox' }}
        </h1>
      </div>
      
      <!-- Close Button -->
      <button 
        @click="$emit('close')"
        class="w-8 h-8 rounded-lg bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors"
      >
        <XMarkIcon class="w-4 h-4 text-white" />
      </button>
    </div>

    <!-- Search Bar -->
    <div class="p-4">
      <div class="relative">
        <MagnifyingGlassIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-white/40" />
        <input 
          type="text" 
          placeholder="Search..." 
          class="w-full pl-10 pr-4 py-2 bg-white/5 border border-white/10 rounded-lg text-white placeholder-white/40 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
        />
      </div>
    </div>
    
    <!-- Mobile Navigation -->
    <nav class="flex-1 p-4 space-y-2">
      <!-- Super Admin Navigation -->
      <template v-if="profile?.role === 'super_admin'">
        <MobileNavItem
          to="/admin"
          :icon="HomeIcon"
          label="Platform"
          @click="$emit('close')"
        />
        <MobileNavItem
          to="/admin/tenants"
          :icon="BuildingOfficeIcon"
          label="Tenants"
          @click="$emit('close')"
        />
        <MobileNavItem
          to="/admin/users"
          :icon="UsersIcon"
          label="Users"
          @click="$emit('close')"
        />
        <MobileNavItem
          to="/admin/analytics"
          :icon="ChartBarIcon"
          label="Analytics"
          @click="$emit('close')"
        />
      </template>
      
      <!-- Tenant Owner/End User Navigation -->
      <template v-else>
        <MobileNavItem
          to="/dashboard"
          :icon="HomeIcon"
          label="Dashboard"
          :active="$route.path === '/dashboard'"
          @click="$emit('close')"
        />
        <MobileNavItem
          to="/dashboard/applications"
          :icon="InboxIcon"
          label="Inbox"
          @click="$emit('close')"
        />
        <MobileNavItem
          v-if="profile?.role === 'tenant_owner'"
          to="/dashboard/forms"
          :icon="FolderIcon"
          label="Projects"
          @click="$emit('close')"
        />
        <MobileNavItem
          to="/dashboard/calendar"
          :icon="CalendarIcon"
          label="Calendar"
          @click="$emit('close')"
        />
        <MobileNavItem
          to="/dashboard/reports"
          :icon="ChartBarIcon"
          label="Reports"
          @click="$emit('close')"
        />
        <MobileNavItem
          to="/dashboard/help"
          :icon="QuestionMarkCircleIcon"
          label="Help & Center"
          @click="$emit('close')"
        />
        <MobileNavItem
          to="/dashboard/settings"
          :icon="Cog6ToothIcon"
          label="Settings"
          @click="$emit('close')"
        />
      </template>
    </nav>

    <!-- Mobile User Profile -->
    <div class="border-t border-white/10 p-4">
      <div v-if="profile" class="flex items-center space-x-3">
        <div class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-full flex items-center justify-center">
          <span class="text-white text-xs font-semibold">
            {{ profile.full_name?.charAt(0).toUpperCase() }}
          </span>
        </div>
        <div class="flex-1 min-w-0">
          <p class="text-white text-sm font-medium truncate">{{ profile.full_name }}</p>
          <p class="text-white/60 text-xs truncate">{{ profile.role?.replace('_', ' ') }}</p>
        </div>
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
  BuildingOfficeIcon,
  UsersIcon,
  XMarkIcon
} from '@heroicons/vue/24/outline'
import MobileNavItem from '~/components/ui/MobileNavItem.vue'

const { profile } = useAuth()
const { tenant } = useTenant()
const route = useRoute()

defineEmits(['close'])
</script>