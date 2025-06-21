import Stripe from 'stripe'
import { serverSupabaseServiceRole, serverSupabaseUser } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event)
  const { priceId, billingPeriod } = body

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

  const supabase = await serverSupabaseServiceRole(event)

  try {
    // Get user profile
    const { data: profile, error: profileError } = await supabase
      .from('users')
      .select('*')
      .eq('id', user.id)
      .single()

    if (profileError) throw profileError

    // Create or get Stripe customer
    let customerId = profile.stripe_customer_id

    if (!customerId) {
      const customer = await stripe.customers.create({
        email: user.email,
        name: profile.full_name,
        metadata: {
          user_id: user.id
        }
      })

      customerId = customer.id

      // Update user with Stripe customer ID
      await supabase
        .from('users')
        .update({ stripe_customer_id: customerId })
        .eq('id', user.id)
    }

    // Create checkout session
    const session = await stripe.checkout.sessions.create({
      customer: customerId,
      payment_method_types: ['card'],
      line_items: [
        {
          price: priceId,
          quantity: 1
        }
      ],
      mode: 'subscription',
      success_url: `${getRequestURL(event).origin}/onboarding/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${getRequestURL(event).origin}/pricing`,
      metadata: {
        user_id: user.id,
        billing_period: billingPeriod
      },
      subscription_data: {
        metadata: {
          user_id: user.id
        }
      }
    })

    return {
      data: {
        url: session.url
      }
    }
  } catch (error: any) {
    console.error('Stripe checkout error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Failed to create checkout session'
    })
  }
})