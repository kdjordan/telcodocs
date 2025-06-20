import { createClient } from '@supabase/supabase-js'
import type { H3Event } from 'h3'

export const serverSupabaseClient = () => {
  const config = useRuntimeConfig()
  
  return createClient(
    config.public.supabaseUrl,
    config.supabaseServiceKey,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      }
    }
  )
}

export const serverSupabaseUser = async (event: H3Event) => {
  const config = useRuntimeConfig()
  const token = getCookie(event, 'sb-access-token') || getHeader(event, 'authorization')?.replace('Bearer ', '')
  
  if (!token) {
    return null
  }

  try {
    const supabase = serverSupabaseClient()
    const { data: { user }, error } = await supabase.auth.getUser(token)
    
    if (error) throw error
    
    return user
  } catch (error) {
    return null
  }
}

export const requireAuth = async (event: H3Event) => {
  const user = await serverSupabaseUser(event)
  
  if (!user) {
    throw createError({
      statusCode: 401,
      statusMessage: 'Unauthorized'
    })
  }
  
  return user
}

export const requireRole = async (event: H3Event, allowedRoles: string[]) => {
  const user = await requireAuth(event)
  const supabase = serverSupabaseClient()
  
  const { data: profile, error } = await supabase
    .from('users')
    .select('role')
    .eq('id', user.id)
    .single()
  
  if (error || !profile || !allowedRoles.includes(profile.role)) {
    throw createError({
      statusCode: 403,
      statusMessage: 'Forbidden'
    })
  }
  
  return { user, role: profile.role }
}