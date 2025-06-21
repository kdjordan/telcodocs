<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div>
        <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Set new password
        </h2>
        <p class="mt-2 text-center text-sm text-gray-600">
          Enter your new password below.
        </p>
      </div>

      <Card v-if="!passwordUpdated" class="p-6">
        <template #content>
          <form @submit.prevent="updatePassword" class="space-y-6">
            <div>
              <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
                New password
              </label>
              <Password
                id="password"
                v-model="password"
                :feedback="false"
                toggleMask
                class="w-full"
                :class="{ 'p-invalid': passwordError }"
                placeholder="Enter new password"
                @input="passwordError = ''"
              />
              <small v-if="passwordError" class="p-error">{{ passwordError }}</small>
            </div>

            <div>
              <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">
                Confirm new password
              </label>
              <Password
                id="confirmPassword"
                v-model="confirmPassword"
                :feedback="false"
                toggleMask
                class="w-full"
                :class="{ 'p-invalid': confirmPasswordError }"
                placeholder="Confirm new password"
                @input="confirmPasswordError = ''"
              />
              <small v-if="confirmPasswordError" class="p-error">{{ confirmPasswordError }}</small>
            </div>

            <Button
              type="submit"
              :loading="loading"
              :disabled="!password || !confirmPassword || loading"
              class="w-full"
              label="Update password"
            />
          </form>
        </template>
      </Card>

      <Card v-else class="p-6">
        <template #content>
          <div class="text-center">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4">
              <i class="pi pi-check text-green-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-medium text-gray-900 mb-2">Password updated</h3>
            <p class="text-sm text-gray-600 mb-6">
              Your password has been successfully updated. You can now sign in with your new password.
            </p>
            <Button
              @click="goToLogin"
              class="w-full"
              label="Sign in"
            />
          </div>
        </template>
      </Card>

      <div v-if="error" class="text-center">
        <Card class="p-6">
          <template #content>
            <div class="text-center">
              <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 mb-4">
                <i class="pi pi-times text-red-600 text-xl"></i>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Invalid or expired link</h3>
              <p class="text-sm text-gray-600 mb-6">
                {{ error }}
              </p>
              <NuxtLink
                to="/auth/forgot-password"
                class="text-blue-600 hover:text-blue-500"
              >
                Request a new reset link
              </NuxtLink>
            </div>
          </template>
        </Card>
      </div>
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
const route = useRoute()
const router = useRouter()

const password = ref('')
const confirmPassword = ref('')
const passwordError = ref('')
const confirmPasswordError = ref('')
const loading = ref(false)
const passwordUpdated = ref(false)
const error = ref('')

onMounted(async () => {
  // Check if we have the session from the reset link
  const { data: { session }, error: sessionError } = await $supabase.auth.getSession()
  
  if (sessionError || !session) {
    error.value = 'Invalid or expired reset link. Please request a new password reset.'
    return
  }

  // Check for access token in URL params (from email link)
  const accessToken = route.query.access_token
  const refreshToken = route.query.refresh_token
  
  if (accessToken && refreshToken) {
    try {
      const { data, error: setSessionError } = await $supabase.auth.setSession({
        access_token: accessToken,
        refresh_token: refreshToken
      })
      
      if (setSessionError) {
        throw setSessionError
      }
    } catch (err) {
      console.error('Session error:', err)
      error.value = 'Invalid or expired reset link. Please request a new password reset.'
    }
  }
})

const validatePasswords = () => {
  let isValid = true
  
  if (!password.value) {
    passwordError.value = 'Password is required'
    isValid = false
  } else if (password.value.length < 6) {
    passwordError.value = 'Password must be at least 6 characters'
    isValid = false
  }
  
  if (!confirmPassword.value) {
    confirmPasswordError.value = 'Please confirm your password'
    isValid = false
  } else if (password.value !== confirmPassword.value) {
    confirmPasswordError.value = 'Passwords do not match'
    isValid = false
  }
  
  return isValid
}

const updatePassword = async () => {
  if (!validatePasswords()) {
    return
  }

  loading.value = true
  
  try {
    const { error: updateError } = await $supabase.auth.updateUser({
      password: password.value
    })

    if (updateError) {
      throw updateError
    }

    passwordUpdated.value = true
    toast.add({
      severity: 'success',
      summary: 'Password updated',
      detail: 'Your password has been successfully updated',
      life: 5000
    })
  } catch (err) {
    console.error('Password update error:', err)
    
    if (err.message?.includes('session_not_found')) {
      error.value = 'Your reset session has expired. Please request a new password reset.'
    } else {
      passwordError.value = err.message || 'Failed to update password'
      toast.add({
        severity: 'error',
        summary: 'Update failed',
        detail: passwordError.value,
        life: 5000
      })
    }
  } finally {
    loading.value = false
  }
}

const goToLogin = () => {
  router.push('/auth/login')
}

useSeoMeta({
  title: 'Reset Password - TelcoDocs',
  description: 'Set your new TelcoDocs password'
})
</script>