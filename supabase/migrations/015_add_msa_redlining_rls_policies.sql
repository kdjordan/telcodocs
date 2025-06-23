-- Row Level Security policies for MSA redlining and document collaboration
-- Implements proper access control for document editing and approval workflow

-- MSA Documents policies
CREATE POLICY "Organization admins can view all MSA documents in their tenant" ON msa_documents
    FOR SELECT USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Team members can view MSA documents for their assigned applications" ON msa_documents
    FOR SELECT USING (
        application_id IN (
            SELECT id FROM applications 
            WHERE tenant_id = get_user_tenant_id() AND assigned_to = auth.uid()
        ) AND is_organization_member()
    );

CREATE POLICY "Carriers can view MSA documents for their own applications" ON msa_documents
    FOR SELECT USING (
        application_id IN (
            SELECT id FROM applications WHERE user_id = auth.uid()
        )
    );

CREATE POLICY "Organization admins can create MSA documents" ON msa_documents
    FOR INSERT WITH CHECK (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Organization admins can update MSA documents in their tenant" ON msa_documents
    FOR UPDATE USING (tenant_id = get_user_tenant_id() AND is_organization_admin());

CREATE POLICY "Team members can update MSA documents for their assigned applications" ON msa_documents
    FOR UPDATE USING (
        application_id IN (
            SELECT id FROM applications 
            WHERE tenant_id = get_user_tenant_id() AND assigned_to = auth.uid()
        ) AND is_organization_member()
    );

-- Document Changes policies (redlines and edits)
CREATE POLICY "Organization admins can view all document changes in their tenant" ON document_changes
    FOR SELECT USING (
        document_id IN (
            SELECT id FROM msa_documents WHERE tenant_id = get_user_tenant_id()
        ) AND is_organization_admin()
    );

CREATE POLICY "Team members can view changes for their assigned applications" ON document_changes
    FOR SELECT USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE a.tenant_id = get_user_tenant_id() AND a.assigned_to = auth.uid()
        ) AND is_organization_member()
    );

CREATE POLICY "Carriers can view changes for their own applications" ON document_changes
    FOR SELECT USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE a.user_id = auth.uid()
        )
    );

CREATE POLICY "Organization members can create document changes" ON document_changes
    FOR INSERT WITH CHECK (
        document_id IN (
            SELECT md.id FROM msa_documents md
            WHERE md.tenant_id = get_user_tenant_id()
        ) AND (is_organization_admin() OR is_organization_member())
    );

CREATE POLICY "Carriers can create changes for their own applications" ON document_changes
    FOR INSERT WITH CHECK (
        document_id IN (
            SELECT md.id FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE a.user_id = auth.uid()
        )
    );

CREATE POLICY "Organization admins can approve/reject changes" ON document_changes
    FOR UPDATE USING (
        document_id IN (
            SELECT id FROM msa_documents WHERE tenant_id = get_user_tenant_id()
        ) AND is_organization_admin()
    );

CREATE POLICY "Users can update their own changes" ON document_changes
    FOR UPDATE USING (created_by = auth.uid());

-- Document Comments policies
CREATE POLICY "Organization admins can view all document comments in their tenant" ON document_comments
    FOR SELECT USING (
        document_id IN (
            SELECT id FROM msa_documents WHERE tenant_id = get_user_tenant_id()
        ) AND is_organization_admin()
    );

CREATE POLICY "Team members can view comments for their assigned applications" ON document_comments
    FOR SELECT USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE a.tenant_id = get_user_tenant_id() AND a.assigned_to = auth.uid()
        ) AND is_organization_member()
    );

CREATE POLICY "Carriers can view comments for their own applications" ON document_comments
    FOR SELECT USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE a.user_id = auth.uid()
        )
    );

CREATE POLICY "Organization members can create document comments" ON document_comments
    FOR INSERT WITH CHECK (
        document_id IN (
            SELECT md.id FROM msa_documents md
            WHERE md.tenant_id = get_user_tenant_id()
        ) AND (is_organization_admin() OR is_organization_member())
    );

CREATE POLICY "Carriers can create comments for their own applications" ON document_comments
    FOR INSERT WITH CHECK (
        document_id IN (
            SELECT md.id FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE a.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update their own comments" ON document_comments
    FOR UPDATE USING (created_by = auth.uid());

-- Document Versions policies
CREATE POLICY "Organization admins can view all document versions in their tenant" ON document_versions
    FOR SELECT USING (
        document_id IN (
            SELECT id FROM msa_documents WHERE tenant_id = get_user_tenant_id()
        ) AND is_organization_admin()
    );

CREATE POLICY "Team members can view versions for their assigned applications" ON document_versions
    FOR SELECT USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE a.tenant_id = get_user_tenant_id() AND a.assigned_to = auth.uid()
        ) AND is_organization_member()
    );

CREATE POLICY "Carriers can view versions for their own applications" ON document_versions
    FOR SELECT USING (
        document_id IN (
            SELECT md.id FROM msa_documents md
            JOIN applications a ON md.application_id = a.id
            WHERE a.user_id = auth.uid()
        )
    );

CREATE POLICY "System can create document versions" ON document_versions
    FOR INSERT WITH CHECK (true);

-- Helper functions for document permissions
CREATE OR REPLACE FUNCTION can_edit_document(doc_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    doc_locked BOOLEAN;
    locked_by_user UUID;
BEGIN
    SELECT is_locked, locked_by INTO doc_locked, locked_by_user
    FROM msa_documents
    WHERE id = doc_id;
    
    -- Can edit if not locked, or if locked by current user
    RETURN NOT doc_locked OR locked_by_user = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION can_approve_changes(doc_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    -- Only organization admins can approve changes
    RETURN (
        SELECT md.tenant_id = get_user_tenant_id() AND is_organization_admin()
        FROM msa_documents md
        WHERE md.id = doc_id
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Comments for documentation
COMMENT ON POLICY "Organization admins can view all MSA documents in their tenant" ON msa_documents IS 'Owners and admins can access all MSA documents in their organization';
COMMENT ON POLICY "Team members can view MSA documents for their assigned applications" ON msa_documents IS 'Team members can only access MSA documents for carriers assigned to them';
COMMENT ON POLICY "Carriers can view MSA documents for their own applications" ON msa_documents IS 'External carriers can only see their own MSA documents';
COMMENT ON POLICY "Organization admins can approve/reject changes" ON document_changes IS 'Only owners and admins can approve or reject redlines and changes';
COMMENT ON FUNCTION can_edit_document(UUID) IS 'Checks if current user can edit the specified document (considers locking)';
COMMENT ON FUNCTION can_approve_changes(UUID) IS 'Checks if current user has permission to approve document changes';