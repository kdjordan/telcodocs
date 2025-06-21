-- Promote k.dean.jordan@gmail.com to super admin
UPDATE users 
SET 
    role = 'super_admin',
    tenant_id = NULL,  -- Super admin doesn't belong to any specific tenant
    updated_at = NOW()
WHERE email = 'k.dean.jordan@gmail.com';

-- Verify the update worked
SELECT id, email, full_name, role, tenant_id 
FROM users 
WHERE email = 'k.dean.jordan@gmail.com';