-- Update Row Level Security policies for new organization role system
-- Implements proper access control for Owner/Admin/Member hierarchy

-- Drop old policies that don't account for organization roles
DROP POLICY IF EXISTS "Tenant owners can view users in their tenant" ON users;
DROP POLICY IF EXISTS "Tenant owners can manage users in their tenant" ON users;
DROP POLICY IF EXISTS "Tenant owners can update their own tenant" ON tenants;
DROP POLICY IF EXISTS "Tenant owners can manage form templates" ON form_templates;
DROP POLICY IF EXISTS "Tenant owners can view all applications in their tenant" ON applications;
DROP POLICY IF EXISTS "Tenant owners can update applications in their tenant" ON applications;
DROP POLICY IF EXISTS "Tenant owners can view all submissions in their tenant" ON form_submissions;
DROP POLICY IF EXISTS "Tenant owners can view all signatures in their tenant" ON signatures;
DROP POLICY IF EXISTS "Tenant owners can view all documents in their tenant" ON documents;
DROP POLICY IF EXISTS "Tenant owners can view audit logs for their tenant" ON audit_logs;
DROP POLICY IF EXISTS "Tenant owners can manage email templates" ON email_templates;

-- Update tenant policies for organization roles
CREATE POLICY "Organization owners can update their tenant" ON tenants
    FOR UPDATE USING (id = get_user_tenant_id() AND is_organization_owner());

-- Enhanced user policies for team management
CREATE POLICY "Organization admins can view users in their tenant" ON users
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Organization owners can manage all users in their tenant" ON users
    FOR ALL USING (tenant_id = get_user_tenant_id() AND is_organization_owner());

CREATE POLICY "Organization admins can manage team members in their tenant" ON users
    FOR UPDATE USING (
        tenant_id = get_user_tenant_id() 
        AND is_organization_admin() 
        AND organization_role IN ('member', 'admin')
    );

CREATE POLICY "Organization admins can add team members" ON users
    FOR INSERT WITH CHECK (
        tenant_id = get_user_tenant_id() 
        AND is_organization_admin()
        AND organization_role = 'member'
    );

-- Form template policies for organization roles
CREATE POLICY "Organization owners can manage form templates" ON form_templates
    FOR ALL USING (tenant_id = get_user_tenant_id() AND is_organization_owner());

CREATE POLICY "Organization admins can view form templates" ON form_templates
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

-- Enhanced application policies for team assignment system
CREATE POLICY "Organization admins can view all applications in their tenant" ON applications
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Team members can view their assigned applications" ON applications
    FOR SELECT USING (
        tenant_id = get_user_tenant_id() 
        AND is_organization_member() 
        AND assigned_to = auth.uid()
    );

CREATE POLICY "Organization admins can update applications in their tenant" ON applications
    FOR UPDATE USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Team members can update their assigned applications" ON applications
    FOR UPDATE USING (
        tenant_id = get_user_tenant_id() 
        AND is_organization_member() 
        AND assigned_to = auth.uid()
    );

-- Form submission policies for team members
CREATE POLICY "Organization admins can view all submissions in their tenant" ON form_submissions
    FOR SELECT USING (
        application_id IN (
            SELECT id FROM applications WHERE tenant_id = get_user_tenant_id()
        ) AND is_organization_admin()
    );

CREATE POLICY "Team members can view submissions for their assigned applications" ON form_submissions
    FOR SELECT USING (
        application_id IN (
            SELECT id FROM applications 
            WHERE tenant_id = get_user_tenant_id() AND assigned_to = auth.uid()
        ) AND is_organization_member()
    );

-- Signature policies for team access
CREATE POLICY "Organization admins can view all signatures in their tenant" ON signatures
    FOR SELECT USING (
        submission_id IN (
            SELECT fs.id FROM form_submissions fs
            JOIN applications a ON fs.application_id = a.id
            WHERE a.tenant_id = get_user_tenant_id()
        ) AND is_organization_admin()
    );

CREATE POLICY "Team members can view signatures for their assigned applications" ON signatures
    FOR SELECT USING (
        submission_id IN (
            SELECT fs.id FROM form_submissions fs
            JOIN applications a ON fs.application_id = a.id
            WHERE a.tenant_id = get_user_tenant_id() AND a.assigned_to = auth.uid()
        ) AND is_organization_member()
    );

-- Document policies for team access
CREATE POLICY "Organization admins can view all documents in their tenant" ON documents
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Team members can view documents for their assigned applications" ON documents
    FOR SELECT USING (
        application_id IN (
            SELECT id FROM applications 
            WHERE tenant_id = get_user_tenant_id() AND assigned_to = auth.uid()
        ) AND is_organization_member()
    );

-- Audit log policies
CREATE POLICY "Organization admins can view audit logs for their tenant" ON audit_logs
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

-- Email template policies
CREATE POLICY "Organization owners can manage email templates" ON email_templates
    FOR ALL USING (tenant_id = get_user_tenant_id() AND is_organization_owner());

CREATE POLICY "Organization admins can view email templates in their tenant" ON email_templates
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

-- Policies for new team management tables

-- Team invitations policies
ALTER TABLE team_invitations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Organization admins can manage team invitations" ON team_invitations
    FOR ALL USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

-- Deal assignments policies  
ALTER TABLE deal_assignments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Organization admins can view all deal assignments" ON deal_assignments
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Team members can view their own assignments" ON deal_assignments
    FOR SELECT USING (
        tenant_id = get_user_tenant_id() 
        AND assigned_to = auth.uid()
    );

CREATE POLICY "Organization admins can manage deal assignments" ON deal_assignments
    FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND is_organization_admin());

-- Activity logs policies
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Organization admins can view all activity logs" ON activity_logs
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Team members can view activity for their applications" ON activity_logs
    FOR SELECT USING (
        tenant_id = get_user_tenant_id() 
        AND (
            user_id = auth.uid() OR
            application_id IN (
                SELECT id FROM applications 
                WHERE assigned_to = auth.uid()
            )
        )
    );

CREATE POLICY "All organization members can create activity logs" ON activity_logs
    FOR INSERT WITH CHECK (
        tenant_id = get_user_tenant_id() 
        AND (is_organization_admin() OR is_organization_member())
    );

-- Comments for documentation
COMMENT ON POLICY "Organization admins can view all applications in their tenant" ON applications IS 'Owners and admins can see all carrier applications in their tenant';
COMMENT ON POLICY "Team members can view their assigned applications" ON applications IS 'Team members can only see carriers assigned to them';
COMMENT ON POLICY "Organization admins can manage deal assignments" ON deal_assignments IS 'Only owners and admins can assign carriers to team members';