# TelcoDocs - Multi-Tenant Telecom Document Management System

## Overview

TelcoDocs is a comprehensive multi-tenant SaaS application designed for telecommunications companies to manage carrier onboarding documents. It provides a DocuSign-like experience specifically tailored for telco/VoIP operators.

## Features

- **Multi-Tenant Architecture**: Each telecom company gets their own subdomain
- **Sequential Document Workflow**: KYC → FUSF → MSA → Interop with approval gates
- **Form Builder**: Drag-and-drop interface to create custom forms
- **Digital Signatures**: Canvas-based signature capture
- **Auto-Save**: Automatic saving on every field change
- **Role-Based Access**: Super Admin, Tenant Owner, and End User roles
- **Real-time Updates**: Live status tracking and notifications

## Tech Stack

- **Frontend**: Nuxt 3, TypeScript, Tailwind CSS, PrimeVue
- **Database**: Supabase (PostgreSQL with RLS)
- **Authentication**: Supabase Auth
- **File Storage**: Cloudflare R2
- **Email**: Amazon SES

## Prerequisites

- Node.js 18+ and npm
- Supabase account
- Cloudflare account (for R2 storage)
- AWS account (for SES)
- Domain name for multi-tenant setup

## Installation

1. Clone the repository:
```bash
cd telodox
```

2. Install dependencies:
```bash
npm install
```

3. Copy the environment template:
```bash
cp .env.example .env
```

4. Configure your environment variables in `.env`:
```
# Supabase
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_KEY=your_supabase_service_key

# Application
APP_DOMAIN=telodox.com

# Cloudflare R2
R2_ACCOUNT_ID=your_r2_account_id
R2_ACCESS_KEY_ID=your_r2_access_key_id
R2_SECRET_ACCESS_KEY=your_r2_secret_access_key
R2_BUCKET_NAME=telodox-files
R2_PUBLIC_URL=https://files.telodox.com

# Amazon SES
SES_REGION=us-east-1
SES_ACCESS_KEY_ID=your_ses_access_key_id
SES_SECRET_ACCESS_KEY=your_ses_secret_access_key
SES_FROM_EMAIL=noreply@telodox.com
```

## Database Setup

1. Create a new Supabase project

2. Run the migration scripts in order:
```sql
-- In Supabase SQL editor, run:
-- 1. /supabase/migrations/001_initial_schema.sql
-- 2. /supabase/migrations/002_row_level_security.sql
```

3. Enable Email Auth in Supabase Authentication settings

4. Configure your domain in Supabase for multi-tenant support

## Development

Start the development server:

```bash
npm run dev
```

The application will be available at `http://localhost:3000`

## Project Structure

```
telodox/
├── assets/           # CSS and static assets
├── components/       # Vue components
│   ├── forms/       # Form-related components
│   ├── signatures/  # Signature capture components
│   ├── dashboard/   # Dashboard components
│   └── ui/          # Shared UI components
├── composables/     # Vue composables
├── layouts/         # Nuxt layouts
├── middleware/      # Route middleware
├── pages/           # Application pages
├── plugins/         # Nuxt plugins
├── server/          # Server API routes
├── stores/          # Pinia stores
├── types/           # TypeScript type definitions
└── utils/           # Utility functions
```

## Key Components

### Multi-Tenant Setup

The application uses subdomain-based multi-tenancy:
- `tenant1.telodox.com` - Tenant 1's instance
- `tenant2.telodox.com` - Tenant 2's instance

Tenant resolution happens in `middleware/tenant.global.ts`

### Authentication

- Supabase Auth handles user authentication
- Custom user profiles extend auth.users with roles
- Role-based middleware protects routes

### Form Builder

- Drag-and-drop interface in `components/forms/FormBuilder.vue`
- Support for 11 field types including signatures
- Dynamic form rendering with validation

### Workflow Engine

- Sequential document progression
- Approval gates between stages
- Configurable drip settings per tenant

## API Routes

- `/api/tenants/*` - Tenant management
- `/api/forms/*` - Form templates
- `/api/applications/*` - Application workflow
- `/api/signatures/*` - Signature handling
- `/api/files/*` - File management
- `/api/notifications/*` - Email notifications

## Deployment

1. Build the application:
```bash
npm run build
```

2. Deploy to your preferred hosting:
- Vercel (recommended)
- Netlify
- Cloudflare Pages
- Custom VPS

3. Configure DNS:
- Wildcard subdomain pointing to your deployment
- SSL certificates for subdomain support

## Security Considerations

- All data is isolated by tenant using RLS
- Signatures include IP and user agent tracking
- File uploads are scanned and validated
- API rate limiting is implemented
- CORS is configured for subdomain access

## Next Steps

1. Complete R2 file storage integration
2. Implement SES email notifications
3. Add PDF generation with signatures
4. Build analytics dashboard
5. Create mobile-responsive signature interface
6. Add webhook support for integrations

## Support

For issues and feature requests, please use the GitHub issues tracker.

## License

[Your License Here]
