import { serverSupabaseServiceRole, serverSupabaseUser } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const { form_template_id, application_id, submission_id, form_data } = body

  // Validate input
  if (!form_template_id || !form_data) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Form template ID and form data are required'
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
    // Get form template to verify access
    const { data: formTemplate, error: templateError } = await supabase
      .from('form_templates')
      .select('*, tenant:tenants(*)')
      .eq('id', form_template_id)
      .single()

    if (templateError) throw templateError
    if (!formTemplate) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Form template not found'
      })
    }

    // Verify user has access to this form
    const { data: userProfile } = await supabase
      .from('users')
      .select('tenant_id, role')
      .eq('id', user.id)
      .single()

    // Allow access if user is tenant owner/admin or if it's their own application
    const hasAccess = userProfile?.tenant_id === formTemplate.tenant_id || 
                     userProfile?.role === 'super_admin'

    if (!hasAccess && application_id) {
      // Check if user owns this application
      const { data: application } = await supabase
        .from('applications')
        .select('user_id')
        .eq('id', application_id)
        .single()

      if (application?.user_id !== user.id) {
        throw createError({
          statusCode: 403,
          statusMessage: 'Access denied'
        })
      }
    }

    let submission

    if (submission_id) {
      // Update existing submission
      const { data, error } = await supabase
        .from('form_submissions')
        .update({
          form_data,
          updated_at: new Date().toISOString()
        })
        .eq('id', submission_id)
        .select()
        .single()

      if (error) throw error
      submission = data
    } else {
      // Create new submission
      const { data, error } = await supabase
        .from('form_submissions')
        .insert({
          form_template_id,
          application_id,
          form_data,
          user_id: user.id
        })
        .select()
        .single()

      if (error) throw error
      submission = data
    }

    // Update application status if applicable
    if (application_id && submission) {
      await supabase
        .from('applications')
        .update({
          status: 'in_progress',
          updated_at: new Date().toISOString()
        })
        .eq('id', application_id)
    }

    return {
      data: {
        submission,
        message: 'Form auto-saved successfully'
      }
    }
  } catch (error: any) {
    console.error('Auto-save error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Failed to auto-save form'
    })
  }
})