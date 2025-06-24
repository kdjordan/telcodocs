-- TELODOX Production Migration 005: Views and Aggregates (Fixed)
-- Creates all analytical views and aggregation functions for platform analytics

-- ============================================================================
-- PLATFORM ANALYTICS VIEWS (PLATFORM OWNER ACCESS)
-- ============================================================================

-- Revenue analytics view
CREATE OR REPLACE VIEW revenue_analytics AS
SELECT 
    COUNT(DISTINCT CASE WHEN COALESCE(sp.price_monthly, 0) > 0 THEN t.id END) as paying_tenants,
    COALESCE(SUM(CASE WHEN t.subscription_status = 'active' THEN sp.price_monthly ELSE 0 END) / 100.0, 0) as mrr,
    COALESCE(SUM(CASE WHEN t.subscription_status = 'active' THEN sp.price_monthly * 12 ELSE 0 END) / 100.0, 0) as arr,
    COALESCE(AVG(CASE WHEN sp.price_monthly > 0 THEN sp.price_monthly END) / 100.0, 0) as avg_revenue_per_tenant,
    COUNT(DISTINCT CASE 
        WHEN t.subscription_status = 'active' 
        AND t.created_at > NOW() - INTERVAL '30 days' 
        THEN t.id 
    END) as new_paying_tenants_30d
FROM tenants t
LEFT JOIN subscription_plans sp ON t.subscription_plan = sp.name;

-- Platform overview dashboard
CREATE OR REPLACE VIEW platform_overview AS
SELECT 
    COUNT(DISTINCT t.id) as total_tenants,
    COUNT(DISTINCT CASE WHEN t.subscription_status = 'active' THEN t.id END) as active_tenants,
    COUNT(DISTINCT CASE WHEN t.subscription_status = 'trial' THEN t.id END) as trial_tenants,
    COUNT(DISTINCT CASE WHEN t.subscription_status IN ('cancelled', 'expired') THEN t.id END) as churned_tenants,
    COUNT(DISTINCT u.id) as total_users,
    COUNT(DISTINCT CASE WHEN u.created_at > NOW() - INTERVAL '30 days' THEN u.id END) as new_users_30d,
    COUNT(DISTINCT a.id) as total_applications,
    COUNT(DISTINCT CASE WHEN a.status = 'completed' THEN a.id END) as completed_applications,
    COALESCE(AVG(CASE WHEN a.status = 'completed' 
        THEN EXTRACT(epoch FROM (a.completed_at - a.created_at))/86400 
        ELSE NULL END), 0) as avg_completion_days
FROM tenants t
LEFT JOIN users u ON u.tenant_id = t.id
LEFT JOIN applications a ON a.tenant_id = t.id;

-- Tenant activity summary with health indicators
CREATE OR REPLACE VIEW tenant_activity_summary AS
SELECT 
    t.id as tenant_id,
    t.name as tenant_name,
    t.subdomain,
    t.subscription_status,
    t.subscription_plan,
    t.created_at as tenant_created_at,
    COUNT(DISTINCT u.id) as user_count,
    COUNT(DISTINCT CASE WHEN u.organization_role = 'owner' THEN u.id END) as owner_count,
    COUNT(DISTINCT CASE WHEN u.organization_role = 'admin' THEN u.id END) as admin_count,
    COUNT(DISTINCT CASE WHEN u.organization_role = 'member' THEN u.id END) as member_count,
    COUNT(DISTINCT a.id) as application_count,
    COUNT(DISTINCT CASE WHEN a.status = 'completed' THEN a.id END) as completed_count,
    COUNT(DISTINCT CASE WHEN a.status IN ('draft', 'in_progress') THEN a.id END) as active_count,
    COUNT(DISTINCT CASE WHEN a.created_at > NOW() - INTERVAL '30 days' THEN a.id END) as recent_applications,
    COUNT(DISTINCT CASE WHEN a.created_at > NOW() - INTERVAL '7 days' THEN a.id END) as applications_last_week,
    MAX(a.created_at) as last_application_date,
    MAX(u.created_at) as last_user_signup,
    CASE 
        WHEN MAX(a.created_at) > NOW() - INTERVAL '7 days' THEN 'highly_active'
        WHEN MAX(a.created_at) > NOW() - INTERVAL '30 days' THEN 'active'
        WHEN MAX(a.created_at) > NOW() - INTERVAL '90 days' THEN 'low_activity'
        ELSE 'inactive'
    END as activity_level,
    CASE 
        WHEN t.subscription_status = 'active' AND COUNT(DISTINCT a.id) > 10 THEN 'healthy'
        WHEN t.subscription_status = 'active' AND COUNT(DISTINCT a.id) > 0 THEN 'stable'
        WHEN t.subscription_status = 'trial' AND COUNT(DISTINCT a.id) > 0 THEN 'promising'
        WHEN t.subscription_status = 'trial' THEN 'new'
        ELSE 'at_risk'
    END as health_status
FROM tenants t
LEFT JOIN users u ON u.tenant_id = t.id
LEFT JOIN applications a ON a.tenant_id = t.id
GROUP BY t.id, t.name, t.subdomain, t.subscription_status, t.subscription_plan, t.created_at;

-- User engagement analytics
CREATE OR REPLACE VIEW user_engagement_analytics AS
SELECT 
    t.id as tenant_id,
    t.name as tenant_name,
    u.id as user_id,
    u.full_name,
    u.email,
    u.role,
    u.organization_role,
    u.created_at as user_created_at,
    COUNT(DISTINCT al.id) as total_activities,
    COUNT(DISTINCT CASE WHEN al.created_at > NOW() - INTERVAL '7 days' THEN al.id END) as activities_last_week,
    COUNT(DISTINCT CASE WHEN al.created_at > NOW() - INTERVAL '30 days' THEN al.id END) as activities_last_month,
    COUNT(DISTINCT da.application_id) as assigned_applications,
    COUNT(DISTINCT CASE WHEN a.status = 'completed' THEN da.application_id END) as completed_assignments,
    MAX(al.created_at) as last_activity_date,
    CASE 
        WHEN MAX(al.created_at) > NOW() - INTERVAL '24 hours' THEN 'very_active'
        WHEN MAX(al.created_at) > NOW() - INTERVAL '7 days' THEN 'active'
        WHEN MAX(al.created_at) > NOW() - INTERVAL '30 days' THEN 'occasional'
        ELSE 'inactive'
    END as engagement_level
FROM tenants t
JOIN users u ON u.tenant_id = t.id
LEFT JOIN activity_logs al ON al.user_id = u.id
LEFT JOIN deal_assignments da ON da.assigned_to = u.id
LEFT JOIN applications a ON a.id = da.application_id
WHERE u.role != 'end_user'  -- Exclude external carriers
GROUP BY t.id, t.name, u.id, u.full_name, u.email, u.role, u.organization_role, u.created_at;

-- Application pipeline analytics
CREATE OR REPLACE VIEW application_pipeline_analytics AS
SELECT 
    t.id as tenant_id,
    t.name as tenant_name,
    COUNT(*) as total_applications,
    COUNT(CASE WHEN a.status = 'draft' THEN 1 END) as draft_count,
    COUNT(CASE WHEN a.status = 'in_progress' THEN 1 END) as in_progress_count,
    COUNT(CASE WHEN a.status = 'pending_approval' THEN 1 END) as pending_approval_count,
    COUNT(CASE WHEN a.status = 'approved' THEN 1 END) as approved_count,
    COUNT(CASE WHEN a.status = 'rejected' THEN 1 END) as rejected_count,
    COUNT(CASE WHEN a.status = 'completed' THEN 1 END) as completed_count,
    ROUND(COUNT(CASE WHEN a.status = 'completed' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) as completion_rate,
    ROUND(COUNT(CASE WHEN a.status = 'rejected' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) as rejection_rate,
    AVG(CASE WHEN a.status = 'completed' 
        THEN EXTRACT(epoch FROM (a.completed_at - a.created_at))/86400 
        ELSE NULL END) as avg_completion_days,
    COUNT(CASE WHEN a.created_at > NOW() - INTERVAL '30 days' THEN 1 END) as new_applications_30d,
    COUNT(CASE WHEN a.completed_at > NOW() - INTERVAL '30 days' THEN 1 END) as completed_30d
FROM tenants t
LEFT JOIN applications a ON a.tenant_id = t.id
GROUP BY t.id, t.name;

-- Form usage analytics
CREATE OR REPLACE VIEW form_usage_analytics AS
SELECT 
    t.id as tenant_id,
    t.name as tenant_name,
    ft.form_type,
    COUNT(DISTINCT ft.id) as template_count,
    COUNT(DISTINCT fs.id) as submission_count,
    COUNT(DISTINCT CASE WHEN fs.is_final = true THEN fs.id END) as final_submission_count,
    COUNT(DISTINCT a.id) as unique_applications,
    AVG(CASE WHEN fs.submitted_at IS NOT NULL 
        THEN EXTRACT(epoch FROM (fs.submitted_at - fs.created_at))/3600 
        ELSE NULL END) as avg_completion_hours,
    MAX(fs.created_at) as last_submission_date
FROM tenants t
LEFT JOIN form_templates ft ON ft.tenant_id = t.id
LEFT JOIN form_submissions fs ON fs.form_template_id = ft.id
LEFT JOIN applications a ON a.id = fs.application_id
GROUP BY t.id, t.name, ft.form_type;

-- MSA redlining analytics
CREATE OR REPLACE VIEW msa_redlining_analytics AS
SELECT 
    t.id as tenant_id,
    t.name as tenant_name,
    COUNT(DISTINCT md.id) as total_msa_documents,
    COUNT(DISTINCT CASE WHEN md.status = 'draft' THEN md.id END) as draft_documents,
    COUNT(DISTINCT CASE WHEN md.status = 'under_review' THEN md.id END) as under_review_documents,
    COUNT(DISTINCT CASE WHEN md.status = 'signed' THEN md.id END) as signed_documents,
    COUNT(DISTINCT dc.id) as total_changes,
    COUNT(DISTINCT CASE WHEN dc.status = 'pending' THEN dc.id END) as pending_changes,
    COUNT(DISTINCT CASE WHEN dc.status = 'approved' THEN dc.id END) as approved_changes,
    COUNT(DISTINCT CASE WHEN dc.status = 'rejected' THEN dc.id END) as rejected_changes,
    ROUND(COUNT(DISTINCT CASE WHEN dc.status = 'approved' THEN dc.id END) * 100.0 / 
          NULLIF(COUNT(DISTINCT CASE WHEN dc.status IN ('approved', 'rejected') THEN dc.id END), 0), 2) as change_approval_rate,
    AVG(md.version) as avg_document_versions,
    COUNT(DISTINCT dcom.id) as total_comments
FROM tenants t
LEFT JOIN msa_documents md ON md.tenant_id = t.id
LEFT JOIN document_changes dc ON dc.document_id = md.id
LEFT JOIN document_comments dcom ON dcom.document_id = md.id
GROUP BY t.id, t.name;

-- ============================================================================
-- AGGREGATION SUMMARY VIEWS
-- ============================================================================

-- Daily platform summary for quick dashboard access
CREATE OR REPLACE VIEW daily_platform_summary AS
SELECT 
    CURRENT_DATE as summary_date,
    (SELECT COUNT(*) FROM tenants) as total_tenants,
    (SELECT COUNT(*) FROM tenants WHERE subscription_status = 'active') as active_tenants,
    (SELECT COUNT(*) FROM tenants WHERE subscription_status = 'trial') as trial_tenants,
    (SELECT COUNT(*) FROM users WHERE role != 'end_user') as total_org_users,
    (SELECT COUNT(*) FROM users WHERE role = 'end_user') as total_carriers,
    (SELECT COUNT(*) FROM applications) as total_applications,
    (SELECT COUNT(*) FROM applications WHERE created_at::date = CURRENT_DATE) as applications_today,
    (SELECT COUNT(*) FROM applications WHERE completed_at::date = CURRENT_DATE) as completed_today,
    (SELECT COUNT(*) FROM tenants WHERE created_at::date = CURRENT_DATE) as new_tenants_today,
    (SELECT COUNT(*) FROM users WHERE created_at::date = CURRENT_DATE AND role != 'end_user') as new_users_today,
    (SELECT COALESCE(SUM(sp.price_monthly), 0) / 100.0
     FROM tenants t
     LEFT JOIN subscription_plans sp ON t.subscription_plan = sp.name
     WHERE t.subscription_status = 'active') as current_mrr;

-- Weekly growth metrics (FIXED - no more CROSS JOIN)
CREATE OR REPLACE VIEW weekly_growth_metrics AS
SELECT 
    DATE_TRUNC('week', CURRENT_DATE) as week_start,
    -- This week's metrics
    (SELECT COUNT(*) FROM tenants WHERE created_at >= DATE_TRUNC('week', CURRENT_DATE)) as new_tenants_this_week,
    (SELECT COUNT(*) FROM users WHERE created_at >= DATE_TRUNC('week', CURRENT_DATE) AND role != 'end_user') as new_users_this_week,
    (SELECT COUNT(*) FROM applications WHERE created_at >= DATE_TRUNC('week', CURRENT_DATE)) as new_applications_this_week,
    (SELECT COUNT(*) FROM applications WHERE completed_at >= DATE_TRUNC('week', CURRENT_DATE)) as completed_applications_this_week,
    
    -- Last week's metrics for comparison
    (SELECT COUNT(*) FROM tenants 
     WHERE created_at >= DATE_TRUNC('week', CURRENT_DATE) - INTERVAL '1 week' 
     AND created_at < DATE_TRUNC('week', CURRENT_DATE)) as new_tenants_last_week,
    (SELECT COUNT(*) FROM users 
     WHERE created_at >= DATE_TRUNC('week', CURRENT_DATE) - INTERVAL '1 week' 
     AND created_at < DATE_TRUNC('week', CURRENT_DATE) 
     AND role != 'end_user') as new_users_last_week,
    (SELECT COUNT(*) FROM applications 
     WHERE created_at >= DATE_TRUNC('week', CURRENT_DATE) - INTERVAL '1 week' 
     AND created_at < DATE_TRUNC('week', CURRENT_DATE)) as new_applications_last_week,
    (SELECT COUNT(*) FROM applications 
     WHERE completed_at >= DATE_TRUNC('week', CURRENT_DATE) - INTERVAL '1 week' 
     AND completed_at < DATE_TRUNC('week', CURRENT_DATE)) as completed_applications_last_week;

-- ============================================================================
-- TENANT HEALTH SCORING VIEW
-- ============================================================================

-- Real-time tenant health scores
CREATE OR REPLACE VIEW current_tenant_health AS
SELECT 
    t.id as tenant_id,
    t.name as tenant_name,
    t.subscription_status,
    t.subscription_plan,
    -- Activity scoring
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN a.created_at > NOW() - INTERVAL '7 days' THEN a.id END) > 5 THEN 100
        WHEN COUNT(DISTINCT CASE WHEN a.created_at > NOW() - INTERVAL '30 days' THEN a.id END) > 5 THEN 75
        WHEN COUNT(DISTINCT CASE WHEN a.created_at > NOW() - INTERVAL '90 days' THEN a.id END) > 0 THEN 50
        ELSE 25
    END as activity_score,
    -- Engagement scoring
    CASE 
        WHEN COUNT(DISTINCT u.id) > 5 THEN 100
        WHEN COUNT(DISTINCT u.id) > 2 THEN 75
        WHEN COUNT(DISTINCT u.id) > 0 THEN 50
        ELSE 25
    END as engagement_score,
    -- Billing scoring
    CASE 
        WHEN t.subscription_status = 'active' THEN 100
        WHEN t.subscription_status = 'trial' THEN 75
        WHEN t.subscription_status = 'cancelled' THEN 25
        ELSE 0
    END as billing_score,
    -- Support scoring (default to 100, can be adjusted)
    100 as support_score,
    -- Overall health score
    (
        (CASE 
            WHEN COUNT(DISTINCT CASE WHEN a.created_at > NOW() - INTERVAL '7 days' THEN a.id END) > 5 THEN 100
            WHEN COUNT(DISTINCT CASE WHEN a.created_at > NOW() - INTERVAL '30 days' THEN a.id END) > 5 THEN 75
            WHEN COUNT(DISTINCT CASE WHEN a.created_at > NOW() - INTERVAL '90 days' THEN a.id END) > 0 THEN 50
            ELSE 25
        END) +
        (CASE 
            WHEN COUNT(DISTINCT u.id) > 5 THEN 100
            WHEN COUNT(DISTINCT u.id) > 2 THEN 75
            WHEN COUNT(DISTINCT u.id) > 0 THEN 50
            ELSE 25
        END) +
        (CASE 
            WHEN t.subscription_status = 'active' THEN 100
            WHEN t.subscription_status = 'trial' THEN 75
            WHEN t.subscription_status = 'cancelled' THEN 25
            ELSE 0
        END) +
        100
    ) / 4 as overall_health_score,
    NOW() as calculated_at
FROM tenants t
LEFT JOIN users u ON u.tenant_id = t.id AND u.role != 'end_user'
LEFT JOIN applications a ON a.tenant_id = t.id
GROUP BY t.id, t.name, t.subscription_status, t.subscription_plan;

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON VIEW revenue_analytics IS 'Platform revenue metrics including MRR, ARR, and paying tenant counts';
COMMENT ON VIEW platform_overview IS 'High-level platform statistics for platform owner dashboard';
COMMENT ON VIEW tenant_activity_summary IS 'Detailed tenant activity and health indicators';
COMMENT ON VIEW user_engagement_analytics IS 'User engagement metrics within each tenant';
COMMENT ON VIEW application_pipeline_analytics IS 'Application workflow and completion metrics by tenant';
COMMENT ON VIEW form_usage_analytics IS 'Form template usage and completion analytics';
COMMENT ON VIEW msa_redlining_analytics IS 'MSA document collaboration and redlining metrics';
COMMENT ON VIEW daily_platform_summary IS 'Daily snapshot of key platform metrics';
COMMENT ON VIEW weekly_growth_metrics IS 'Week-over-week growth comparisons (fixed - no Cartesian product)';
COMMENT ON VIEW current_tenant_health IS 'Real-time tenant health scoring and risk assessment';