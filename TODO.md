# TelcoDocs TODO List

## High Priority (MVP Features)

### ✅ Completed
- [x] Supabase project setup and database migrations
- [x] User authentication and registration system
- [x] Multi-tenant database schema with RLS
- [x] Environment configuration for local development
- [x] Local subdomain testing setup
- [x] Test tenant creation
- [x] Super admin user creation
- [x] AWS Amplify deployment configuration
- [x] Production/development environment separation (.env and .env.local)
- [x] Fixed authentication redirect loop issue
- [x] Added trial functionality to tenants (7-day free trial)
- [x] Fixed dashboard loading state
- [x] Changed "Applications" to "Applicants" throughout UI
- [x] Added 404 error page with proper redirects
- [x] Improved login persistence with redirect handling

### 🚧 In Progress
- [x] Super admin dashboard (`/admin`)
  - ✅ Platform-wide tenant overview
  - ✅ Basic tenant management
  - ✅ Platform analytics and health metrics
  - [ ] Advanced user management across tenants

- [x] Self-Service Tenant Creation (Trial Version)
  - ✅ Tenant onboarding flow
  - ✅ Subdomain selection with availability check  
  - ✅ Automatic tenant owner role assignment
  - ✅ 7-day free trial setup
  - [ ] Stripe integration for paid subscriptions

### 📋 Next Up
- [ ] Dashboard UI Improvements
  - Better styling and layout
  - Mobile responsiveness
  - Trial status indicator
  - Upgrade prompts for trial users

- [ ] Tenant Management for Owners
  - Subdomain change functionality
  - Company profile editing
  - Subscription management view

- [ ] Tenant owner dashboard (`/dashboard`)
  - Tenant-specific application pipeline view
  - Form template management
  - Carrier application approval workflows
  - Tenant analytics

- [ ] Form builder interface
  - Drag-and-drop form creation
  - Field type library (text, email, file upload, signature, etc.)
  - Form validation rules
  - Sequential workflow configuration

- [ ] API routes for core functionality
  - Form template CRUD operations (`/api/forms/`)
  - Application management (`/api/applications/`)
  - User management (`/api/users/`)
  - Tenant self-service (`/api/tenants/check-subdomain`, `/api/tenants/create`)
  - Stripe integration (`/api/stripe/create-checkout`, `/api/stripe/webhook`)

## Medium Priority

### Form Submission System
- [ ] Carrier onboarding flow
  - Sequential form completion (KYC → FUSF → MSA → Interop)
  - Auto-save functionality
  - File upload handling
  - Progress tracking

### Digital Signature System
- [ ] Enhanced signature capture
  - Canvas-based signatures
  - Signature validation
  - Audit trail logging
  - PDF integration

### Email Notification System
- [ ] Amazon SES integration
- [ ] Template-based notifications
- [ ] Workflow trigger emails
- [ ] Status update notifications

### Payment System (Stripe)
- [ ] Stripe integration setup
- [ ] Subscription plans configuration
- [ ] Billing portal for tenant owners
- [ ] Usage-based pricing implementation
- [ ] Payment webhook handling
- [ ] Invoice management

## Low Priority (Future Enhancements)

### File Storage & Document Generation
- [ ] Cloudflare R2 integration
- [ ] PDF generation with embedded signatures
- [ ] Document template system
- [ ] Bulk document operations

### Advanced Features
- [ ] Advanced analytics dashboard
- [ ] Webhook system for integrations
- [ ] Mobile-responsive optimizations
- [ ] Advanced approval workflows
- [ ] Audit logging enhancements

### DevOps & Deployment
- [ ] Production deployment setup
- [ ] CI/CD pipeline
- [ ] Environment management
- [ ] Monitoring and logging
- [ ] Backup strategies

### AWS Amplify Deployment
- [ ] Configure wildcard DNS in Route 53
- [ ] Set up CloudFront distribution
- [ ] Implement Lambda@Edge for subdomain routing
- [ ] Alternative: Implement URL-based tenant routing
- [ ] SSL certificate configuration for wildcard domains

## Architecture Improvements
- [ ] Fix subdomain tenant resolution for anonymous users
- [ ] Implement proper error handling
- [ ] Add comprehensive testing suite
- [ ] Performance optimizations
- [ ] Security audit and improvements

---

## Current Sprint Focus
1. ✅ Complete super admin dashboard
2. Implement self-service tenant creation with Stripe
3. Build tenant onboarding flow
4. Create tenant management for owners
5. Build tenant owner dashboard
6. Implement basic form builder

## Definition of Done for MVP
- Users can self-register, subscribe, and create their own tenants
- Tenant owners can manage their subdomain and company settings
- Tenant owners can create forms and manage their pipeline
- End users can fill forms and submit applications
- Basic email notifications work
- Digital signatures are captured and stored
- Applications progress through approval workflow