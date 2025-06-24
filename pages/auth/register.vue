<template>
  <div class="min-h-screen bg-black flex flex-col">
    <!-- Top Navigation -->
    <nav class="bg-black/80 backdrop-blur-md border-b border-white/10">
      <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-14">
          <!-- Logo -->
          <NuxtLink to="/" class="flex items-center space-x-2">
            <div class="w-7 h-7 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center">
              <span class="text-white text-xs font-bold">T</span>
            </div>
            <span class="text-white font-bold text-lg">TeloDox</span>
          </NuxtLink>

          <!-- Back to Home -->
          <NuxtLink to="/" class="text-white/80 hover:text-white transition-colors flex items-center space-x-2 text-sm">
            <ArrowLeftIcon class="w-4 h-4" />
            <span>Back to Home</span>
          </NuxtLink>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <div class="flex-1 flex items-center justify-center p-6">
      <div class="w-full max-w-md">
        <!-- Auth Card -->
        <div class="bg-white/5 border border-white/10 rounded-xl p-6 backdrop-blur-sm">
          <!-- Header -->
          <div class="text-center mb-6">
            <div class="w-12 h-12 bg-gradient-to-br from-pink-500 to-purple-600 rounded-xl flex items-center justify-center mx-auto mb-3">
              <UserPlusIcon class="w-6 h-6 text-white" />
            </div>
            <h2 class="text-xl font-bold text-white mb-2">
              Create new account
            </h2>
            <p v-if="tenant" class="text-sm text-white/60">
              for {{ tenant.name }}
            </p>
            <p v-else class="text-sm text-white/60">
              Get started with TeloDox
            </p>
          </div>
      
          <form class="space-y-5" @submit.prevent="handleRegister">
            <div class="space-y-3">
          <div>
              <label for="fullName" class="block text-xs font-medium text-white mb-2">
                Full Name
              </label>
              <input
                id="fullName"
                v-model="form.fullName"
                name="fullName"
                type="text"
                autocomplete="name"
                required
                class="w-full px-3 py-2.5 bg-white/10 border border-white/20 rounded-lg text-sm text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="John Doe"
              >
          </div>
          
          <div>
              <label for="email" class="block text-xs font-medium text-white mb-2">
                Email Address
              </label>
              <input
                id="email"
                v-model="form.email"
                name="email"
                type="email"
                autocomplete="email"
                required
                class="w-full px-3 py-2.5 bg-white/10 border border-white/20 rounded-lg text-sm text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="john@example.com"
              >
          </div>
          
          <div>
              <label for="password" class="block text-xs font-medium text-white mb-2">
                Password
              </label>
              <input
                id="password"
                v-model="form.password"
                name="password"
                type="password"
                autocomplete="new-password"
                required
                class="w-full px-3 py-2.5 bg-white/10 border border-white/20 rounded-lg text-sm text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="••••••••"
              >
          </div>
          
          <div>
              <label for="confirmPassword" class="block text-xs font-medium text-white mb-2">
                Confirm Password
              </label>
              <input
                id="confirmPassword"
                v-model="form.confirmPassword"
                name="confirmPassword"
                type="password"
                autocomplete="new-password"
                required
                class="w-full px-3 py-2.5 bg-white/10 border border-white/20 rounded-lg text-sm text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="••••••••"
              >
          </div>
          
          <!-- Dev Password Field (only shown when needed) -->
          <div v-if="showDevPassword">
              <label for="devPassword" class="block text-xs font-medium text-yellow-400 mb-2">
                Developer Access Code
              </label>
              <input
                id="devPassword"
                v-model="form.devPassword"
                name="devPassword"
                type="password"
                class="w-full px-3 py-2.5 bg-yellow-500/10 border border-yellow-500/30 rounded-lg text-sm text-white placeholder-yellow-300/60 focus:outline-none focus:ring-2 focus:ring-yellow-500 focus:border-transparent transition-all"
                placeholder="Enter developer access code"
              >
              <p class="text-xs text-yellow-300/80 mt-1">
                Platform is in pre-launch mode. Access code required for testing.
              </p>
          </div>
            </div>

            <div v-if="error" class="bg-red-500/10 border border-red-500/30 rounded-xl p-4">
              <div class="flex items-center">
                <ExclamationCircleIcon class="w-5 h-5 text-red-400 mr-3" />
                <p class="text-sm text-red-300">{{ error }}</p>
              </div>
            </div>

            <div class="w-full flex justify-end">
              <GlowButton
                type="submit"
                :disabled="loading"
                size="sm"
              >
              <span v-if="loading" class="flex items-center justify-center">
                <svg class="animate-spin -ml-1 mr-3 h-3 w-3 text-white" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Creating account...
              </span>
              <span v-else>Create account</span>
            </GlowButton>
            </div>

            <div class="text-center">
              <p class="text-xs text-white/60">
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
import GlowButton from "~/components/ui/GlowButton.vue";

definePageMeta({
  layout: false,
  auth: false
})

const { register } = useAuth()
const { tenant } = useTenant()
const router = useRouter()

const form = reactive({
  fullName: '',
  email: '',
  password: '',
  confirmPassword: '',
  devPassword: ''
})

const loading = ref(false)
const error = ref('')

// Show dev password field when in production mode and dev password is configured
const runtimeConfig = useRuntimeConfig()
const showDevPassword = computed(() => {
  return process.env.NODE_ENV === 'production' && runtimeConfig.public.devPassword
})

const handleRegister = async () => {
  loading.value = true
  error.value = ''
  
  // Check if we're in production and no dev password provided
  const runtimeConfig = useRuntimeConfig()
  const isProduction = process.env.NODE_ENV === 'production'
  const devPassword = runtimeConfig.public.devPassword
  
  if (isProduction && devPassword && form.devPassword !== devPassword) {
    // Redirect to early access page instead of showing error
    await router.push('/early-access')
    return
  }
  
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