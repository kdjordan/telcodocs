import Stripe from 'stripe'
import { serverSupabaseServiceRole } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  
  if (!config.stripeSecretKey || !config.stripeWebhookSecret) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Stripe not configured'
    })
  }

  const stripe = new Stripe(config.stripeSecretKey, {
    apiVersion: '2023-10-16'
  })

  const supabase = await serverSupabaseServiceRole(event)
  const body = await readRawBody(event)
  const signature = getHeader(event, 'stripe-signature')

  if (!signature || !body) {
    throw createError({
      statusCode: 400,
      statusMessage: 'Missing signature or body'
    })
  }

  let stripeEvent: Stripe.Event

  try {
    stripeEvent = stripe.webhooks.constructEvent(
      body,
      signature,
      config.stripeWebhookSecret
    )
  } catch (error: any) {
    console.error('Webhook signature verification failed:', error)
    throw createError({
      statusCode: 400,
      statusMessage: `Webhook Error: ${error.message}`
    })
  }

  try {
    switch (stripeEvent.type) {
      case 'checkout.session.completed':
        await handleCheckoutCompleted(stripeEvent.data.object as Stripe.Checkout.Session, supabase)
        break
      
      case 'customer.subscription.updated':
        await handleSubscriptionUpdated(stripeEvent.data.object as Stripe.Subscription, supabase)
        break
      
      case 'customer.subscription.deleted':
        await handleSubscriptionDeleted(stripeEvent.data.object as Stripe.Subscription, supabase)
        break
      
      case 'invoice.payment_succeeded':
        await handlePaymentSucceeded(stripeEvent.data.object as Stripe.Invoice, supabase)
        break
      
      case 'invoice.payment_failed':
        await handlePaymentFailed(stripeEvent.data.object as Stripe.Invoice, supabase)
        break

      default:
        console.log(`Unhandled event type: ${stripeEvent.type}`)
    }

    return { received: true }
  } catch (error: any) {
    console.error('Webhook processing error:', error)
    throw createError({
      statusCode: 500,
      statusMessage: error.message || 'Webhook processing failed'
    })
  }
})

async function handleCheckoutCompleted(session: Stripe.Checkout.Session, supabase: any) {
  const userId = session.metadata?.user_id
  const subscriptionId = session.subscription as string

  if (!userId || !subscriptionId) {
    console.error('Missing user_id or subscription_id in checkout session')
    return
  }

  // Update user with subscription ID
  await supabase
    .from('users')
    .update({ 
      stripe_subscription_id: subscriptionId,
      role: 'tenant_owner' // Promote to tenant owner after successful payment
    })
    .eq('id', userId)

  console.log(`Checkout completed for user ${userId}, subscription ${subscriptionId}`)
}

async function handleSubscriptionUpdated(subscription: Stripe.Subscription, supabase: any) {
  const userId = subscription.metadata?.user_id

  if (!userId) {
    console.error('Missing user_id in subscription metadata')
    return
  }

  // Get the user's tenant
  const { data: user } = await supabase
    .from('users')
    .select('tenant_id')
    .eq('id', userId)
    .single()

  if (user?.tenant_id) {
    // Update tenant subscription status
    await supabase
      .from('tenants')
      .update({
        subscription_status: subscription.status,
        updated_at: new Date().toISOString()
      })
      .eq('id', user.tenant_id)
  }

  console.log(`Subscription updated for user ${userId}: ${subscription.status}`)
}

async function handleSubscriptionDeleted(subscription: Stripe.Subscription, supabase: any) {
  const userId = subscription.metadata?.user_id

  if (!userId) {
    console.error('Missing user_id in subscription metadata')
    return
  }

  // Get the user's tenant
  const { data: user } = await supabase
    .from('users')
    .select('tenant_id')
    .eq('id', userId)
    .single()

  if (user?.tenant_id) {
    // Update tenant to inactive
    await supabase
      .from('tenants')
      .update({
        subscription_status: 'canceled',
        updated_at: new Date().toISOString()
      })
      .eq('id', user.tenant_id)
  }

  // Downgrade user role
  await supabase
    .from('users')
    .update({ 
      stripe_subscription_id: null,
      role: 'end_user'
    })
    .eq('id', userId)

  console.log(`Subscription canceled for user ${userId}`)
}

async function handlePaymentSucceeded(invoice: Stripe.Invoice, supabase: any) {
  const subscriptionId = invoice.subscription as string
  
  if (!subscriptionId) return

  // Find user by subscription ID
  const { data: user } = await supabase
    .from('users')
    .select('id, tenant_id')
    .eq('stripe_subscription_id', subscriptionId)
    .single()

  if (user?.tenant_id) {
    await supabase
      .from('tenants')
      .update({
        subscription_status: 'active',
        updated_at: new Date().toISOString()
      })
      .eq('id', user.tenant_id)
  }

  console.log(`Payment succeeded for subscription ${subscriptionId}`)
}

async function handlePaymentFailed(invoice: Stripe.Invoice, supabase: any) {
  const subscriptionId = invoice.subscription as string
  
  if (!subscriptionId) return

  // Find user by subscription ID
  const { data: user } = await supabase
    .from('users')
    .select('id, tenant_id')
    .eq('stripe_subscription_id', subscriptionId)
    .single()

  if (user?.tenant_id) {
    await supabase
      .from('tenants')
      .update({
        subscription_status: 'past_due',
        updated_at: new Date().toISOString()
      })
      .eq('id', user.tenant_id)
  }

  console.log(`Payment failed for subscription ${subscriptionId}`)
}