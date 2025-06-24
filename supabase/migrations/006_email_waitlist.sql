-- TELODOX Production Migration 006: Email Waitlist
-- Creates email waitlist table for pre-launch marketing and email capture

-- ============================================================================
-- EMAIL WAITLIST TABLE
-- ============================================================================

-- Email waitlist for pre-launch marketing
CREATE TABLE email_waitlist (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    source VARCHAR(100) NOT NULL CHECK (source IN ('homepage', 'signup_redirect', 'manual', 'social', 'referral')),
    referrer TEXT, -- HTTP referrer for tracking marketing channels
    metadata JSONB DEFAULT '{}', -- Additional tracking data (utm params, etc.)
    ip_address INET,
    user_agent TEXT,
    subscribed_at TIMESTAMPTZ DEFAULT NOW(),
    notified_at TIMESTAMPTZ, -- When launch notification was sent
    converted_at TIMESTAMPTZ, -- When they actually signed up post-launch
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'unsubscribed', 'bounced', 'converted')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

CREATE INDEX idx_email_waitlist_email ON email_waitlist(email);
CREATE INDEX idx_email_waitlist_source ON email_waitlist(source);
CREATE INDEX idx_email_waitlist_status ON email_waitlist(status);
CREATE INDEX idx_email_waitlist_subscribed_at ON email_waitlist(subscribed_at);
CREATE INDEX idx_email_waitlist_created_at ON email_waitlist(created_at);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Updated_at trigger for email_waitlist
CREATE TRIGGER update_email_waitlist_updated_at BEFORE UPDATE ON email_waitlist
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

-- No RLS on email_waitlist - accessible from Supabase dashboard for exports
-- This is just email addresses for pre-launch marketing, not sensitive tenant data

-- ============================================================================
-- ANALYTICS VIEW
-- ============================================================================

-- Email waitlist analytics for platform owners
CREATE OR REPLACE VIEW email_waitlist_analytics AS
SELECT 
    COUNT(*) as total_emails,
    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_subscribers,
    COUNT(CASE WHEN status = 'converted' THEN 1 END) as converted_users,
    COUNT(CASE WHEN status = 'unsubscribed' THEN 1 END) as unsubscribed,
    COUNT(CASE WHEN subscribed_at > NOW() - INTERVAL '7 days' THEN 1 END) as signups_last_week,
    COUNT(CASE WHEN subscribed_at > NOW() - INTERVAL '30 days' THEN 1 END) as signups_last_month,
    ROUND(COUNT(CASE WHEN status = 'converted' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) as conversion_rate,
    source,
    COUNT(*) as source_count
FROM email_waitlist
GROUP BY ROLLUP(source)
ORDER BY source_count DESC NULLS FIRST;

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON TABLE email_waitlist IS 'Pre-launch email capture for marketing and launch notifications';
COMMENT ON COLUMN email_waitlist.source IS 'Where the email was captured from (homepage, signup_redirect, etc.)';
COMMENT ON COLUMN email_waitlist.referrer IS 'HTTP referrer header for tracking marketing channels';
COMMENT ON COLUMN email_waitlist.metadata IS 'Additional tracking data like UTM parameters';
COMMENT ON COLUMN email_waitlist.notified_at IS 'When launch notification email was sent';
COMMENT ON COLUMN email_waitlist.converted_at IS 'When they signed up for real account post-launch';
COMMENT ON VIEW email_waitlist_analytics IS 'Analytics view for email waitlist performance and conversion tracking';