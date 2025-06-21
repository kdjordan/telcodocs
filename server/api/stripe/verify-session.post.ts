import Stripe from 'stripe'
import { serverSupabaseUser } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event)
  const { sessionId } = body

  if (!config.stripeSecretKey) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Stripe not configured'
    })
  }

  const stripe = new Stripe(config.stripeSecretKey, {
    apiVersion: '2023-10-16'
  })

  // Get authenticated user
  const user = await serverSupabaseUser(event)
  if (!user) {
    throw createError({
      statusCode: 401,
      statusMessage: 'Authentication required'
    })
  }

  try {
    // Retrieve the checkout session
    const session = await stripe.checkout.sessions.retrieve(sessionId)
    
    // Verify the session belongs to the current user
    if (session.metadata?.user_id !== user.id) {
      throw createError({
        statusCode: 403,
        statusMessage: 'Session does not belong to current user'
      })
    }

    // Check if payment was successful
    if (session.payment_status === 'paid') {
      return {
        data: {
          success: true,
          sessionId: session.id,
          subscriptionId: session.subscription
        }
      }
    } else {
      return {
        data: {
          success: false,
          error: 'Payment not completed'
        }
      }
    }
  } catch (error: any) {
    console.error('Session verification error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Failed to verify session'
    })
  }
})