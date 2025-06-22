<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <!-- Header -->
    <header class="bg-white border-b border-gray-200">
      <div class="container mx-auto px-4 py-4 flex items-center justify-between">
        <NuxtLink to="/" class="font-sign1 text-3xl text-dark">
          Telodox
        </NuxtLink>
        <NuxtLink to="/" class="text-gray-600 hover:text-dark transition-colors flex items-center space-x-2">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
          </svg>
          <span>Back to Home</span>
        </NuxtLink>
      </div>
    </header>

    <div class="container mx-auto px-4 py-12 max-w-4xl flex-grow">
      <div class="bg-white rounded-lg shadow-sm p-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Privacy Policy</h1>
        
        <div class="prose prose-gray max-w-none">
          <p class="text-gray-600 mb-6">Last updated: {{ lastUpdated }}</p>
          
          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">1. Introduction</h2>
            <p class="text-gray-700 mb-4">
              TeloDox ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our multi-tenant SaaS application for telecommunications document management.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">2. Information We Collect</h2>
            <h3 class="text-xl font-semibold text-gray-800 mb-3">Personal Information</h3>
            <p class="text-gray-700 mb-4">We may collect the following personal information:</p>
            <ul class="list-disc pl-6 mb-4 text-gray-700">
              <li>Name and contact information (email address, phone number)</li>
              <li>Company name and business details</li>
              <li>Billing and payment information</li>
              <li>Account credentials</li>
              <li>Digital signatures</li>
            </ul>
            
            <h3 class="text-xl font-semibold text-gray-800 mb-3">Document Data</h3>
            <p class="text-gray-700 mb-4">
              We store and process documents and forms you upload or create within the Service, including carrier onboarding documents, KYC forms, and related telecommunications compliance documents.
            </p>
            
            <h3 class="text-xl font-semibold text-gray-800 mb-3">Usage Data</h3>
            <p class="text-gray-700 mb-4">We automatically collect:</p>
            <ul class="list-disc pl-6 mb-4 text-gray-700">
              <li>IP addresses and browser information</li>
              <li>Device information</li>
              <li>Access times and dates</li>
              <li>Features used within the Service</li>
            </ul>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">3. How We Use Your Information</h2>
            <p class="text-gray-700 mb-4">We use your information to:</p>
            <ul class="list-disc pl-6 mb-4 text-gray-700">
              <li>Provide and maintain the Service</li>
              <li>Process transactions and send billing information</li>
              <li>Send administrative information and updates</li>
              <li>Respond to customer service requests</li>
              <li>Monitor and analyze usage patterns</li>
              <li>Detect and prevent fraud or abuse</li>
              <li>Comply with legal obligations</li>
            </ul>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">4. Data Storage and Security</h2>
            <p class="text-gray-700 mb-4">
              Your data is stored using industry-standard security measures:
            </p>
            <ul class="list-disc pl-6 mb-4 text-gray-700">
              <li>Database: Supabase (PostgreSQL) with Row Level Security</li>
              <li>File Storage: Cloudflare R2 with encrypted storage</li>
              <li>All data transmissions are encrypted using SSL/TLS</li>
              <li>Regular security audits and monitoring</li>
              <li>Access controls and authentication measures</li>
            </ul>
            <p class="text-gray-700 mb-4">
              While we implement robust security measures, no method of transmission over the Internet is 100% secure, and we cannot guarantee absolute security.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">5. Data Sharing and Disclosure</h2>
            <p class="text-gray-700 mb-4">
              We do not sell, trade, or rent your personal information. We may share your information in the following circumstances:
            </p>
            <ul class="list-disc pl-6 mb-4 text-gray-700">
              <li>With your consent</li>
              <li>To comply with legal obligations or court orders</li>
              <li>To protect our rights, privacy, safety, or property</li>
              <li>With service providers who assist in operating our Service (under confidentiality agreements)</li>
              <li>In connection with a business transfer, merger, or acquisition</li>
            </ul>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">6. Data Retention</h2>
            <p class="text-gray-700 mb-4">
              We retain your information for as long as your account is active or as needed to provide you services. Upon account termination, we will retain your data for 30 days to allow for data export requests, after which it will be securely deleted unless we are required to retain it for legal purposes.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">7. Your Rights</h2>
            <p class="text-gray-700 mb-4">You have the right to:</p>
            <ul class="list-disc pl-6 mb-4 text-gray-700">
              <li>Access your personal information</li>
              <li>Correct inaccurate data</li>
              <li>Request deletion of your data</li>
              <li>Export your data in a portable format</li>
              <li>Opt-out of marketing communications</li>
              <li>Lodge a complaint with a supervisory authority</li>
            </ul>
            <p class="text-gray-700 mb-4">
              To exercise these rights, please contact us at privacy@telodox.com.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">8. Cookies and Tracking</h2>
            <p class="text-gray-700 mb-4">
              We use cookies and similar tracking technologies to enhance your experience. You can control cookies through your browser settings, but disabling cookies may limit some features of the Service.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">9. Third-Party Services</h2>
            <p class="text-gray-700 mb-4">
              We integrate with the following third-party services, each with their own privacy policies:
            </p>
            <ul class="list-disc pl-6 mb-4 text-gray-700">
              <li>Stripe (payment processing)</li>
              <li>Amazon SES (email delivery)</li>
              <li>Cloudflare (content delivery and security)</li>
              <li>Supabase (authentication and database)</li>
            </ul>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">10. Children's Privacy</h2>
            <p class="text-gray-700 mb-4">
              Our Service is not intended for children under 18 years of age. We do not knowingly collect personal information from children under 18.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">11. International Data Transfers</h2>
            <p class="text-gray-700 mb-4">
              Your information may be transferred to and processed in countries other than your country of residence. We ensure appropriate safeguards are in place for such transfers in compliance with applicable data protection laws.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">12. Changes to This Policy</h2>
            <p class="text-gray-700 mb-4">
              We may update this Privacy Policy from time to time. We will notify you of any material changes by posting the new Privacy Policy on this page and updating the "Last updated" date.
            </p>
          </section>

          <section class="mb-8">
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">13. Contact Us</h2>
            <p class="text-gray-700 mb-4">
              If you have questions or concerns about this Privacy Policy, please contact us at:
            </p>
            <p class="text-gray-700">
              Email: privacy@telodox.com<br>
              Address: [Your Company Address]<br>
              Data Protection Officer: [Name if applicable]
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
import AppFooter from "~/components/ui/AppFooter.vue";

const lastUpdated = new Date().toLocaleDateString('en-US', { 
  year: 'numeric', 
  month: 'long', 
  day: 'numeric' 
})

useHead({
  title: 'Privacy Policy - TeloDox',
  meta: [
    { name: 'description', content: 'Privacy Policy for TeloDox - How we collect, use, and protect your data in our telecommunications document management platform' }
  ]
})
</script>