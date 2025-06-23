-- Fix subscription_status column conflict between migrations
-- 009_add_subscription_fields.sql and 20250621_add_trial_fields.sql both try to add this column

-- First, check if subscription_status exists and what type it is
-- If it exists as TEXT without constraints, we need to add the constraint
-- If it doesn't exist, we'll create it properly

-- Drop the column if it exists without proper constraints
DO $$
BEGIN
    -- Check if subscription_status exists
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'tenants' 
        AND column_name = 'subscription_status'
        AND table_schema = 'public'
    ) THEN
        -- Drop existing column to recreate with proper constraints
        ALTER TABLE tenants DROP COLUMN subscription_status;
    END IF;
END $$;

-- Add subscription_status with proper constraints
ALTER TABLE tenants 
ADD COLUMN subscription_status TEXT DEFAULT 'trial' 
CHECK (subscription_status IN ('trial', 'active', 'cancelled', 'expired'));

-- Ensure trial_ends_at exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'tenants' 
        AND column_name = 'trial_ends_at'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE tenants ADD COLUMN trial_ends_at TIMESTAMPTZ;
    END IF;
END $$;

-- Ensure stripe fields exist on tenants (might be duplicated but safe)
DO $$
BEGIN
    -- Add stripe_customer_id if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'tenants' 
        AND column_name = 'stripe_customer_id'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE tenants ADD COLUMN stripe_customer_id TEXT;
    END IF;
    
    -- Add stripe_subscription_id if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'tenants' 
        AND column_name = 'stripe_subscription_id'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE tenants ADD COLUMN stripe_subscription_id TEXT;
    END IF;
END $$;

-- Set trial_ends_at for existing tenants if it's null
UPDATE tenants 
SET trial_ends_at = NOW() + INTERVAL '7 days'
WHERE trial_ends_at IS NULL;

-- Ensure indexes exist
CREATE INDEX IF NOT EXISTS idx_tenants_subscription_status ON tenants(subscription_status);
CREATE INDEX IF NOT EXISTS idx_tenants_trial_ends_at ON tenants(trial_ends_at);
CREATE INDEX IF NOT EXISTS idx_tenants_stripe_customer_id ON tenants(stripe_customer_id);

-- Comments for clarity
COMMENT ON COLUMN tenants.subscription_status IS 'Current subscription status: trial, active, cancelled, or expired';
COMMENT ON COLUMN tenants.trial_ends_at IS 'When the free trial expires for this tenant';
COMMENT ON COLUMN tenants.stripe_customer_id IS 'Stripe customer ID for billing';
COMMENT ON COLUMN tenants.stripe_subscription_id IS 'Stripe subscription ID for recurring billing';