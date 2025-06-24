-- TELODOX Production Migration 004: Row Level Security (Fixed)
-- Creates consolidated RLS policies for multi-tenant data isolation and role-based access

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
-- CONSOLIDATED TENANT-LEVEL POLICIES (ONE POLICY PER TABLE/ACTION)
-- ============================================================================

-- Tenants: Users can see their own tenant or if they're platform owners
CREATE POLICY "tenants_access_policy" ON tenants
    FOR ALL 
    USING (
        id = get_user_tenant_id() OR 
        is_platform_owner() OR 
        is_super_admin()
    );

-- Users: Complete access policy combining all user access rules
CREATE POLICY "users_access_policy" ON users
    FOR ALL 
    USING (
        tenant_id = get_user_tenant_id() OR 
        is_platform_owner() OR 
        is_super_admin() OR
        id = auth.uid()  -- Users can always see themselves
    );

-- Subscription plans: Read access for all, modify access for platform owners only
CREATE POLICY "subscription_plans_select_policy" ON subscription_plans
    FOR SELECT 
    USING (true);

CREATE POLICY "subscription_plans_modify_policy" ON subscription_plans
    FOR INSERT 
    WITH CHECK (is_platform_owner() OR is_super_admin());

CREATE POLICY "subscription_plans_update_policy" ON subscription_plans
    FOR UPDATE 
    USING (is_platform_owner() OR is_super_admin());

CREATE POLICY "subscription_plans_delete_policy" ON subscription_plans
    FOR DELETE 
    USING (is_platform_owner() OR is_super_admin());

-- ============================================================================
-- TEAM MANAGEMENT POLICIES
-- ============================================================================

-- Team invitations: Tenant isolation + admin management
CREATE POLICY "team_invitations_access_policy" ON team_invitations
    FOR SELECT
    USING (tenant_id = get_user_tenant_id());

CREATE POLICY "team_invitations_manage_policy" ON team_invitations
    FOR INSERT 
    WITH CHECK (
        tenant_id = get_user_tenant_id() AND 
        is_organization_admin()
    );

CREATE POLICY "team_invitations_update_policy" ON team_invitations
    FOR UPDATE 
    USING (
        tenant_id = get_user_tenant_id() AND 
        is_organization_admin()
    );

-- Deal assignments: Tenant isolation + admin management
CREATE POLICY "deal_assignments_access_policy" ON deal_assignments
    FOR SELECT
    USING (tenant_id = get_user_tenant_id());

CREATE POLICY "deal_assignments_manage_policy" ON deal_assignments
    FOR INSERT 
    WITH CHECK (
        tenant_id = get_user_tenant_id() AND 
        is_organization_admin()
    );

CREATE POLICY "deal_assignments_update_policy" ON deal_assignments
    FOR UPDATE 
    USING (
        tenant_id = get_user_tenant_id() AND 
        is_organization_admin()
    );

-- Activity logs: Tenant isolation + platform owner access
CREATE POLICY "activity_logs_access_policy" ON activity_logs
    FOR ALL 
    USING (
        tenant_id = get_user_tenant_id() OR 
        is_platform_owner() OR 
        is_super_admin()
    );

-- ============================================================================
-- FORM MANAGEMENT POLICIES
-- ============================================================================

-- Form templates: Tenant isolation + owner management
CREATE POLICY "form_templates_access_policy" ON form_templates
    FOR SELECT
    USING (tenant_id = get_user_tenant_id());

CREATE POLICY "form_templates_manage_policy" ON form_templates
    FOR INSERT 
    WITH CHECK (
        tenant_id = get_user_tenant_id() AND 
        (is_tenant_owner() OR is_organization_owner())
    );

CREATE POLICY "form_templates_update_policy" ON form_templates
    FOR UPDATE 
    USING (
        tenant_id = get_user_tenant_id() AND 
        (is_tenant_owner() OR is_organization_owner())
    );

CREATE POLICY "form_templates_delete_policy" ON form_templates
    FOR DELETE 
    USING (
        tenant_id = get_user_tenant_id() AND 
        (is_tenant_owner() OR is_organization_owner())
    );

-- ============================================================================
-- APPLICATION ACCESS POLICIES (ROLE-BASED ACCESS)
-- ============================================================================

-- Applications: Comprehensive access policy combining tenant isolation + role-based access
CREATE POLICY "applications_access_policy" ON applications
    FOR SELECT 
    USING (
        tenant_id = get_user_tenant_id() AND (
            -- Admins and owners see all applications in their tenant
            is_organization_admin() OR 
            -- Team members see only assigned applications
            (is_organization_member() AND assigned_to = auth.uid()) OR
            -- Carriers see their own applications
            (role = 'end_user' AND user_id = auth.uid())
        )
    );

-- Applications: Insert policy (admins can create applications)
CREATE POLICY "applications_insert_policy" ON applications
    FOR INSERT 
    WITH CHECK (
        tenant_id = get_user_tenant_id() AND 
        is_organization_admin()
    );

-- Applications: Update policy (admins + assigned team members)
CREATE POLICY "applications_update_policy" ON applications
    FOR UPDATE 
    USING (
        tenant_id = get_user_tenant_id() AND (
            is_organization_admin() OR 
            (is_organization_member() AND assigned_to = auth.uid())
        )
    );

-- Form submissions: Follow application access rules
CREATE POLICY "form_submissions_access_policy" ON form_submissions
    FOR ALL 
    USING (
        application_id IN (
            SELECT id FROM applications 
            WHERE tenant_id = get_user_tenant_id() AND (
                is_organization_admin() OR 
                (is_organization_member() AND assigned_to = auth.uid()) OR
                (role = 'end_user' AND user_id = auth.uid())
            )
        )
    );

-- Signatures: Follow form submission access rules
CREATE POLICY "signatures_access_policy" ON signatures
    FOR ALL 
    USING (
        submission_id IN (
            SELECT fs.id FROM form_submissions fs
            JOIN applications a ON fs.application_id = a.id
            WHERE a.tenant_id = get_user_tenant_id() AND (
                is_organization_admin() OR 
                (is_organization_member() AND a.assigned_to = auth.uid()) OR
                (role = 'end_user' AND a.user_id = auth.uid())
            )
        )
    );

-- Documents: Tenant isolation
CREATE POLICY "documents_access_policy" ON documents
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- ============================================================================
-- MSA REDLINING ACCESS POLICIES
-- ============================================================================

-- MSA documents: Application-based access
CREATE POLICY "msa_documents_access_policy" ON msa_documents
    FOR SELECT 
    USING (
        tenant_id = get_user_tenant_id() AND
        application_id IN (
            SELECT id FROM applications 
            WHERE tenant_id = get_user_tenant_id() AND (
                is_organization_admin() OR 
                (is_organization_member() AND assigned_to = auth.uid()) OR
                (role = 'end_user' AND user_id = auth.uid())
            )
        )
    );

-- MSA documents: Create/modify by admins and assigned team members
CREATE POLICY "msa_documents_modify_policy" ON msa_documents
    FOR INSERT 
    WITH CHECK (
        tenant_id = get_user_tenant_id() AND (
            is_organization_admin() OR 
            (is_organization_member() AND application_id IN (
                SELECT id FROM applications WHERE assigned_to = auth.uid()
            ))
        )
    );

CREATE POLICY "msa_documents_update_policy" ON msa_documents
    FOR UPDATE 
    USING (
        tenant_id = get_user_tenant_id() AND (
            is_organization_admin() OR 
            (is_organization_member() AND application_id IN (
                SELECT id FROM applications WHERE assigned_to = auth.uid()
            ))
        )
    );

-- Document changes: Comprehensive access policy
CREATE POLICY "document_changes_access_policy" ON document_changes
    FOR SELECT 
    USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            WHERE md.tenant_id = get_user_tenant_id() AND
            md.application_id IN (
                SELECT id FROM applications 
                WHERE tenant_id = get_user_tenant_id() AND (
                    is_organization_admin() OR 
                    (is_organization_member() AND assigned_to = auth.uid()) OR
                    (role = 'end_user' AND user_id = auth.uid())
                )
            )
        )
    );

CREATE POLICY "document_changes_create_policy" ON document_changes
    FOR INSERT 
    WITH CHECK (
        document_id IN (
            SELECT md.id FROM msa_documents md
            WHERE md.tenant_id = get_user_tenant_id() AND
            md.application_id IN (
                SELECT id FROM applications 
                WHERE tenant_id = get_user_tenant_id() AND (
                    is_organization_admin() OR 
                    (is_organization_member() AND assigned_to = auth.uid()) OR
                    (role = 'end_user' AND user_id = auth.uid())
                )
            )
        )
    );

CREATE POLICY "document_changes_update_policy" ON document_changes
    FOR UPDATE 
    USING (
        created_by = auth.uid() OR 
        is_organization_admin()
    );

-- Document comments: Same access as document changes
CREATE POLICY "document_comments_access_policy" ON document_comments
    FOR ALL 
    USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            WHERE md.tenant_id = get_user_tenant_id() AND
            md.application_id IN (
                SELECT id FROM applications 
                WHERE tenant_id = get_user_tenant_id() AND (
                    is_organization_admin() OR 
                    (is_organization_member() AND assigned_to = auth.uid()) OR
                    (role = 'end_user' AND user_id = auth.uid())
                )
            )
        )
    );

-- Document versions: Same access as documents
CREATE POLICY "document_versions_access_policy" ON document_versions
    FOR SELECT 
    USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            WHERE md.tenant_id = get_user_tenant_id() AND
            md.application_id IN (
                SELECT id FROM applications 
                WHERE tenant_id = get_user_tenant_id() AND (
                    is_organization_admin() OR 
                    (is_organization_member() AND assigned_to = auth.uid()) OR
                    (role = 'end_user' AND user_id = auth.uid())
                )
            )
        )
    );

-- ============================================================================
-- PLATFORM ANALYTICS ACCESS (PLATFORM OWNERS ONLY)
-- ============================================================================

-- Platform metrics: Only platform owners can access
CREATE POLICY "platform_metrics_access_policy" ON platform_metrics
    FOR ALL 
    USING (is_platform_owner() OR is_super_admin());

-- Tenant health scores: Only platform owners can access
CREATE POLICY "tenant_health_scores_access_policy" ON tenant_health_scores
    FOR ALL 
    USING (is_platform_owner() OR is_super_admin());

-- Platform events: Only platform owners can access
CREATE POLICY "platform_events_access_policy" ON platform_events
    FOR ALL 
    USING (is_platform_owner() OR is_super_admin());

-- System health metrics: Only platform owners can access
CREATE POLICY "system_health_metrics_access_policy" ON system_health_metrics
    FOR ALL 
    USING (is_platform_owner() OR is_super_admin());

-- ============================================================================
-- EMAIL TEMPLATES
-- ============================================================================

-- Email templates: Tenant isolation
CREATE POLICY "email_templates_access_policy" ON email_templates
    FOR ALL 
    USING (tenant_id = get_user_tenant_id());

-- ============================================================================
-- AUDIT LOGS
-- ============================================================================

-- Audit logs: Tenant isolation + platform owner access
CREATE POLICY "audit_logs_access_policy" ON audit_logs
    FOR ALL 
    USING (
        tenant_id = get_user_tenant_id() OR 
        is_platform_owner() OR 
        is_super_admin()
    );

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON POLICY "tenants_access_policy" ON tenants IS 'Multi-tenant isolation - users see only their tenant data, platform owners see all';
COMMENT ON POLICY "users_access_policy" ON users IS 'Users can see other users in their tenant only, plus themselves';
COMMENT ON POLICY "applications_access_policy" ON applications IS 'Role-based access: admins see all, members see assigned, carriers see own';
COMMENT ON POLICY "msa_documents_access_policy" ON msa_documents IS 'MSA document access follows application assignment rules';
COMMENT ON POLICY "platform_metrics_access_policy" ON platform_metrics IS 'Platform analytics restricted to platform owners only';
COMMENT ON POLICY "document_changes_access_policy" ON document_changes IS 'Document change access follows MSA document access rules';