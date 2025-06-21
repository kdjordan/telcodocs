<template>
  <div class="min-h-screen bg-bgLight flex items-center justify-center p-6">
    <div class="w-full max-w-md">
      <!-- Auth Card -->
      <div class="glass-card">
        <!-- Header -->
        <div class="text-center mb-8">
          <div class="w-16 h-16 bg-gradient-to-br from-primary to-accent rounded-2xl flex items-center justify-center mx-auto mb-4">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
            </svg>
          </div>
          <h1 class="text-2xl font-bold font-heading text-textPrimary mb-2">
            Welcome back
          </h1>
          <p class="text-textSecondary">
            {{ tenant ? `Sign in to ${tenant.name}` : 'Sign in to your account' }}
          </p>
        </div>
        
        <form class="space-y-6" @submit.prevent="handleLogin">
          <div class="space-y-4">
            <div>
              <label for="email" class="block text-sm font-medium text-textPrimary mb-2">
                Email address
              </label>
              <input
                id="email"
                v-model="form.email"
                name="email"
                type="email"
                autocomplete="email"
                required
                class="form-input"
                placeholder="Enter your email"
              >
            </div>
            
            <div>
              <label for="password" class="block text-sm font-medium text-textPrimary mb-2">
                Password
              </label>
              <input
                id="password"
                v-model="form.password"
                name="password"
                type="password"
                autocomplete="current-password"
                required
                class="form-input"
                placeholder="Enter your password"
              >
            </div>
          </div>

          <div v-if="error" class="bg-red-50 border border-red-200 rounded-xl p-4">
            <div class="flex items-center">
              <svg class="w-5 h-5 text-red-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <p class="text-sm text-red-700">{{ error }}</p>
            </div>
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="btn-primary w-full py-3 font-semibold"
          >
            <span v-if="loading" class="flex items-center justify-center">
              <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              Signing in...
            </span>
            <span v-else>Sign in</span>
          </button>

          <div class="text-center space-y-3">
            <NuxtLink
              to="/auth/forgot-password"
              class="text-sm text-textSecondary hover:text-textPrimary transition-colors"
            >
              Forgot your password?
            </NuxtLink>
            
            <div class="border-t border-gray-200 pt-4">
              <p class="text-sm text-textSecondary">
                Don't have an account?
                <NuxtLink
                  to="/auth/register"
                  class="font-semibold text-primary hover:text-primary/80 transition-colors"
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
</template>

<script setup lang="ts">
definePageMeta({
  layout: false
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