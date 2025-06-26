<template>
  <div id="app">
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
    <ClientOnly>
      <Toaster 
        theme="dark"
        :toastOptions="{
          style: {
            backgroundColor: '#1f2937',
            color: '#f3f4f6',
            border: '1px solid #374151'
          }
        }"
      />
    </ClientOnly>
  </div>
</template>

<script setup>
import { Toaster } from 'vue-sonner'
</script>
