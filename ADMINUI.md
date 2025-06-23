# Admin UI & Role-Based Dashboard Design

## User Role Summary & Dashboard Requirements

### 1. Super Admin (Platform Level)
**Purpose**: Platform management and oversight across all tenants
**Dashboard Focus**: Platform-wide analytics, tenant management, system health
**Key Features Needed**:
- Multi-tenant overview with health metrics
- Billing and subscription analytics across all tenants
- System-wide user management
- Platform performance monitoring
- Support ticket management
- Feature rollout controls

### 2. Organization Owner (Tenant Level)
**Purpose**: Ultimate authority with complete control over their tenant
**Dashboard Focus**: Full organizational overview, team management, business metrics
**Key Features Needed**:
- Complete deal pipeline visibility (all carriers, all team members)
- Team performance analytics and individual metrics
- Billing and subscription management for their organization
- Form template management and customization
- User management (add/remove admins and team members)
- Document approval and signing authority
- Revenue and conversion analytics
- Team activity feed and audit logs

### 3. Admin (Tenant Level - Multiple Allowed)
**Purpose**: Senior staff with broad authority but cannot manage other admins
**Dashboard Focus**: Deal oversight, team support, document management
**Key Features Needed**:
- Full deal pipeline visibility (all carriers, all team members)
- Document redlining and approval capabilities
- Team member management (add team members only)
- Communication hub (notifications to carriers/team)
- Document signing authority
- Performance tracking for assigned areas
- Approval workflows for carrier progression

### 4. Team Member (Tenant Level)
**Purpose**: Individual contributors with focused, assigned responsibilities
**Dashboard Focus**: Personal pipeline, assigned carriers only
**Key Features Needed**:
- Assigned carrier pipeline only (siloed view)
- Task management for assigned deals
- Limited communication (assigned carriers only)
- Document access for assigned carriers
- Personal performance metrics
- Activity feed for assigned deals only
- Status update capabilities

### 5. Carrier (External - Temporary Access)
**Purpose**: External companies applying for interconnection
**Dashboard Focus**: Application progress, document management
**Key Features Needed**:
- Single application workflow view (KYC → FUSF → MSA → Interop)
- Document upload and form filling interface
- MSA redlining and approval workflow
- Communication with assigned team member/admin
- Application status tracking
- Download access to their documents only
- Signature completion interface

## Current Dashboard Issues (Screenshot Analysis)

Looking at the current dashboard, it appears to be a generic task/project management interface that doesn't reflect our telecom carrier onboarding focus. Current issues:

1. **Generic Metrics**: "Total Projects", "Total Tasks", "Completed Tasks" - not relevant to our domain
2. **Wrong Focus**: Task management vs. carrier deal pipeline
3. **Missing Role Context**: No indication of user role or permissions
4. **Irrelevant Features**: "Today's Tasks", "Performance" metrics don't align with telecom onboarding
5. **Generic Language**: Should use telecom-specific terminology

## Proposed Dashboard Structure by Role

### Organization Owner Dashboard Layout
```
┌─────────────────┬─────────────────┬─────────────────┐
│ Active Carriers │ Team Performance│ Revenue Metrics │
│ Pipeline Status │ This Month      │ This Quarter    │
├─────────────────┼─────────────────┼─────────────────┤
│ Recent Activity Feed               │ Team Management │
│ (All team actions, carrier updates)│ Quick Actions   │
├─────────────────┴─────────────────┼─────────────────┤
│ Deal Pipeline Overview             │ Form Templates  │
│ (KYC→FUSF→MSA→Interop stages)     │ & Settings      │
└───────────────────────────────────┴─────────────────┘
```

### Admin Dashboard Layout
```
┌─────────────────┬─────────────────┬─────────────────┐
│ Active Carriers │ Pending Approvals│ Team Activity  │
│ Requiring Review│ (Redlines/Docs) │ Overview        │
├─────────────────┼─────────────────┼─────────────────┤
│ Recent Activity Feed               │ Communication   │
│ (Team + carrier actions)           │ Center          │
├─────────────────┴─────────────────┼─────────────────┤
│ Deal Pipeline Overview             │ Document        │
│ (All carriers across all stages)   │ Management      │
└───────────────────────────────────┴─────────────────┘
```

### Team Member Dashboard Layout
```
┌─────────────────┬─────────────────┬─────────────────┐
│ My Assigned     │ Tasks Due       │ My Performance  │
│ Carriers        │ This Week       │ This Month      │
├─────────────────┼─────────────────┼─────────────────┤
│ Recent Activity on My Deals        │ Communication   │
│ (Assigned carriers only)           │ Center          │
├─────────────────┴─────────────────┼─────────────────┤
│ My Carrier Pipeline                │ Document        │
│ (Assigned carriers by stage)       │ Actions         │
└───────────────────────────────────┴─────────────────┘
```

### Carrier Dashboard Layout
```
┌─────────────────────────────────────────────────────┐
│ Application Progress                                │
│ KYC ✓ → FUSF ✓ → MSA (In Review) → Interop        │
├─────────────────┬─────────────────┬─────────────────┤
│ Current Step    │ Required Actions│ Recent Updates  │
│ MSA Review      │ Review Redlines │ From GloTell    │
├─────────────────┼─────────────────┼─────────────────┤
│ Document Center │ Communication   │ Help & Support  │
│ Upload/Download │ with GloTell    │ Process Guide   │
└─────────────────┴─────────────────┴─────────────────┘
```

## Implementation Strategy

### Phase 1: Role Detection & Routing
1. Update middleware to detect user role from database
2. Create role-based route guards
3. Implement dashboard component routing based on role

### Phase 2: Dashboard Components
1. Create shared components (metrics cards, activity feeds)
2. Build role-specific dashboard layouts
3. Implement data filtering based on role permissions

### Phase 3: Data Integration
1. Update API endpoints to respect role-based access
2. Implement proper data scoping (team member sees only assigned carriers)
3. Add real-time updates for activity feeds

## Technical Implementation Notes

### Component Structure
```
components/
├── dashboard/
│   ├── shared/
│   │   ├── MetricCard.vue
│   │   ├── ActivityFeed.vue
│   │   ├── PipelineView.vue
│   │   └── QuickActions.vue
│   ├── owner/
│   │   ├── OwnerDashboard.vue
│   │   ├── TeamPerformance.vue
│   │   └── RevenueMetrics.vue
│   ├── admin/
│   │   ├── AdminDashboard.vue
│   │   ├── PendingApprovals.vue
│   │   └── TeamActivity.vue
│   ├── member/
│   │   ├── MemberDashboard.vue
│   │   ├── AssignedCarriers.vue
│   │   └── MyTasks.vue
│   └── carrier/
│       ├── CarrierDashboard.vue
│       ├── ApplicationProgress.vue
│       └── DocumentCenter.vue
```

### Data Scoping Rules
- **Owner/Admin**: Full tenant data access
- **Team Member**: Only assigned carrier data
- **Carrier**: Only own application data
- **Super Admin**: Cross-tenant platform data

## Success Metrics
- Role-appropriate information displayed
- Proper access control enforcement
- Intuitive navigation for each user type
- Domain-specific terminology and workflows
- Clear visual hierarchy and action priorities

## Current Status
- ❌ Generic dashboard not aligned with telecom domain
- ❌ No role-based access or views
- ❌ Missing carrier pipeline visualization
- ❌ No team collaboration features
- ❌ Wrong terminology and metrics

## Next Steps
1. Implement role detection in dashboard page
2. Create Organization Owner dashboard first (most comprehensive)
3. Build shared components for reuse across roles
4. Add proper data filtering and API integration
5. Test role-based access controls