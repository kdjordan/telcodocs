-- Create a test tenant for development
INSERT INTO tenants (name, subdomain, domain, settings)
VALUES (
    'Acme Telecom',
    'acme',
    'acme.localhost:3000',
    '{
        "primary_color": "#0066cc",
        "logo_url": null,
        "workflow_settings": {
            "drip_mode": "sequential",
            "require_approval": true,
            "approval_roles": ["tenant_owner"]
        }
    }'::jsonb
)
ON CONFLICT (subdomain) DO UPDATE SET
    name = EXCLUDED.name,
    domain = EXCLUDED.domain,
    settings = EXCLUDED.settings,
    updated_at = NOW();

-- Create another test tenant
INSERT INTO tenants (name, subdomain, domain, settings)
VALUES (
    'Demo Telco',
    'demo',
    'demo.localhost:3000',
    '{
        "primary_color": "#00aa55",
        "logo_url": null,
        "workflow_settings": {
            "drip_mode": "multiple",
            "require_approval": false
        }
    }'::jsonb
)
ON CONFLICT (subdomain) DO NOTHING;

-- Update existing users to belong to a tenant (optional)
-- This assigns Kevin to the Acme tenant
UPDATE users 
SET tenant_id = (SELECT id FROM tenants WHERE subdomain = 'acme' LIMIT 1)
WHERE email = 'glasskdj@yahoo.com' AND tenant_id IS NULL;

UPDATE users 
SET tenant_id = (SELECT id FROM tenants WHERE subdomain = 'acme' LIMIT 1)
WHERE email = 'k.dean.jordan@gmail.com' AND tenant_id IS NULL;