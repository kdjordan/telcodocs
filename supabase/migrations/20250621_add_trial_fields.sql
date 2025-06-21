-- Add trial fields to tenants table
ALTER TABLE tenants 
ADD COLUMN trial_ends_at timestamptz,
ADD COLUMN subscription_status text DEFAULT 'trial' CHECK (subscription_status IN ('trial', 'active', 'cancelled', 'expired')),
ADD COLUMN stripe_customer_id text,
ADD COLUMN stripe_subscription_id text;

-- Set trial_ends_at for existing tenants (7 days from now)
UPDATE tenants 
SET trial_ends_at = now() + interval '7 days'
WHERE trial_ends_at IS NULL;

-- Add indexes for performance
CREATE INDEX idx_tenants_trial_ends_at ON tenants(trial_ends_at);
CREATE INDEX idx_tenants_subscription_status ON tenants(subscription_status);
CREATE INDEX idx_tenants_stripe_customer_id ON tenants(stripe_customer_id);

-- Add comment
COMMENT ON COLUMN tenants.trial_ends_at IS 'When the free trial expires for this tenant';
COMMENT ON COLUMN tenants.subscription_status IS 'Current subscription status: trial, active, cancelled, or expired';
COMMENT ON COLUMN tenants.stripe_customer_id IS 'Stripe customer ID for billing';
COMMENT ON COLUMN tenants.stripe_subscription_id IS 'Stripe subscription ID for recurring billing';