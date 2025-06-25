<template>
  <div class="relative">
    <button
      @click="toggleUserMenu"
      class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-full flex items-center justify-center hover:ring-2 hover:ring-white/20 transition-all"
    >
      <span class="text-white text-sm font-semibold">
        A
      </span>
    </button>
    
    <!-- User Menu Dropdown -->
    <div 
      v-if="userMenuOpen"
      class="absolute top-full right-0 mt-2 w-48 bg-black/90 backdrop-blur-md rounded-lg border border-white/10 py-1 z-50"
    >
      <div class="px-3 py-2 border-b border-white/10">
        <p class="text-sm font-medium text-white">Alicia Thompson</p>
        <p class="text-xs text-white/60">Organization Owner</p>
      </div>
      <button
        @click="handleLogout"
        class="w-full text-left px-3 py-2 text-sm text-white hover:bg-white/10 transition-colors flex items-center space-x-2"
      >
        <ArrowRightOnRectangleIcon class="w-4 h-4" />
        <span>Sign out</span>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowRightOnRectangleIcon } from '@heroicons/vue/24/outline'

const { profile, logout } = useAuth()
const userMenuOpen = ref(false)

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