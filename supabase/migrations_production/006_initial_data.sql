-- TELODOX Production Migration 006: Initial Data (Fixed)
-- Seeds the database with subscription plans and initial configuration data

-- ============================================================================
-- SUBSCRIPTION PLANS
-- ============================================================================

-- Insert default subscription plans
INSERT INTO subscription_plans (name, stripe_price_id, price_monthly, price_yearly, features, max_applications, max_forms, is_active) VALUES
(
    'Free',
    'price_free_plan',
    0,
    0,
    '[
        "1 admin user",
        "10 carrier applications per month",
        "Basic form templates",
        "Email notifications",
        "Basic support"
    ]'::jsonb,
    10,
    3,
    true
),
(
    'Starter',
    'price_starter_monthly',
    4900, -- $49.00 per month
    49000, -- $490.00 per year (2 months free)
    '[
        "5 team members",
        "100 carrier applications per month",
        "Custom form builder",
        "Digital signatures",
        "Team collaboration",
        "Email notifications",
        "Priority support"
    ]'::jsonb,
    100,
    10,
    true
),
(
    'Professional',
    'price_professional_monthly',
    9900, -- $99.00 per month
    99000, -- $990.00 per year (2 months free)
    '[
        "15 team members",
        "500 carrier applications per month",
        "Advanced form builder",
        "MSA redlining & collaboration",
        "Document version control",
        "Advanced team management",
        "Custom email templates",
        "Analytics dashboard",
        "Priority support"
    ]'::jsonb,
    500,
    25,
    true
),
(
    'Enterprise',
    'price_enterprise_monthly',
    24900, -- $249.00 per month
    249000, -- $2490.00 per year (2 months free)
    '[
        "Unlimited team members",
        "Unlimited carrier applications",
        "White-label branding",
        "Custom subdomain",
        "Advanced analytics",
        "API access",
        "SSO integration",
        "Custom integrations",
        "Dedicated account manager",
        "24/7 phone support"
    ]'::jsonb,
    999999,
    999999,
    true
);

-- ============================================================================
-- PLATFORM CONFIGURATION
-- ============================================================================

-- Initialize platform metrics with zero values for today
INSERT INTO platform_metrics (metric_type, metric_value, metric_date, time_period) VALUES
('total_tenants', 0, CURRENT_DATE, 'daily'),
('active_tenants', 0, CURRENT_DATE, 'daily'),
('trial_tenants', 0, CURRENT_DATE, 'daily'),
('total_users', 0, CURRENT_DATE, 'daily'),
('total_applications', 0, CURRENT_DATE, 'daily'),
('completed_applications_today', 0, CURRENT_DATE, 'daily'),
('new_tenants_today', 0, CURRENT_DATE, 'daily'),
('mrr', 0, CURRENT_DATE, 'daily')
ON CONFLICT (metric_type, metric_date, time_period) DO NOTHING;

-- ============================================================================
-- SYSTEM HEALTH METRICS INITIALIZATION
-- ============================================================================

-- Initialize system health metrics
INSERT INTO system_health_metrics (metric_name, metric_value, metric_unit, threshold_warning, threshold_critical, status) VALUES
('database_connections', 0, 'count', 80, 95, 'healthy'),
('api_response_time', 0, 'ms', 500, 1000, 'healthy'),
('storage_usage', 0, 'GB', 80, 95, 'healthy'),
('error_rate', 0, 'percentage', 5, 10, 'healthy'),
('uptime', 100, 'percentage', 99, 95, 'healthy');

-- ============================================================================
-- PLATFORM EVENTS SEED DATA
-- ============================================================================

-- Create initial platform startup event
INSERT INTO platform_events (event_type, severity, description, metadata) VALUES
('system_initialization', 'info', 'TELODOX platform database initialized with production schema', 
 '{"migration_version": "006", "schema_complete": true, "initial_data_loaded": true}'::jsonb);

-- ============================================================================
-- COMMENTS AND DOCUMENTATION
-- ============================================================================

COMMENT ON TABLE subscription_plans IS 'Available subscription tiers with Stripe integration';
COMMENT ON COLUMN subscription_plans.price_monthly IS 'Monthly price in cents (e.g., 4900 = $49.00)';
COMMENT ON COLUMN subscription_plans.price_yearly IS 'Yearly price in cents with discount';
COMMENT ON COLUMN subscription_plans.features IS 'JSON array of plan features for display';
COMMENT ON COLUMN subscription_plans.max_applications IS 'Maximum carrier applications per month';
COMMENT ON COLUMN subscription_plans.max_forms IS 'Maximum form templates allowed';

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- These are informational queries to verify the data was inserted correctly
-- They will be executed but not affect the migration

DO $$
DECLARE
    plan_count INTEGER;
    metric_count INTEGER;
    health_count INTEGER;
BEGIN
    -- Verify subscription plans
    SELECT COUNT(*) INTO plan_count FROM subscription_plans;
    RAISE NOTICE 'Inserted % subscription plans', plan_count;
    
    -- Verify platform metrics
    SELECT COUNT(*) INTO metric_count FROM platform_metrics WHERE metric_date = CURRENT_DATE;
    RAISE NOTICE 'Initialized % platform metrics for today', metric_count;
    
    -- Verify system health metrics
    SELECT COUNT(*) INTO health_count FROM system_health_metrics;
    RAISE NOTICE 'Initialized % system health metrics', health_count;
    
    -- Log successful initialization
    RAISE NOTICE 'TELODOX production database initialization complete';
END $$;