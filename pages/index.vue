<template>
  <div class="min-h-screen bg-[#dfecf1]">
    <!-- Hero Section -->
    <section class="relative overflow-hidden">
      <div class="max-w-7xl mx-auto px-6 py-24">
        <div class="text-center">
          <!-- Main Headline -->
          <h1 class="text-6xl md:text-7xl font-bold font-heading text-gray-900 mb-6 leading-tight">
            Stop Chasing 
            <span class="text-transparent bg-gradient-to-r from-primary to-accent bg-clip-text">Signatures.</span>
            <br>Start Closing Deals.
          </h1>
          
          <!-- Subheadline -->
          <p class="text-xl md:text-2xl text-gray-600 mb-12 max-w-4xl mx-auto leading-relaxed">
            The telecom onboarding platform that turns email chaos into streamlined deal flow. 
            Built specifically for carriers, fiber operators, and VoIP providers who are tired of losing deals in endless email threads.
          </p>
          
          <!-- CTA Buttons -->
          <div class="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <NuxtLink 
              to="/auth/register" 
              class="bg-primary hover:bg-primary/90 text-white font-semibold px-8 py-4 rounded-2xl text-lg transition-all duration-300 shadow-lg hover:shadow-xl hover:-translate-y-0.5"
            >
              Start Free Trial
            </NuxtLink>
            <button class="border border-gray-300 hover:border-primary text-gray-700 hover:text-primary font-semibold px-8 py-4 rounded-2xl text-lg transition-all duration-300">
              Watch Demo
            </button>
          </div>
          
          <!-- Trust Badge -->
          <p class="text-sm text-gray-500 mb-8">7-day free trial • No credit card required • Cancel anytime</p>
        </div>
      </div>
      
      <!-- Background Elements -->
      <div class="absolute top-20 left-10 w-20 h-20 bg-primary/10 rounded-full blur-xl"></div>
      <div class="absolute bottom-20 right-20 w-32 h-32 bg-accent/10 rounded-full blur-xl"></div>
    </section>

    <!-- Problem Section -->
    <section class="py-20">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-16">
          <div class="text-4xl mb-4">🎯</div>
          <h2 class="text-5xl font-bold font-heading text-gray-900 mb-6">
            The Telecom Onboarding Nightmare
          </h2>
          <p class="text-3xl text-gray-700 font-medium mb-12 leading-tight">
            15+ emails. 6 document versions. 3 weeks later... 
            <span class="text-warning font-bold">still no signature.</span>
          </p>
        </div>
        
        <!-- Problem Cards Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-16">
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-6 text-center">
            <div class="text-3xl mb-4">📧</div>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">Email Chaos</h3>
            <p class="text-gray-600">KYC forms buried in attachments across 15+ email threads</p>
          </div>
          
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-6 text-center">
            <div class="text-3xl mb-4">📄</div>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">Version Confusion</h3>
            <p class="text-gray-600">MSAs with conflicting redlines across multiple document versions</p>
          </div>
          
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-6 text-center">
            <div class="text-3xl mb-4">⏱️</div>
            <h3 class="text-xl font-semibold text-gray-900 mb-2">Deal Delays</h3>
            <p class="text-gray-600">40+ hours per month wrangling missing fields and stalled approvals</p>
          </div>
        </div>
        
        <!-- Large Impact Statement -->
        <div class="bg-warning/10 border border-warning/20 rounded-3xl p-12 text-center">
          <h3 class="text-4xl font-bold text-gray-900 mb-4">
            Sales teams waste <span class="text-warning">40+ hours per month</span> on manual onboarding
          </h3>
          <p class="text-xl text-gray-600">While competitors close deals faster with streamlined processes</p>
        </div>
      </div>
    </section>

    <!-- Solution Section -->
    <section class="py-20">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-16">
          <div class="text-4xl mb-4">✅</div>
          <h2 class="text-5xl font-bold font-heading text-gray-900 mb-6">
            Telodox Fixes That
          </h2>
          <p class="text-xl text-gray-600 max-w-3xl mx-auto">
            The complete telecom onboarding solution that turns chaos into clean, automated workflows
          </p>
        </div>
        
        <!-- Features Bento Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <!-- Build Once -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-primary/20 rounded-xl flex items-center justify-center mb-6">
              <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Build Once, Use Forever</h3>
            <p class="text-gray-600">Upload PDFs or build forms from scratch. Set required fields so nothing gets missed.</p>
          </div>
          
          <!-- Smart Flow -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-accent/20 rounded-xl flex items-center justify-center mb-6">
              <svg class="w-6 h-6 text-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Smart Document Flow</h3>
            <p class="text-gray-600">KYC → FUSF → MSA → Interop. Next doc only appears when the previous one's approved.</p>
          </div>
          
          <!-- Redlining -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-warning/20 rounded-xl flex items-center justify-center mb-6">
              <svg class="w-6 h-6 text-warning" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Built-in Redlining</h3>
            <p class="text-gray-600">Track changes with full version control. No more "which document is current?"</p>
          </div>
          
          <!-- Collaboration -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-primary/20 rounded-xl flex items-center justify-center mb-6">
              <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Real-time Collaboration</h3>
            <p class="text-gray-600">In-app chat and notifications when action is needed. Stop playing email tag.</p>
          </div>
          
          <!-- Branded Portal -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-accent/20 rounded-xl flex items-center justify-center mb-6">
              <svg class="w-6 h-6 text-accent" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9v-9m0-9v9" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Your Branded Portal</h3>
            <p class="text-gray-600">Custom subdomain that integrates seamlessly with your sales process.</p>
          </div>
          
          <!-- Pipeline Visibility -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 hover:-translate-y-1 transition-all duration-300">
            <div class="w-12 h-12 bg-warning/20 rounded-xl flex items-center justify-center mb-6">
              <svg class="w-6 h-6 text-warning" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-gray-900 mb-3">Full Pipeline Visibility</h3>
            <p class="text-gray-600">See exactly where every deal stands. Identify bottlenecks before they kill momentum.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- How It Works Section -->
    <section class="py-20">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-16">
          <div class="text-4xl mb-4">🧠</div>
          <h2 class="text-5xl font-bold font-heading text-gray-900 mb-6">
            Get Live in 3 Simple Steps
          </h2>
        </div>
        
        <!-- Steps -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Step 1 -->
          <div class="text-center">
            <div class="w-20 h-20 bg-primary rounded-2xl flex items-center justify-center text-white text-2xl font-bold mx-auto mb-6">1</div>
            <h3 class="text-2xl font-bold text-gray-900 mb-4">Set Up Your Portal</h3>
            <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-6">
              <p class="text-gray-600 mb-4"><strong>2 minutes to go live</strong></p>
              <ul class="text-gray-600 space-y-2">
                <li>• Choose your subdomain</li>
                <li>• Upload logo & brand colors</li>
                <li>• You're live!</li>
              </ul>
            </div>
          </div>
          
          <!-- Step 2 -->
          <div class="text-center">
            <div class="w-20 h-20 bg-accent rounded-2xl flex items-center justify-center text-white text-2xl font-bold mx-auto mb-6">2</div>
            <h3 class="text-2xl font-bold text-gray-900 mb-4">Build Your Flow</h3>
            <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-6">
              <p class="text-gray-600 mb-4"><strong>Drag, drop, done</strong></p>
              <ul class="text-gray-600 space-y-2">
                <li>• Upload PDFs or build forms</li>
                <li>• Set required fields</li>
                <li>• Define document sequence</li>
              </ul>
            </div>
          </div>
          
          <!-- Step 3 -->
          <div class="text-center">
            <div class="w-20 h-20 bg-warning rounded-2xl flex items-center justify-center text-white text-2xl font-bold mx-auto mb-6">3</div>
            <h3 class="text-2xl font-bold text-gray-900 mb-4">Share & Scale</h3>
            <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-6">
              <p class="text-gray-600 mb-4"><strong>Let the system work</strong></p>
              <ul class="text-gray-600 space-y-2">
                <li>• Share your onboarding link</li>
                <li>• Carriers self-complete</li>
                <li>• Close deals faster</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Pricing Section -->
    <section class="py-20">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-16">
          <div class="text-4xl mb-4">💸</div>
          <h2 class="text-5xl font-bold font-heading text-gray-900 mb-6">
            Simple, Transparent Pricing
          </h2>
          <p class="text-2xl text-gray-700 font-medium">
            Start Free. Scale When Ready.
          </p>
        </div>
        
        <!-- Pricing Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Free Trial -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 border-2 border-primary">
            <div class="text-center mb-8">
              <h3 class="text-2xl font-bold text-gray-900 mb-2">Free Trial</h3>
              <div class="text-4xl font-bold text-primary mb-2">7 Days</div>
              <p class="text-gray-600">No credit card required</p>
            </div>
            
            <ul class="space-y-3 mb-8">
              <li class="flex items-center text-gray-700"><span class="text-primary mr-2">✓</span>Unlimited documents</li>
              <li class="flex items-center text-gray-700"><span class="text-primary mr-2">✓</span>Up to 10 active applications</li>
              <li class="flex items-center text-gray-700"><span class="text-primary mr-2">✓</span>Full feature access</li>
              <li class="flex items-center text-gray-700"><span class="text-primary mr-2">✓</span>Custom subdomain</li>
              <li class="flex items-center text-gray-700"><span class="text-primary mr-2">✓</span>Email support</li>
            </ul>
            
            <NuxtLink 
              to="/auth/register" 
              class="w-full bg-primary hover:bg-primary/90 text-white font-semibold py-3 px-6 rounded-xl text-center block transition-all duration-300"
            >
              Start Free Trial
            </NuxtLink>
          </div>
          
          <!-- Pro Plan -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 relative">
            <div class="absolute -top-4 left-1/2 transform -translate-x-1/2">
              <span class="bg-accent text-white px-4 py-1 rounded-full text-sm font-semibold">Most Popular</span>
            </div>
            
            <div class="text-center mb-8">
              <h3 class="text-2xl font-bold text-gray-900 mb-2">Pro Plan</h3>
              <div class="text-4xl font-bold text-gray-900 mb-2">$99<span class="text-lg text-gray-600">/month</span></div>
              <p class="text-gray-600">Perfect for growing teams</p>
            </div>
            
            <ul class="space-y-3 mb-8">
              <li class="flex items-center text-gray-700"><span class="text-accent mr-2">✓</span>Everything in Free Trial</li>
              <li class="flex items-center text-gray-700"><span class="text-accent mr-2">✓</span>Unlimited applications</li>
              <li class="flex items-center text-gray-700"><span class="text-accent mr-2">✓</span>Advanced analytics</li>
              <li class="flex items-center text-gray-700"><span class="text-accent mr-2">✓</span>Priority support</li>
              <li class="flex items-center text-gray-700"><span class="text-accent mr-2">✓</span>Custom integrations</li>
            </ul>
            
            <NuxtLink 
              to="/auth/register" 
              class="w-full bg-accent hover:bg-accent/90 text-white font-semibold py-3 px-6 rounded-xl text-center block transition-all duration-300"
            >
              Choose Pro
            </NuxtLink>
          </div>
          
          <!-- Enterprise -->
          <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8">
            <div class="text-center mb-8">
              <h3 class="text-2xl font-bold text-gray-900 mb-2">Enterprise</h3>
              <div class="text-4xl font-bold text-gray-900 mb-2">Custom</div>
              <p class="text-gray-600">For large organizations</p>
            </div>
            
            <ul class="space-y-3 mb-8">
              <li class="flex items-center text-gray-700"><span class="text-warning mr-2">✓</span>Everything in Pro</li>
              <li class="flex items-center text-gray-700"><span class="text-warning mr-2">✓</span>Dedicated success manager</li>
              <li class="flex items-center text-gray-700"><span class="text-warning mr-2">✓</span>Custom workflows</li>
              <li class="flex items-center text-gray-700"><span class="text-warning mr-2">✓</span>API access</li>
              <li class="flex items-center text-gray-700"><span class="text-warning mr-2">✓</span>SSO integration</li>
            </ul>
            
            <button class="w-full border border-gray-300 hover:border-warning text-gray-700 hover:text-warning font-semibold py-3 px-6 rounded-xl transition-all duration-300">
              Contact Sales
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Final CTA Section -->
    <section class="py-20 bg-gradient-to-br from-primary/10 to-accent/10">
      <div class="max-w-7xl mx-auto px-6 text-center">
        <div class="text-4xl mb-6">🧲</div>
        <h2 class="text-5xl font-bold font-heading text-gray-900 mb-6">
          Ready to Transform Your Onboarding?
        </h2>
        <p class="text-2xl text-gray-700 mb-12">
          Stop losing deals to process friction.
        </p>
        
        <!-- Large CTA Buttons -->
        <div class="flex flex-col sm:flex-row gap-6 justify-center mb-12">
          <NuxtLink 
            to="/auth/register" 
            class="bg-primary hover:bg-primary/90 text-white font-bold px-12 py-6 rounded-2xl text-xl transition-all duration-300 shadow-lg hover:shadow-xl hover:-translate-y-1"
          >
            Start Free Trial
          </NuxtLink>
          <button class="border-2 border-gray-300 hover:border-primary text-gray-700 hover:text-primary font-bold px-12 py-6 rounded-2xl text-xl transition-all duration-300">
            Book Demo
          </button>
        </div>
        
        <!-- Risk-Free Promise -->
        <div class="bg-[#d0e2e8] rounded-2xl shadow-card p-8 inline-block">
          <h3 class="text-xl font-bold text-gray-900 mb-4">Risk-Free Promise</h3>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-gray-600">
            <div class="flex items-center"><span class="text-primary mr-2">✓</span>7-day free trial</div>
            <div class="flex items-center"><span class="text-primary mr-2">✓</span>No setup fees</div>
            <div class="flex items-center"><span class="text-primary mr-2">✓</span>Cancel anytime</div>
            <div class="flex items-center"><span class="text-primary mr-2">✓</span>Keep your data</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Sticky CTA (appears on scroll) -->
    <div class="fixed bottom-6 right-6 z-50">
      <NuxtLink 
        to="/auth/register" 
        class="bg-primary hover:bg-primary/90 text-white font-semibold px-6 py-3 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 flex items-center space-x-2"
      >
        <span>🚀</span>
        <span>Start Free Trial</span>
      </NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false
})

useHead({
  title: 'Telodox - Stop Chasing Signatures. Start Closing Deals.',
  meta: [
    {
      name: 'description',
      content: 'The telecom onboarding platform that turns email chaos into streamlined deal flow. Built for carriers, fiber operators, and VoIP providers.'
    }
  ]
})

const user = useSupabaseUser()
const { profile } = useAuth()
const router = useRouter()

// Redirect logged-in users to appropriate dashboard
onMounted(async () => {
  if (user.value) {
    // Wait a bit for profile to load
    await new Promise(resolve => setTimeout(resolve, 100))
    
    if (profile.value?.role === 'super_admin') {
      await router.push('/admin')
    } else {
      await router.push('/dashboard')
    }
  }
})
</script>