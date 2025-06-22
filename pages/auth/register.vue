<template>
  <div class="min-h-screen bg-black flex flex-col">
    <!-- Top Navigation -->
    <nav class="bg-black/80 backdrop-blur-md border-b border-white/10">
      <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <NuxtLink to="/" class="flex items-center space-x-3">
            <div class="w-8 h-8 bg-pink-500 rounded-lg flex items-center justify-center">
              <span class="text-white text-sm font-bold">T</span>
            </div>
            <span class="text-white font-bold text-xl">TeloDox</span>
          </NuxtLink>

          <!-- Back to Home -->
          <NuxtLink to="/" class="text-white/80 hover:text-white transition-colors flex items-center space-x-2">
            <ArrowLeftIcon class="w-5 h-5" />
            <span>Back to Home</span>
          </NuxtLink>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <div class="flex-1 flex items-center justify-center p-6">
      <div class="w-full max-w-md">
        <!-- Auth Card -->
        <div class="bg-white/5 border border-white/10 rounded-2xl p-8 backdrop-blur-sm">
          <!-- Header -->
          <div class="text-center mb-8">
            <div class="w-16 h-16 bg-pink-500 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <UserPlusIcon class="w-8 h-8 text-white" />
            </div>
            <h2 class="text-2xl font-bold text-white mb-2">
              Create new account
            </h2>
            <p v-if="tenant" class="text-white/60">
              for {{ tenant.name }}
            </p>
            <p v-else class="text-white/60">
              Get started with TeloDox
            </p>
          </div>
      
          <form class="space-y-6" @submit.prevent="handleRegister">
            <div class="space-y-4">
          <div>
              <label for="fullName" class="block text-sm font-medium text-white mb-2">
                Full Name
              </label>
              <input
                id="fullName"
                v-model="form.fullName"
                name="fullName"
                type="text"
                autocomplete="name"
                required
                class="w-full px-4 py-3 bg-white/10 border border-white/20 rounded-xl text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="John Doe"
              >
          </div>
          
          <div>
              <label for="email" class="block text-sm font-medium text-white mb-2">
                Email Address
              </label>
              <input
                id="email"
                v-model="form.email"
                name="email"
                type="email"
                autocomplete="email"
                required
                class="w-full px-4 py-3 bg-white/10 border border-white/20 rounded-xl text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="john@example.com"
              >
          </div>
          
          <div>
              <label for="password" class="block text-sm font-medium text-white mb-2">
                Password
              </label>
              <input
                id="password"
                v-model="form.password"
                name="password"
                type="password"
                autocomplete="new-password"
                required
                class="w-full px-4 py-3 bg-white/10 border border-white/20 rounded-xl text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="••••••••"
              >
          </div>
          
          <div>
              <label for="confirmPassword" class="block text-sm font-medium text-white mb-2">
                Confirm Password
              </label>
              <input
                id="confirmPassword"
                v-model="form.confirmPassword"
                name="confirmPassword"
                type="password"
                autocomplete="new-password"
                required
                class="w-full px-4 py-3 bg-white/10 border border-white/20 rounded-xl text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="••••••••"
              >
          </div>
            </div>

            <div v-if="error" class="bg-red-500/10 border border-red-500/30 rounded-xl p-4">
              <div class="flex items-center">
                <ExclamationCircleIcon class="w-5 h-5 text-red-400 mr-3" />
                <p class="text-sm text-red-300">{{ error }}</p>
              </div>
            </div>

            <button
              type="submit"
              :disabled="loading"
              class="w-full bg-pink-500 hover:bg-pink-600 disabled:bg-pink-500/50 text-white font-semibold py-3 px-6 rounded-xl transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:ring-offset-2 focus:ring-offset-black"
            >
              <span v-if="loading" class="flex items-center justify-center">
                <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Creating account...
              </span>
              <span v-else>Create account</span>
            </button>

            <div class="text-center">
              <p class="text-sm text-white/60">
                Already have an account?
                <NuxtLink
                  to="/auth/login"
                  class="font-semibold text-pink-400 hover:text-pink-300 transition-colors"
                >
                  Sign in
                </NuxtLink>
              </p>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowLeftIcon, UserPlusIcon, ExclamationCircleIcon } from "@heroicons/vue/24/outline";

definePageMeta({
  layout: false
})

const { register } = useAuth()
const { tenant } = useTenant()
const router = useRouter()

const form = reactive({
  fullName: '',
  email: '',
  password: '',
  confirmPassword: ''
})

const loading = ref(false)
const error = ref('')

const handleRegister = async () => {
  loading.value = true
  error.value = ''
  
  // Validate passwords match
  if (form.password !== form.confirmPassword) {
    error.value = 'Passwords do not match'
    loading.value = false
    return
  }
  
  // Validate password strength
  if (form.password.length < 8) {
    error.value = 'Password must be at least 8 characters'
    loading.value = false
    return
  }
  
  try {
    const result = await register(
      form.email, 
      form.password, 
      form.fullName,
      tenant.value?.id
    )
    
    // Check if email confirmation is required
    if (result?.user && !result.session) {
      // Email confirmation required
      await router.push('/auth/verify-email')
    } else if (result?.session) {
      // Auto-confirmed, redirect to tenant setup
      await router.push('/onboarding/company-setup')
    }
  } catch (err: any) {
    console.error('Registration error:', err)
    error.value = err.message || 'Failed to create account'
  } finally {
    loading.value = false
  }
}
</script>