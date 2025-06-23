-- Recreate subscription_plans table if it doesn't exist
-- This table may have been missed in migration 009

-- Create subscription plans table (safe if already exists)
CREATE TABLE IF NOT EXISTS subscription_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    stripe_price_id TEXT NOT NULL UNIQUE,
    price_monthly INTEGER NOT NULL, -- Price in cents
    price_yearly INTEGER, -- Price in cents (optional)
    features JSONB DEFAULT '[]',
    max_applications INTEGER DEFAULT 100,
    max_forms INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Only insert default plans if table is empty
INSERT INTO subscription_plans (name, stripe_price_id, price_monthly, price_yearly, features, max_applications, max_forms)
SELECT * FROM (VALUES
    ('Free', 'free_plan', 0, 0, 
     '["3 free carrier onboardings", "Unlimited custom forms", "Email support", "Basic analytics", "Test the full platform"]'::jsonb, 
     3, -1),
    ('Starter', 'price_starter_monthly', 2900, 29000, 
     '["Up to 100 applications/month", "Unlimited custom forms", "Email support", "Basic analytics", "Custom subdomain"]'::jsonb, 
     100, -1),
    ('Professional', 'price_pro_monthly', 9900, 99000, 
     '["Up to 500 applications/month", "Unlimited custom forms", "Priority support", "Advanced analytics", "Custom branding", "API access"]'::jsonb, 
     500, -1),
    ('Enterprise', 'price_enterprise_monthly', 24900, 249000, 
     '["Unlimited applications", "Unlimited forms", "24/7 phone support", "White-label solution", "Advanced API access", "Custom integrations", "Dedicated support"]'::jsonb, 
     -1, -1)
) AS v(name, stripe_price_id, price_monthly, price_yearly, features, max_applications, max_forms)
WHERE NOT EXISTS (
    SELECT 1 FROM subscription_plans
);

-- Add trigger for updated_at (safe if already exists)
DROP TRIGGER IF EXISTS update_subscription_plans_updated_at ON subscription_plans;
CREATE TRIGGER update_subscription_plans_updated_at BEFORE UPDATE ON subscription_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Add indexes (safe if already exist)
CREATE INDEX IF NOT EXISTS idx_subscription_plans_stripe_price_id ON subscription_plans(stripe_price_id);
CREATE INDEX IF NOT EXISTS idx_subscription_plans_is_active ON subscription_plans(is_active);

-- Enable RLS
ALTER TABLE subscription_plans ENABLE ROW LEVEL SECURITY;

-- RLS policies for subscription plans
CREATE POLICY IF NOT EXISTS "Anyone can view active subscription plans" ON subscription_plans
    FOR SELECT USING (is_active = true);

CREATE POLICY IF NOT EXISTS "Super admins can manage subscription plans" ON subscription_plans
    FOR ALL USING (is_super_admin());

-- Comments for documentation
COMMENT ON TABLE subscription_plans IS 'Available subscription plans with pricing and feature limits';
COMMENT ON COLUMN subscription_plans.price_monthly IS 'Monthly price in cents (e.g., 2900 = $29.00)';
COMMENT ON COLUMN subscription_plans.price_yearly IS 'Yearly price in cents (optional discount)';
COMMENT ON COLUMN subscription_plans.max_applications IS 'Maximum applications per month (-1 = unlimited)';
COMMENT ON COLUMN subscription_plans.max_forms IS 'Maximum form templates (-1 = unlimited)';
COMMENT ON COLUMN subscription_plans.features IS 'Array of feature descriptions for marketing';