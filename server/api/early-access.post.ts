import { serverSupabaseServiceRole } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const { email, source, referrer, metadata } = body

  // Validate email
  if (!email || !email.includes('@')) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Valid email address is required'
    })
  }

  // Get IP address for tracking
  const forwardedFor = getHeader(event, 'x-forwarded-for')
  const ipAddress = Array.isArray(forwardedFor) 
    ? forwardedFor[0] 
    : forwardedFor || getClientIP(event)

  // Get user agent
  const userAgent = getHeader(event, 'user-agent')

  const supabase = serverSupabaseServiceRole(event)

  try {
    // Check if email already exists
    const { data: existing } = await supabase
      .from('email_waitlist')
      .select('id, email')
      .eq('email', email.toLowerCase())
      .single()

    if (existing) {
      throw createError({
        statusCode: 409,
        statusMessage: 'Email already exists in waitlist'
      })
    }

    // Insert new email
    const { data, error } = await supabase
      .from('email_waitlist')
      .insert({
        email: email.toLowerCase(),
        source: source || 'manual',
        referrer: referrer || null,
        metadata: {
          ...metadata,
          ip_address: ipAddress,
          user_agent: userAgent
        },
        ip_address: ipAddress,
        user_agent: userAgent,
        status: 'active'
      })
      .select()
      .single()

    if (error) {
      console.error('Database error:', error)
      throw createError({
        statusCode: 500,
        statusMessage: 'Failed to add email to waitlist'
      })
    }

    // Get total count for social proof
    const { count } = await supabase
      .from('email_waitlist')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'active')

    return {
      success: true,
      message: 'Successfully added to waitlist',
      totalCount: count || 0
    }

  } catch (error: any) {
    // Re-throw createError instances
    if (error.statusCode) {
      throw error
    }

    console.error('Unexpected error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Internal server error'
    })
  }
})