import { serverSupabaseServiceRole, serverSupabaseUser } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const submissionId = getRouterParam(event, 'id')

  if (!submissionId) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Submission ID is required'
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
    // Get submission with related data
    const { data: submission, error: submissionError } = await supabase
      .from('form_submissions')
      .select(`
        *,
        form_template:form_templates(*),
        application:applications(*)
      `)
      .eq('id', submissionId)
      .single()

    if (submissionError) throw submissionError
    if (!submission) {
      throw createError({
        statusCode: 404,
        statusMessage: 'Submission not found'
      })
    }

    // Verify user has access to this submission
    const { data: userProfile } = await supabase
      .from('users')
      .select('tenant_id, role')
      .eq('id', user.id)
      .single()

    const hasAccess = submission.user_id === user.id || // User owns submission
                     userProfile?.tenant_id === submission.form_template.tenant_id || // Same tenant
                     userProfile?.role === 'super_admin' // Super admin

    if (!hasAccess) {
      throw createError({
        statusCode: 403,
        statusMessage: 'Access denied'
      })
    }

    return {
      data: {
        submission
      }
    }
  } catch (error: any) {
    console.error('Error loading submission:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Failed to load submission'
    })
  }
})