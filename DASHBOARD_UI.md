# TELODOX Dashboard UI Design Specification

**⚠️ CRITICAL NOTE**: Project name is **TELODOX** - NOT telodx, telodx, teledox, or any other variation. Always use TELODOX.

## Overview
Each user role gets a customized dashboard experience tailored to their specific responsibilities and access levels. This ensures users see only what's relevant to them while maintaining security boundaries.

## Architecture Approach

### Single Layout + Role-Based Components
**Design Pattern**: Use one unified dashboard layout with intelligent components that adapt based on user role and permissions. This approach provides:

- **Component Reusability**: Same components show different data scopes (platform-wide vs tenant-specific)
- **Maintainability**: Single layout to maintain instead of 5+ separate dashboard pages
- **Performance**: Shared component instances, better caching, single route with conditional rendering
- **Consistency**: Unified design system across all user roles

### Component Structure
```
/components/dashboard/
├── DashboardLayout.vue           # Single unified layout
├── shared/                       # Multi-role components
│   ├── MetricsCard.vue          # Adapts metrics based on role
│   ├── ActivityFeed.vue         # Shows relevant activities per role
│   ├── PipelineOverview.vue     # Scoped pipeline data
│   └── ApprovalQueue.vue        # Role-specific approvals
├── platform/                    # Platform Owner exclusive
│   ├── SystemHealthCard.vue     # Infrastructure monitoring
│   ├── RevenueAnalytics.vue     # Cross-tenant revenue data
│   └── TenantHealthMap.vue      # Geographic tenant distribution
├── tenant/                      # Organization-level roles
│   ├── TeamManagementCard.vue   # Team oversight (Owner/Admin)
│   ├── FormTemplatesCard.vue    # Template management (Owner)
│   └── MyAssignmentsCard.vue    # Personal assignments (Admin/Member)
└── carrier/                     # External user components
    ├── ApplicationProgress.vue   # Carrier onboarding status
    └── DocumentUploadCard.vue   # Required documents
```

### Role-Based Rendering Logic
Each component receives `userRole` and `organizationRole` props and handles its own visibility and data scope:

- **Platform Owner**: System-wide metrics, no tenant-specific data access
- **Organization Owner**: Complete tenant visibility, team management, all deals
- **Admin**: Team oversight, approval workflows, assigned deals visibility
- **Team Member**: Personal assignments only, limited communication
- **Carrier**: Own application data only, external user experience

## Role-Based Dashboard Views

### 1. 🏢 Platform Owner Dashboard
**Access**: System-wide analytics and operational management (replaces deprecated Super Admin role)
**Primary Use**: Monitor platform health, revenue, and tenant performance
**Data Scope**: Aggregated cross-tenant metrics only, NO individual tenant deal access

**Dashboard Components**:
- **platform/RevenueAnalytics.vue**: MRR, ARR, paying tenants, conversion funnel
- **platform/SystemHealthCard.vue**: Infrastructure health, API performance, error rates
- **platform/TenantHealthMap.vue**: Geographic distribution, tenant locations, market penetration
- **shared/MetricsCard.vue** (Platform scope): Total tenants, users, applications, growth trends
- **shared/ActivityFeed.vue** (Platform scope): Billing failures, system alerts, critical notifications

**Visual Layout**:
```
┌─────────────────────────────────────────────────────────────┐
│ Header: Platform Overview | System Status | Profile        │
├─────────────────────────────────────────────────────────────┤
│ Platform Metrics Row:                                      │
│ [Total Tenants: 847] [Active Users: 12.3k] [MRR: $84k]    │
├─────────────────────────────────────────────────────────────┤
│ Main Content (3-column):                                   │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│ │ Revenue     │ │ System      │ │ Tenant      │           │
│ │ Analytics   │ │ Health      │ │ Health Map  │           │
│ │ [Charts]    │ │ [Status]    │ │ [World Map] │           │
│ └─────────────┘ └─────────────┘ └─────────────┘           │
├─────────────────────────────────────────────────────────────┤
│ Bottom Section (2-column):                                 │
│ ┌─────────────────────────┐ ┌─────────────────────────┐   │
│ │ Platform Events         │ │ Performance Insights    │   │
│ │ [System alerts feed]    │ │ [Usage analytics]       │   │
│ └─────────────────────────┘ └─────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

### 2. 👑 Organization Owner Dashboard (★ PRIMARY FOR LANDING PAGE)
**Access**: Complete control over their tenant organization
**Primary Use**: Manage team, oversee all deals, optimize operations
**Data Scope**: All deals, all team activity, all carrier interactions within their tenant

**Dashboard Components**:
- **shared/PipelineOverview.vue** (Tenant scope): All carrier applications with status breakdown
- **tenant/TeamManagementCard.vue**: User roles, assignments, performance metrics  
- **tenant/FormTemplatesCard.vue**: Create/edit onboarding workflows
- **shared/MetricsCard.vue** (Tenant scope): Deal values, completion rates, cycle times
- **shared/ActivityFeed.vue** (Tenant scope): Real-time team and carrier actions
- **shared/ApprovalQueue.vue** (Owner scope): Documents requiring owner approval

**Visual Layout** (Most visually rich for landing page):
```
┌─────────────────────────────────────────────────────────────┐
│ Header: Welcome back, [Name] | Notifications | Profile     │
├─────────────────────────────────────────────────────────────┤
│ Quick Stats Row:                                            │
│ [Active Deals: 23] [Pending Approval: 7] [This Month: 12]  │
├─────────────────────────────────────────────────────────────┤
│ Main Content (3-column):                                    │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│ │ Pipeline    │ │ Team        │ │ Activity    │            │
│ │ Overview    │ │ Performance │ │ Feed        │            │
│ │             │ │             │ │             │            │
│ │ [Chart]     │ │ [Metrics]   │ │ [Live Feed] │            │
│ │             │ │             │ │             │            │
│ └─────────────┘ └─────────────┘ └─────────────┘            │
├─────────────────────────────────────────────────────────────┤
│ Bottom Section (2-column):                                  │
│ ┌─────────────────────────┐ ┌─────────────────────────┐    │
│ │ Recent Applications     │ │ Form Templates          │    │
│ │ [Table with status]     │ │ [Template cards]        │    │
│ └─────────────────────────┘ └─────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

### 3. 🛡️ Admin Dashboard
**Access**: Senior staff with broad authority within tenant
**Primary Use**: Manage assigned deals, approve redlines, oversee team members
**Data Scope**: All team member deals, full document access, approval authority

**Dashboard Components**:
- **tenant/MyAssignmentsCard.vue** (Admin scope): Deals assigned to this admin
- **tenant/TeamManagementCard.vue** (Admin scope): Team members they manage (cannot add other admins)
- **shared/ApprovalQueue.vue** (Admin scope): Documents requiring admin approval, MSA redlines
- **shared/PipelineOverview.vue** (Admin scope): All deals they can approve/oversee
- **shared/ActivityFeed.vue** (Admin scope): Team and carrier communications
- **shared/MetricsCard.vue** (Admin scope): Team productivity and success rates

**Visual Focus**:
- Task-oriented layout with action items prominently displayed
- Approval workflows with clear next steps and deadlines
- MSA redlining interface with change tracking
- Team member cards with assignment status and performance

---

### 4. 👤 Team Member Dashboard
**Access**: Individual contributors with focused responsibilities
**Primary Use**: Manage assigned carriers and complete specific tasks
**Data Scope**: Only assigned carriers, limited communication, no signing authority

**Dashboard Components**:
- **tenant/MyAssignmentsCard.vue** (Member scope): Applications assigned to this user only
- **shared/MetricsCard.vue** (Member scope): Personal productivity metrics
- **shared/ActivityFeed.vue** (Member scope): Activity with assigned carriers only
- **shared/ApprovalQueue.vue** (Member scope): Tasks requiring attention (no approval authority)
- **carrier/DocumentUploadCard.vue** (Member view): Review documents from assigned carriers

**Visual Focus**:
- Clean, focused interface without distractions or admin features
- Clear task prioritization with due dates and progress tracking
- Progress indicators for each assigned deal through KYC → FUSF → MSA → Interop
- Quick action buttons for common tasks (review, comment, escalate to admin)

---

### 5. 📱 Carrier Dashboard (External Users)
**Access**: Limited to their own application and documents only
**Primary Use**: Complete onboarding process and track progress
**Data Scope**: Own application data only, time-limited access (90-day retention)

**Dashboard Components**:
- **carrier/ApplicationProgress.vue**: Current stage and next steps with timeline
- **carrier/DocumentUploadCard.vue**: Required forms and attachments
- **shared/ActivityFeed.vue** (Carrier scope): Messages with assigned team member only
- **shared/MetricsCard.vue** (Carrier scope): Personal application progress metrics
- **carrier/MSARedliningCard.vue**: Contract negotiation interface (mutual consent workflow)

**Visual Focus**:
- Progress bar showing completion percentage through KYC → FUSF → MSA → Interop
- Clear call-to-action for next required step with deadlines
- Mobile-friendly design for on-the-go access
- Document status with visual indicators (Draft | Under Review | Approved | Signed)

---

## Design System Consistency

### Color Scheme
- **Primary**: Pink/Purple gradient (existing brand)
- **Success**: Green for completed items
- **Warning**: Yellow for pending approvals
- **Error**: Red for rejected/failed items
- **Neutral**: Dark theme with white/gray text

### Component Library
- **Bento Cards**: Consistent card design across all dashboards
- **Status Badges**: Color-coded indicators for application stages
- **Action Buttons**: Consistent CTA styling
- **Data Visualization**: Charts and graphs with brand colors
- **Navigation**: Role-appropriate sidebar menus

### Typography
- **Headers**: Bold, clear hierarchy
- **Body**: Readable sans-serif
- **Data**: Monospace for numbers and codes
- **Actions**: Prominent button text

---

## Implementation Strategy

### Phase 1: Unified Dashboard Architecture (CURRENT PRIORITY)
**Target**: Refactor existing dashboard to support role-based components
1. **Refactor DashboardLayout.vue**: Single layout accepting role props
2. **Create shared components**: MetricsCard, ActivityFeed, PipelineOverview, ApprovalQueue
3. **Move existing components**: Reorganize `/components/dashboard/owner/` → `/components/dashboard/tenant/`
4. **Implement role logic**: Each component handles visibility/data scope based on user role
5. **Test role switching**: Ensure proper component rendering for each user type

### Phase 2: Platform Owner Dashboard (Analytics Priority)
**Target**: Platform-wide monitoring and revenue analytics
- **platform/RevenueAnalytics.vue**: Cross-tenant revenue dashboard
- **platform/SystemHealthCard.vue**: Infrastructure monitoring
- **platform/TenantHealthMap.vue**: Geographic tenant distribution

### Phase 3: Role-Specific Enhancements
**Target**: Optimize experience for each user type
- **Admin workflows**: Enhanced approval queues and MSA redlining
- **Team member focus**: Streamlined assignment management
- **Carrier experience**: Mobile-optimized onboarding interface

### Phase 4: Advanced Features
**Target**: Interactive elements and real-time updates
- Real-time notifications and status updates
- Advanced filtering and search capabilities
- Performance analytics and reporting

---

## Screenshot Strategy for Landing Page

**Ideal Organization Owner Dashboard Screenshot**:
1. **Populated Data**: Show realistic numbers (20+ applications, 5-8 team members)
2. **Visual Variety**: Mix of charts, tables, cards, and feeds
3. **Action Items**: Some pending approvals to show workflow
4. **Professional Polish**: Clean, modern, business-appropriate
5. **Brand Consistency**: Pink/purple accents, dark theme
6. **Information Density**: Rich enough to impress, not overwhelming

**Mock Data Needed**:
- Carrier company names and contacts
- Application statuses and dates
- Team member profiles and assignments
- Revenue/pipeline metrics
- Recent activity logs

This dashboard will serve as the hero image showing the power and sophistication of the TELODOX platform!

---

## Current Implementation Status

### ✅ COMPLETED (December 24, 2025)

#### 🏗️ Dashboard Architecture
- **Dashboard Layout**: Organization Owner dashboard fully implemented with 2-column grid layout
- **Component Library**: Complete set of dashboard components built and working
- **Mock Data System**: Comprehensive realistic telecom carrier data (Verizon, AT&T, T-Mobile, etc.)
- **Loading States**: Fixed all loading spinner issues - data loads instantly
- **Error Handling**: Resolved props undefined errors with null safety checks

#### 🎨 Visual Design & UX
- **Brand Colors**: Dark theme with pink/purple gradient icons consistently applied
- **Metrics Cards**: 4 top-level KPI cards with gradient icons (removed secondary text for cleaner look)
- **Typography**: Professional spacing and hierarchy implemented
- **Activity Feed**: Proper spacing between user names and actions
- **Icons**: Using Heroicons throughout (replaced custom SVG loading spinners)

#### 🧑‍💼 User Experience
- **Personalized Header**: "Welcome back, Alicia!" with fake professional data for screenshots
- **Company Branding**: Uses "Perfect Vox" as fake company name (not personal info)
- **Team Profiles**: Professional fake team member data with @teleconnect.com emails
- **Cycle Times**: Optimized to show impressive "36hr" average cycle time

#### 📊 Dashboard Content
- **Active Carriers**: 47 with realistic major telecom companies
- **Pipeline Data**: KYC: 14, FUSF: 12, MSA: 15, Interop: 6 (Total: 47)
- **Team Performance**: 92% efficiency rating
- **Activity Feed**: Real-time team actions with proper formatting
- **Team Management**: 6 high-performing team members with performance scores

#### 🔧 Technical Implementation
- **Props Safety**: All components have null checks to prevent undefined errors
- **Layout Optimization**: Removed Revenue Analytics (Platform Owner only), clean 2-column layout
- **Responsive Design**: Works on mobile and desktop
- **Performance**: Instant data loading with no loading states
- **Code Quality**: TypeScript definitions, proper component structure

### 📸 READY FOR MARKETING SCREENSHOT

**Current Dashboard Shows**:
- Clean 4-metric header row with gradient icons
- 2-column layout: Requiring Attention | Team Activity
- 2-column layout: Pipeline Overview | Team Management  
- Full-width: Form Templates
- Professional fake data for screenshots
- Consistent TELODOX branding

### 🎯 NEXT STEPS (New Chat Session)
1. **Marketing Screenshot**: Capture high-quality dashboard screenshot for landing page hero
2. **Landing Page Integration**: Add screenshot to hero section with compelling copy
3. **Additional Dashboards**: Build Admin, Team Member, and Carrier dashboard views
4. **Real Data Integration**: Connect to actual Supabase queries when ready
5. **Advanced Features**: Add filtering, search, and interactive elements

### 📋 FILES READY FOR NEXT SESSION
- `/pages/dashboard/index.vue` - Main dashboard (screenshot-ready)
- `/components/dashboard/owner/OwnerDashboardLayout.vue` - Clean layout
- `/layouts/dashboard.vue` - Sidebar with fake branding
- `/components/ui/UserMenuDropdown.vue` - Profile with fake data
- All dashboard components in `/components/dashboard/` working perfectly

**✅ STATUS**: Dashboard is polished, professional, and ready for marketing screenshot!