# TelcoDocs - Project Context for Claude

## Project Overview
Multi-tenant SaaS application for telecommunications companies to manage carrier onboarding documents. A DocuSign-like application specifically for telco/VoIP operators.

## Tech Stack
- **Frontend**: Nuxt 3 + TypeScript + Tailwind CSS + PrimeVue
- **Database**: Supabase (PostgreSQL with RLS)
- **Authentication**: Supabase Auth
- **File Storage**: Cloudflare R2
- **Email**: Amazon SES
- **Serverless**: Cloudflare Workers/Edge functions

## Architecture
**Multi-tenant**: Each telecom company gets subdomain (e.g., `faketelecom.telcodocs.com`)
**Database**: Shared tables with Row Level Security using `tenant_id`
**Forms**: Sequential workflow (KYC → FUSF → MSA → Interop) with owner approval gates

## User Roles
1. **Super Admin**: Platform management
2. **Tenant Owner**: Telecom company admin managing their subdomain
3. **End User**: Carriers filling forms to interconnect

## Key Features
- **Form Builder**: Owners create custom forms replicating PDF documents
- **Auto-save**: Save on every field change
- **Digital Signatures**: Proprietary signature system (no external integrations)
- **Approval Workflow**: Manual owner approval between document stages
- **Multi-tenant Dashboard**: Pipeline view of carrier applications
- **Email Notifications**: SES integration for status updates

## Core Workflow
1. Telecom owner signs up → gets subdomain
2. Owner uses form builder to recreate their documents
3. Carriers visit subdomain and create accounts
4. Carriers fill forms sequentially with owner approval gates
5. Completed forms generate signed PDFs stored in R2

## Database Schema Key Tables
- `tenants` - Telecom companies
- `users` - All users with roles and tenant association
- `form_templates` - Owner-created forms
- `form_fields` - Dynamic form structure
- `applications` - Carrier onboarding instances
- `form_submissions` - Auto-saved form data
- `signatures` - Signature capture data
- `documents` - Generated PDFs

## Development Priorities (MVP)
1. Multi-tenant setup with subdomain routing
2. Basic form builder
3. User authentication & roles
4. Form submission with auto-save
5. Basic signature capture
6. Owner dashboard with application pipeline
7. Email notifications

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
```

## Key Implementation Notes
- Use middleware to extract tenant from subdomain
- Implement RLS policies for all tenant-scoped operations
- Debounced auto-save with optimistic updates
- Mobile-responsive signature canvas
- PDF generation with embedded signatures
- Audit logging for compliance

## Current Status
Project scaffolded with Nuxt 3 setup. Continue development focusing on MVP features in priority order.