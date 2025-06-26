import { toast } from 'vue-sonner'

export default defineNuxtPlugin(() => {
  // Make toast available globally
  return {
    provide: {
      toast
    }
  }
})