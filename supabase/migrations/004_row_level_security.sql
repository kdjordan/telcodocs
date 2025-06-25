-- TELODOX Production Migration 004: Row Level Security
-- Creates all RLS policies for multi-tenant data isolation and role-based access

-- ============================================================================
-- ENABLE RLS ON ALL TABLES
-- ============================================================================

ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE deal_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE signatures ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE msa_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_changes ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE platform_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_health_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE platform_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_health_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_templates ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- TENANT-LEVEL POLICIES (MULTI-TENANT ISOLATION)
-- ============================================================================

-- Tenants: Users can only see their own tenant or if they're platform owners
CREATE POLICY "tenants_isolation" ON tenants
    FOR ALL 
    USING (
        id = get_user_tenant_id() OR 
        is_platform_owner()
    );

-- Users: Users can see users in their tenant + platform owners see all
CREATE POLICY "users_tenant_isolation" ON users
    FOR ALL 
    USING (
        tenant_id = get_user_tenant_id() OR 
        is_platform_owner() OR
        id = auth.uid()  -- Users can always see themselves
    );

-- Team invitations: Only within same tenant
CREATE POLICY "team_invitations_tenant_isolation" ON team_invitations
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- Deal assignments: Only within same tenant
CREATE POLICY "deal_assignments_tenant_isolation" ON deal_assignments
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- Activity logs: Only within same tenant
CREATE POLICY "activity_logs_tenant_isolation" ON activity_logs
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- Form templates: Only within same tenant
CREATE POLICY "form_templates_tenant_isolation" ON form_templates
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- Applications: Policies are now broken down by action (SELECT, INSERT, UPDATE) for clarity and security.
CREATE POLICY "applications_select_policy" ON applications
    FOR SELECT
    USING (
        tenant_id = get_user_tenant_id() AND (
            is_organization_admin() OR
            (is_organization_member() AND assigned_to = auth.uid()) OR
            (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = applications.user_id))
        )
    );

CREATE POLICY "applications_insert_policy" ON applications
    FOR INSERT
    WITH CHECK (
        tenant_id = get_user_tenant_id()
    );

CREATE POLICY "applications_update_policy" ON applications
    FOR UPDATE
    USING (
        tenant_id = get_user_tenant_id() AND (
            is_organization_admin() OR
            (is_organization_member() AND assigned_to = auth.uid()) OR
            (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = applications.user_id))
        )
    );

-- Documents: Only within same tenant
CREATE POLICY "documents_tenant_isolation" ON documents
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- MSA documents: Only within same tenant
CREATE POLICY "msa_documents_tenant_isolation" ON msa_documents
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- Audit logs: Only within same tenant (except platform owners)
CREATE POLICY "audit_logs_tenant_isolation" ON audit_logs
    FOR ALL 
    USING (
        tenant_id = get_user_tenant_id() OR 
        is_platform_owner() OR 
        false  -- No super admin role anymore
    );

-- Email templates: Only within same tenant
CREATE POLICY "email_templates_tenant_isolation" ON email_templates
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- ============================================================================
-- ROLE-BASED ACCESS POLICIES
-- ============================================================================

-- Subscription plans: Everyone can read, only platform owners can modify
CREATE POLICY "subscription_plans_read_all" ON subscription_plans
    FOR SELECT 
    USING (true);

CREATE POLICY "subscription_plans_modify_platform_only" ON subscription_plans
    FOR INSERT 
    WITH CHECK (is_platform_owner());

CREATE POLICY "subscription_plans_update_platform_only" ON subscription_plans
    FOR UPDATE 
    USING (is_platform_owner());

CREATE POLICY "subscription_plans_delete_platform_only" ON subscription_plans
    FOR DELETE 
    USING (is_platform_owner());

-- ============================================================================
-- TEAM MEMBER ACCESS RESTRICTIONS
-- ============================================================================

-- Form submissions follow application access rules
CREATE POLICY "form_submissions_access" ON form_submissions
    FOR ALL 
    USING (
        EXISTS (
            SELECT 1 FROM applications a
            WHERE form_submissions.application_id = a.id AND (
                is_organization_admin() OR 
                (is_organization_member() AND a.assigned_to = auth.uid()) OR
                (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = a.user_id))
            )
        )
    );

-- Signatures follow form submission access rules
CREATE POLICY "signatures_access" ON signatures
    FOR ALL 
    USING (
        EXISTS (
            SELECT 1 FROM form_submissions fs
            JOIN applications a ON fs.application_id = a.id
            WHERE signatures.submission_id = fs.id AND (
                is_organization_admin() OR 
                (is_organization_member() AND a.assigned_to = auth.uid()) OR
                (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = a.user_id))
            )
        )
    );

-- ============================================================================
-- MSA REDLINING ACCESS POLICIES
-- ============================================================================

-- MSA documents: Admins + assigned team members + related carriers
CREATE POLICY "msa_documents_access" ON msa_documents
    FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM applications a
            WHERE msa_documents.application_id = a.id AND (
                is_organization_admin() OR 
                (is_organization_member() AND a.assigned_to = auth.uid()) OR
                (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = a.user_id))
            )
        )
    );

-- MSA document modifications: Only admins and assigned team members
CREATE POLICY "msa_documents_modify" ON msa_documents
    FOR INSERT 
    WITH CHECK (
        is_organization_admin() OR 
        (is_organization_member() AND application_id IN (
            SELECT id FROM applications WHERE assigned_to = auth.uid()
        ))
    );

CREATE POLICY "msa_documents_update" ON msa_documents
    FOR UPDATE 
    USING (
        is_organization_admin() OR 
        (is_organization_member() AND application_id IN (
            SELECT id FROM applications WHERE assigned_to = auth.uid()
        ))
    );

-- Document changes: Can view changes on accessible documents
CREATE POLICY "document_changes_access" ON document_changes
    FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE document_changes.document_id = md.id AND (
                is_organization_admin() OR 
                (is_organization_member() AND a.assigned_to = auth.uid()) OR
                (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = a.user_id))
            )
        )
    );

-- Document changes: Can create changes on accessible documents
CREATE POLICY "document_changes_create" ON document_changes
    FOR INSERT 
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE document_changes.document_id = md.id AND (
                is_organization_admin() OR 
                (is_organization_member() AND a.assigned_to = auth.uid()) OR
                (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = a.user_id))
            )
        )
    );

-- Document changes: Can update own changes or if admin
CREATE POLICY "document_changes_update" ON document_changes
    FOR UPDATE 
    USING (
        created_by = auth.uid() OR 
        is_organization_admin()
    );

-- Document comments: Same access as document changes
CREATE POLICY "document_comments_access" ON document_comments
    FOR ALL 
    USING (
        EXISTS (
            SELECT 1 FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE document_comments.document_id = md.id AND (
                is_organization_admin() OR 
                (is_organization_member() AND a.assigned_to = auth.uid()) OR
                (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = a.user_id))
            )
        )
    );

-- Document versions: Same access as documents
CREATE POLICY "document_versions_access" ON document_versions
    FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE document_versions.document_id = md.id AND (
                is_organization_admin() OR 
                (is_organization_member() AND a.assigned_to = auth.uid()) OR
                (EXISTS (SELECT 1 FROM users u WHERE u.id = auth.uid() AND u.role = 'carrier' AND u.id = a.user_id))
            )
        )
    );

-- ============================================================================
-- PLATFORM ANALYTICS ACCESS (PLATFORM OWNERS ONLY)
-- ============================================================================

-- Platform metrics: Only platform owners can access
CREATE POLICY "platform_metrics_platform_only" ON platform_metrics
    FOR ALL 
    USING (is_platform_owner());

-- Tenant health scores: Only platform owners can access
CREATE POLICY "tenant_health_scores_platform_only" ON tenant_health_scores
    FOR ALL 
    USING (is_platform_owner());

-- Platform events: Only platform owners can access
CREATE POLICY "platform_events_platform_only" ON platform_events
    FOR ALL 
    USING (is_platform_owner());

-- System health metrics: Only platform owners can access
CREATE POLICY "system_health_metrics_platform_only" ON system_health_metrics
    FOR ALL 
    USING (is_platform_owner());

-- ============================================================================
-- ADMIN MANAGEMENT POLICIES
-- ============================================================================

-- Team invitations: Only admins can create/manage
CREATE POLICY "team_invitations_admin_manage" ON team_invitations
    FOR INSERT 
    WITH CHECK (is_organization_admin());

CREATE POLICY "team_invitations_admin_update" ON team_invitations
    FOR UPDATE 
    USING (is_organization_admin());

-- Deal assignments: Only admins can create/modify
CREATE POLICY "deal_assignments_admin_manage" ON deal_assignments
    FOR INSERT 
    WITH CHECK (is_organization_admin());

CREATE POLICY "deal_assignments_admin_update" ON deal_assignments
    FOR UPDATE 
    USING (is_organization_admin());

-- Form templates: Only tenant owners can create/modify
CREATE POLICY "form_templates_owner_manage" ON form_templates
    FOR INSERT 
    WITH CHECK (is_organization_owner());

CREATE POLICY "form_templates_owner_update" ON form_templates
    FOR UPDATE 
    USING (is_organization_owner());

CREATE POLICY "form_templates_owner_delete" ON form_templates
    FOR DELETE 
    USING (is_organization_owner());

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON POLICY "tenants_isolation" ON tenants IS 'Multi-tenant isolation - users see only their tenant data';
COMMENT ON POLICY "users_tenant_isolation" ON users IS 'Users can see other users in their tenant only';
COMMENT ON POLICY "applications_select_policy" ON applications IS 'Defines who can view applications based on role and assignment';
COMMENT ON POLICY "msa_documents_access" ON msa_documents IS 'MSA document access follows application assignment rules';
COMMENT ON POLICY "platform_metrics_platform_only" ON platform_metrics IS 'Platform analytics restricted to platform owners';