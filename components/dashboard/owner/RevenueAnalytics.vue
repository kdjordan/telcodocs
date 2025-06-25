<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6">
    <div class="flex items-center justify-between mb-6">
      <h3 class="text-white font-semibold text-lg">Revenue Analytics</h3>
      <button 
        @click="$emit('view-billing')"
        class="text-pink-400 hover:text-pink-300 text-sm font-medium transition-colors"
      >
        View Billing
      </button>
    </div>
    
    <div v-if="loading" class="text-center py-8">
      <svg class="animate-spin h-6 w-6 mx-auto text-pink-500" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    </div>
    
    <div v-else class="space-y-6">
      <!-- Key Metrics -->
      <div class="grid grid-cols-2 gap-4">
        <div class="text-center">
          <p class="text-2xl font-bold text-white">${{ formatCurrency(revenueData?.mrr || 0) }}</p>
          <p class="text-white/60 text-xs">Monthly Recurring Revenue</p>
          <p :class="['text-xs mt-1', mrrGrowthColor]">
            {{ (revenueData?.growth || 0) > 0 ? '+' : '' }}{{ revenueData?.growth || 0 }}% this month
          </p>
        </div>
        <div class="text-center">
          <p class="text-2xl font-bold text-white">{{ revenueData?.seats || 0 }}</p>
          <p class="text-white/60 text-xs">Active Seats</p>
          <p class="text-green-400 text-xs mt-1">{{ seatUtilization }}% utilized</p>
        </div>
      </div>
      
      <!-- Revenue Breakdown -->
      <div class="space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-white/60 text-sm">Base Subscription</span>
          <span class="text-white text-sm">${{ formatCurrency(baseSubscription) }}</span>
        </div>
        <div class="flex items-center justify-between">
          <span class="text-white/60 text-sm">Per-Seat Revenue</span>
          <span class="text-white text-sm">${{ formatCurrency(seatRevenue) }}</span>
        </div>
        <div class="flex items-center justify-between">
          <span class="text-white/60 text-sm">Usage Fees</span>
          <span class="text-white text-sm">${{ formatCurrency(usageFees) }}</span>
        </div>
        <div class="pt-2 border-t border-white/10 flex items-center justify-between">
          <span class="text-white font-medium">Total MRR</span>
          <span class="text-white font-semibold">${{ formatCurrency(revenueData?.mrr || 0) }}</span>
        </div>
      </div>
      
      <!-- Health Indicators -->
      <div class="grid grid-cols-2 gap-4 pt-4 border-t border-white/10">
        <div class="text-center">
          <p :class="['text-lg font-semibold', churnColor]">{{ revenueData?.churnRate || 0 }}%</p>
          <p class="text-white/60 text-xs">Churn Rate</p>
        </div>
        <div class="text-center">
          <p class="text-lg font-semibold text-green-400">{{ netGrowth }}%</p>
          <p class="text-white/60 text-xs">Net Growth</p>
        </div>
      </div>
      
      <!-- Upgrade Potential -->
      <div class="bg-gradient-to-r from-pink-500/20 to-purple-500/20 rounded-lg p-4">
        <div class="flex items-center space-x-3">
          <ChartBarIcon class="w-5 h-5 text-pink-400" />
          <div>
            <p class="text-white text-sm font-medium">Growth Opportunity</p>
            <p class="text-white/60 text-xs">Add {{ potentialSeats }} more seats for +${{ potentialRevenue }}/mo</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ChartBarIcon } from '@heroicons/vue/24/outline'

interface RevenueData {
  mrr: number
  growth: number
  seats: number
  churnRate: number
}

interface Props {
  revenueData: RevenueData
  loading: boolean
}

const props = defineProps<Props>()

defineEmits<{
  'view-billing': []
}>()

const formatCurrency = (amount: number) => {
  return amount.toLocaleString('en-US', { 
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  })
}

const mrrGrowthColor = computed(() => 
  (props.revenueData?.growth || 0) > 0 ? 'text-green-400' : 'text-red-400'
)

const churnColor = computed(() => {
  const churn = props.revenueData?.churnRate || 0
  if (churn <= 5) return 'text-green-400'
  if (churn <= 10) return 'text-yellow-400'
  return 'text-red-400'
})

// Mock calculations - would be based on actual data
const baseSubscription = computed(() => 2999) // Enterprise base plan
const seatRevenue = computed(() => ((props.revenueData?.seats || 1) - 1) * 299) // Additional seats at $299 each
const usageFees = computed(() => (props.revenueData?.mrr || 0) - baseSubscription.value - seatRevenue.value)
const seatUtilization = computed(() => Math.min(100, ((props.revenueData?.seats || 1) / 10) * 100))
const netGrowth = computed(() => Math.max(0, (props.revenueData?.growth || 0) - (props.revenueData?.churnRate || 0)))
const potentialSeats = computed(() => Math.max(0, 15 - (props.revenueData?.seats || 1)))
const potentialRevenue = computed(() => potentialSeats.value * 299)
</script>