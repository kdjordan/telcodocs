-- TELODOX Production Migration 001: Core Types and Enums
-- Creates all custom types and enums used throughout the application

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- User role hierarchy (platform and tenant levels)
CREATE TYPE user_role AS ENUM (
    'platform_owner',  -- System-wide analytics and operations
    'super_admin',     -- Deprecated, use platform_owner
    'tenant_owner',    -- Owns a tenant organization
    'end_user'         -- External carriers or unassigned users
);

-- Organization role hierarchy (within tenant)
CREATE TYPE organization_role AS ENUM (
    'owner',   -- Full control within organization
    'admin',   -- Senior staff, can manage team
    'member'   -- Team member with limited access
);

-- Form types for carrier onboarding workflow
CREATE TYPE form_type AS ENUM (
    'kyc',      -- Know Your Customer
    'fusf',     -- Federal Universal Service Fund
    'msa',      -- Master Service Agreement
    'interop',  -- Interoperability Testing
    'custom'    -- Custom forms
);

-- Application lifecycle statuses
CREATE TYPE application_status AS ENUM (
    'draft',
    'in_progress',
    'pending_approval',
    'approved',
    'rejected',
    'completed'
);

-- Workflow status for individual forms
CREATE TYPE workflow_status AS ENUM (
    'pending',
    'in_progress',
    'completed',
    'approved',
    'rejected'
);

-- Form delivery modes
CREATE TYPE drip_mode AS ENUM (
    'sequential',  -- One at a time
    'multiple',    -- Several at once
    'all'          -- All available
);

-- Comments for documentation
COMMENT ON TYPE user_role IS 'Platform and tenant-level user roles';
COMMENT ON TYPE organization_role IS 'Roles within a tenant organization';
COMMENT ON TYPE form_type IS 'Types of forms in the carrier onboarding workflow';
COMMENT ON TYPE application_status IS 'Overall application status';
COMMENT ON TYPE workflow_status IS 'Status of individual form submissions';
COMMENT ON TYPE drip_mode IS 'How forms are delivered to carriers';