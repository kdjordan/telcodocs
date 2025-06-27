<template>
  <div class="min-h-screen bg-gray-50 py-12">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="text-center">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">
          Choose Your Plan
        </h1>
        <p class="text-xl text-gray-600 mb-4">
          Start your carrier onboarding platform today
        </p>
        <p class="text-lg text-blue-600 font-medium mb-8">
          Begin with 3 free carrier onboardings - no credit card required!
        </p>
        
        <!-- Billing Toggle -->
        <div class="flex items-center justify-center mb-8">
          <span class="text-sm font-medium" :class="billingPeriod === 'monthly' ? 'text-gray-900' : 'text-gray-500'">
            Monthly
          </span>
          <button
            @click="toggleBilling"
            class="mx-3 relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            :class="billingPeriod === 'yearly' ? 'bg-blue-600' : 'bg-gray-200'"
          >
            <span
              class="pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
              :class="billingPeriod === 'yearly' ? 'translate-x-5' : 'translate-x-0'"
            />
          </button>
          <span class="text-sm font-medium" :class="billingPeriod === 'yearly' ? 'text-gray-900' : 'text-gray-500'">
            Yearly
          </span>
          <span v-if="billingPeriod === 'yearly'" class="ml-2 inline-flex items-center rounded-full bg-green-100 px-2.5 py-0.5 text-xs font-medium text-green-800">
            Save 20%
          </span>
        </div>
      </div>

      <!-- Pricing Cards -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
        <div
          v-for="plan in plans"
          :key="plan.id"
          class="bg-white rounded-lg shadow-sm border-2 relative"
          :class="plan.name === 'Free' ? 'border-green-500' : plan.name === 'Professional' ? 'border-blue-500' : 'border-gray-200'"
        >
          <div v-if="plan.name === 'Free'" class="absolute -top-4 left-1/2 transform -translate-x-1/2">
            <span class="inline-flex items-center rounded-full bg-green-500 px-4 py-1 text-xs font-medium text-white">
              Start Free
            </span>
          </div>
          <div v-else-if="plan.name === 'Professional'" class="absolute -top-4 left-1/2 transform -translate-x-1/2">
            <span class="inline-flex items-center rounded-full bg-blue-500 px-4 py-1 text-xs font-medium text-white">
              Most Popular
            </span>
          </div>
          
          <div class="p-8">
            <h3 class="text-2xl font-semibold text-gray-900 mb-2">{{ plan.name }}</h3>
            <div class="mb-6">
              <span v-if="plan.name === 'Free'" class="text-4xl font-bold text-green-600">
                Free
              </span>
              <span v-else class="text-4xl font-bold text-gray-900">
                ${{ getPrice(plan) }}
              </span>
              <span v-if="plan.name !== 'Free'" class="text-gray-500 ml-1">
                /{{ billingPeriod === 'monthly' ? 'month' : 'year' }}
              </span>
            </div>
            
            <ul class="space-y-3 mb-8">
              <li v-for="feature in plan.features" :key="feature" class="flex items-start">
                <svg class="h-5 w-5 text-green-500 mr-3 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
                <span class="text-gray-600">{{ feature }}</span>
              </li>
            </ul>
            
            <button
              @click="selectPlan(plan)"
              :disabled="loading === plan.id"
              class="w-full py-3 px-4 rounded-md text-sm font-medium transition-colors"
              :class="plan.name === 'Free' 
                ? 'bg-green-600 text-white hover:bg-green-700 disabled:opacity-50'
                : plan.name === 'Professional' 
                ? 'bg-blue-600 text-white hover:bg-blue-700 disabled:opacity-50' 
                : 'bg-gray-100 text-gray-900 hover:bg-gray-200 disabled:opacity-50'"
            >
              <span v-if="loading === plan.id">Processing...</span>
              <span v-else-if="plan.name === 'Free'">Start Free</span>
              <span v-else>Get Early Access</span>
            </button>
          </div>
        </div>
      </div>

      <!-- Feature Comparison -->
      <div class="mt-16 max-w-5xl mx-auto">
        <h2 class="text-2xl font-bold text-gray-900 text-center mb-8">
          Compare Features
        </h2>
        <div class="overflow-x-auto">
          <table class="min-w-full bg-white rounded-lg shadow-sm">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Feature
                </th>
                <th v-for="plan in plans" :key="plan.id" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {{ plan.name }}
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                  Monthly Applications
                </td>
                <td v-for="plan in plans" :key="`apps-${plan.id}`" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                  {{ plan.max_applications === -1 ? 'Unlimited' : plan.max_applications }}
                </td>
              </tr>
              <tr>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                  Custom Forms
                </td>
                <td v-for="plan in plans" :key="`forms-${plan.id}`" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                  {{ plan.max_forms === -1 ? 'Unlimited' : plan.max_forms }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false
})

interface SubscriptionPlan {
  id: string
  name: string
  stripe_price_id: string
  price_monthly: number
  price_yearly?: number
  features: string[]
  max_applications: number
  max_forms: number
}

const { $supabase } = useNuxtApp()
const user = useSupabaseUser()
const { isComingSoon } = useLaunchConfig()

const billingPeriod = ref<'monthly' | 'yearly'>('monthly')
const plans = ref<SubscriptionPlan[]>([])
const loading = ref<string | null>(null)

// Fetch subscription plans
const fetchPlans = async () => {
  try {
    const { data, error } = await $supabase
      .from('subscription_plans')
      .select('*')
      .eq('is_active', true)
      .order('price_monthly', { ascending: true })

    if (error) throw error
    plans.value = data || []
  } catch (error) {
    console.error('Error fetching plans:', error)
  }
}

// Toggle billing period
const toggleBilling = () => {
  billingPeriod.value = billingPeriod.value === 'monthly' ? 'yearly' : 'monthly'
}

// Get price based on billing period
const getPrice = (plan: SubscriptionPlan) => {
  if (billingPeriod.value === 'yearly' && plan.price_yearly) {
    return (plan.price_yearly / 100).toFixed(0)
  }
  return (plan.price_monthly / 100).toFixed(0)
}

// Select a plan and redirect to checkout
const selectPlan = async (plan: SubscriptionPlan) => {
  // If in coming soon mode, always redirect to early access
  if (isComingSoon.value) {
    await navigateTo('/early-access')
    return
  }
  
  if (!user.value) {
    // Redirect to signup
    await navigateTo('/auth/register')
    return
  }

  loading.value = plan.id
  
  try {
    if (plan.name === 'Free') {
      // For free plan, redirect directly to company setup
      await navigateTo('/onboarding/company-setup')
      return
    }

    // For paid plans, create Stripe checkout session
    const { data } = await $fetch('/api/stripe/create-checkout', {
      method: 'POST',
      body: {
        priceId: plan.stripe_price_id,
        billingPeriod: billingPeriod.value
      }
    })

    if (data?.url) {
      window.location.href = data.url
    }
  } catch (error) {
    console.error('Error creating checkout session:', error)
  } finally {
    loading.value = null
  }
}

// Load plans on mount
onMounted(() => {
  fetchPlans()
})
</script>