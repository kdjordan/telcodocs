import { createClient } from '@supabase/supabase-js'

export default defineNuxtPlugin({
  name: 'supabase-client',
  enforce: 'pre',
  async setup() {
    const config = useRuntimeConfig()
    
    // Validate config
    if (!config.public.supabaseUrl || !config.public.supabaseAnonKey) {
      console.error('Supabase configuration missing')
      return {
        provide: {
          supabase: null
        }
      }
    }
    
    const supabase = createClient(
      config.public.supabaseUrl,
      config.public.supabaseAnonKey,
      {
        auth: {
          persistSession: true,
          autoRefreshToken: true,
          detectSessionInUrl: true,
          storage: {
            getItem: (key) => {
              if (process.client) {
                return window.localStorage.getItem(key)
              }
              return null
            },
            setItem: (key, value) => {
              if (process.client) {
                window.localStorage.setItem(key, value)
              }
            },
            removeItem: (key) => {
              if (process.client) {
                window.localStorage.removeItem(key)
              }
            }
          }
        }
      }
    )

    return {
      provide: {
        supabase
      }
    }
  }
})