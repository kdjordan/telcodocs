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
          
          <!-- Reset Form -->
          <div v-if="!emailSent">
            <!-- Header -->
            <div class="text-center mb-6">
              <div class="w-12 h-12 bg-gradient-to-br from-pink-500 to-purple-600 rounded-xl flex items-center justify-center mx-auto mb-3">
                <KeyIcon class="w-6 h-6 text-white" />
              </div>
              <h2 class="text-xl font-bold text-white mb-2">
                Reset your password
              </h2>
              <p class="text-sm text-white/60">
                Enter your email address and we'll send you a link to reset your password.
              </p>
            </div>

            <form @submit.prevent="resetPassword" class="space-y-5">
              <div>
                <label for="email" class="block text-xs font-medium text-white mb-2">
                  Email address
                </label>
                <input
                  id="email"
                  v-model="email"
                  type="email"
                  required
                  class="w-full px-3 py-2.5 bg-white/10 border border-white/20 rounded-lg text-sm text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                  :class="{ 'border-red-500 focus:ring-red-500': emailError }"
                  placeholder="Enter your email"
                  @input="emailError = ''"
                />
                <p v-if="emailError" class="mt-2 text-xs text-red-300">{{ emailError }}</p>
              </div>

              <div class="w-full flex justify-end">
                <button
                  type="submit"
                  :disabled="!email || loading"
                  class="bg-white text-black hover:bg-white/90 font-medium px-6 py-3 rounded-lg transition-all duration-300 text-sm disabled:opacity-50 disabled:cursor-not-allowed"
                >
                <span v-if="loading" class="flex items-center justify-center">
                  <svg class="animate-spin -ml-1 mr-3 h-3 w-3 text-black" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Sending...
                </span>
                <span v-else>Send reset link</span>
                </button>
              </div>
            </form>

            <div class="mt-5 text-center">
              <NuxtLink
                to="/auth/login"
                class="text-xs text-white/60 hover:text-white transition-colors"
              >
                Back to login
              </NuxtLink>
            </div>
          </div>

          <!-- Success State -->
          <div v-else class="text-center">
            <div class="w-12 h-12 bg-gradient-to-br from-green-500 to-emerald-600 rounded-xl flex items-center justify-center mx-auto mb-3">
              <CheckCircleIcon class="w-6 h-6 text-white" />
            </div>
            <h3 class="text-lg font-bold text-white mb-2">Check your email</h3>
            <p class="text-sm text-white/60 mb-5">
              We've sent a password reset link to <strong class="text-white">{{ email }}</strong>.
              Click the link in the email to reset your password.
            </p>
            <div class="space-y-3">
              <button
                @click="resetPassword"
                :disabled="loading"
                class="w-full bg-white/10 hover:bg-white/20 disabled:bg-white/5 text-white font-medium py-2.5 px-4 rounded-lg border border-white/20 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-pink-500 text-sm"
              >
                <span v-if="loading" class="flex items-center justify-center">
                  <svg class="animate-spin -ml-1 mr-3 h-3 w-3 text-white" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Sending...
                </span>
                <span v-else>Resend email</span>
              </button>
              <NuxtLink
                to="/auth/login"
                class="block text-xs text-white/60 hover:text-white transition-colors"
              >
                Back to login
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ArrowLeftIcon, KeyIcon, CheckCircleIcon } from "@heroicons/vue/24/outline";
import GlowButton from "~/components/ui/GlowButton.vue";

definePageMeta({
  layout: false,
  auth: false
})

const supabase = useSupabaseClient()

const email = ref('')
const emailError = ref('')
const loading = ref(false)
const emailSent = ref(false)

const resetPassword = async () => {
  if (!email.value) {
    emailError.value = 'Email is required'
    return
  }

  if (!isValidEmail(email.value)) {
    emailError.value = 'Please enter a valid email address'
    return
  }

  loading.value = true
  emailError.value = ''

  try {
    const { error } = await supabase.auth.resetPasswordForEmail(email.value, {
      redirectTo: `${window.location.origin}/auth/reset-password`
    })

    if (error) {
      throw error
    }

    emailSent.value = true
  } catch (error) {
    console.error('Password reset error:', error)
    
    if (error.message?.includes('Email not confirmed')) {
      emailError.value = 'Please verify your email address first'
    } else if (error.message?.includes('Invalid email')) {
      emailError.value = 'No account found with this email address'
    } else {
      emailError.value = error.message || 'Failed to send reset email'
    }
  } finally {
    loading.value = false
  }
}

const isValidEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

useSeoMeta({
  title: 'Reset Password - TelcoDocs',
  description: 'Reset your TelcoDocs password'
})
</script>