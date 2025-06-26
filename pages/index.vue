<template>
  <div class="min-h-screen bg-black">
    <!-- Top Navigation -->
    <LandingNav />

    <!-- Hero Section -->
    <section
      class="relative overflow-hidden bg-brand-dark py-20 lg:py-32 pt-32"
    >
      <div class="max-w-7xl mx-auto px-6 relative z-10">
        <!-- Content - Centered -->
        <div class="mb-16 text-center">
          <div class="hero-content">
            <!-- Main Headline -->
            <h1
              class="text-3xl md:text-4xl lg:text-6xl font-bold font-heading text-white mb-4 tracking-wide"
            >
              Stop Chasing
              <span class="font-allura text-gradient-purple-magenta text-6xl"
                >Signatures.</span
              ><br />
              Start Closing Deals.
            </h1>

            <!-- Subheadline -->
            <p
              class="text-base text-white/80 mb-6 leading-relaxed max-w-lg mx-auto"
            >
              Telodox simplifies the telco customer onboarding process by
              centralizing documents, approvals, and communication — so you can
              onboard faster, with zero back-and-forth.
            </p>

            <!-- CTA Buttons -->
            <div class="flex flex-col sm:flex-row gap-3 mb-6 justify-center">
              <GlowButton tag="NuxtLink" to="/early-access" size="md">
                Get Early Access
              </GlowButton>
              <button
                class="text-white/80 hover:text-white font-semibold px-6 py-3 rounded-xl text-base transition-all duration-300 flex items-center gap-2"
              >
                See How It Works
                <svg
                  class="w-4 h-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 5l7 7-7 7"
                  />
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Simple Sunrise Spotlight Effect -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none">
        <!-- Single magenta sunrise spotlight -->
        <div class="absolute bottom-0 left-1/2 transform -translate-x-1/2 translate-y-1/2 w-[1400px] h-[1400px] sunrise-spotlight"></div>
      </div>
    </section>

    <!-- Launch Announcement Section -->
    <section class="py-16 bg-gradient-to-b from-black to-gray-900/50">
      <div class="max-w-4xl mx-auto px-6 text-center">
        <!-- Launch Badge -->
        <div class="inline-flex items-center px-6 py-3 bg-pink-500/20 border border-pink-500/30 rounded-full text-pink-300 text-lg font-semibold mb-8">
          <RocketLaunchIcon class="w-5 h-5 mr-3" />
          Launching August 1, 2025
        </div>
        
        <!-- Announcement Content -->
        <h2 class="text-3xl md:text-4xl font-bold text-white mb-6">
          The Future of Telecom Onboarding is Almost Here
        </h2>
        <p class="text-xl text-white/80 mb-8 max-w-3xl mx-auto">
          Be among the first to experience streamlined carrier onboarding, intelligent document processing, 
          and collaborative MSA redlining. Join <span class="font-semibold text-pink-400">500+</span> industry professionals already waiting.
        </p>
        
        <!-- Email Capture Form -->
        <form @submit.prevent="handleEmailSubmit" class="max-w-md mx-auto mb-8">
          <div class="flex flex-col sm:flex-row gap-3">
            <input
              v-model="launchEmail"
              type="email"
              placeholder="Enter your email for launch updates"
              class="flex-1 px-4 py-3 bg-white/10 border border-white/20 rounded-lg text-white placeholder-white/60 focus:outline-none focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
              required
            >
            <GlowButton 
              type="submit" 
              :disabled="emailLoading || !launchEmail"
              size="md"
              class="sm:w-auto w-full"
            >
              <span v-if="emailLoading">Joining...</span>
              <span v-else>Join Waitlist</span>
            </GlowButton>
          </div>
          <div v-if="emailSuccess" class="mt-3 text-green-400 text-sm">
            ✅ You're on the list! We'll notify you on launch day.
          </div>
          <div v-if="emailError" class="mt-3 text-red-400 text-sm">
            {{ emailError }}
          </div>
        </form>
        
        <!-- Benefits Preview -->
        <div class="grid md:grid-cols-3 gap-6 mt-12">
          <div class="text-center">
            <div class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mx-auto mb-4">
              <DocumentCheckIcon class="w-6 h-6 text-pink-400" />
            </div>
            <h3 class="text-white font-semibold mb-2">Smart Document Processing</h3>
            <p class="text-sm text-white/60">Upload PDFs and transform them into digital workflows</p>
          </div>
          <div class="text-center">
            <div class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mx-auto mb-4">
              <UsersIcon class="w-6 h-6 text-pink-400" />
            </div>
            <h3 class="text-white font-semibold mb-2">Team Collaboration</h3>
            <p class="text-sm text-white/60">Eliminate email chaos with role-based workflows</p>
          </div>
          <div class="text-center">
            <div class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mx-auto mb-4">
              <PencilSquareIcon class="w-6 h-6 text-pink-400" />
            </div>
            <h3 class="text-white font-semibold mb-2">MSA Redlining</h3>
            <p class="text-sm text-white/60">Professional document negotiation and tracking</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Problem Section -->
    <section class="py-16 bg-black animate-on-scroll">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-12">
          <h2
            class="text-3xl md:text-4xl font-bold font-heading text-white mb-4"
          >
            The Telecom Onboarding Nightmare
          </h2>
          <p
            class="text-xl md:text-2xl text-white/80 font-medium mb-8 leading-tight"
          >
            15+ emails. 6 document versions. 3 weeks later...
            <span class="text-gradient-purple-magenta font-bold"
              >still no signature.</span
            >
          </p>
        </div>

        <!-- Problem Cards Grid -->
        <div
          class="animate-cards grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12"
        >
          <div
            class="card bg-white/5 border border-white/10 rounded-xl p-5 text-center"
          >
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mx-auto mb-3"
            >
              <EnvelopeIcon class="w-5 h-5 text-white" />
            </div>
            <h3 class="text-lg font-semibold text-white mb-2">Email Chaos</h3>
            <p class="text-sm text-white/60">
              KYC forms buried in attachments across 15+ email threads
            </p>
          </div>

          <div
            class="card bg-white/5 border border-white/10 rounded-xl p-5 text-center"
          >
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mx-auto mb-3"
            >
              <DocumentDuplicateIcon class="w-5 h-5 text-white" />
            </div>
            <h3 class="text-lg font-semibold text-white mb-2">
              Version Confusion
            </h3>
            <p class="text-sm text-white/60">
              MSAs with conflicting redlines across multiple document versions
            </p>
          </div>

          <div
            class="card bg-white/5 border border-white/10 rounded-xl p-5 text-center"
          >
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mx-auto mb-3"
            >
              <ClockIcon class="w-5 h-5 text-white" />
            </div>
            <h3 class="text-lg font-semibold text-white mb-2">Deal Delays</h3>
            <p class="text-sm text-white/60">
              40+ hours per month wrangling missing fields and stalled approvals
            </p>
          </div>
        </div>

        <!-- Large Impact Statement -->
        <div
          class="bg-white/5 border border-white/10 rounded-2xl p-8 text-center"
        >
          <h3 class="text-2xl md:text-3xl font-bold text-white mb-3">
            Sales teams waste
            <span class="text-gradient-purple-magenta"
              >40+ hours per month</span
            >
            on manual onboarding
          </h3>
          <p class="text-base text-white/60">
            While competitors close deals faster with streamlined processes
          </p>
        </div>
      </div>
    </section>

    <!-- Solution Section -->
    <section class="py-16 bg-black animate-on-scroll">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-12">
          <h2
            class="text-3xl md:text-4xl font-bold font-heading text-white mb-4"
          >
            Telodox Fixes That
          </h2>
          <p class="text-base text-white/60 max-w-3xl mx-auto">
            The complete telecom onboarding solution that turns chaos into
            clean, automated workflows
          </p>
        </div>

        <!-- Features Bento Grid -->
        <div
          class="animate-cards grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
        >
          <!-- Build Once -->
          <div class="card bg-white/5 border border-white/10 rounded-xl p-6">
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mb-4"
            >
              <svg
                class="w-5 h-5 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                />
              </svg>
            </div>
            <h3 class="text-lg font-bold text-white mb-2">
              Build Once, Use Forever
            </h3>
            <p class="text-sm text-white/60">
              Upload PDFs or build forms from scratch. Set required fields so
              nothing gets missed.
            </p>
          </div>

          <!-- Smart Flow -->
          <div class="card bg-white/5 border border-white/10 rounded-xl p-6">
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mb-4"
            >
              <svg
                class="w-5 h-5 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 5l7 7-7 7"
                />
              </svg>
            </div>
            <h3 class="text-lg font-bold text-white mb-2">
              Smart Document Flow
            </h3>
            <p class="text-sm text-white/60">
              KYC → FUSF → MSA → Interop. Next doc only appears when the
              previous one's approved.
            </p>
          </div>

          <!-- Redlining -->
          <div class="card bg-white/5 border border-white/10 rounded-xl p-6">
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mb-4"
            >
              <svg
                class="w-5 h-5 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                />
              </svg>
            </div>
            <h3 class="text-lg font-bold text-white mb-2">
              Built-in Redlining
            </h3>
            <p class="text-sm text-white/60">
              Track changes with full version control. No more "which document
              is current?"
            </p>
          </div>

          <!-- Collaboration -->
          <div class="card bg-white/5 border border-white/10 rounded-xl p-6">
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mb-4"
            >
              <svg
                class="w-5 h-5 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
                />
              </svg>
            </div>
            <h3 class="text-lg font-bold text-white mb-2">
              Real-time Collaboration
            </h3>
            <p class="text-sm text-white/60">
              In-app chat and notifications when action is needed. Stop playing
              email tag.
            </p>
          </div>

          <!-- Branded Portal -->
          <div class="card bg-white/5 border border-white/10 rounded-xl p-6">
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mb-4"
            >
              <svg
                class="w-5 h-5 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9v-9m0-9v9"
                />
              </svg>
            </div>
            <h3 class="text-lg font-bold text-white mb-2">
              Your Branded Portal
            </h3>
            <p class="text-sm text-white/60">
              Custom subdomain that integrates seamlessly with your sales
              process.
            </p>
          </div>

          <!-- Pipeline Visibility -->
          <div class="card bg-white/5 border border-white/10 rounded-xl p-6">
            <div
              class="w-10 h-10 bg-gradient-to-br from-pink-500 to-purple-600 rounded-lg flex items-center justify-center mb-4"
            >
              <svg
                class="w-5 h-5 text-white"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                />
              </svg>
            </div>
            <h3 class="text-lg font-bold text-white mb-2">
              Full Pipeline Visibility
            </h3>
            <p class="text-sm text-white/60">
              See exactly where every deal stands. Identify bottlenecks before
              they kill momentum.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- How It Works Section -->
    <section id="how-it-works" class="py-16 bg-black animate-on-scroll">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-12">
          <h2
            class="text-3xl md:text-4xl font-bold font-heading text-white mb-4"
          >
            Get Live in 3 Simple Steps
          </h2>
        </div>

        <!-- Steps -->
        <div class="animate-cards grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Step 1 -->
          <div class="text-center">
            <div
              class="w-16 h-16 bg-gradient-to-br from-pink-500 to-purple-600 rounded-xl flex items-center justify-center text-white text-xl font-bold mx-auto mb-4"
            >
              1
            </div>
            <h3 class="text-xl font-bold text-white mb-3">
              Set Up Your Portal
            </h3>
            <div class="bg-white/5 border border-white/10 rounded-xl p-5">
              <p class="text-sm text-white/60 mb-3">
                <strong>2 minutes to go live</strong>
              </p>
              <ul class="text-sm text-white/60 space-y-2">
                <li>• Choose your subdomain</li>
                <li>• Upload logo & brand colors</li>
                <li>• You're live!</li>
              </ul>
            </div>
          </div>

          <!-- Step 2 -->
          <div class="text-center">
            <div
              class="w-16 h-16 bg-gradient-to-br from-pink-500 to-purple-600 rounded-xl flex items-center justify-center text-white text-xl font-bold mx-auto mb-4"
            >
              2
            </div>
            <h3 class="text-xl font-bold text-white mb-3">Build Your Flow</h3>
            <div class="bg-white/5 border border-white/10 rounded-xl p-5">
              <p class="text-sm text-white/60 mb-3">
                <strong>Drag, drop, done</strong>
              </p>
              <ul class="text-sm text-white/60 space-y-2">
                <li>• Upload PDFs or build forms</li>
                <li>• Set required fields</li>
                <li>• Define document sequence</li>
              </ul>
            </div>
          </div>

          <!-- Step 3 -->
          <div class="text-center">
            <div
              class="w-16 h-16 bg-gradient-to-br from-pink-500 to-purple-600 rounded-xl flex items-center justify-center text-white text-xl font-bold mx-auto mb-4"
            >
              3
            </div>
            <h3 class="text-xl font-bold text-white mb-3">Share & Scale</h3>
            <div class="bg-white/5 border border-white/10 rounded-xl p-5">
              <p class="text-sm text-white/60 mb-3">
                <strong>Let the system Cook</strong>
              </p>
              <ul class="text-sm text-white/60 space-y-2">
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
    <section id="pricing" class="py-16 bg-black animate-on-scroll">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-12">
          <h2
            class="text-3xl md:text-4xl font-bold font-heading text-white mb-4"
          >
            Simple, Transparent Pricing
          </h2>
          <p class="text-xl text-white/80 font-medium">
            Start Free. Scale When Ready.
          </p>
        </div>

        <!-- Pricing Cards -->
        <div class="animate-cards grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Free Trial -->
          <div class="bg-white/5 border-2 border-pink-500 rounded-xl p-6">
            <div class="text-center mb-6">
              <h3 class="text-xl font-bold text-white mb-2">Free Trial</h3>
              <div class="text-3xl font-bold text-white mb-2">7 Days</div>
              <p class="text-sm text-white/60">No credit card required</p>
            </div>

            <ul class="space-y-2 mb-6 text-sm">
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Unlimited documents
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Up to 10 active
                applications
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Full feature access
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Custom subdomain
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Email support
              </li>
            </ul>

            <GlowButton
              tag="NuxtLink"
              to="/early-access"
              size="sm"
              class="w-full"
            >
              Get Early Access
            </GlowButton>
          </div>

          <!-- Pro Plan -->
          <div
            class="bg-white/5 border border-white/10 rounded-xl p-6 relative"
          >
            <div class="absolute -top-3 left-1/2 transform -translate-x-1/2">
              <span
                class="bg-dark text-white px-3 py-1 rounded-full text-xs font-semibold"
                >Most Popular</span
              >
            </div>

            <div class="text-center mb-6">
              <h3 class="text-xl font-bold text-white mb-2">Pro Plan</h3>
              <div class="text-3xl font-bold text-white mb-2">
                $99<span class="text-base text-white/60">/month</span>
              </div>
              <p class="text-sm text-white/60">Perfect for growing teams</p>
            </div>

            <ul class="space-y-2 mb-6 text-sm">
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Everything in Free
                Trial
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Unlimited applications
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Advanced analytics
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Priority support
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Custom integrations
              </li>
            </ul>

            <GlowButton
              tag="NuxtLink"
              to="/early-access"
              size="sm"
              class="w-full"
            >
              Get Early Access
            </GlowButton>
          </div>

          <!-- Enterprise -->
          <div class="bg-white/5 border border-white/10 rounded-xl p-6">
            <div class="text-center mb-6">
              <h3 class="text-xl font-bold text-white mb-2">Enterprise</h3>
              <div class="text-3xl font-bold text-white mb-2">Custom</div>
              <p class="text-sm text-white/60">For large organizations</p>
            </div>

            <ul class="space-y-2 mb-6 text-sm">
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Everything in Pro
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Dedicated success
                manager
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>Custom workflows
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>API access
              </li>
              <li class="flex items-center text-white/80">
                <span class="text-pink-500 mr-2">✓</span>SSO integration
              </li>
            </ul>

            <button
              class="w-full border border-white/30 hover:border-white/50 text-white/80 hover:text-white font-semibold py-2.5 px-6 rounded-xl transition-all duration-300 text-sm"
            >
              Contact Sales
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Final CTA Section -->
    <section id="contact" class="py-16 bg-black">
      <div class="max-w-7xl mx-auto px-6 text-center">
        <h2 class="text-3xl md:text-4xl font-bold font-heading text-white mb-4">
          Ready to Transform Your Onboarding?
        </h2>
        <p class="text-xl text-white/80 mb-8">
          Stop losing deals to process friction.
        </p>

        <!-- Large CTA Buttons -->
        <div class="flex flex-col sm:flex-row gap-4 justify-center mb-8">
          <div>
            <GlowButton tag="NuxtLink" to="/early-access" size="md">
              Get Early Access
            </GlowButton>
          </div>
          <button
            class="border border-white/30 hover:border-white/50 text-white hover:text-white font-semibold px-8 py-4 rounded-xl text-base transition-all duration-300"
          >
            Book Demo
          </button>
        </div>

        <!-- Risk-Free Promise -->
        <div
          class="bg-white/5 border border-white/10 rounded-xl p-6 inline-block"
        >
          <h3 class="text-lg font-bold text-white mb-3">Risk-Free Promise</h3>
          <div
            class="grid grid-cols-2 md:grid-cols-4 gap-3 text-sm text-white/60"
          >
            <div class="flex items-center">
              <span class="text-pink-500 mr-2">✓</span>7-day free trial
            </div>
            <div class="flex items-center">
              <span class="text-pink-500 mr-2">✓</span>No setup fees
            </div>
            <div class="flex items-center">
              <span class="text-pink-500 mr-2">✓</span>Cancel anytime
            </div>
            <div class="flex items-center">
              <span class="text-pink-500 mr-2">✓</span>Keep your data
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Sticky CTA (appears on scroll) -->
    <div class="fixed bottom-6 right-6 z-50">
      <GlowButton
        tag="NuxtLink"
        to="/early-access"
        size="sm"
        class="shadow-lg hover:shadow-xl"
      >
        <RocketLaunchIcon class="w-4 h-4" />
        <span>Get Early Access</span>
      </GlowButton>
    </div>
  </div>

  <!-- Footer -->
  <AppFooter />
</template>

<script setup lang="ts">
import {
  ExclamationTriangleIcon,
  CheckCircleIcon,
  CogIcon,
  CurrencyDollarIcon,
  RocketLaunchIcon,
  EnvelopeIcon,
  DocumentDuplicateIcon,
  ClockIcon,
  DocumentCheckIcon,
  UsersIcon,
  PencilSquareIcon,
} from "@heroicons/vue/24/outline";
import AppFooter from "~/components/ui/AppFooter.vue";
import GlowButton from "~/components/ui/GlowButton.vue";
import LandingNav from "~/components/ui/LandingNav.vue";

// Email capture for launch announcement
const launchEmail = ref('')
const emailLoading = ref(false)
const emailSuccess = ref(false)
const emailError = ref('')

const handleEmailSubmit = async () => {
  if (!launchEmail.value) return
  
  emailLoading.value = true
  emailError.value = ''
  emailSuccess.value = false
  
  try {
    await $fetch('/api/early-access', {
      method: 'POST',
      body: {
        email: launchEmail.value,
        source: 'homepage',
        referrer: document.referrer,
        metadata: {
          userAgent: navigator.userAgent,
          timestamp: new Date().toISOString()
        }
      }
    })
    
    emailSuccess.value = true
    launchEmail.value = ''
    
    // Track conversion for analytics
    if (typeof gtag !== 'undefined') {
      gtag('event', 'homepage_email_signup', {
        email_hash: btoa(launchEmail.value).substring(0, 8)
      })
    }
    
  } catch (err: any) {
    console.error('Email signup error:', err)
    if (err.data?.message?.includes('already exists')) {
      emailError.value = 'You\'re already on our waitlist!'
    } else {
      emailError.value = 'Failed to join waitlist. Please try again.'
    }
  } finally {
    emailLoading.value = false
  }
}

// GSAP animations
const { animateHeroEntrance, animateOnScroll, animateNavOnScroll, cleanup } =
  useGSAP();

definePageMeta({
  layout: false,
});

useHead({
  title: "Telodox - Stop Chasing Signatures. Start Closing Deals.",
  meta: [
    {
      name: "description",
      content:
        "The telecom onboarding platform that turns email chaos into streamlined deal flow. Built for carriers, fiber operators, and VoIP providers.",
    },
  ],
});

const user = useSupabaseUser();
const { profile } = useAuth();
const router = useRouter();

// Redirect logged-in users to appropriate dashboard
onMounted(async () => {
  if (user.value) {
    // Wait a bit for profile to load
    await new Promise((resolve) => setTimeout(resolve, 100));

    if (profile.value?.role === "super_admin") {
      await router.push("/admin");
    } else {
      await router.push("/dashboard");
    }
  } else {
    // Initialize animations for landing page
    await nextTick();
    animateHeroEntrance();
    animateOnScroll();
    animateNavOnScroll();
  }
});

// Cleanup animations on unmount
onUnmounted(() => {
  cleanup();
});
</script>

<style scoped>
.hero-content,
.hero-dashboard,
.hero-nav {
  opacity: 0;
}
</style>
