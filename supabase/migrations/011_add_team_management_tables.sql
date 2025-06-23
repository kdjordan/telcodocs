-- Add team management tables for assignment and collaboration
-- Enables deal assignment, team invitations, and activity tracking

-- Team invitations table for managing user invitations
CREATE TABLE team_invitations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    organization_role organization_role NOT NULL,
    invited_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    invitation_token UUID NOT NULL DEFAULT uuid_generate_v4(),
    expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '7 days'),
    accepted_at TIMESTAMPTZ,
    accepted_by UUID REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'expired', 'cancelled')),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Deal assignments table for carrier-to-team-member assignments
CREATE TABLE deal_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    assigned_to UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assigned_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Ensure assignment is within same tenant
    CONSTRAINT deal_assignments_same_tenant CHECK (
        (SELECT tenant_id FROM applications WHERE id = application_id) = tenant_id
    ),
    
    -- Prevent duplicate active assignments
    UNIQUE(application_id, assigned_to)
);

-- Activity logs table for detailed team activity tracking
CREATE TABLE activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    application_id UUID REFERENCES applications(id) ON DELETE CASCADE,
    activity_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_team_invitations_tenant_id ON team_invitations(tenant_id);
CREATE INDEX idx_team_invitations_email ON team_invitations(email);
CREATE INDEX idx_team_invitations_token ON team_invitations(invitation_token);
CREATE INDEX idx_team_invitations_status ON team_invitations(status);
CREATE INDEX idx_team_invitations_expires_at ON team_invitations(expires_at);

CREATE INDEX idx_deal_assignments_tenant_id ON deal_assignments(tenant_id);
CREATE INDEX idx_deal_assignments_application_id ON deal_assignments(application_id);
CREATE INDEX idx_deal_assignments_assigned_to ON deal_assignments(assigned_to);
CREATE INDEX idx_deal_assignments_assigned_by ON deal_assignments(assigned_by);

CREATE INDEX idx_activity_logs_tenant_id ON activity_logs(tenant_id);
CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_application_id ON activity_logs(application_id);
CREATE INDEX idx_activity_logs_activity_type ON activity_logs(activity_type);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);

-- Add updated_at triggers
CREATE TRIGGER update_team_invitations_updated_at BEFORE UPDATE ON team_invitations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Helper function to get user's current assignments
CREATE OR REPLACE FUNCTION get_user_assigned_applications()
RETURNS TABLE(application_id UUID) AS $$
BEGIN
    RETURN QUERY
    SELECT da.application_id
    FROM deal_assignments da
    WHERE da.assigned_to = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Comments for documentation
COMMENT ON TABLE team_invitations IS 'Manages invitations for new team members to join organizations';
COMMENT ON TABLE deal_assignments IS 'Tracks which team members are assigned to which carrier applications';
COMMENT ON TABLE activity_logs IS 'Detailed activity tracking for team collaboration and audit purposes';

COMMENT ON COLUMN team_invitations.invitation_token IS 'Unique token for invitation links';
COMMENT ON COLUMN team_invitations.expires_at IS 'When the invitation expires (default 7 days)';
COMMENT ON COLUMN deal_assignments.assigned_to IS 'Team member responsible for this carrier application';
COMMENT ON COLUMN deal_assignments.assigned_by IS 'Who made this assignment (owner or admin)';