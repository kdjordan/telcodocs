-- TELODOX Production Migration 002: Core Tables
-- Creates all tables with proper structure, constraints, and relationships

-- ============================================================================
-- CORE TENANT AND USER MANAGEMENT
-- ============================================================================

-- Tenants (telecom organizations using the platform)
CREATE TABLE tenants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    subdomain VARCHAR(100) UNIQUE NOT NULL,
    domain VARCHAR(255),
    settings JSONB DEFAULT '{}',
    
    -- Subscription and billing
    subscription_status TEXT DEFAULT 'trial' CHECK (subscription_status IN ('trial', 'active', 'cancelled', 'expired')),
    subscription_plan VARCHAR(100), -- FK to subscription_plans.name
    billing_email TEXT,
    trial_ends_at TIMESTAMPTZ,
    
    -- Stripe integration
    stripe_customer_id TEXT,
    stripe_subscription_id TEXT,
    
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Users (extends Supabase auth.users)
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    
    -- Clean two-field role system
    role user_role NOT NULL DEFAULT 'carrier',
    organization_role organization_role,
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    
    -- Stripe billing (for individual users if needed)
    stripe_customer_id TEXT,
    stripe_subscription_id TEXT,
    
    -- Metadata and timestamps
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Role-based constraints ensuring data integrity
    CONSTRAINT check_role_organization_consistency CHECK (
        -- Platform owners cannot have organization_role or tenant_id
        (role = 'platform_owner' AND organization_role IS NULL AND tenant_id IS NULL) OR
        -- Organization users must have both organization_role and tenant_id
        (role = 'organization_user' AND organization_role IS NOT NULL AND tenant_id IS NOT NULL) OR
        -- Carriers cannot have organization_role but must have tenant_id (the tenant they're applying to)
        (role = 'carrier' AND organization_role IS NULL AND tenant_id IS NOT NULL)
    )
);

-- Subscription plans
CREATE TABLE subscription_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    stripe_price_id TEXT NOT NULL UNIQUE,
    price_monthly INTEGER NOT NULL, -- Price in cents
    price_yearly INTEGER, -- Price in cents (optional)
    features JSONB DEFAULT '[]',
    max_applications INTEGER DEFAULT 100,
    max_forms INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- TEAM MANAGEMENT AND COLLABORATION
-- ============================================================================

-- Team invitations for new members
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

-- Deal assignments (carrier to team member)
CREATE TABLE deal_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    application_id UUID NOT NULL, -- FK added after applications table
    assigned_to UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assigned_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(application_id, assigned_to)
);

-- Activity logs for team collaboration
CREATE TABLE activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    application_id UUID, -- FK added after applications table
    activity_type VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- FORM MANAGEMENT AND SUBMISSIONS
-- ============================================================================

-- Form templates created by tenant owners
CREATE TABLE form_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    form_type form_type NOT NULL,
    fields JSONB NOT NULL DEFAULT '[]',
    settings JSONB DEFAULT '{}',
    version INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(tenant_id, form_type, version)
);

-- Carrier applications (one per carrier per tenant)
CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    
    -- Carrier information
    carrier_name VARCHAR(255) NOT NULL,
    carrier_company_name VARCHAR(255) NOT NULL,
    carrier_email VARCHAR(255) NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Workflow and status
    status application_status NOT NULL DEFAULT 'draft',
    current_stage form_type NOT NULL DEFAULT 'kyc',
    workflow JSONB NOT NULL DEFAULT '[]',
    
    -- Team assignment
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    assigned_at TIMESTAMPTZ,
    assigned_by UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Tracking and management
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    tags JSONB DEFAULT '[]',
    last_activity_at TIMESTAMPTZ DEFAULT NOW(),
    approval_notes TEXT,
    
    -- Metadata and timestamps
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

-- Form submissions with auto-save
CREATE TABLE form_submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    form_template_id UUID NOT NULL REFERENCES form_templates(id),
    form_data JSONB NOT NULL DEFAULT '{}',
    attachments JSONB DEFAULT '[]',
    signature_id UUID,
    is_final BOOLEAN DEFAULT false,
    submitted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Digital signatures
CREATE TABLE signatures (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    submission_id UUID NOT NULL REFERENCES form_submissions(id) ON DELETE CASCADE,
    signature_data TEXT NOT NULL,
    ip_address INET,
    user_agent TEXT,
    metadata JSONB DEFAULT '{}',
    signed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Generated documents (PDFs)
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    submission_id UUID REFERENCES form_submissions(id) ON DELETE SET NULL,
    document_type VARCHAR(100) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- MSA REDLINING AND DOCUMENT COLLABORATION
-- ============================================================================

-- MSA documents with version control
CREATE TABLE msa_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    application_id UUID NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL DEFAULT 'Master Service Agreement',
    content TEXT NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    is_template BOOLEAN DEFAULT false,
    is_locked BOOLEAN DEFAULT false,
    locked_by UUID REFERENCES users(id) ON DELETE SET NULL,
    locked_at TIMESTAMPTZ,
    status VARCHAR(50) NOT NULL DEFAULT 'draft' CHECK (
        status IN ('draft', 'under_review', 'pending_approval', 'approved', 'signed', 'archived')
    ),
    metadata JSONB DEFAULT '{}',
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Document changes (redlines and edits)
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

-- Document comments for collaboration
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

-- Document version history
CREATE TABLE document_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID NOT NULL REFERENCES msa_documents(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    change_summary TEXT,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(document_id, version_number)
);

-- ============================================================================
-- PLATFORM ANALYTICS (PLATFORM OWNER ACCESS)
-- ============================================================================

-- Platform-wide metrics aggregation
CREATE TABLE platform_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    metric_type VARCHAR(100) NOT NULL,
    metric_value NUMERIC NOT NULL,
    metric_date DATE NOT NULL DEFAULT CURRENT_DATE,
    time_period VARCHAR(20) DEFAULT 'daily',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(metric_type, metric_date, time_period)
);

-- Tenant health scoring
CREATE TABLE tenant_health_scores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    health_score INTEGER CHECK (health_score BETWEEN 0 AND 100),
    activity_score INTEGER CHECK (activity_score BETWEEN 0 AND 100),
    engagement_score INTEGER CHECK (engagement_score BETWEEN 0 AND 100),
    billing_score INTEGER CHECK (billing_score BETWEEN 0 AND 100),
    support_score INTEGER CHECK (support_score BETWEEN 0 AND 100),
    calculated_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB DEFAULT '{}',
    
    UNIQUE(tenant_id, calculated_at)
);

-- Platform events and alerts
CREATE TABLE platform_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) DEFAULT 'info' CHECK (severity IN ('info', 'warning', 'error', 'critical')),
    tenant_id UUID REFERENCES tenants(id) ON DELETE SET NULL,
    description TEXT,
    metadata JSONB DEFAULT '{}',
    resolved BOOLEAN DEFAULT false,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- System health metrics
CREATE TABLE system_health_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    metric_name VARCHAR(100) NOT NULL,
    metric_value NUMERIC NOT NULL,
    metric_unit VARCHAR(20),
    threshold_warning NUMERIC,
    threshold_critical NUMERIC,
    status VARCHAR(20) DEFAULT 'healthy' CHECK (status IN ('healthy', 'warning', 'critical')),
    recorded_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- AUDIT AND EMAIL TEMPLATES
-- ============================================================================

-- System audit logs
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(255) NOT NULL,
    resource_type VARCHAR(100) NOT NULL,
    resource_id UUID,
    metadata JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Email templates
CREATE TABLE email_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    variables JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- ADD FOREIGN KEY CONSTRAINTS AND INDEXES
-- ============================================================================

-- Add foreign key constraints that reference tables created later
ALTER TABLE tenants 
ADD CONSTRAINT tenants_subscription_plan_fkey 
FOREIGN KEY (subscription_plan) REFERENCES subscription_plans(name);

ALTER TABLE deal_assignments 
ADD CONSTRAINT deal_assignments_application_id_fkey 
FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;

ALTER TABLE activity_logs 
ADD CONSTRAINT activity_logs_application_id_fkey 
FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;

-- Create indexes for performance
CREATE INDEX idx_tenants_subdomain ON tenants(subdomain);
CREATE INDEX idx_tenants_subscription_status ON tenants(subscription_status);
CREATE INDEX idx_tenants_subscription_plan ON tenants(subscription_plan);
CREATE INDEX idx_tenants_trial_ends_at ON tenants(trial_ends_at);
CREATE INDEX idx_tenants_stripe_customer_id ON tenants(stripe_customer_id);

CREATE INDEX idx_users_tenant_id ON users(tenant_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_organization_role ON users(organization_role);
CREATE INDEX idx_users_stripe_customer_id ON users(stripe_customer_id);

CREATE INDEX idx_subscription_plans_stripe_price_id ON subscription_plans(stripe_price_id);
CREATE INDEX idx_subscription_plans_is_active ON subscription_plans(is_active);

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

CREATE INDEX idx_form_templates_tenant_id ON form_templates(tenant_id);
CREATE INDEX idx_form_templates_form_type ON form_templates(form_type);
CREATE INDEX idx_form_templates_is_active ON form_templates(is_active);

CREATE INDEX idx_applications_tenant_id ON applications(tenant_id);
CREATE INDEX idx_applications_user_id ON applications(user_id);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_carrier_email ON applications(carrier_email);
CREATE INDEX idx_applications_assigned_to ON applications(assigned_to);
CREATE INDEX idx_applications_assigned_at ON applications(assigned_at);
CREATE INDEX idx_applications_last_activity_at ON applications(last_activity_at);
CREATE INDEX idx_applications_priority ON applications(priority);
CREATE INDEX idx_applications_tenant_assigned ON applications(tenant_id, assigned_to, status);

CREATE INDEX idx_form_submissions_application_id ON form_submissions(application_id);
CREATE INDEX idx_form_submissions_form_template_id ON form_submissions(form_template_id);

CREATE INDEX idx_signatures_submission_id ON signatures(submission_id);

CREATE INDEX idx_documents_tenant_id ON documents(tenant_id);
CREATE INDEX idx_documents_application_id ON documents(application_id);

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

CREATE INDEX idx_platform_metrics_type_date ON platform_metrics(metric_type, metric_date);
CREATE INDEX idx_platform_metrics_date ON platform_metrics(metric_date);

CREATE INDEX idx_tenant_health_scores_tenant_id ON tenant_health_scores(tenant_id);
CREATE INDEX idx_tenant_health_scores_calculated_at ON tenant_health_scores(calculated_at);

CREATE INDEX idx_platform_events_type ON platform_events(event_type);
CREATE INDEX idx_platform_events_severity ON platform_events(severity);
CREATE INDEX idx_platform_events_resolved ON platform_events(resolved);
CREATE INDEX idx_platform_events_created_at ON platform_events(created_at);

CREATE INDEX idx_system_health_metrics_name ON system_health_metrics(metric_name);
CREATE INDEX idx_system_health_metrics_recorded_at ON system_health_metrics(recorded_at);

CREATE INDEX idx_audit_logs_tenant_id ON audit_logs(tenant_id);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_resource ON audit_logs(resource_type, resource_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

CREATE INDEX idx_email_templates_tenant_id ON email_templates(tenant_id);