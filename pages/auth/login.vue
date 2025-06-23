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
              <LockClosedIcon class="w-6 h-6 text-white" />
            </div>
            <h1 class="text-xl font-bold text-white mb-2">
              Welcome back
            </h1>
            <p class="text-sm text-white/60">
              {{ tenant ? `Sign in to ${tenant.name}` : 'Sign in to your account' }}
            </p>
          </div>
        
          <form class="space-y-5" @submit.prevent="handleLogin">
          <div class="space-y-4">
            <div>
              <label for="email" class="block text-xs font-medium text-white mb-2">
                Email address
              </label>
              <input
                id="email"
                v-model="form.email"
                name="email"
                type="email"
                autocomplete="email"
                required
                class="w-full px-3 py-2.5 bg-white/10 border border-white/20 rounded-lg text-sm text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="Enter your email"
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
                autocomplete="current-password"
                required
                class="w-full px-3 py-2.5 bg-white/10 border border-white/20 rounded-lg text-sm text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="Enter your password"
              >
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
              Signing in...
            </span>
            <span v-else>Sign in</span>
          </GlowButton>
          </div>

          <div class="text-center space-y-3">
            <NuxtLink
              to="/auth/forgot-password"
              class="text-xs text-white/60 hover:text-white transition-colors"
            >
              Forgot your password?
            </NuxtLink>
            
            <div class="border-t border-white/10 pt-3">
              <p class="text-xs text-white/60">
                Don't have an account?
                <NuxtLink
                  to="/auth/register"
                  class="font-semibold text-pink-400 hover:text-pink-300 transition-colors"
                >
                  Create account
                </NuxtLink>
              </p>
            </div>
          </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowLeftIcon, LockClosedIcon, ExclamationCircleIcon } from "@heroicons/vue/24/outline";
import GlowButton from "~/components/ui/GlowButton.vue";

definePageMeta({
  layout: false,
  auth: false
})

const { login, profile } = useAuth()
const { tenant } = useTenant()
const router = useRouter()

const form = reactive({
  email: '',
  password: ''
})

const loading = ref(false)
const error = ref('')

const handleLogin = async () => {
  loading.value = true
  error.value = ''
  
  try {
    await login(form.email, form.password)
    
    // Wait for profile to be loaded
    await new Promise(resolve => setTimeout(resolve, 100))
    
    // Get redirect from query params if exists
    const redirect = router.currentRoute.value.query.redirect as string
    
    // Redirect based on user role or to intended destination
    if (redirect && redirect !== '/auth/login') {
      await router.push(redirect)
    } else if (profile.value?.role === 'super_admin') {
      await router.push('/admin')
    } else {
      await router.push('/dashboard')
    }
  } catch (err: any) {
    error.value = err.message || 'Invalid email or password'
  } finally {
    loading.value = false
  }
}
</script>