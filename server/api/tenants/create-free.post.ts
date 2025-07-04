import { serverSupabaseServiceRole, serverSupabaseUser } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const { companyName, subdomain, contactEmail } = body

  // Validate input
  if (!companyName || !subdomain) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Company name and subdomain are required'
    })
  }

  // Get authenticated user
  const user = await serverSupabaseUser(event)
  if (!user) {
    throw createError({
      statusCode: 401,
      statusMessage: 'Authentication required'
    })
  }

  const supabase = await serverSupabaseServiceRole(event)

  try {
    // Check if user already has a tenant
    const { data: existingUser } = await supabase
      .from('users')
      .select('tenant_id, role')
      .eq('id', user.id)
      .single()

    if (existingUser?.tenant_id) {
      throw createError({
        statusCode: 400,
        statusMessage: 'User already has a tenant'
      })
    }

    // Check if subdomain is available
    const { data: existingTenant } = await supabase
      .from('tenants')
      .select('id')
      .eq('subdomain', subdomain.toLowerCase())
      .single()

    if (existingTenant) {
      throw createError({
        statusCode: 400,
        statusMessage: 'Subdomain is already taken'
      })
    }

    // Calculate trial end date (7 days from now)
    const trialEndsAt = new Date()
    trialEndsAt.setDate(trialEndsAt.getDate() + 7)

    // Create the tenant with trial
    const { data: tenant, error: tenantError } = await supabase
      .from('tenants')
      .insert({
        name: companyName,
        subdomain: subdomain.toLowerCase(),
        trial_ends_at: trialEndsAt.toISOString(),
        subscription_status: 'trial',
        settings: {
          contact_email: contactEmail || user.email,
          workflow_settings: {
            drip_mode: 'sequential',
            require_approval: true
          }
        }
      })
      .select()
      .single()

    if (tenantError) throw tenantError

    // Update user to be tenant owner
    const { error: userError } = await supabase
      .from('users')
      .update({
        role: 'tenant_owner',
        tenant_id: tenant.id
      })
      .eq('id', user.id)

    if (userError) throw userError

    return {
      data: {
        tenant,
        message: 'Tenant created successfully'
      }
    }
  } catch (error: any) {
    console.error('Tenant creation error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Failed to create tenant'
    })
  }
})