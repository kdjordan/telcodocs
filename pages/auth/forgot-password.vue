<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Reset your password
        </h2>
        <p class="mt-2 text-center text-sm text-gray-600">
          Enter your email address and we'll send you a link to reset your password.
        </p>
      </div>

      <Card v-if="!emailSent" class="p-6">
        <template #content>
          <form @submit.prevent="resetPassword" class="space-y-6">
            <div>
              <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                Email address
              </label>
              <InputText
                id="email"
                v-model="email"
                type="email"
                required
                class="w-full"
                :class="{ 'p-invalid': emailError }"
                placeholder="Enter your email"
                @input="emailError = ''"
              />
              <small v-if="emailError" class="p-error">{{ emailError }}</small>
            </div>

            <Button
              type="submit"
              :loading="loading"
              :disabled="!email || loading"
              class="w-full"
              label="Send reset link"
            />
          </form>

          <div class="mt-6 text-center">
            <NuxtLink
              to="/auth/login"
              class="text-sm text-blue-600 hover:text-blue-500"
            >
              Back to login
            </NuxtLink>
          </div>
        </template>
      </Card>

      <Card v-else class="p-6">
        <template #content>
          <div class="text-center">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4">
              <i class="pi pi-check text-green-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-medium text-gray-900 mb-2">Check your email</h3>
            <p class="text-sm text-gray-600 mb-6">
              We've sent a password reset link to <strong>{{ email }}</strong>.
              Click the link in the email to reset your password.
            </p>
            <div class="space-y-3">
              <Button
                @click="resetPassword"
                :loading="loading"
                class="w-full"
                severity="secondary"
                outlined
                label="Resend email"
              />
              <NuxtLink
                to="/auth/login"
                class="block text-sm text-blue-600 hover:text-blue-500"
              >
                Back to login
              </NuxtLink>
            </div>
          </div>
        </template>
      </Card>
    </div>
  </div>
</template>

<script setup>
definePageMeta({
  layout: false,
  auth: false
})

const { $supabase } = useNuxtApp()
const toast = useToast()

const email = ref('')
const emailError = ref('')
const loading = ref(false)
const emailSent = ref(false)

const resetPassword = async () => {
  if (!email.value) {
    emailError.value = 'Email is required'
    return
  }

  if (!isValidEmail(email.value)) {
    emailError.value = 'Please enter a valid email address'
    return
  }

  loading.value = true
  emailError.value = ''

  try {
    const { error } = await $supabase.auth.resetPasswordForEmail(email.value, {
      redirectTo: `${window.location.origin}/auth/reset-password`
    })

    if (error) {
      throw error
    }

    emailSent.value = true
    toast.add({
      severity: 'success',
      summary: 'Reset link sent',
      detail: 'Check your email for the password reset link',
      life: 5000
    })
  } catch (error) {
    console.error('Password reset error:', error)
    
    if (error.message?.includes('Email not confirmed')) {
      emailError.value = 'Please verify your email address first'
    } else if (error.message?.includes('Invalid email')) {
      emailError.value = 'No account found with this email address'
    } else {
      emailError.value = error.message || 'Failed to send reset email'
    }
    
    toast.add({
      severity: 'error',
      summary: 'Reset failed',
      detail: emailError.value,
      life: 5000
    })
  } finally {
    loading.value = false
  }
}

const isValidEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(email)
}

useSeoMeta({
  title: 'Reset Password - TelcoDocs',
  description: 'Reset your TelcoDocs password'
})
</script>