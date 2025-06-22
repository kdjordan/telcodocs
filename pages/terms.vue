<template>
  <div class="min-h-screen bg-black flex flex-col">
    <!-- Top Navigation -->
    <nav class="fixed top-0 left-0 right-0 z-50 bg-black/80 backdrop-blur-md border-b border-white/10">
      <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <NuxtLink to="/" class="flex items-center space-x-3">
            <div class="w-8 h-8 bg-pink-500 rounded-lg flex items-center justify-center">
              <span class="text-white text-sm font-bold">T</span>
            </div>
            <span class="text-white font-bold text-xl">TeloDox</span>
          </NuxtLink>

          <!-- Back to Home -->
          <NuxtLink to="/" class="text-white/80 hover:text-white transition-colors flex items-center space-x-2">
            <ArrowLeftIcon class="w-5 h-5" />
            <span>Back to Home</span>
          </NuxtLink>
        </div>
      </div>
    </nav>

    <div class="pt-20 container mx-auto px-6 py-12 max-w-4xl flex-grow">
      <div class="bg-white/5 border border-white/10 rounded-2xl p-8">
        <h1 class="text-3xl font-bold text-white mb-8">Terms and Conditions</h1>
        
        <div class="prose prose-gray max-w-none">
          <p class="text-white/60 mb-6">Last updated: {{ lastUpdated }}</p>
          
          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">1. Acceptance of Terms</h2>
            <p class="text-white/80 mb-4">
              By accessing and using TeloDox ("the Service"), you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">2. Description of Service</h2>
            <p class="text-white/80 mb-4">
              TeloDox is a multi-tenant SaaS application designed for telecommunications companies to manage carrier onboarding documents. The Service provides document management, form creation, digital signatures, and workflow automation tools.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">3. Subscription and Payment</h2>
            <p class="text-white/80 mb-4">
              Access to TeloDox requires a paid subscription. By subscribing to our Service, you agree to pay the subscription fees indicated for such Service. Subscription fees are billed in advance on a monthly or annual basis and are non-refundable.
            </p>
            <p class="text-white/80 mb-4">
              We reserve the right to change our subscription plans or adjust pricing at any time. Any price changes will take effect at the start of the next billing cycle.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">4. Tenant Accounts</h2>
            <p class="text-white/80 mb-4">
              When you create a tenant account, you are responsible for maintaining the security of your account and subdomain. You are fully responsible for all activities that occur under your account.
            </p>
            <p class="text-white/80 mb-4">
              You may not use offensive, vulgar, or otherwise inappropriate language in your subdomain name. We reserve the right to refuse service, terminate accounts, or remove content at our sole discretion.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">5. User Responsibilities</h2>
            <p class="text-white/80 mb-4">You agree not to:</p>
            <ul class="list-disc pl-6 mb-4 text-white/80">
              <li>Use the Service for any illegal purposes or in violation of any laws</li>
              <li>Upload or transmit viruses or any other malicious code</li>
              <li>Attempt to gain unauthorized access to any portion of the Service</li>
              <li>Use the Service to send spam or unsolicited communications</li>
              <li>Resell, redistribute, or sublicense the Service without our express written consent</li>
            </ul>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">6. Data Ownership and Security</h2>
            <p class="text-white/80 mb-4">
              You retain ownership of all data you submit to the Service. We will not sell, share, or rent your data to third parties. We implement industry-standard security measures to protect your data.
            </p>
            <p class="text-white/80 mb-4">
              You grant us a limited license to use, store, and process your data solely for the purpose of providing the Service to you.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">7. Intellectual Property</h2>
            <p class="text-white/80 mb-4">
              The Service and its original content, features, and functionality are owned by TeloDox and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">8. Limitation of Liability</h2>
            <p class="text-white/80 mb-4">
              In no event shall TeloDox, its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your use of the Service.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">9. Termination</h2>
            <p class="text-white/80 mb-4">
              We may terminate or suspend your account and bar access to the Service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever, including without limitation if you breach the Terms.
            </p>
            <p class="text-white/80 mb-4">
              Upon termination, your right to use the Service will cease immediately. You may request a copy of your data within 30 days of termination.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">10. Changes to Terms</h2>
            <p class="text-white/80 mb-4">
              We reserve the right to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days notice prior to any new terms taking effect.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-white mb-4">11. Contact Information</h2>
            <p class="text-white/80 mb-4">
              If you have any questions about these Terms, please contact us at:
            </p>
            <p class="text-white/80">
              Email: legal@telodox.com<br>
              Address: [Your Company Address]
            </p>
          </section>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <AppFooter />
  </div>
</template>

<script setup lang="ts">
import { ArrowLeftIcon } from "@heroicons/vue/24/outline";
import AppFooter from "~/components/ui/AppFooter.vue";

definePageMeta({
  layout: false,
});

const lastUpdated = new Date().toLocaleDateString('en-US', { 
  year: 'numeric', 
  month: 'long', 
  day: 'numeric' 
})

useHead({
  title: 'Terms and Conditions - TeloDox',
  meta: [
    { name: 'description', content: 'Terms and Conditions for TeloDox - Multi-tenant SaaS for telecommunications document management' }
  ]
})
</script>