# TELODOX Production Migrations

## Clean Role System Implementation

This migration set implements the final, clean TELODOX role system with no legacy code or deprecated references.

### Migration Order
1. **001_core_types_and_enums.sql** - Clean role enums
2. **002_core_tables.sql** - Tables with proper role constraints
3. **003_helper_functions.sql** - Role check functions + auth trigger (with permissions fix)
4. **004_row_level_security.sql** - RLS policies
5. **005_views_and_aggregates.sql** - Analytics views
6. **006_email_waitlist.sql** - Email functionality
7. **007_initial_data.sql** - Subscription plans

### ✅ User Creation Flow
User and tenant creation is handled in the frontend after successful Supabase Auth signup:
1. User signs up through Supabase Auth
2. Frontend detects successful auth and creates:
   - Temporary tenant with unique subdomain
   - User profile as organization owner
3. User can then customize tenant name/subdomain in dashboard

This approach avoids auth.users permission issues and keeps logic in application code.

### Role System Summary
```sql
-- Database fields
role: 'platform_owner' | 'organization_user' | 'carrier'
organization_role: 'owner' | 'admin' | 'member' | null

-- Role combinations
Platform Owner: role='platform_owner', organization_role=null
Organization Owner: role='organization_user', organization_role='owner'
Admin: role='organization_user', organization_role='admin'
Team Member: role='organization_user', organization_role='member'
Carrier: role='carrier', organization_role=null
```

### Helper Functions Available
- `is_platform_owner()` - Platform-wide access
- `is_organization_owner()` - Organization owner
- `is_organization_admin()` - Organization admin
- `is_organization_member()` - Organization member
- `is_organization_user()` - Any organization user
- `is_carrier()` - External carrier
- `has_approval_authority()` - Owner or admin (can approve)
- `get_user_tenant_id()` - User's tenant
- `get_user_organization_role()` - User's org role

### Validation
Run these queries after migration to verify:

```sql
-- Check role distribution
SELECT role, organization_role, COUNT(*) as user_count
FROM users
GROUP BY role, organization_role
ORDER BY user_count DESC;

-- Verify constraints work
SELECT COUNT(*) as invalid_users
FROM users
WHERE NOT (
    (role = 'platform_owner' AND organization_role IS NULL AND tenant_id IS NULL) OR
    (role = 'organization_user' AND organization_role IS NOT NULL AND tenant_id IS NOT NULL) OR
    (role = 'carrier' AND organization_role IS NULL AND tenant_id IS NOT NULL)
);
-- Should return 0

-- Test helper functions
SELECT 
    is_platform_owner() as is_platform_owner,
    is_organization_owner() as is_org_owner,
    has_approval_authority() as can_approve;
```

This migration set is production-ready and can be run on a fresh Supabase instance.