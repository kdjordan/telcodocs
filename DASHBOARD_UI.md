# TELODOX Dashboard UI Design Specification

## Overview
Each user role gets a customized dashboard experience tailored to their specific responsibilities and access levels. This ensures users see only what's relevant to them while maintaining security boundaries.

## Role-Based Dashboard Views

### 1. 🏢 Platform Owner Dashboard
**Access**: System-wide analytics and operational management
**Primary Use**: Monitor platform health, revenue, and tenant performance

**Key Sections**:
- **Revenue Analytics**: MRR, ARR, paying tenants, conversion funnel
- **Platform Metrics**: Total tenants, users, applications, growth trends
- **Tenant Health Monitoring**: Activity scores, engagement levels, churn prediction
- **System Operations**: Infrastructure health, API performance, error rates
- **Geographic Distribution**: Tenant locations and market penetration
- **Usage Analytics**: Feature adoption, popular workflows, bottlenecks
- **Billing Health**: Payment failures, subscription status, revenue forecasts

**Visual Elements**:
- Revenue trend charts with month-over-month growth
- World map showing tenant distribution
- Health score indicators with traffic light colors
- Real-time system status dashboard
- Top performing tenants leaderboard

---

### 2. 👑 Organization Owner Dashboard (★ PRIMARY FOR LANDING PAGE)
**Access**: Complete control over their tenant organization
**Primary Use**: Manage team, oversee all deals, optimize operations

**Key Sections**:
- **Pipeline Overview**: All carrier applications with status breakdown
- **Team Management**: User roles, assignments, performance metrics
- **Revenue Insights**: Deal values, completion rates, cycle times
- **Form Templates**: Create/edit onboarding workflows
- **Activity Feed**: Real-time team and carrier actions
- **Performance Analytics**: Conversion rates, bottlenecks, team productivity
- **Settings & Billing**: Subscription management, integrations

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

**Key Sections**:
- **My Assignments**: Deals assigned to this admin
- **Team Overview**: Team members they manage
- **Approval Queue**: Documents requiring admin approval
- **MSA Redlining**: Active negotiations and change requests
- **Performance Metrics**: Their team's productivity and success rates
- **Communication Center**: Notifications to carriers and team

**Visual Focus**:
- Task-oriented layout with action items prominently displayed
- Approval workflows with clear next steps
- Team member cards with assignment status
- Document collaboration interface

---

### 4. 👤 Team Member Dashboard
**Access**: Individual contributors with focused responsibilities
**Primary Use**: Manage assigned carriers and complete specific tasks

**Key Sections**:
- **My Carriers**: Applications assigned to this user
- **Task List**: Action items and deadlines
- **Document Review**: Forms and files requiring attention
- **Communication**: Messages with assigned carriers
- **Progress Tracking**: Status of their deals through the pipeline
- **Resource Center**: Templates, guides, and help docs

**Visual Focus**:
- Clean, focused interface without distractions
- Clear task prioritization with due dates
- Progress indicators for each assigned deal
- Quick action buttons for common tasks

---

### 5. 📱 Carrier Dashboard (External Users)
**Access**: Limited to their own application and documents
**Primary Use**: Complete onboarding process and track progress

**Key Sections**:
- **Application Status**: Current stage and next steps
- **Document Upload**: Required forms and attachments
- **Communication**: Messages with assigned team member
- **Timeline**: Progress through KYC → FUSF → MSA → Interop
- **MSA Negotiation**: Redlining interface for contract terms
- **Document Library**: Completed forms and signed agreements

**Visual Focus**:
- Progress bar showing completion percentage
- Clear call-to-action for next required step
- Mobile-friendly design for on-the-go access
- Document status with visual indicators

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

## Implementation Priority

### Phase 1: Organization Owner Dashboard (For Landing Page)
**Target**: Create the most visually impressive dashboard for marketing
- Pipeline overview with interactive charts
- Team management cards
- Real-time activity feed
- Revenue analytics
- Form template management

### Phase 2: Core User Dashboards
- Admin dashboard with approval workflows
- Team member focused interface
- Carrier onboarding experience

### Phase 3: Platform Analytics
- Platform owner system-wide view
- Advanced reporting and insights

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