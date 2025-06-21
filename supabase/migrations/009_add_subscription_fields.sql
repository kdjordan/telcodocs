-- Add subscription fields to users table
ALTER TABLE users ADD COLUMN stripe_customer_id TEXT;
ALTER TABLE users ADD COLUMN stripe_subscription_id TEXT;

-- Add subscription fields to tenants table
ALTER TABLE tenants ADD COLUMN subscription_status TEXT DEFAULT 'inactive';
ALTER TABLE tenants ADD COLUMN subscription_plan TEXT;
ALTER TABLE tenants ADD COLUMN billing_email TEXT;

-- Create subscription plans table
CREATE TABLE subscription_plans (
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

-- Insert default subscription plans
INSERT INTO subscription_plans (name, stripe_price_id, price_monthly, price_yearly, features, max_applications, max_forms) VALUES
('Free', 'free_plan', 0, 0, 
 '["3 free carrier onboardings", "Unlimited custom forms", "Email support", "Basic analytics", "Test the full platform"]', 
 3, -1),
('Starter', 'price_starter_monthly', 2900, 29000, 
 '["Up to 100 applications/month", "Unlimited custom forms", "Email support", "Basic analytics", "Custom subdomain"]', 
 100, -1),
('Professional', 'price_pro_monthly', 9900, 99000, 
 '["Up to 500 applications/month", "Unlimited custom forms", "Priority support", "Advanced analytics", "Custom branding", "API access"]', 
 500, -1),
('Enterprise', 'price_enterprise_monthly', 24900, 249000, 
 '["Unlimited applications", "Unlimited forms", "24/7 phone support", "White-label solution", "Advanced API access", "Custom integrations", "Dedicated support"]', 
 -1, -1);

-- Add trigger for updated_at
CREATE TRIGGER update_subscription_plans_updated_at BEFORE UPDATE ON subscription_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Add indexes
CREATE INDEX idx_users_stripe_customer_id ON users(stripe_customer_id);
CREATE INDEX idx_users_stripe_subscription_id ON users(stripe_subscription_id);
CREATE INDEX idx_tenants_subscription_status ON tenants(subscription_status);
CREATE INDEX idx_subscription_plans_stripe_price_id ON subscription_plans(stripe_price_id);