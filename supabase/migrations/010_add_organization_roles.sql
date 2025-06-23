-- Add organization-level roles for multi-user team management
-- This enables Owner/Admin/Member hierarchy within each tenant

-- Create organization role enum
CREATE TYPE organization_role AS ENUM ('owner', 'admin', 'member');

-- Add organization_role column to users table
ALTER TABLE users ADD COLUMN organization_role organization_role;

-- Set existing tenant_owners to have organization_role = 'owner'
UPDATE users 
SET organization_role = 'owner' 
WHERE role = 'tenant_owner';

-- Set all end_users with tenant_id to be 'member' by default
-- (Carriers without tenant_id remain NULL)
UPDATE users 
SET organization_role = 'member' 
WHERE role = 'end_user' AND tenant_id IS NOT NULL;

-- Add index for organization_role
CREATE INDEX idx_users_organization_role ON users(organization_role);

-- Add constraint: only users with tenant_id can have organization_role
ALTER TABLE users ADD CONSTRAINT check_organization_role_requires_tenant 
    CHECK (
        (organization_role IS NULL AND tenant_id IS NULL) OR 
        (organization_role IS NOT NULL AND tenant_id IS NOT NULL)
    );

-- Update helper functions for new role system
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

-- Comment for clarity
COMMENT ON COLUMN users.organization_role IS 'Role within the organization: owner (full control), admin (team management), member (assigned work), or NULL for external carriers';
COMMENT ON TYPE organization_role IS 'Hierarchy within tenant organizations: owner > admin > member';