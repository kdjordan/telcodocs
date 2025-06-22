# TeloDox 

## Project Overview
Next-generation multi-tenant SaaS platform that transforms telecom carrier onboarding from email chaos into streamlined deal flow. Beyond simple document management, TeloDox delivers team collaboration, intelligent document processing, and MSA negotiation tools that accelerate deal cycles and increase win rates.

**Market Position**: The first platform built specifically for telecommunications that combines document automation, team workflow management, and collaborative MSA redlining in one integrated solution.

## Tech Stack
- **Frontend**: Nuxt 3 + TypeScript + Tailwind CSS + PrimeVue
- **Database**: Supabase (PostgreSQL with RLS)
- **Authentication**: Supabase Auth
- **File Storage**: Cloudflare R2
- **Email**: Amazon SES
- **Payments**: Stripe (subscription billing)
- **Serverless**: Cloudflare Workers/Edge functions

## Architecture
**Multi-tenant**: Each telecom company gets subdomain (e.g., `faketelecom.telodox.com`)
**Database**: Shared tables with Row Level Security using `tenant_id`
**Forms**: Sequential workflow (KYC → FUSF → MSA → Interop) with owner approval gates

## User Roles

### Platform Level
1. **Super Admin**: Platform management and oversight

### Organization Level (within each tenant - e.g., GloTell)
2. **Organization Owner**: Ultimate authority with complete control
   - **User Management**: Add/remove multiple admins and team members
   - **Billing Management**: Subscription and payment oversight
   - **Form Templates**: Create and edit all form templates
   - **Complete Access**: Inherits ALL admin and team member capabilities
   - **Document Authority**: Sign documents, approve redlines, download all docs
   - **Visibility**: See all deals, all team activity, all carrier interactions

3. **Admin**: Senior staff with broad authority (multiple admins allowed)
   - **Redlining**: Redline MSAs and approve carrier redlines
   - **Communications**: Send notifications to anyone (carriers, team members)
   - **Team Building**: Add team members (not other admins)
   - **Document Authority**: Sign documents on behalf of organization
   - **Full Visibility**: Download ALL carrier documents, see ALL team member deals
   - **Approval Power**: Approve carrier redlines to allow process progression

4. **Team Member**: Individual contributors with focused responsibilities
   - **Limited Communications**: Send notifications to assigned carriers only
   - **Assigned Visibility**: View only assigned carriers' statuses and documents
   - **Document Access**: Download only assigned carriers' documents
   - **No Signing Authority**: Cannot sign documents or approve redlines

### External Level (Carriers applying for interconnection)
5. **Carrier**: External carrier companies with time-limited access
   - **Registration**: Signs up on tenant subdomain (e.g., `abc-telecom.com` → `glotell.telodox.com`)
   - **Document Management**: Fill document information and sign agreements
   - **Redlining Capability**: Redline MSAs and approve organization redlines
   - **Mutual Consent**: Must approve organization redlines before process continues
   - **Limited Visibility**: Only their own application and documents
   - **Workflow Progression**: Complete KYC → FUSF → MSA → Interop (with admin approval)
   - **Document Access**: Download only their own documents after completion
   - **Lifecycle**: Account archived/removed after process completion (90-day retention)

## Critical Business Logic & Edge Cases

### Mutual Redline Approval Workflow
**Intuitive Consent Process:**
- Either Carrier or Admin can initiate redlines on MSA documents
- Each redline creates a "change request" requiring explicit approval
- Visual status indicators: "Pending Your Review" | "Awaiting Their Approval" | "Approved" | "Rejected"
- Document cannot proceed to signature until ALL redlines resolved (approved/rejected)
- Clear escalation path: rejected redlines can be revised and resubmitted

### Carrier Lifecycle Management
**Automated Account Management:**
- **Active Phase**: Full access during application process
- **Completion Phase**: 30-day download window after final signatures
- **Archive Phase**: Account automatically archived after 90 days
- **Manual Override**: Admins can extend or immediately archive
- **Data Retention**: Audit trail maintained for compliance (7 years)

### Team Member Assignment Rules
**Clear Boundaries:**
- Team members see only currently assigned carriers
- Assignment changes transfer all access (notifications, documents, status)
- Historical assignments remain in audit logs but not accessible
- Reassignment requires Admin approval to prevent conflicts

### Admin Authority Structure
**Hierarchical Permissions:**
- **Owner**: Can add/remove Admins and override any Admin decision
- **Admins**: Cannot add other Admins, but can add Team Members
- **Admin Consensus**: Any Admin can approve carrier redlines (no multiple approval required)
- **Conflict Resolution**: Owner has final authority on disputed redlines

### Document State Management
**Workflow Integrity:**
- Documents have clear states: Draft | Under Review | Pending Approval | Signed | Archived
- State transitions require appropriate permissions (Admin approval for progression)
- Abandoned processes auto-escalate to Admin after 7 days of inactivity
- Version control maintains complete change history for legal compliance

## Core Platform Features

### Foundation (MVP)
- **Self-Service Tenant Creation**: Users subscribe and create their own tenants
- **Subdomain Management**: Tenant owners can update their subdomain anytime
- **Form Builder**: Owners create custom forms replicating PDF documents
- **Auto-save**: Save on every field change
- **Digital Signatures**: Proprietary signature system (no external integrations)
- **Approval Workflow**: Manual owner approval between document stages
- **Multi-tenant Dashboard**: Pipeline view of carrier applications
- **Email Notifications**: SES integration for status updates

### Game-Changing Features (V1)

#### 🏢 Team & Organization Management
- **Multi-user Organizations**: Transform single-owner model into collaborative teams
- **Per-seat Billing**: Revenue growth through team expansion
- **Deal Assignment System**: Siloed access promoting accountability
- **Role-based Permissions**: Granular access control within organizations
- **Team Performance Tracking**: Visibility into individual and team metrics

#### 📄 Intelligent Document Processing
- **PDF/DOCX Upload**: Reduce onboarding friction by 70%+
- **OCR Text Extraction**: Transform existing documents into digital assets
- **Smart Field Detection**: AI-assisted form generation from uploaded documents
- **Visual Reference System**: Side-by-side document viewing during form creation
- **Document Library**: Centralized storage with search and categorization

#### ✏️ MSA Redlining & Negotiation
- **Collaborative Document Editing**: Turn-based MSA negotiation system
- **Change Tracking**: Professional redlining with full audit trail
- **Accept/Reject Workflow**: Streamlined review process
- **Version Management**: Complete document history and comparison
- **Legal Compliance**: Built-in audit trails meeting regulatory requirements

## Enhanced Core Workflows

### Tenant Onboarding (Reduced Friction)
1. User signs up → Selects subscription plan → Becomes organization owner
2. Owner chooses subdomain during onboarding
3. **NEW**: Upload existing PDF/DOCX documents for instant processing
4. **NEW**: OCR extracts text and suggests form structure
5. Owner reviews AI suggestions and finalizes form templates
6. **NEW**: Invite team members with appropriate roles

### Carrier Application Process
1. **Carrier** (external company) visits tenant subdomain (e.g., `glotell.telodox.com`)
2. **Carrier** creates account and starts application
3. **Carrier** fills forms sequentially (KYC → FUSF → MSA → Interop)
4. **NEW**: Auto-assignment to appropriate GloTell team member
5. GloTell team member reviews and provides approvals
6. **NEW**: MSA negotiation via collaborative redlining with mutual consent workflow
   - Either party (Carrier or Admin) can propose redlines
   - Other party must approve/reject each redline individually
   - Visual indicators show "Pending Your Approval" vs "Waiting for Their Approval"
   - Document ready for signature only when ALL redlines approved
7. Completed documents generate signed PDFs stored in R2
8. **NEW**: Automatic carrier account archival 90 days after final signature

### Team Collaboration Workflow
1. **NEW**: Organization owner assigns deals to team members
2. **NEW**: Team members manage their assigned pipeline
3. **NEW**: Team admins oversee multiple deals and provide guidance
4. **NEW**: Real-time notifications and status updates
5. **NEW**: Performance tracking and analytics for optimization

## Enhanced Database Schema

### Core Tables (Existing)
- `tenants` - Telecom companies/organizations (e.g., GloTell)
- `users` - All platform users with role system:
  - `role`: 'super_admin' | 'tenant_owner' | 'end_user' 
  - `organization_role`: 'owner' | 'admin' | 'member' | null (for carriers)
  - Carriers have `role: 'end_user'` and `organization_role: null`
- `form_templates` - Owner-created forms with document references
- `form_fields` - Dynamic form structure
- `applications` - Carrier onboarding instances (one per carrier)
- `form_submissions` - Auto-saved form data
- `signatures` - Signature capture data
- `documents` - Generated PDFs

### Team Management (V1)
- `deal_assignments` - Application assignment to team members
- `activity_logs` - Audit trail for all user actions
- `team_invitations` - User invitation management

### Document Processing (V1)
- `uploaded_documents` - Original PDF/DOCX files with OCR data
- `document_processing_jobs` - Background OCR and field detection
- `field_suggestions` - AI-generated form field recommendations

### MSA Redlining (V1)
- `msa_documents` - MSA documents with rich text content
- `document_changes` - Change tracking for redlining
- `document_comments` - Comments and suggestions
- `document_versions` - Version history and comparison

## Strategic Development Roadmap

### Phase 1: Foundation (MVP) ✅ Complete
1. ✅ Multi-tenant architecture with subdomain routing
2. ✅ User authentication & basic role system
3. ✅ Modern dashboard with bento grid design
4. ✅ Landing page with pricing and onboarding
5. ✅ Self-service tenant creation with Stripe integration
6. ✅ Basic form builder interface with drag-and-drop
7. ✅ Form submission with auto-save
8. ✅ Digital signature capture
9. 📋 Email notification system (AWS SES integration pending)

### Phase 2: Game Changers (V1) - Market Differentiators
**Priority 1: Document Upload & Processing** (4-6 weeks)
- Immediate friction reduction for new customers
- OCR processing and smart field detection
- Integration with form builder

**Priority 2: Team & Organization Management** (3-4 weeks)
- Per-seat billing model for revenue growth
- Deal assignment and role-based access
- Team invitation and management system

**Priority 3: MSA Redlining System** (4-5 weeks)
- Industry-first competitive advantage
- Turn-based collaborative editing
- Professional change tracking and approval

### Phase 3: Platform Optimization (V2)
- Advanced analytics and business intelligence
- CRM/ERP integrations and API platform
- Mobile-first experience and offline capabilities
- White-label and enterprise features

## File Structure
```
/
├── components/
│   ├── forms/          # Form builder & display components
│   ├── signatures/     # Signature capture
│   ├── dashboard/      # Owner dashboard
│   └── ui/            # Reusable UI components
├── pages/
│   ├── admin/         # Super admin pages
│   ├── dashboard/     # Owner dashboard
│   └── forms/         # Form filling interface
├── server/api/        # API routes
├── middleware/        # Tenant resolution, auth guards
├── utils/            # Shared utilities
├── types/            # TypeScript definitions
└── supabase/         # Database migrations & types
```

## Environment Variables Needed
```
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
R2_ACCOUNT_ID=
R2_ACCESS_KEY_ID=
R2_SECRET_ACCESS_KEY=
R2_BUCKET_NAME=
AWS_SES_ACCESS_KEY=
AWS_SES_SECRET_KEY=
AWS_SES_REGION=
STRIPE_PUBLISHABLE_KEY=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
```

## Key Implementation Notes
- Use middleware to extract tenant from subdomain
- Implement RLS policies for all tenant-scoped operations
- Debounced auto-save with optimistic updates
- Mobile-responsive signature canvas
- PDF generation with embedded signatures
- Audit logging for compliance

## AWS Amplify Deployment Considerations
- **DNS Configuration**: Wildcard DNS in Route 53 (*.telodox.com)
- **Dynamic Subdomains**: CloudFront + Lambda@Edge for subdomain routing
- **Alternative Approach**: URL parameter routing (/t/subdomain) for simpler deployment
- **SSL**: Wildcard SSL certificate for all subdomains

## Current Status
**Dashboard & Landing Page Complete** - Multi-tenant dashboard with floating collapsible sidebar and modern SaaS landing page implemented. Both use consistent bento card design system with flat, borderless aesthetic. Ready for core application functionality development.

### Recently Completed (2025-06-22)
- ✅ **MVP Foundation Complete**: All core features implemented and tested
- ✅ **Stripe Integration**: Full subscription billing with webhooks and payment verification
- ✅ **Form Builder**: Professional drag-and-drop interface with 11 field types
- ✅ **Form Submission**: Auto-save with 1-second debouncing and comprehensive validation
- ✅ **Digital Signatures**: Canvas-based signature capture with touch support
- ✅ **API Infrastructure**: 8 comprehensive endpoints for forms, submissions, and payments
- ✅ **TypeScript Definitions**: Complete type safety across the application

### Previously Completed (2025-06-21)
- ✅ **Dashboard Design System**: Implemented custom Tailwind theme with proper color palette
- ✅ **Floating Sidebar**: Collapsible dark sidebar with smooth animations and role-based navigation
- ✅ **Bento Grid Layout**: Clean card-based dashboard with borderless design
- ✅ **User Profile Integration**: Dynamic welcome messages with proper user name display
- ✅ **Page Refresh Handling**: Fixed authentication errors on hard refresh
- ✅ **Tailwind Configuration**: Resolved beta version issues, proper PostCSS setup with stable v6.14.0
- ✅ **Landing Page**: Modern SaaS landing page with hero, problem/solution, pricing sections
- ✅ **Icon System**: Implemented Heroicons throughout for professional appearance
- ✅ **Color Consolidation**: Replaced all accent colors with dark theme (#28282B)
- ✅ **Typography Enhancement**: Added Allura signature font for elegant branding

### Development Lessons Learned
- **Tailwind Beta Issues**: `@nuxtjs/tailwindcss@7.0.0-beta.0` had custom color generation problems
- **Solution**: Downgraded to stable `@nuxtjs/tailwindcss@6.14.0` with PostCSS config
- **Custom Colors**: Use `postcss.config.js` + proper color definitions in `tailwind.config.js`
- **Nuxt Module Conflicts**: Always check module versions when custom configs fail
- **Design Consistency**: Using theme classes instead of inline Tailwind values ensures consistency
- **Flat Design**: Removing shadows and hover effects creates cleaner, more modern aesthetic
- **Icon Libraries**: Heroicons provides comprehensive icon set that integrates well with Vue 3

### Technical Stack Validated
- **Nuxt 3.17.5**: Stable, SSR working properly
- **Tailwind CSS**: v6.14.0 with PostCSS (avoid v7 beta)
- **Supabase Module**: `@nuxtjs/supabase@1.5.2` working well
- **Authentication**: Middleware and composables functioning correctly
- **Google Fonts**: `@nuxtjs/google-fonts` module for web font integration
- **Heroicons**: `@heroicons/vue` for comprehensive icon system
- **Custom Fonts**: Successfully integrated Allura font as 'sign1' font family

### Immediate Next Steps (Priority Order)

**✅ MVP Foundation Complete** - Ready for Game-Changing Features

**Week 1-4: Document Upload System** (Immediate Priority)
1. File upload to R2 storage with drag-and-drop interface
2. OCR processing pipeline using Tesseract.js
3. Form builder integration with document reference
4. Smart field detection and suggestions

**Week 3-6: Team & Organization Management** (Parallel Development)
1. Enhanced user roles and permissions (Owner/Admin/Member/Carrier)
2. Deal assignment system with siloed access
3. Team invitation workflow and management interface
4. Per-seat billing integration with Stripe

**Week 5-8: MSA Redlining System** (Market Differentiator)
1. Rich text editor with change tracking (TipTap)
2. Turn-based editing workflow with edit locks
3. Accept/reject review system with mutual consent
4. Email notification integration and audit trails

### Success Metrics
- **MVP**: 10 paying tenants using basic platform
- **V1**: 50% reduction in customer onboarding time
- **V1**: 3x increase in average revenue per customer (team seats)
- **V1**: First MSA negotiation completed entirely in platform