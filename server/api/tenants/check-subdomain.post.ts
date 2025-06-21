import { serverSupabaseServiceRole } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const { subdomain } = body

  if (!subdomain) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Subdomain is required'
    })
  }

  const supabase = await serverSupabaseServiceRole(event)

  try {
    // Check if subdomain exists
    const { data, error } = await supabase
      .from('tenants')
      .select('id')
      .eq('subdomain', subdomain.toLowerCase())
      .single()

    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows returned
      throw error
    }

    return {
      data: {
        available: !data, // Available if no data found
        subdomain: subdomain.toLowerCase()
      }
    }
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Failed to check subdomain availability'
    })
  }
})