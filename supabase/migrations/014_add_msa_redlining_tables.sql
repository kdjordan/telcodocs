-- Add MSA redlining and document negotiation tables
-- Enables collaborative document editing and approval workflow

-- MSA documents table for rich text content and version control
CREATE TABLE msa_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL DEFAULT 'Master Service Agreement',
    content TEXT NOT NULL, -- Rich text content
    version INTEGER NOT NULL DEFAULT 1,
    is_template BOOLEAN DEFAULT false,
    is_locked BOOLEAN DEFAULT false, -- Prevents editing during review
    locked_by UUID REFERENCES users(id) ON DELETE SET NULL,
    locked_at TIMESTAMPTZ,
    status VARCHAR(50) NOT NULL DEFAULT 'draft' CHECK (
        status IN ('draft', 'under_review', 'pending_approval', 'approved', 'signed', 'archived')
    ),
    metadata JSONB DEFAULT '{}',
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Ensure document belongs to correct tenant
    CONSTRAINT msa_documents_same_tenant CHECK (
        (SELECT tenant_id FROM applications WHERE id = application_id) = tenant_id
    )
);

-- Document changes table for tracking redlines and edits
CREATE TABLE document_changes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID NOT NULL REFERENCES msa_documents(id) ON DELETE CASCADE,
    change_type VARCHAR(50) NOT NULL CHECK (
        change_type IN ('insert', 'delete', 'modify', 'comment', 'suggestion')
    ),
    position_start INTEGER NOT NULL,
    position_end INTEGER,
    original_text TEXT,
    new_text TEXT,
    reason TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (
        status IN ('pending', 'approved', 'rejected', 'resolved')
    ),
    created_by UUID NOT NULL REFERENCES users(id),
    reviewed_by UUID REFERENCES users(id) ON DELETE SET NULL,
    reviewed_at TIMESTAMPTZ,
    review_notes TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Document comments table for discussion and collaboration
CREATE TABLE document_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID NOT NULL REFERENCES msa_documents(id) ON DELETE CASCADE,
    change_id UUID REFERENCES document_changes(id) ON DELETE CASCADE,
    parent_comment_id UUID REFERENCES document_comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    position_start INTEGER,
    position_end INTEGER,
    is_resolved BOOLEAN DEFAULT false,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Document versions table for complete history
CREATE TABLE document_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID NOT NULL REFERENCES msa_documents(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    change_summary TEXT,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Ensure unique version numbers per document
    UNIQUE(document_id, version_number)
);

-- Create indexes for performance
CREATE INDEX idx_msa_documents_tenant_id ON msa_documents(tenant_id);
CREATE INDEX idx_msa_documents_application_id ON msa_documents(application_id);
CREATE INDEX idx_msa_documents_status ON msa_documents(status);
CREATE INDEX idx_msa_documents_is_template ON msa_documents(is_template);
CREATE INDEX idx_msa_documents_locked_by ON msa_documents(locked_by);

CREATE INDEX idx_document_changes_document_id ON document_changes(document_id);
CREATE INDEX idx_document_changes_status ON document_changes(status);
CREATE INDEX idx_document_changes_created_by ON document_changes(created_by);
CREATE INDEX idx_document_changes_reviewed_by ON document_changes(reviewed_by);

CREATE INDEX idx_document_comments_document_id ON document_comments(document_id);
CREATE INDEX idx_document_comments_change_id ON document_comments(change_id);
CREATE INDEX idx_document_comments_parent_id ON document_comments(parent_comment_id);
CREATE INDEX idx_document_comments_created_by ON document_comments(created_by);

CREATE INDEX idx_document_versions_document_id ON document_versions(document_id);
CREATE INDEX idx_document_versions_version_number ON document_versions(version_number);

-- Add updated_at triggers
CREATE TRIGGER update_msa_documents_updated_at BEFORE UPDATE ON msa_documents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_document_changes_updated_at BEFORE UPDATE ON document_changes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_document_comments_updated_at BEFORE UPDATE ON document_comments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to create new document version when content changes
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

-- Add trigger for automatic versioning
CREATE TRIGGER create_msa_document_version BEFORE UPDATE ON msa_documents
    FOR EACH ROW EXECUTE FUNCTION create_document_version();

-- Function to check if all changes are resolved before approval
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

-- Function to lock/unlock documents for editing
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

-- Enable RLS on new tables
ALTER TABLE msa_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_changes ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_versions ENABLE ROW LEVEL SECURITY;

-- Comments for documentation
COMMENT ON TABLE msa_documents IS 'Master Service Agreement documents with version control and collaborative editing';
COMMENT ON TABLE document_changes IS 'Track all redlines, edits, and changes to MSA documents';
COMMENT ON TABLE document_comments IS 'Comments and discussions on specific parts of documents';
COMMENT ON TABLE document_versions IS 'Complete version history of MSA documents';

COMMENT ON COLUMN msa_documents.is_locked IS 'Prevents editing when document is under review';
COMMENT ON COLUMN msa_documents.locked_by IS 'User who currently has editing lock';
COMMENT ON COLUMN document_changes.position_start IS 'Character position where change begins';
COMMENT ON COLUMN document_changes.status IS 'Approval status: pending, approved, rejected, resolved';
COMMENT ON FUNCTION can_approve_document(UUID) IS 'Checks if all redlines are resolved before document approval';
COMMENT ON FUNCTION lock_document(UUID, UUID) IS 'Locks document for exclusive editing by specified user';