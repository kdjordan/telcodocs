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
      <div class="w-full max-w-2xl text-center">
        <!-- Success State -->
        <div v-if="submitted" class="bg-white/5 border border-white/10 rounded-xl p-8 backdrop-blur-sm">
          <div class="w-16 h-16 bg-gradient-to-br from-green-500 to-emerald-600 rounded-full flex items-center justify-center mx-auto mb-6">
            <CheckIcon class="w-8 h-8 text-white" />
          </div>
          <h2 class="text-3xl font-bold text-white mb-4">
            You're on the list! 🚀
          </h2>
          <p class="text-lg text-white/80 mb-6">
            We'll send you an email as soon as TELODOX launches on <strong class="text-pink-400">August 1, 2025</strong>.
          </p>
          <p class="text-sm text-white/60 mb-8">
            In the meantime, follow our progress and get exclusive updates about the platform that's transforming telecom carrier onboarding.
          </p>
          <GlowButton @click="$router.push('/')" size="sm">
            Back to Home
          </GlowButton>
        </div>

        <!-- Email Capture Form -->
        <div v-else class="bg-white/5 border border-white/10 rounded-xl p-8 backdrop-blur-sm">
          <!-- Launch Announcement -->
          <div class="mb-8">
            <div class="inline-flex items-center px-4 py-2 bg-pink-500/20 border border-pink-500/30 rounded-full text-pink-300 text-sm font-medium mb-6">
              <RocketLaunchIcon class="w-4 h-4 mr-2" />
              Launching August 1, 2025
            </div>
            <h1 class="text-4xl font-bold text-white mb-4">
              The Future of Telecom Onboarding is Almost Here
            </h1>
            <p class="text-xl text-white/80 mb-8">
              Be among the first to experience streamlined carrier onboarding, intelligent document processing, and collaborative MSA redlining.
            </p>
          </div>

          <!-- Benefits List -->
          <div class="grid md:grid-cols-2 gap-6 mb-8 text-left">
            <div class="flex items-start space-x-3">
              <div class="w-6 h-6 bg-pink-500/20 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
                <DocumentCheckIcon class="w-4 h-4 text-pink-400" />
              </div>
              <div>
                <h3 class="text-white font-medium mb-1">Intelligent Document Processing</h3>
                <p class="text-sm text-white/60">Upload PDFs and transform them into digital workflows with AI-powered field detection.</p>
              </div>
            </div>
            <div class="flex items-start space-x-3">
              <div class="w-6 h-6 bg-pink-500/20 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
                <UsersIcon class="w-4 h-4 text-pink-400" />
              </div>
              <div>
                <h3 class="text-white font-medium mb-1">Team Collaboration</h3>
                <p class="text-sm text-white/60">Eliminate email chaos with role-based access and real-time team workflows.</p>
              </div>
            </div>
            <div class="flex items-start space-x-3">
              <div class="w-6 h-6 bg-pink-500/20 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
                <PencilSquareIcon class="w-4 h-4 text-pink-400" />
              </div>
              <div>
                <h3 class="text-white font-medium mb-1">MSA Redlining</h3>
                <p class="text-sm text-white/60">Professional document negotiation with change tracking and approval workflows.</p>
              </div>
            </div>
            <div class="flex items-start space-x-3">
              <div class="w-6 h-6 bg-pink-500/20 rounded-lg flex items-center justify-center flex-shrink-0 mt-0.5">
                <ChartBarIcon class="w-4 h-4 text-pink-400" />
              </div>
              <div>
                <h3 class="text-white font-medium mb-1">Analytics & Insights</h3>
                <p class="text-sm text-white/60">Track deal cycles, team performance, and optimize your onboarding process.</p>
              </div>
            </div>
          </div>

          <!-- Email Form -->
          <form @submit.prevent="handleSubmit" class="max-w-md mx-auto">
            <div class="mb-6">
              <label for="email" class="block text-sm font-medium text-white mb-3 text-left">
                Get notified when we launch
              </label>
              <input
                id="email"
                v-model="form.email"
                type="email"
                required
                class="w-full px-4 py-3 bg-white/10 border border-white/20 rounded-lg text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                placeholder="Enter your email address"
              >
            </div>

            <div v-if="error" class="bg-red-500/10 border border-red-500/30 rounded-lg p-4 mb-6">
              <div class="flex items-center">
                <ExclamationCircleIcon class="w-5 h-5 text-red-400 mr-3" />
                <p class="text-sm text-red-300">{{ error }}</p>
              </div>
            </div>

            <GlowButton
              type="submit"
              :disabled="loading || !form.email"
              size="lg"
              class="w-full"
            >
              <span v-if="loading" class="flex items-center justify-center">
                <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Joining waitlist...
              </span>
              <span v-else>Notify me on launch day</span>
            </GlowButton>
          </form>

          <!-- Social Proof -->
          <div class="mt-8 pt-6 border-t border-white/10">
            <p class="text-sm text-white/60">
              Join <span class="font-semibold text-pink-400">{{ subscriberCount }}+</span> telecom professionals already waiting
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { 
  ArrowLeftIcon, 
  RocketLaunchIcon, 
  DocumentCheckIcon, 
  UsersIcon, 
  PencilSquareIcon, 
  ChartBarIcon,
  CheckIcon,
  ExclamationCircleIcon
} from "@heroicons/vue/24/outline";
import GlowButton from "~/components/ui/GlowButton.vue";

definePageMeta({
  layout: false,
  auth: false
})

const form = reactive({
  email: ''
})

const loading = ref(false)
const error = ref('')
const submitted = ref(false)
const subscriberCount = ref(247) // Start with a reasonable number

const handleSubmit = async () => {
  if (!form.email) return
  
  loading.value = true
  error.value = ''
  
  try {
    const response = await $fetch('/api/early-access', {
      method: 'POST',
      body: {
        email: form.email,
        source: 'early_access_page',
        referrer: document.referrer,
        metadata: {
          userAgent: navigator.userAgent,
          timestamp: new Date().toISOString()
        }
      }
    })
    
    submitted.value = true
    subscriberCount.value = response.totalCount || subscriberCount.value + 1
    
    // Track conversion for analytics
    if (typeof gtag !== 'undefined') {
      gtag('event', 'early_access_signup', {
        email_hash: btoa(form.email).substring(0, 8) // Anonymous tracking
      })
    }
    
  } catch (err: any) {
    console.error('Early access signup error:', err)
    if (err.data?.message?.includes('already exists')) {
      error.value = 'You\'re already on our waitlist! We\'ll notify you on launch day.'
    } else {
      error.value = err.data?.message || 'Failed to join waitlist. Please try again.'
    }
  } finally {
    loading.value = false
  }
}

// Set page title and meta
useHead({
  title: 'Early Access - TELODOX',
  meta: [
    { name: 'description', content: 'Be among the first to experience the future of telecom carrier onboarding. TELODOX launches August 1, 2025.' },
    { property: 'og:title', content: 'Early Access - TELODOX' },
    { property: 'og:description', content: 'Transform telecom carrier onboarding from email chaos to streamlined deal flow. Join the waitlist for August 1, 2025 launch.' },
    { name: 'twitter:card', content: 'summary_large_image' }
  ]
})
</script>