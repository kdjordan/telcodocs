// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  
  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxtjs/google-fonts'
  ],

  googleFonts: {
    families: {
      Inter: [400, 500, 600, 700]
    }
  },

  css: ['~/assets/css/main.css'],

  runtimeConfig: {
    public: {
      supabaseUrl: process.env.SUPABASE_URL || '',
      supabaseAnonKey: process.env.SUPABASE_ANON_KEY || '',
      appDomain: process.env.APP_DOMAIN || 'telcodocs.com',
      r2PublicUrl: process.env.R2_PUBLIC_URL || ''
    },
    supabaseServiceKey: process.env.SUPABASE_SERVICE_KEY || '',
    r2AccountId: process.env.R2_ACCOUNT_ID || '',
    r2AccessKeyId: process.env.R2_ACCESS_KEY_ID || '',
    r2SecretAccessKey: process.env.R2_SECRET_ACCESS_KEY || '',
    r2BucketName: process.env.R2_BUCKET_NAME || '',
    sesRegion: process.env.SES_REGION || 'us-east-1',
    sesAccessKeyId: process.env.SES_ACCESS_KEY_ID || '',
    sesSecretAccessKey: process.env.SES_SECRET_ACCESS_KEY || '',
    sesFromEmail: process.env.SES_FROM_EMAIL || 'noreply@telcodocs.com'
  },

  nitro: {
    experimental: {
      wasm: true
    }
  },

  typescript: {
    strict: true
  }
})
