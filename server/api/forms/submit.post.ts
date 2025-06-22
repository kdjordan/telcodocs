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
    // Get form template to verify access and validate data
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

    // Validate form data against template
    const validationErrors = validateFormData(form_data, formTemplate.fields)
    if (validationErrors.length > 0) {
      throw createError({
        statusCode: 400,
        statusMessage: `Validation errors: ${validationErrors.join(', ')}`
      })
    }

    // Verify user has access to this form
    const { data: userProfile } = await supabase
      .from('users')
      .select('tenant_id, role')
      .eq('id', user.id)
      .single()

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
      // Update existing submission and mark as submitted
      const { data, error } = await supabase
        .from('form_submissions')
        .update({
          form_data,
          submitted_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
        .eq('id', submission_id)
        .select()
        .single()

      if (error) throw error
      submission = data
    } else {
      // Create new submission and mark as submitted
      const { data, error } = await supabase
        .from('form_submissions')
        .insert({
          form_template_id,
          application_id,
          form_data,
          user_id: user.id,
          submitted_at: new Date().toISOString()
        })
        .select()
        .single()

      if (error) throw error
      submission = data
    }

    // Update application status
    if (application_id) {
      const newStatus = formTemplate.form_type === 'msa' ? 'pending_approval' : 'completed'
      
      await supabase
        .from('applications')
        .update({
          status: newStatus,
          updated_at: new Date().toISOString()
        })
        .eq('id', application_id)

      // Update workflow step if applicable
      if (formTemplate.form_type !== 'custom') {
        await supabase
          .from('application_workflow')
          .update({
            status: 'completed',
            completed_at: new Date().toISOString()
          })
          .eq('application_id', application_id)
          .eq('form_type', formTemplate.form_type)
      }
    }

    // TODO: Send email notifications to tenant owners/admins
    // TODO: Generate PDF if all forms are complete

    return {
      data: {
        submission,
        message: 'Form submitted successfully'
      }
    }
  } catch (error: any) {
    console.error('Form submission error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Failed to submit form'
    })
  }
})

// Helper function to validate form data
function validateFormData(formData: Record<string, any>, fields: any[]) {
  const errors: string[] = []

  fields.forEach(field => {
    const value = formData[field.name]

    // Required field validation
    if (field.required) {
      if (value === '' || value === null || value === undefined) {
        errors.push(`${field.label} is required`)
        return
      }

      if (field.type === 'checkbox' && value !== true) {
        errors.push(`${field.label} must be checked`)
        return
      }
    }

    // Skip validation if field is empty and not required
    if (!value && !field.required) return

    // Type-specific validation
    if (field.validation) {
      const validation = field.validation

      if (validation.pattern && !new RegExp(validation.pattern).test(String(value))) {
        errors.push(validation.customMessage || `${field.label} format is invalid`)
      }

      if (validation.minLength && String(value).length < validation.minLength) {
        errors.push(`${field.label} must be at least ${validation.minLength} characters`)
      }

      if (validation.maxLength && String(value).length > validation.maxLength) {
        errors.push(`${field.label} must be no more than ${validation.maxLength} characters`)
      }

      if (validation.min && Number(value) < validation.min) {
        errors.push(`${field.label} must be at least ${validation.min}`)
      }

      if (validation.max && Number(value) > validation.max) {
        errors.push(`${field.label} must be no more than ${validation.max}`)
      }
    }

    // Email validation
    if (field.type === 'email' && value) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!emailRegex.test(value)) {
        errors.push(`${field.label} must be a valid email address`)
      }
    }

    // Phone validation (basic)
    if (field.type === 'phone' && value) {
      const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/
      if (!phoneRegex.test(value.replace(/[\s\-\(\)]/g, ''))) {
        errors.push(`${field.label} must be a valid phone number`)
      }
    }
  })

  return errors
}