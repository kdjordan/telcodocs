<template>
  <footer class="bg-white border-t border-gray-200">
    <div class="container mx-auto px-4 py-12">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
        <!-- Company Info -->
        <div class="col-span-1 md:col-span-2">
          <h3 class="font-sign1 text-3xl text-dark mb-4">Telodox</h3>
          <p class="text-gray-600 mb-4">
            The telecom onboarding platform that turns email chaos into streamlined deal flow.
          </p>
          <p class="text-sm text-gray-500">
            © {{ currentYear }} Telodox. All rights reserved.
          </p>
        </div>

        <!-- Product Links -->
        <div>
          <h4 class="font-semibold text-gray-900 mb-4">Product</h4>
          <ul class="space-y-2">
            <li>
              <NuxtLink to="/#features" class="text-gray-600 hover:text-dark transition-colors">
                Features
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/#pricing" class="text-gray-600 hover:text-dark transition-colors">
                Pricing
              </NuxtLink>
            </li>
            <li>
              <a href="mailto:support@telodox.com" class="text-gray-600 hover:text-dark transition-colors">
                Support
              </a>
            </li>
          </ul>
        </div>

        <!-- Legal Links -->
        <div>
          <h4 class="font-semibold text-gray-900 mb-4">Legal</h4>
          <ul class="space-y-2">
            <li>
              <NuxtLink to="/terms" class="text-gray-600 hover:text-dark transition-colors">
                Terms & Conditions
              </NuxtLink>
            </li>
            <li>
              <NuxtLink to="/privacy" class="text-gray-600 hover:text-dark transition-colors">
                Privacy Policy
              </NuxtLink>
            </li>
            <li>
              <a href="mailto:legal@telodox.com" class="text-gray-600 hover:text-dark transition-colors">
                Contact
              </a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
const currentYear = new Date().getFullYear()
</script>