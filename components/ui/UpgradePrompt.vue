<template>
  <div class="bg-white/5 border border-white/10 rounded-xl p-6 relative overflow-hidden">
    <!-- Background gradient -->
    <div class="absolute inset-0 bg-gradient-to-br from-pink-500/10 to-purple-500/10"></div>
    
    <div class="relative">
      <div class="w-12 h-12 bg-pink-500 rounded-full flex items-center justify-center mb-4">
        <RocketLaunchIcon class="w-6 h-6 text-white" />
      </div>
      
      <h3 class="text-white font-bold text-lg mb-2">Upgrade to Pro!</h3>
      <p class="text-white/60 text-sm mb-4">
        Unlock Premium features and get unlimited access to all features.
      </p>
      
      <!-- Trial Progress -->
      <div class="mb-4">
        <div class="flex items-center justify-between mb-2">
          <span class="text-white/60 text-xs">Trial Progress</span>
          <span class="text-white/60 text-xs">{{ trialDaysLeft }} days left</span>
        </div>
        <div class="w-full bg-white/10 rounded-full h-2">
          <div 
            class="bg-gradient-to-r from-pink-500 to-purple-500 h-2 rounded-full transition-all duration-300" 
            :style="{ width: `${trialProgress}%` }"
          ></div>
        </div>
      </div>
      
      <GlowButton size="sm" class="w-full">
        Upgrade Now
      </GlowButton>
    </div>
  </div>
</template>

<script setup lang="ts">
import { RocketLaunchIcon } from '@heroicons/vue/24/outline'

interface Props {
  trialDaysLeft: number
  trialProgress: number
}

defineProps<Props>()
</script>