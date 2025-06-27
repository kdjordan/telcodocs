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
        <!-- Email Verification Card -->
        <div class="bg-white/5 border border-white/10 rounded-xl p-8 backdrop-blur-sm text-center">
          <!-- Icon -->
          <div class="w-16 h-16 bg-gradient-to-br from-pink-500 to-purple-600 rounded-xl flex items-center justify-center mx-auto mb-6">
            <EnvelopeIcon class="w-8 h-8 text-white" />
          </div>
          
          <h2 class="text-2xl font-bold text-white mb-3">
            Check your email
          </h2>
          <p class="text-white/80 mb-8">
            We've sent a verification link to <br/>
            <span class="font-semibold text-white">{{ userEmail }}</span>
          </p>
          
          <div class="space-y-4">
            <p class="text-sm text-white/60">
              Please check your inbox and click the link to verify your email address.
            </p>
            
            <div class="pt-6 border-t border-white/10">
              <p class="text-sm text-white/60 mb-3">
                Didn't receive the email?
              </p>
              <button 
                @click="resendEmail" 
                :disabled="resending || cooldown > 0"
                class="text-pink-400 hover:text-pink-300 font-semibold text-sm transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <span v-if="cooldown > 0">Resend in {{ cooldown }}s</span>
                <span v-else-if="resending">Sending...</span>
                <span v-else>Resend verification email</span>
              </button>
            </div>
          </div>
          
          <div class="mt-8">
            <NuxtLink
              to="/auth/login"
              class="text-white/60 hover:text-white text-sm transition-colors"
            >
              Back to sign in
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ArrowLeftIcon, EnvelopeIcon } from '@heroicons/vue/24/outline'

definePageMeta({
  layout: false,
  auth: false
})

const supabase = useSupabaseClient()

// Get email from localStorage (stored during registration)
const userEmail = ref('')
const resending = ref(false)
const cooldown = ref(0)

onMounted(() => {
  if (typeof window !== 'undefined') {
    const pendingData = localStorage.getItem('pendingRegistration')
    if (pendingData) {
      try {
        const data = JSON.parse(pendingData)
        userEmail.value = data.email
      } catch (e) {
        console.error('Error parsing pending registration data', e)
      }
    }
  }
})

// Cooldown timer
const startCooldown = () => {
  cooldown.value = 60
  const timer = setInterval(() => {
    cooldown.value--
    if (cooldown.value <= 0) {
      clearInterval(timer)
    }
  }, 1000)
}

// Resend verification email
const resendEmail = async () => {
  if (!userEmail.value || resending.value || cooldown.value > 0) return
  
  resending.value = true
  
  try {
    const { error } = await supabase.auth.resend({
      type: 'signup',
      email: userEmail.value
    })
    
    if (error) throw error
    
    // Start cooldown
    startCooldown()
    
    // Show success (you could use vue-sonner here)
    console.log('Verification email resent successfully')
  } catch (error) {
    console.error('Error resending email:', error)
  } finally {
    resending.value = false
  }
}
</script>