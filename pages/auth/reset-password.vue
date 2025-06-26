<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-900 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-white">
          Set new password
        </h2>
        <p class="mt-2 text-center text-sm text-gray-400">
          Enter your new password below.
        </p>
      </div>

      <div v-if="!passwordUpdated" class="bg-gray-800 rounded-2xl p-6 shadow-lg">
        <form @submit.prevent="updatePassword" class="space-y-6">
          <div>
            <label for="password" class="block text-sm font-medium text-gray-300 mb-2">
              New password
            </label>
            <div class="relative">
              <input
                id="password"
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                class="w-full px-3 py-2.5 bg-gray-700 border border-gray-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-accent focus:border-transparent"
                :class="{ 'border-red-500': passwordError }"
                placeholder="Enter new password"
                @input="passwordError = ''"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-300"
              >
                <EyeIcon v-if="!showPassword" class="h-5 w-5" />
                <EyeSlashIcon v-else class="h-5 w-5" />
              </button>
            </div>
            <p v-if="passwordError" class="mt-1 text-sm text-red-400">{{ passwordError }}</p>
          </div>

          <div>
            <label for="confirmPassword" class="block text-sm font-medium text-gray-300 mb-2">
              Confirm new password
            </label>
            <div class="relative">
              <input
                id="confirmPassword"
                v-model="confirmPassword"
                :type="showConfirmPassword ? 'text' : 'password'"
                class="w-full px-3 py-2.5 bg-gray-700 border border-gray-600 rounded-lg text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-accent focus:border-transparent"
                :class="{ 'border-red-500': confirmPasswordError }"
                placeholder="Confirm new password"
                @input="confirmPasswordError = ''"
              />
              <button
                type="button"
                @click="showConfirmPassword = !showConfirmPassword"
                class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-300"
              >
                <EyeIcon v-if="!showConfirmPassword" class="h-5 w-5" />
                <EyeSlashIcon v-else class="h-5 w-5" />
              </button>
            </div>
            <p v-if="confirmPasswordError" class="mt-1 text-sm text-red-400">{{ confirmPasswordError }}</p>
          </div>

          <GlowButton
            type="submit"
            :disabled="!password || !confirmPassword || loading"
            :loading="loading"
            class="w-full"
          >
            Update password
          </GlowButton>
        </form>
      </div>

      <div v-else class="bg-gray-800 rounded-2xl p-6 shadow-lg">
        <div class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-900 mb-4">
            <CheckIcon class="h-6 w-6 text-green-400" />
          </div>
          <h3 class="text-lg font-medium text-white mb-2">Password updated</h3>
          <p class="text-sm text-gray-400 mb-6">
            Your password has been successfully updated. You can now sign in with your new password.
          </p>
          <GlowButton @click="goToLogin" class="w-full">
            Sign in
          </GlowButton>
        </div>
      </div>

      <div v-if="error" class="text-center">
        <div class="bg-gray-800 rounded-2xl p-6 shadow-lg">
          <div class="text-center">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-900 mb-4">
              <XMarkIcon class="h-6 w-6 text-red-400" />
            </div>
            <h3 class="text-lg font-medium text-white mb-2">Invalid or expired link</h3>
            <p class="text-sm text-gray-400 mb-6">
              {{ error }}
            </p>
            <NuxtLink
              to="/auth/forgot-password"
              class="text-accent hover:text-accent/80 transition-colors"
            >
              Request a new reset link
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { EyeIcon, EyeSlashIcon, CheckIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import { toast } from 'vue-sonner'

definePageMeta({
  layout: false,
  auth: false
})

const { $supabase } = useNuxtApp()
const route = useRoute()
const router = useRouter()

const password = ref('')
const confirmPassword = ref('')
const passwordError = ref('')
const confirmPasswordError = ref('')
const loading = ref(false)
const passwordUpdated = ref(false)
const error = ref('')
const showPassword = ref(false)
const showConfirmPassword = ref(false)

onMounted(async () => {
  // Check if we have the session from the reset link
  const { data: { session }, error: sessionError } = await $supabase.auth.getSession()
  
  if (sessionError || !session) {
    error.value = 'Invalid or expired reset link. Please request a new password reset.'
    return
  }

  // Check for access token in URL params (from email link)
  const accessToken = route.query.access_token
  const refreshToken = route.query.refresh_token
  
  if (accessToken && refreshToken) {
    try {
      const { data, error: setSessionError } = await $supabase.auth.setSession({
        access_token: accessToken,
        refresh_token: refreshToken
      })
      
      if (setSessionError) {
        throw setSessionError
      }
    } catch (err) {
      console.error('Session error:', err)
      error.value = 'Invalid or expired reset link. Please request a new password reset.'
    }
  }
})

const validatePasswords = () => {
  let isValid = true
  
  if (!password.value) {
    passwordError.value = 'Password is required'
    isValid = false
  } else if (password.value.length < 6) {
    passwordError.value = 'Password must be at least 6 characters'
    isValid = false
  }
  
  if (!confirmPassword.value) {
    confirmPasswordError.value = 'Please confirm your password'
    isValid = false
  } else if (password.value !== confirmPassword.value) {
    confirmPasswordError.value = 'Passwords do not match'
    isValid = false
  }
  
  return isValid
}

const updatePassword = async () => {
  if (!validatePasswords()) {
    return
  }

  loading.value = true
  
  try {
    const { error: updateError } = await $supabase.auth.updateUser({
      password: password.value
    })

    if (updateError) {
      throw updateError
    }

    passwordUpdated.value = true
    toast.success('Your password has been successfully updated')
  } catch (err) {
    console.error('Password update error:', err)
    
    if (err.message?.includes('session_not_found')) {
      error.value = 'Your reset session has expired. Please request a new password reset.'
    } else {
      passwordError.value = err.message || 'Failed to update password'
      toast.error(passwordError.value)
    }
  } finally {
    loading.value = false
  }
}

const goToLogin = () => {
  router.push('/auth/login')
}

useSeoMeta({
  title: 'Reset Password - TelcoDocs',
  description: 'Set your new TelcoDocs password'
})
</script>