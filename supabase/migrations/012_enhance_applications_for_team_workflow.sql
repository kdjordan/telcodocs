-- Enhance applications table for team-based workflow and assignment
-- Adds fields needed for team collaboration and carrier management

-- Add new fields to applications table
ALTER TABLE applications 
ADD COLUMN carrier_company_name VARCHAR(255),
ADD COLUMN assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
ADD COLUMN assigned_at TIMESTAMPTZ,
ADD COLUMN assigned_by UUID REFERENCES users(id) ON DELETE SET NULL,
ADD COLUMN last_activity_at TIMESTAMPTZ DEFAULT NOW(),
ADD COLUMN approval_notes TEXT,
ADD COLUMN priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
ADD COLUMN tags JSONB DEFAULT '[]';

-- Update existing applications to have company name same as carrier name
UPDATE applications 
SET carrier_company_name = carrier_name 
WHERE carrier_company_name IS NULL;

-- Make carrier_company_name required going forward
ALTER TABLE applications 
ALTER COLUMN carrier_company_name SET NOT NULL;

-- Add indexes for new fields
CREATE INDEX idx_applications_assigned_to ON applications(assigned_to);
CREATE INDEX idx_applications_assigned_at ON applications(assigned_at);
CREATE INDEX idx_applications_last_activity_at ON applications(last_activity_at);
CREATE INDEX idx_applications_priority ON applications(priority);

-- Add composite index for team member dashboard queries
CREATE INDEX idx_applications_tenant_assigned ON applications(tenant_id, assigned_to, status);

-- Create function to automatically update last_activity_at
CREATE OR REPLACE FUNCTION update_application_activity()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_activity_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add trigger to update last_activity_at on any application change
CREATE TRIGGER update_applications_activity BEFORE UPDATE ON applications
    FOR EACH ROW EXECUTE FUNCTION update_application_activity();

-- Create function to auto-assign applications based on round-robin or workload
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

-- Add enhanced status enum values for better workflow tracking
-- Note: PostgreSQL doesn't allow easy enum modification, so we'll comment for now
-- Future migration could recreate enum with additional statuses like:
-- 'waiting_for_carrier', 'under_review', 'requires_revision', 'overdue'

-- Comments for documentation
COMMENT ON COLUMN applications.carrier_company_name IS 'Official company name of the carrier (may differ from carrier_name)';
COMMENT ON COLUMN applications.assigned_to IS 'Team member currently responsible for this application';
COMMENT ON COLUMN applications.assigned_at IS 'When this application was assigned to current team member';
COMMENT ON COLUMN applications.assigned_by IS 'Who made the current assignment (owner or admin)';
COMMENT ON COLUMN applications.last_activity_at IS 'Last time any activity occurred on this application';
COMMENT ON COLUMN applications.approval_notes IS 'Notes from admins about approval decisions';
COMMENT ON COLUMN applications.priority IS 'Priority level: low, normal, high, urgent';
COMMENT ON COLUMN applications.tags IS 'Array of tags for categorization and filtering';

COMMENT ON FUNCTION auto_assign_application(UUID) IS 'Automatically assigns application to team member with least current workload';