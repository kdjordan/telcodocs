# TelcoDocs Known Issues

## 🔴 Critical Issues

### Authentication Redirect Loop (RESOLVED)
**Status:** Resolved  
**Issue:** ~~Users were getting stuck in a redirect loop when logging in on production~~  
**Solution:** ✅ Fixed tenant middleware redirect logic and added proper environment handling  
**Fixed:** 2025-06-21

### Subdomain Tenant Resolution
**Status:** Partially working, needs refinement  
**Issue:** Tenant detection for subdomains (e.g., `acme.localhost:3000`) isn't working consistently for anonymous users  
**Impact:** Users visiting tenant-specific subdomains don't see branded experience  
**Solution:** Fix middleware to properly resolve tenants on client-side for anonymous users  
**Priority:** Medium (can be addressed after core features)

## 🟡 Medium Issues

### Environment Variable Loading
**Status:** Resolved  
**Issue:** ~~APP_DOMAIN environment variable not loading properly during development~~  
**Solution:** ✅ Fixed by restarting dev server after .env changes  
**Note:** Nuxt requires server restart for .env changes

### User Registration RLS Policies
**Status:** Resolved  
**Issue:** ~~Row Level Security preventing user profile creation during registration~~  
**Solution:** ✅ Fixed with database trigger approach for automatic user profile creation

### Dashboard Loading State
**Status:** Resolved  
**Issue:** ~~Dashboard spinner wouldn't stop when no data exists~~  
**Solution:** ✅ Added proper empty state handling and loading logic  
**Fixed:** 2025-06-21

### Login Session Persistence
**Status:** Resolved  
**Issue:** ~~Users had to re-login when visiting non-existent routes~~  
**Solution:** ✅ Added redirect preservation in auth middleware and 404 error page  
**Fixed:** 2025-06-21

## 🟢 Minor Issues

### Console Warnings
**Status:** Active, low priority  
**Issue:** Supabase client initialization warnings during SSR  
**Impact:** Development console noise, no functional impact  
**Solution:** Update middleware to handle SSR gracefully  
**Priority:** Low

### Development Workflow
**Status:** Monitoring  
**Issue:** Need better hot-reload support for database schema changes  
**Impact:** Developer experience  
**Solution:** Consider Supabase CLI integration for local development

## 📝 Technical Debt

### Error Handling
**Status:** Improved  
**Issue:** Inconsistent error handling across components and API routes  
**Impact:** User experience and debugging difficulty  
**Solution:** Added error.vue page and improved auth middleware error handling  
**Next:** Implement centralized error handling pattern for API routes

### Type Safety
**Status:** Partial  
**Issue:** Some API responses and database queries lack proper TypeScript types  
**Impact:** Development experience and potential runtime errors  
**Solution:** Generate types from Supabase schema, add proper API typing

### Testing Coverage
**Status:** Missing  
**Issue:** No automated testing setup  
**Impact:** Code quality and deployment confidence  
**Solution:** Add unit tests, integration tests, and E2E tests

## 🔧 Configuration Issues

### Email Confirmation
**Status:** Configured for development  
**Issue:** Email confirmation disabled for faster development iteration  
**Impact:** Production will need email confirmation flow  
**Solution:** Implement proper email confirmation flow for production

### File Upload Limits
**Status:** Not configured  
**Issue:** No file size or type restrictions implemented  
**Impact:** Potential storage and security issues  
**Solution:** Implement proper file validation and limits

## 🚀 Performance Considerations

### Database Queries
**Status:** Basic implementation  
**Issue:** No query optimization or caching strategy  
**Impact:** Performance at scale  
**Solution:** Implement query optimization and caching layer

### Bundle Size
**Status:** Not optimized  
**Issue:** No bundle analysis or optimization  
**Impact:** Loading performance  
**Solution:** Analyze and optimize bundle size

## 🔒 Security Considerations

### Input Validation
**Status:** Basic  
**Issue:** Limited server-side input validation  
**Impact:** Security vulnerability  
**Solution:** Implement comprehensive input validation

### File Upload Security
**Status:** Not implemented  
**Issue:** No malware scanning or file type validation  
**Impact:** Security risk  
**Solution:** Implement proper file upload security measures

## 🚧 New Issues Added (2025-06-21)

### Production Environment Configuration
**Status:** Active  
**Issue:** Need separate environment configurations for dev and production  
**Solution:** ✅ Implemented .env for production and .env.local for development  
**Impact:** Proper environment-specific settings

### Trial System Implementation
**Status:** Completed  
**Issue:** Need to implement 7-day free trial instead of upfront payment  
**Solution:** ✅ Added trial_ends_at and subscription_status fields to tenants table  
**Impact:** Better user onboarding experience

### Dashboard UI Polish
**Status:** Pending  
**Issue:** Dashboard needs better styling and mobile responsiveness  
**Impact:** User experience  
**Solution:** Implement improved UI components and responsive design

---

## Issue Tracking Workflow

### Labels
- 🔴 **Critical:** Blocks core functionality
- 🟡 **Medium:** Affects user experience but has workarounds
- 🟢 **Minor:** Low impact, quality of life improvements
- 📝 **Technical Debt:** Code quality and maintainability
- 🔧 **Configuration:** Environment and setup issues
- 🚀 **Performance:** Optimization opportunities
- 🔒 **Security:** Security-related concerns

### Status Types
- **Active:** Currently being worked on
- **Monitoring:** Watching for issues
- **Resolved:** Fixed and verified
- **Needs improvement:** Known area for enhancement
- **Not implemented:** Feature not yet built

## Resolution Process
1. **Identify:** Log issue with proper categorization
2. **Prioritize:** Assign priority based on impact and effort
3. **Plan:** Add to appropriate sprint/milestone
4. **Implement:** Develop and test solution
5. **Verify:** Confirm resolution in target environment
6. **Document:** Update status and close issue