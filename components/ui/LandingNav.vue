<template>
  <nav class="main-nav hero-nav fixed top-0 left-0 right-0 z-50 bg-black/80 backdrop-blur-md border-b border-white/10">
    <div class="max-w-7xl mx-auto px-6">
      <div class="flex items-center justify-between h-14">
        <!-- Logo -->
        <div class="flex items-center space-x-2">
          <div class="w-7 h-7 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center">
            <span class="text-white text-xs font-bold">T</span>
          </div>
          <span class="text-white font-bold text-lg">TeloDox</span>
        </div>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center space-x-6">
          <a href="#how-it-works" class="text-sm text-white/80 hover:text-white transition-colors cursor-pointer">
            How It Works
          </a>
          <a href="#pricing" class="text-sm text-white/80 hover:text-white transition-colors cursor-pointer">
            Pricing
          </a>
          <a href="#contact" class="text-sm text-white/80 hover:text-white transition-colors cursor-pointer">
            Contact
          </a>
        </div>

        <!-- Auth Buttons -->
        <div class="hidden md:flex items-center space-x-2">
          <NuxtLink 
            :to="getAuthRoute('login')" 
            class="bg-white text-black hover:bg-white/90 font-medium px-3 py-1.5 rounded-md transition-all duration-300 text-xs"
          >
            Sign in
          </NuxtLink>
          <GlowButton
            tag="NuxtLink"
            :to="getAuthRoute('register')"
            size="xs"
            class="text-xs"
          >
            Sign up
          </GlowButton>
        </div>

        <!-- Mobile Menu Button -->
        <button 
          @click="mobileMenuOpen = !mobileMenuOpen"
          class="md:hidden text-white p-2"
        >
          <Bars3Icon v-if="!mobileMenuOpen" class="w-5 h-5" />
          <XMarkIcon v-if="mobileMenuOpen" class="w-5 h-5" />
        </button>
      </div>

      <!-- Mobile Menu -->
      <div v-if="mobileMenuOpen" class="md:hidden border-t border-white/10 py-3">
        <div class="flex flex-col space-y-3">
          <a href="#how-it-works" @click="mobileMenuOpen = false" class="text-sm text-white/80 hover:text-white transition-colors">
            How It Works
          </a>
          <a href="#pricing" @click="mobileMenuOpen = false" class="text-sm text-white/80 hover:text-white transition-colors">
            Pricing
          </a>
          <a href="#contact" @click="mobileMenuOpen = false" class="text-sm text-white/80 hover:text-white transition-colors">
            Contact
          </a>
          <div class="pt-3 space-y-2">
            <NuxtLink 
              :to="getAuthRoute('login')" 
              @click="mobileMenuOpen = false" 
              class="block bg-white text-black hover:bg-white/90 font-medium px-4 py-2 rounded-lg transition-all duration-300 text-sm text-center"
            >
              Sign in
            </NuxtLink>
            <GlowButton
              tag="NuxtLink"
              :to="getAuthRoute('register')"
              size="sm"
              class="w-full"
              @click="mobileMenuOpen = false"
            >
              Sign up
            </GlowButton>
          </div>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { Bars3Icon, XMarkIcon } from "@heroicons/vue/24/outline";
import GlowButton from "~/components/ui/GlowButton.vue";

// Mobile menu state
const mobileMenuOpen = ref(false);

// Use app config for conditional routing
const { getAuthRoute } = useLaunchConfig();
</script>

<style scoped>
.main-nav {
  transition: all 0.3s ease;
}

.main-nav.nav-scrolled {
  background: rgba(0, 0, 0, 0.95);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}
</style>