-- TELODOX Production Migration 003: Helper Functions (Fixed)
-- Creates all helper functions, triggers, and business logic

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to automatically update application last_activity_at
CREATE OR REPLACE FUNCTION update_application_activity()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_activity_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- TENANT CONSTRAINT ENFORCEMENT FUNCTIONS
-- ============================================================================

-- Function to check deal assignment tenant consistency
CREATE OR REPLACE FUNCTION check_deal_assignment_tenant()
RETURNS TRIGGER AS $$
DECLARE
    app_tenant_id UUID;
BEGIN
    -- Get the tenant_id from the application
    SELECT tenant_id INTO app_tenant_id
    FROM applications
    WHERE id = NEW.application_id;
    
    -- Check if the deal assignment tenant matches the application tenant
    IF app_tenant_id != NEW.tenant_id THEN
        RAISE EXCEPTION 'Deal assignment tenant_id (%) does not match application tenant_id (%)', 
                        NEW.tenant_id, app_tenant_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to check MSA document tenant consistency
CREATE OR REPLACE FUNCTION check_msa_document_tenant()
RETURNS TRIGGER AS $$
DECLARE
    app_tenant_id UUID;
BEGIN
    -- Get the tenant_id from the application
    SELECT tenant_id INTO app_tenant_id
    FROM applications
    WHERE id = NEW.application_id;
    
    -- Check if the MSA document tenant matches the application tenant
    IF app_tenant_id != NEW.tenant_id THEN
        RAISE EXCEPTION 'MSA document tenant_id (%) does not match application tenant_id (%)', 
                        NEW.tenant_id, app_tenant_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- ROLE AND PERMISSION FUNCTIONS
-- ============================================================================

-- Helper function to get current user's tenant_id
CREATE OR REPLACE FUNCTION get_user_tenant_id() 
RETURNS UUID AS $$
BEGIN
    RETURN (
        SELECT tenant_id 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is platform owner
CREATE OR REPLACE FUNCTION is_platform_owner() 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT role = 'platform_owner' 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is super admin (deprecated, use platform_owner)
CREATE OR REPLACE FUNCTION is_super_admin() 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT role = 'super_admin' 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is tenant owner
CREATE OR REPLACE FUNCTION is_tenant_owner() 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT role = 'tenant_owner' 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is organization owner
CREATE OR REPLACE FUNCTION is_organization_owner() 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT organization_role = 'owner' 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is organization admin (owner or admin)
CREATE OR REPLACE FUNCTION is_organization_admin() 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT organization_role IN ('owner', 'admin') 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Check if user is organization member
CREATE OR REPLACE FUNCTION is_organization_member() 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT organization_role = 'member' 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- TEAM MANAGEMENT FUNCTIONS
-- ============================================================================

-- Get user's assigned applications
CREATE OR REPLACE FUNCTION get_user_assigned_applications()
RETURNS TABLE(application_id UUID) AS $$
BEGIN
    RETURN QUERY
    SELECT da.application_id
    FROM deal_assignments da
    WHERE da.assigned_to = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Auto-assign application to team member with least workload
CREATE OR REPLACE FUNCTION auto_assign_application(app_id UUID)
RETURNS VOID AS $$
DECLARE
    tenant_id_val UUID;
    least_busy_member UUID;
BEGIN
    -- Get tenant_id for this application
    SELECT a.tenant_id INTO tenant_id_val
    FROM applications a
    WHERE a.id = app_id;
    
    -- Find team member with least current assignments
    SELECT u.id INTO least_busy_member
    FROM users u
    LEFT JOIN deal_assignments da ON u.id = da.assigned_to
    WHERE u.tenant_id = tenant_id_val 
      AND u.organization_role = 'member'
    GROUP BY u.id
    ORDER BY COUNT(da.id) ASC
    LIMIT 1;
    
    -- If we found a member, assign them
    IF least_busy_member IS NOT NULL THEN
        UPDATE applications
        SET assigned_to = least_busy_member,
            assigned_at = NOW()
        WHERE id = app_id;
        
        -- Create assignment record
        INSERT INTO deal_assignments (
            tenant_id, 
            application_id, 
            assigned_to, 
            assigned_by,
            notes
        ) VALUES (
            tenant_id_val,
            app_id,
            least_busy_member,
            least_busy_member, -- Self-assigned via auto system
            'Auto-assigned based on workload distribution'
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- MSA DOCUMENT MANAGEMENT FUNCTIONS
-- ============================================================================

-- Check if all changes are resolved before approval
CREATE OR REPLACE FUNCTION can_approve_document(doc_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    pending_changes INTEGER;
BEGIN
    SELECT COUNT(*) INTO pending_changes
    FROM document_changes
    WHERE document_id = doc_id AND status = 'pending';
    
    RETURN pending_changes = 0;
END;
$$ LANGUAGE plpgsql;

-- Lock document for editing
CREATE OR REPLACE FUNCTION lock_document(doc_id UUID, user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE msa_documents
    SET is_locked = true,
        locked_by = user_id,
        locked_at = NOW()
    WHERE id = doc_id AND (is_locked = false OR locked_by = user_id);
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Unlock document
CREATE OR REPLACE FUNCTION unlock_document(doc_id UUID, user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    UPDATE msa_documents
    SET is_locked = false,
        locked_by = NULL,
        locked_at = NULL
    WHERE id = doc_id AND locked_by = user_id;
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql;

-- Create new document version when content changes
CREATE OR REPLACE FUNCTION create_document_version()
RETURNS TRIGGER AS $$
BEGIN
    -- Only create version if content actually changed
    IF OLD.content IS DISTINCT FROM NEW.content THEN
        -- Increment version number
        NEW.version = OLD.version + 1;
        
        -- Create version record
        INSERT INTO document_versions (
            document_id,
            version_number,
            title,
            content,
            change_summary,
            created_by
        ) VALUES (
            NEW.id,
            NEW.version,
            NEW.title,
            NEW.content,
            'Content updated',
            NEW.created_by
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- PLATFORM ANALYTICS FUNCTIONS
-- ============================================================================

-- Calculate tenant health score
CREATE OR REPLACE FUNCTION calculate_tenant_health_score(tenant_id_param UUID)
RETURNS INTEGER AS $$
DECLARE
    activity_score INTEGER;
    engagement_score INTEGER;
    billing_score INTEGER;
    support_score INTEGER;
    health_score INTEGER;
BEGIN
    -- Activity score based on recent usage
    SELECT 
        CASE 
            WHEN COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '7 days') > 5 THEN 100
            WHEN COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '30 days') > 5 THEN 75
            WHEN COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '90 days') > 0 THEN 50
            ELSE 25
        END INTO activity_score
    FROM applications
    WHERE tenant_id = tenant_id_param;
    
    -- Engagement score based on user activity
    SELECT 
        CASE 
            WHEN COUNT(DISTINCT user_id) > 5 THEN 100
            WHEN COUNT(DISTINCT user_id) > 2 THEN 75
            WHEN COUNT(DISTINCT user_id) > 0 THEN 50
            ELSE 25
        END INTO engagement_score
    FROM audit_logs
    WHERE tenant_id = tenant_id_param
    AND created_at > NOW() - INTERVAL '30 days';
    
    -- Billing score based on subscription status
    SELECT 
        CASE subscription_status
            WHEN 'active' THEN 100
            WHEN 'trial' THEN 75
            WHEN 'cancelled' THEN 25
            ELSE 0
        END INTO billing_score
    FROM tenants
    WHERE id = tenant_id_param;
    
    -- Support score (default to 100, can be adjusted based on support tickets)
    support_score := 100;
    
    -- Calculate overall health score
    health_score := (activity_score + engagement_score + billing_score + support_score) / 4;
    
    -- Insert the calculated scores
    INSERT INTO tenant_health_scores (
        tenant_id, 
        health_score, 
        activity_score, 
        engagement_score, 
        billing_score, 
        support_score
    ) VALUES (
        tenant_id_param,
        health_score,
        activity_score,
        engagement_score,
        billing_score,
        support_score
    );
    
    RETURN health_score;
END;
$$ LANGUAGE plpgsql;

-- Aggregate daily platform metrics
CREATE OR REPLACE FUNCTION aggregate_platform_metrics()
RETURNS VOID AS $$
BEGIN
    -- Insert or update daily metrics with proper null handling
    INSERT INTO platform_metrics (metric_type, metric_value, metric_date, time_period)
    VALUES 
        ('total_tenants', (SELECT COUNT(*) FROM tenants), CURRENT_DATE, 'daily'),
        ('active_tenants', (SELECT COUNT(*) FROM tenants WHERE subscription_status = 'active'), CURRENT_DATE, 'daily'),
        ('trial_tenants', (SELECT COUNT(*) FROM tenants WHERE subscription_status = 'trial'), CURRENT_DATE, 'daily'),
        ('total_users', (SELECT COUNT(*) FROM users), CURRENT_DATE, 'daily'),
        ('total_applications', (SELECT COUNT(*) FROM applications), CURRENT_DATE, 'daily'),
        ('completed_applications_today', (
            SELECT COUNT(*) FROM applications 
            WHERE completed_at::date = CURRENT_DATE
        ), CURRENT_DATE, 'daily'),
        ('new_tenants_today', (
            SELECT COUNT(*) FROM tenants 
            WHERE created_at::date = CURRENT_DATE
        ), CURRENT_DATE, 'daily'),
        ('mrr', (
            SELECT COALESCE(SUM(sp.price_monthly), 0) / 100.0
            FROM tenants t
            LEFT JOIN subscription_plans sp ON t.subscription_plan = sp.name
            WHERE t.subscription_status = 'active'
        ), CURRENT_DATE, 'daily')
    ON CONFLICT (metric_type, metric_date, time_period) 
    DO UPDATE SET 
        metric_value = EXCLUDED.metric_value,
        created_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- APPLY TRIGGERS
-- ============================================================================

-- Updated_at triggers for tables with updated_at columns
CREATE TRIGGER update_tenants_updated_at BEFORE UPDATE ON tenants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscription_plans_updated_at BEFORE UPDATE ON subscription_plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_team_invitations_updated_at BEFORE UPDATE ON team_invitations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_form_templates_updated_at BEFORE UPDATE ON form_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_applications_updated_at BEFORE UPDATE ON applications
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_form_submissions_updated_at BEFORE UPDATE ON form_submissions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_msa_documents_updated_at BEFORE UPDATE ON msa_documents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_document_changes_updated_at BEFORE UPDATE ON document_changes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_document_comments_updated_at BEFORE UPDATE ON document_comments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_email_templates_updated_at BEFORE UPDATE ON email_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Activity tracking triggers
CREATE TRIGGER update_applications_activity BEFORE UPDATE ON applications
    FOR EACH ROW EXECUTE FUNCTION update_application_activity();

-- Document versioning trigger
CREATE TRIGGER create_msa_document_version BEFORE UPDATE ON msa_documents
    FOR EACH ROW EXECUTE FUNCTION create_document_version();

-- Tenant constraint enforcement triggers
CREATE TRIGGER check_deal_assignment_tenant_trigger 
    BEFORE INSERT OR UPDATE ON deal_assignments
    FOR EACH ROW EXECUTE FUNCTION check_deal_assignment_tenant();

CREATE TRIGGER check_msa_document_tenant_trigger 
    BEFORE INSERT OR UPDATE ON msa_documents
    FOR EACH ROW EXECUTE FUNCTION check_msa_document_tenant();

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON FUNCTION update_updated_at_column() IS 'Automatically updates updated_at timestamp on row changes';
COMMENT ON FUNCTION update_application_activity() IS 'Updates last_activity_at when application is modified';
COMMENT ON FUNCTION check_deal_assignment_tenant() IS 'Ensures deal assignments belong to the same tenant as their application';
COMMENT ON FUNCTION check_msa_document_tenant() IS 'Ensures MSA documents belong to the same tenant as their application';
COMMENT ON FUNCTION get_user_tenant_id() IS 'Returns the tenant_id for the current authenticated user';
COMMENT ON FUNCTION is_platform_owner() IS 'Checks if current user has platform_owner role';
COMMENT ON FUNCTION is_organization_owner() IS 'Checks if current user is organization owner';
COMMENT ON FUNCTION is_organization_admin() IS 'Checks if current user is organization admin (owner or admin)';
COMMENT ON FUNCTION is_organization_member() IS 'Checks if current user is organization member';
COMMENT ON FUNCTION get_user_assigned_applications() IS 'Returns application IDs assigned to current user';
COMMENT ON FUNCTION auto_assign_application(UUID) IS 'Automatically assigns application to team member with least workload';
COMMENT ON FUNCTION can_approve_document(UUID) IS 'Checks if all redlines are resolved before document approval';
COMMENT ON FUNCTION lock_document(UUID, UUID) IS 'Locks document for exclusive editing by specified user';
COMMENT ON FUNCTION unlock_document(UUID, UUID) IS 'Unlocks document from editing lock';
COMMENT ON FUNCTION create_document_version() IS 'Creates new version record when document content changes';
COMMENT ON FUNCTION calculate_tenant_health_score(UUID) IS 'Calculates and stores health scores for a specific tenant';
COMMENT ON FUNCTION aggregate_platform_metrics() IS 'Aggregates daily platform metrics for analytics';