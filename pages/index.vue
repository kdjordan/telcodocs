<template>
  <div class="min-h-screen bg-black">
    <!-- Top Navigation -->
    <nav class="main-nav hero-nav fixed top-0 left-0 right-0 z-50 bg-black/80 backdrop-blur-md border-b border-white/10">
      <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <div class="flex items-center space-x-3">
            <div class="w-8 h-8 bg-pink-500 rounded-lg flex items-center justify-center">
              <span class="text-white text-sm font-bold">T</span>
            </div>
            <span class="text-white font-bold text-xl">TeloDox</span>
          </div>

          <!-- Desktop Navigation -->
          <div class="hidden md:flex items-center space-x-8">
            <a href="#how-it-works" class="text-white/80 hover:text-white transition-colors cursor-pointer">
              How It Works
            </a>
            <a href="#pricing" class="text-white/80 hover:text-white transition-colors cursor-pointer">
              Pricing
            </a>
            <a href="#contact" class="text-white/80 hover:text-white transition-colors cursor-pointer">
              Contact
            </a>
            <NuxtLink to="/auth/login" class="text-white/80 hover:text-white transition-colors">
              Sign In
            </NuxtLink>
          </div>

          <!-- CTA Button -->
          <div class="hidden md:block">
            <GlowButton
              tag="NuxtLink"
              to="/auth/register"
              size="sm"
            >
              Start Free Trial
            </GlowButton>
          </div>

          <!-- Mobile Menu Button -->
          <button 
            @click="mobileMenuOpen = !mobileMenuOpen"
            class="md:hidden text-white p-2"
          >
            <Bars3Icon v-if="!mobileMenuOpen" class="w-6 h-6" />
            <XMarkIcon v-if="mobileMenuOpen" class="w-6 h-6" />
          </button>
        </div>

        <!-- Mobile Menu -->
        <div v-if="mobileMenuOpen" class="md:hidden border-t border-white/10 py-4">
          <div class="flex flex-col space-y-4">
            <a href="#how-it-works" @click="mobileMenuOpen = false" class="text-white/80 hover:text-white transition-colors">
              How It Works
            </a>
            <a href="#pricing" @click="mobileMenuOpen = false" class="text-white/80 hover:text-white transition-colors">
              Pricing
            </a>
            <a href="#contact" @click="mobileMenuOpen = false" class="text-white/80 hover:text-white transition-colors">
              Contact
            </a>
            <NuxtLink to="/auth/login" @click="mobileMenuOpen = false" class="text-white/80 hover:text-white transition-colors">
              Sign In
            </NuxtLink>
            <div class="pt-4">
              <GlowButton
                tag="NuxtLink"
                to="/auth/register"
                size="sm"
                class="w-full"
                @click="mobileMenuOpen = false"
              >
                Start Free Trial
              </GlowButton>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="relative overflow-hidden bg-brand-dark py-20 lg:py-32 pt-32">
      <div class="max-w-7xl mx-auto px-6">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <!-- Left Side - Content -->
          <div class="hero-content">
            <!-- Main Headline -->
            <h1 class="text-5xl md:text-6xl font-bold font-heading text-white mb-6 leading-tight">
              Your Telco's<br />
              Deal Desk.<br />
              Reimagined.
            </h1>

            <!-- Subheadline -->
            <p class="text-xl text-white/80 mb-8 leading-relaxed max-w-lg">
              Upload MSAs, automate redlines, track interop steps — all in one branded portal. 
              Telodox turns onboarding into a sales asset.
            </p>

            <!-- CTA Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 mb-8">
              <GlowButton
                tag="NuxtLink"
                to="/auth/register"
                size="lg"
              >
                Start Free Trial
              </GlowButton>
              <button
                class="border border-white/30 hover:border-white/50 text-white hover:text-white font-semibold px-8 py-4 rounded-2xl text-lg transition-all duration-300"
              >
                See How It Works
              </button>
            </div>

            <!-- Trust Badge -->
            <p class="text-sm text-white/60">
              7-day free trial • No credit card required • Cancel anytime
            </p>
          </div>

          <!-- Right Side - Layered Dashboard Mockup -->
          <div class="hidden lg:block hero-dashboard">
            <div class="relative h-[600px]">
              <!-- Background Dashboard (skewed) -->
              <div class="absolute top-0 right-0 w-[480px] h-[400px] transform rotate-3 translate-x-8 translate-y-8">
                <div class="bg-gray-800/90 border border-gray-700/50 rounded-xl p-6 shadow-2xl backdrop-blur-sm h-full">
                  <div class="space-y-4">
                    <div class="h-6 bg-gray-600/50 rounded w-3/4"></div>
                    <div class="space-y-3">
                      <div class="h-12 bg-gray-700/30 rounded-lg"></div>
                      <div class="h-12 bg-gray-700/30 rounded-lg"></div>
                      <div class="h-12 bg-gray-700/30 rounded-lg"></div>
                    </div>
                    <div class="pt-4 border-t border-gray-600/30">
                      <div class="space-y-2">
                        <div class="h-3 bg-gray-600/40 rounded w-2/3"></div>
                        <div class="h-3 bg-gray-600/40 rounded w-1/2"></div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Foreground Dashboard (main) -->
              <div class="absolute top-0 left-0 w-[480px] h-[400px] z-10">
                <div class="bg-gray-900/95 border border-gray-700/70 rounded-xl p-6 shadow-2xl backdrop-blur-md h-full">
                  <!-- Header -->
                  <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center space-x-3">
                      <div class="w-8 h-8 bg-pink-500 rounded-lg flex items-center justify-center">
                        <span class="text-white text-sm font-bold">T</span>
                      </div>
                      <span class="text-white font-semibold">TeloDox</span>
                    </div>
                    <div class="flex items-center space-x-2">
                      <div class="w-2 h-2 bg-green-400 rounded-full"></div>
                      <span class="text-white/60 text-sm">Live</span>
                    </div>
                  </div>

                  <!-- Main Content -->
                  <div class="space-y-4">
                    <!-- Active Deal -->
                    <div class="bg-gradient-to-r from-pink-500/20 to-purple-500/20 border border-pink-500/30 rounded-lg p-4">
                      <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                          <DocumentDuplicateIcon class="w-5 h-5 text-pink-400" />
                          <div>
                            <div class="text-white font-medium">MSA Negotiation</div>
                            <div class="text-white/60 text-sm">Acme Telecom - Final Review</div>
                          </div>
                        </div>
                        <div class="px-2 py-1 bg-pink-500/20 rounded-full">
                          <span class="text-pink-400 text-xs font-medium">Active</span>
                        </div>
                      </div>
                    </div>

                    <!-- Pipeline Items -->
                    <div class="bg-white/5 border border-white/10 rounded-lg p-4">
                      <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                          <ClockIcon class="w-5 h-5 text-orange-400" />
                          <div>
                            <div class="text-white font-medium">FUSF Documentation</div>
                            <div class="text-white/60 text-sm">NetConnect - Pending</div>
                          </div>
                        </div>
                        <div class="w-2 h-2 bg-orange-400 rounded-full"></div>
                      </div>
                    </div>

                    <div class="bg-white/5 border border-white/10 rounded-lg p-4">
                      <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-3">
                          <CheckCircleIcon class="w-5 h-5 text-green-400" />
                          <div>
                            <div class="text-white font-medium">KYC Verification</div>
                            <div class="text-white/60 text-sm">FiberCorp - Complete</div>
                          </div>
                        </div>
                        <div class="w-2 h-2 bg-green-400 rounded-full"></div>
                      </div>
                    </div>
                  </div>

                  <!-- Bottom Stats -->
                  <div class="mt-6 pt-4 border-t border-white/10">
                    <div class="flex items-center justify-between text-sm">
                      <span class="text-white/60">Pipeline Health</span>
                      <span class="text-green-400 font-medium">94% Complete</span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Glow Effects -->
              <div class="absolute -inset-4 bg-gradient-to-r from-pink-500/10 to-purple-500/10 rounded-3xl blur-2xl -z-10"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Background decorative elements -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none">
        <div class="absolute -top-40 -right-40 w-80 h-80 bg-pink-500/10 rounded-full blur-3xl"></div>
        <div class="absolute -bottom-40 -left-40 w-80 h-80 bg-purple-500/10 rounded-full blur-3xl"></div>
      </div>
    </section>

    <!-- Problem Section -->
    <section class="py-20 bg-black animate-on-scroll">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-16">
          <h2 class="text-5xl font-bold font-heading text-white mb-6">
            The Telecom Onboarding Nightmare
          </h2>
          <p class="text-3xl text-white/80 font-medium mb-12 leading-tight">
            15+ emails. 6 document versions. 3 weeks later...
            <span class="text-pink-500 font-bold">still no signature.</span>
          </p>
        </div>

        <!-- Problem Cards Grid -->
        <div class="animate-cards grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-16">
          <div class="card bg-white/5 border border-white/10 rounded-2xl p-6 text-center">
            <div
              class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mx-auto mb-4"
            >
              <EnvelopeIcon class="w-6 h-6 text-pink-400" />
            </div>
            <h3 class="text-xl font-semibold text-white mb-2">
              Email Chaos
            </h3>
            <p class="text-white/60">
              KYC forms buried in attachments across 15+ email threads
            </p>
          </div>

          <div class="card bg-white/5 border border-white/10 rounded-2xl p-6 text-center">
            <div
              class="w-12 h-12 bg-orange-500/20 rounded-xl flex items-center justify-center mx-auto mb-4"
            >
              <DocumentDuplicateIcon class="w-6 h-6 text-orange-400" />
            </div>
            <h3 class="text-xl font-semibold text-white mb-2">
              Version Confusion
            </h3>
            <p class="text-white/60">
              MSAs with conflicting redlines across multiple document versions
            </p>
          </div>

          <div class="card bg-white/5 border border-white/10 rounded-2xl p-6 text-center">
            <div
              class="w-12 h-12 bg-red-500/20 rounded-xl flex items-center justify-center mx-auto mb-4"
            >
              <ClockIcon class="w-6 h-6 text-red-400" />
            </div>
            <h3 class="text-xl font-semibold text-white mb-2">
              Deal Delays
            </h3>
            <p class="text-white/60">
              40+ hours per month wrangling missing fields and stalled approvals
            </p>
          </div>
        </div>

        <!-- Large Impact Statement -->
        <div
          class="bg-white/5 border border-white/10 rounded-3xl p-12 text-center"
        >
          <h3 class="text-4xl font-bold text-white mb-4">
            Sales teams waste
            <span class="text-pink-500">40+ hours per month</span> on manual
            onboarding
          </h3>
          <p class="text-xl text-white/60">
            While competitors close deals faster with streamlined processes
          </p>
        </div>
      </div>
    </section>

    <!-- Solution Section -->
    <section class="py-20 bg-black animate-on-scroll">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-16">
          <h2 class="text-5xl font-bold font-heading text-white mb-6">
            Telodox Fixes That
          </h2>
          <p class="text-xl text-white/60 max-w-3xl mx-auto">
            The complete telecom onboarding solution that turns chaos into
            clean, automated workflows
          </p>
        </div>

        <!-- Features Bento Grid -->
        <div class="animate-cards grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <!-- Build Once -->
          <div class="card bg-white/5 border border-white/10 rounded-2xl p-8">
            <div
              class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mb-6"
            >
              <svg
                class="w-6 h-6 text-pink-400"
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
            <h3 class="text-xl font-bold text-white mb-3">
              Build Once, Use Forever
            </h3>
            <p class="text-white/60">
              Upload PDFs or build forms from scratch. Set required fields so
              nothing gets missed.
            </p>
          </div>

          <!-- Smart Flow -->
          <div class="card bg-white/5 border border-white/10 rounded-2xl p-8">
            <div
              class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mb-6"
            >
              <svg
                class="w-6 h-6 text-pink-400"
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
            <h3 class="text-xl font-bold text-white mb-3">
              Smart Document Flow
            </h3>
            <p class="text-white/60">
              KYC → FUSF → MSA → Interop. Next doc only appears when the
              previous one's approved.
            </p>
          </div>

          <!-- Redlining -->
          <div class="card bg-white/5 border border-white/10 rounded-2xl p-8">
            <div
              class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mb-6"
            >
              <svg
                class="w-6 h-6 text-pink-400"
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
            <h3 class="text-xl font-bold text-white mb-3">
              Built-in Redlining
            </h3>
            <p class="text-white/60">
              Track changes with full version control. No more "which document
              is current?"
            </p>
          </div>

          <!-- Collaboration -->
          <div class="card bg-white/5 border border-white/10 rounded-2xl p-8">
            <div
              class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mb-6"
            >
              <svg
                class="w-6 h-6 text-pink-400"
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
            <h3 class="text-xl font-bold text-white mb-3">
              Real-time Collaboration
            </h3>
            <p class="text-white/60">
              In-app chat and notifications when action is needed. Stop playing
              email tag.
            </p>
          </div>

          <!-- Branded Portal -->
          <div class="card bg-white/5 border border-white/10 rounded-2xl p-8">
            <div
              class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mb-6"
            >
              <svg
                class="w-6 h-6 text-pink-400"
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
            <h3 class="text-xl font-bold text-white mb-3">
              Your Branded Portal
            </h3>
            <p class="text-white/60">
              Custom subdomain that integrates seamlessly with your sales
              process.
            </p>
          </div>

          <!-- Pipeline Visibility -->
          <div class="card bg-white/5 border border-white/10 rounded-2xl p-8">
            <div
              class="w-12 h-12 bg-pink-500/20 rounded-xl flex items-center justify-center mb-6"
            >
              <svg
                class="w-6 h-6 text-pink-400"
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
            <h3 class="text-xl font-bold text-white mb-3">
              Full Pipeline Visibility
            </h3>
            <p class="text-white/60">
              See exactly where every deal stands. Identify bottlenecks before
              they kill momentum.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- How It Works Section -->
    <section id="how-it-works" class="py-20 bg-black">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-16">
          <h2 class="text-5xl font-bold font-heading text-white mb-6">
            Get Live in 3 Simple Steps
          </h2>
        </div>

        <!-- Steps -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Step 1 -->
          <div class="text-center">
            <div
              class="w-20 h-20 bg-dark rounded-2xl flex items-center justify-center text-white text-2xl font-bold mx-auto mb-6"
            >
              1
            </div>
            <h3 class="text-2xl font-bold text-white mb-4">
              Set Up Your Portal
            </h3>
            <div class="bg-white/5 border border-white/10 rounded-2xl p-6">
              <p class="text-white/60 mb-4">
                <strong>2 minutes to go live</strong>
              </p>
              <ul class="text-white/60 space-y-2">
                <li>• Choose your subdomain</li>
                <li>• Upload logo & brand colors</li>
                <li>• You're live!</li>
              </ul>
            </div>
          </div>

          <!-- Step 2 -->
          <div class="text-center">
            <div
              class="w-20 h-20 bg-dark rounded-2xl flex items-center justify-center text-white text-2xl font-bold mx-auto mb-6"
            >
              2
            </div>
            <h3 class="text-2xl font-bold text-white mb-4">
              Build Your Flow
            </h3>
            <div class="bg-white/5 border border-white/10 rounded-2xl p-6">
              <p class="text-white/60 mb-4">
                <strong>Drag, drop, done</strong>
              </p>
              <ul class="text-white/60 space-y-2">
                <li>• Upload PDFs or build forms</li>
                <li>• Set required fields</li>
                <li>• Define document sequence</li>
              </ul>
            </div>
          </div>

          <!-- Step 3 -->
          <div class="text-center">
            <div
              class="w-20 h-20 bg-dark rounded-2xl flex items-center justify-center text-white text-2xl font-bold mx-auto mb-6"
            >
              3
            </div>
            <h3 class="text-2xl font-bold text-white mb-4">Share & Scale</h3>
            <div class="bg-white/5 border border-white/10 rounded-2xl p-6">
              <p class="text-white/60 mb-4">
                <strong>Let the system work</strong>
              </p>
              <ul class="text-white/60 space-y-2">
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
    <section id="pricing" class="py-20 bg-black">
      <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-16">
          <h2 class="text-5xl font-bold font-heading text-white mb-6">
            Simple, Transparent Pricing
          </h2>
          <p class="text-2xl text-white/80 font-medium">
            Start Free. Scale When Ready.
          </p>
        </div>

        <!-- Pricing Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- Free Trial -->
          <div class="bg-white/5 border-2 border-pink-500 rounded-2xl p-8">
            <div class="text-center mb-8">
              <h3 class="text-2xl font-bold text-white mb-2">Free Trial</h3>
              <div class="text-4xl font-bold text-dark mb-2">7 Days</div>
              <p class="text-white/60">No credit card required</p>
            </div>

            <ul class="space-y-3 mb-8">
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Unlimited documents
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Up to 10 active
                applications
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Full feature access
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Custom subdomain
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Email support
              </li>
            </ul>

            <GlowButton
              tag="NuxtLink"
              to="/auth/register"
              size="md"
              class="w-full"
            >
              Start Free Trial
            </GlowButton>
          </div>

          <!-- Pro Plan -->
          <div class="bg-white/5 border border-white/10 rounded-2xl p-8 relative">
            <div class="absolute -top-4 left-1/2 transform -translate-x-1/2">
              <span
                class="bg-dark text-white px-4 py-1 rounded-full text-sm font-semibold"
                >Most Popular</span
              >
            </div>

            <div class="text-center mb-8">
              <h3 class="text-2xl font-bold text-white mb-2">Pro Plan</h3>
              <div class="text-4xl font-bold text-white mb-2">
                $99<span class="text-lg text-gray-600">/month</span>
              </div>
              <p class="text-white/60">Perfect for growing teams</p>
            </div>

            <ul class="space-y-3 mb-8">
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Everything in Free Trial
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Unlimited applications
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Advanced analytics
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Priority support
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Custom integrations
              </li>
            </ul>

            <GlowButton
              tag="NuxtLink"
              to="/auth/register"
              size="md"
              class="w-full"
            >
              Choose Pro
            </GlowButton>
          </div>

          <!-- Enterprise -->
          <div class="bg-white/5 border border-white/10 rounded-2xl p-8">
            <div class="text-center mb-8">
              <h3 class="text-2xl font-bold text-white mb-2">Enterprise</h3>
              <div class="text-4xl font-bold text-white mb-2">Custom</div>
              <p class="text-white/60">For large organizations</p>
            </div>

            <ul class="space-y-3 mb-8">
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Everything in Pro
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Dedicated success manager
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>Custom workflows
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>API access
              </li>
              <li class="flex items-center text-gray-700">
                <span class="text-pink-500 mr-2">✓</span>SSO integration
              </li>
            </ul>

            <button
              class="w-full border border-gray-300 hover:border-dark text-gray-700 hover:text-dark font-semibold py-3 px-6 rounded-xl transition-all duration-300"
            >
              Contact Sales
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Final CTA Section -->
    <section id="contact" class="py-20 bg-black">
      <div class="max-w-7xl mx-auto px-6 text-center">
        <h2 class="text-5xl font-bold font-heading text-white mb-6">
          Ready to Transform Your Onboarding?
        </h2>
        <p class="text-2xl text-white/80 mb-12">
          Stop losing deals to process friction.
        </p>

        <!-- Large CTA Buttons -->
        <div class="flex flex-col sm:flex-row gap-6 justify-center mb-12">
          <GlowButton
            tag="NuxtLink"
            to="/auth/register"
            size="xl"
          >
            Start Free Trial
          </GlowButton>
          <button
            class="border-2 border-white/30 hover:border-white/50 text-white hover:text-white font-bold px-12 py-6 rounded-2xl text-xl transition-all duration-300"
          >
            Book Demo
          </button>
        </div>

        <!-- Risk-Free Promise -->
        <div class="bg-white/5 border border-white/10 rounded-2xl p-8 inline-block">
          <h3 class="text-xl font-bold text-white mb-4">
            Risk-Free Promise
          </h3>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-white/60">
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
        to="/auth/register"
        size="md"
        class="shadow-lg hover:shadow-xl"
      >
        <RocketLaunchIcon class="w-5 h-5" />
        <span>Start Free Trial</span>
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
  Bars3Icon,
  XMarkIcon,
} from "@heroicons/vue/24/outline";
import AppFooter from "~/components/ui/AppFooter.vue";
import GlowButton from "~/components/ui/GlowButton.vue";

// Mobile menu state
const mobileMenuOpen = ref(false);

// GSAP animations
const { animateHeroEntrance, animateOnScroll, animateNavOnScroll, cleanup } = useGSAP();

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
.main-nav {
  transition: all 0.3s ease;
}

.main-nav.nav-scrolled {
  background: rgba(0, 0, 0, 0.95);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
}

.hero-content,
.hero-dashboard,
.hero-nav {
  opacity: 0;
}
</style>
