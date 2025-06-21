import type { Tenant } from '~/types'

export default defineNuxtRouteMiddleware(async (to, from) => {
  const config = useRuntimeConfig()
  
  // Only run on client side to ensure Supabase is available
  if (!process.client) return
  
  const { $supabase } = useNuxtApp()
  
  // Extract subdomain from hostname
  const hostname = process.client ? window.location.hostname : useRequestHeaders().host || ''
  const subdomain = extractSubdomain(hostname, config.public.appDomain)
  
  // Store tenant info in state
  const tenant = useState<Tenant | null>('tenant', () => null)
  
  // Skip tenant resolution for auth pages and super admin routes
  if (to.path.startsWith('/auth') || to.path.startsWith('/admin')) {
    return
  }
  
  // If no subdomain and not localhost, redirect to main domain
  if (!subdomain) {
    // Allow localhost development without subdomain
    if (hostname.includes('localhost') || hostname.includes('127.0.0.1')) {
      // Set tenant to null for main portal access
      tenant.value = null
      return
    }
    
    // Only redirect on production domains
    if (process.client && hostname.includes(config.public.appDomain)) {
      window.location.href = `https://www.${config.public.appDomain}`
    }
    return
  }
  
  // Fetch tenant by subdomain
  try {
    // Check if Supabase is configured
    if (!config.public.supabaseUrl || !config.public.supabaseAnonKey) {
      // In development mode without Supabase, create a mock tenant
      if (process.dev || hostname.includes('localhost')) {
        tenant.value = {
          id: 'mock-tenant-id',
          name: `${subdomain.charAt(0).toUpperCase() + subdomain.slice(1)} Demo Telecom`,
          subdomain: subdomain,
          settings: {
            workflow_settings: {
              drip_mode: 'sequential',
              require_approval: true
            }
          },
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        } as Tenant
        return
      }
      
      throw createError({
        statusCode: 500,
        statusMessage: 'Supabase not configured'
      })
    }

    const { data, error } = await $supabase
      .from('tenants')
      .select('*')
      .eq('subdomain', subdomain)
      .single()
    
    if (error || !data) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Tenant not found'
      })
    }
    
    tenant.value = data
  } catch (error: any) {
    // In development, show a helpful error
    if (process.dev || hostname.includes('localhost')) {
      console.warn('Tenant resolution failed:', error.message)
      tenant.value = null
      return
    }
    
    throw createError({
      statusCode: 404,
      statusMessage: 'Tenant not found'
    })
  }
})

function extractSubdomain(hostname: string, appDomain: string): string | null {
  // Remove www. if present
  hostname = hostname.replace(/^www\./, '')
  
  // Handle localhost with port
  if (hostname.includes('localhost') || hostname.includes('127.0.0.1')) {
    // For localhost, check if there's a subdomain before 'localhost'
    const localhostMatch = hostname.match(/^([^.]+)\.(localhost|127\.0\.0\.1)(:\d+)?$/)
    if (localhostMatch) {
      return localhostMatch[1]
    }
    return null
  }
  
  // Check if it's the main domain
  if (hostname === appDomain || hostname === `www.${appDomain}`) {
    return null
  }
  
  // Extract subdomain for production domains
  const regex = new RegExp(`^([^.]+)\.${appDomain.replace('.', '\\.')}$`)
  const match = hostname.match(regex)
  
  return match ? match[1] : null
}