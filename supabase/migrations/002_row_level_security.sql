-- Enable RLS on all tables
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE signatures ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_templates ENABLE ROW LEVEL SECURITY;

-- Helper function to get current user's tenant_id
CREATE OR REPLACE FUNCTION auth.tenant_id() 
RETURNS UUID AS $$
BEGIN
    RETURN (
        SELECT tenant_id 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Helper function to check if user is super admin
CREATE OR REPLACE FUNCTION auth.is_super_admin() 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT role = 'super_admin' 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Helper function to check if user is tenant owner
CREATE OR REPLACE FUNCTION auth.is_tenant_owner() 
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT role = 'tenant_owner' 
        FROM users 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Tenants policies
CREATE POLICY "Super admins can view all tenants" ON tenants
    FOR SELECT USING (auth.is_super_admin());

CREATE POLICY "Users can view their own tenant" ON tenants
    FOR SELECT USING (id = auth.tenant_id());

CREATE POLICY "Super admins can create tenants" ON tenants
    FOR INSERT WITH CHECK (auth.is_super_admin());

CREATE POLICY "Super admins can update any tenant" ON tenants
    FOR UPDATE USING (auth.is_super_admin());

CREATE POLICY "Tenant owners can update their own tenant" ON tenants
    FOR UPDATE USING (id = auth.tenant_id() AND auth.is_tenant_owner());

-- Users policies
CREATE POLICY "Users can view themselves" ON users
    FOR SELECT USING (id = auth.uid());

CREATE POLICY "Tenant owners can view users in their tenant" ON users
    FOR SELECT USING (tenant_id = auth.tenant_id() AND auth.is_tenant_owner());

CREATE POLICY "Super admins can view all users" ON users
    FOR SELECT USING (auth.is_super_admin());

CREATE POLICY "Users can update their own profile" ON users
    FOR UPDATE USING (id = auth.uid());

CREATE POLICY "Tenant owners can manage users in their tenant" ON users
    FOR ALL USING (tenant_id = auth.tenant_id() AND auth.is_tenant_owner());

CREATE POLICY "Super admins can manage all users" ON users
    FOR ALL USING (auth.is_super_admin());

-- Form templates policies
CREATE POLICY "Users can view active form templates in their tenant" ON form_templates
    FOR SELECT USING (tenant_id = auth.tenant_id() AND is_active = true);

CREATE POLICY "Tenant owners can manage form templates" ON form_templates
    FOR ALL USING (tenant_id = auth.tenant_id() AND auth.is_tenant_owner());

CREATE POLICY "Super admins can view all form templates" ON form_templates
    FOR SELECT USING (auth.is_super_admin());

-- Applications policies
CREATE POLICY "Users can view their own applications" ON applications
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Tenant owners can view all applications in their tenant" ON applications
    FOR SELECT USING (tenant_id = auth.tenant_id() AND auth.is_tenant_owner());

CREATE POLICY "Users can create applications" ON applications
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update their own applications" ON applications
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Tenant owners can update applications in their tenant" ON applications
    FOR UPDATE USING (tenant_id = auth.tenant_id() AND auth.is_tenant_owner());

-- Form submissions policies
CREATE POLICY "Users can view their own submissions" ON form_submissions
    FOR SELECT USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Tenant owners can view all submissions in their tenant" ON form_submissions
    FOR SELECT USING (
        application_id IN (
            SELECT id FROM applications WHERE tenant_id = auth.tenant_id()
        ) AND auth.is_tenant_owner()
    );

CREATE POLICY "Users can create and update their own submissions" ON form_submissions
    FOR ALL USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

-- Signatures policies
CREATE POLICY "Users can view their own signatures" ON signatures
    FOR SELECT USING (
        submission_id IN (
            SELECT id FROM form_submissions WHERE application_id IN (
                SELECT id FROM applications WHERE user_id = auth.uid()
            )
        )
    );

CREATE POLICY "Tenant owners can view all signatures in their tenant" ON signatures
    FOR SELECT USING (
        submission_id IN (
            SELECT fs.id FROM form_submissions fs
            JOIN applications a ON fs.application_id = a.id
            WHERE a.tenant_id = auth.tenant_id()
        ) AND auth.is_tenant_owner()
    );

CREATE POLICY "Users can create signatures for their submissions" ON signatures
    FOR INSERT WITH CHECK (
        submission_id IN (
            SELECT id FROM form_submissions WHERE application_id IN (
                SELECT id FROM applications WHERE user_id = auth.uid()
            )
        )
    );

-- Documents policies
CREATE POLICY "Users can view their own documents" ON documents
    FOR SELECT USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Tenant owners can view all documents in their tenant" ON documents
    FOR SELECT USING (tenant_id = auth.tenant_id() AND auth.is_tenant_owner());

CREATE POLICY "System can create documents" ON documents
    FOR INSERT WITH CHECK (true);

-- Audit logs policies
CREATE POLICY "Tenant owners can view audit logs for their tenant" ON audit_logs
    FOR SELECT USING (tenant_id = auth.tenant_id() AND auth.is_tenant_owner());

CREATE POLICY "Super admins can view all audit logs" ON audit_logs
    FOR SELECT USING (auth.is_super_admin());

CREATE POLICY "System can create audit logs" ON audit_logs
    FOR INSERT WITH CHECK (true);

-- Email templates policies
CREATE POLICY "Tenant owners can manage email templates" ON email_templates
    FOR ALL USING (tenant_id = auth.tenant_id() AND auth.is_tenant_owner());

CREATE POLICY "Users can view active email templates in their tenant" ON email_templates
    FOR SELECT USING (tenant_id = auth.tenant_id() AND is_active = true);