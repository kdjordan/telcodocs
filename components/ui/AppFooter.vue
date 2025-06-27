<template>
  <footer class="bg-black border-t border-white/10">
    <div class="max-w-7xl mx-auto px-6 py-12">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
        <!-- Company Info -->
        <div class="col-span-1 md:col-span-2">
          <div class="flex items-center space-x-3 mb-4">
            <div class="w-8 h-8 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center">
              <span class="text-white text-sm font-bold">T</span>
            </div>
            <span class="text-white font-bold text-2xl">TeloDox</span>
          </div>
          <p class="text-white/80 mb-4 max-w-md">
            The telecom onboarding platform that turns email chaos into streamlined deal flow.
          </p>
          <p class="text-sm text-white/60">
            © {{ currentYear }} TeloDox. All rights reserved.
          </p>
        </div>

        <!-- Product Links -->
        <div>
          <h4 class="font-semibold text-white mb-4">Product</h4>
          <ul class="space-y-2">
            <li>
              <a href="/#how-it-works" class="text-white/70 hover:text-white transition-colors">
                How It Works
              </a>
            </li>
            <li>
              <a href="/#pricing" class="text-white/70 hover:text-white transition-colors">
                Pricing
              </a>
            </li>
            <li>
              <a href="mailto:support@telodox.com" class="text-white/70 hover:text-white transition-colors">
                Support
              </a>
            </li>
            <li>
              <NuxtLink :to="getAuthRoute('register')" class="text-white/70 hover:text-white transition-colors">
                Get Started
              </NuxtLink>
            </li>
          </ul>
        </div>

        <!-- Legal Links -->
        <div>
          <h4 class="font-semibold text-white mb-4">Legal</h4>
          <ul class="space-y-2">
            <li>
              <NuxtLink to="/terms" class="text-white/70 hover:text-white transition-colors">
                Terms & Conditions
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/privacy" class="text-white/70 hover:text-white transition-colors">
                Privacy Policy
              </NuxtLink>
            </li>
            <li>
              <a href="mailto:legal@telodox.com" class="text-white/70 hover:text-white transition-colors">
                Contact Legal
              </a>
            </li>
            <li>
              <NuxtLink :to="getAuthRoute('login')" class="text-white/70 hover:text-white transition-colors">
                Sign In
              </NuxtLink>
            </li>
          </ul>
        </div>
      </div>
      
      <!-- Bottom Border -->
      <div class="mt-8 pt-8 border-t border-white/10 flex flex-col md:flex-row justify-between items-center">
        <p class="text-white/60 text-sm">
          Built for telecommunications professionals who demand excellence.
        </p>
        <div class="flex space-x-6 mt-4 md:mt-0">
          <a href="mailto:hello@telodox.com" class="text-white/60 hover:text-white transition-colors text-sm">
            hello@telodox.com
          </a>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
const currentYear = new Date().getFullYear()
const { getAuthRoute } = useLaunchConfig()
</script>