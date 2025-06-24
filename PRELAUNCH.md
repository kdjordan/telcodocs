# TELODOX Pre-Launch Marketing Strategy

## Overview
We're implementing a pre-launch email capture system to build buzz and collect interested users before the August 1, 2025 launch date. This allows us to start marketing immediately while development continues, ensuring a strong user base ready to onboard on day one.

## Launch Strategy
- **Official Launch Date**: August 1, 2025
- **Pre-Launch Phase**: Now through July 2025
- **Goal**: Capture 500+ qualified email addresses before launch
- **Target**: 100+ signups on launch day from pre-registered users

## Technical Implementation Plan

### 1. Database Schema (Migration 006)
Create a new table to store pre-launch email addresses:

```sql
-- Email waitlist for pre-launch marketing
CREATE TABLE email_waitlist (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    source VARCHAR(100) NOT NULL, -- 'homepage', 'signup_redirect', 'manual'
    referrer TEXT, -- HTTP referrer for tracking
    metadata JSONB DEFAULT '{}', -- Additional tracking data
    ip_address INET,
    user_agent TEXT,
    subscribed_at TIMESTAMPTZ DEFAULT NOW(),
    notified_at TIMESTAMPTZ, -- When launch notification was sent
    converted_at TIMESTAMPTZ, -- When they actually signed up
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'unsubscribed', 'bounced', 'converted')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_email_waitlist_email ON email_waitlist(email);
CREATE INDEX idx_email_waitlist_source ON email_waitlist(source);
CREATE INDEX idx_email_waitlist_status ON email_waitlist(status);
CREATE INDEX idx_email_waitlist_subscribed_at ON email_waitlist(subscribed_at);
```

### 2. New Routes & Pages
- `/early-access` - Main email capture page (redirect destination)
- `/api/early-access` - API endpoint to handle email submissions
- Update homepage with launch date section

### 3. Email Capture Flow
1. User clicks existing "Sign Up" or "Get Started" buttons
2. Redirect to `/early-access` page with clean messaging
3. Capture email with launch date expectations
4. Store in `email_waitlist` table with source tracking
5. Show success message with next steps

### 4. Homepage Updates
Add a prominent section with:
- Launch date announcement
- Value proposition reminder
- Email capture form
- Social proof elements (when available)

### 5. Testing Strategy
- Manual URL access for development testing
- Separate test environment variables
- Email validation and duplicate handling
- Analytics tracking for conversion optimization

## Content Strategy

### Key Messages
1. **Timing**: "Launching August 1, 2025"
2. **Value**: "Transform telecom carrier onboarding from email chaos to streamlined deal flow"
3. **Exclusivity**: "Be among the first to experience the future of telecom onboarding"
4. **Social Proof**: "Join hundreds of industry professionals already waiting"

### Email Capture Page Copy
**Headline**: "The Future of Telecom Onboarding is Almost Here"
**Subheading**: "TELODOX launches August 1, 2025. Be the first to know when early access begins."
**Benefits List**:
- Streamline carrier onboarding with intelligent document processing
- Eliminate email chaos with collaborative team workflows
- Accelerate deal cycles with professional MSA redlining tools
- Transform your telecom operations with the industry's first purpose-built platform

### Homepage Launch Section
**Announcement**: "🚀 Coming August 1, 2025"
**CTA**: "Get notified when we launch"
**Description**: "Join the waitlist to be among the first telecom professionals to experience streamlined carrier onboarding."

## Marketing Channels
1. **Direct**: Homepage and signup redirects
2. **Social**: LinkedIn posts about launch date
3. **Industry**: Telecom forums and communities
4. **Network**: Personal/professional connections
5. **Content**: Blog posts about telecom pain points

## Analytics & Tracking
- Email capture conversion rates by source
- Homepage engagement metrics
- Social media referral tracking
- Geographic distribution of interest
- Industry role/company size data (optional form fields)

## Email Marketing Plan
### Pre-Launch Sequence (July 2025)
1. **Week 1**: "3 weeks until launch" - feature preview
2. **Week 2**: "2 weeks until launch" - behind the scenes
3. **Week 3**: "1 week until launch" - final preparations
4. **Launch Day**: "TELODOX is live!" - direct signup link

### Post-Launch Follow-up
- Day 1: Welcome and onboarding guidance
- Day 7: Check-in and feature highlight
- Day 30: Success stories and advanced features

## Success Metrics
- **Pre-Launch**: 500+ email addresses captured
- **Launch Conversion**: 20%+ of waitlist converts to trial
- **Source Attribution**: Track which channels drive highest quality signups
- **Timeline**: All infrastructure ready by end of week

## Risk Mitigation
- **Email Deliverability**: Use professional email service (AWS SES)
- **Spam Prevention**: Implement proper opt-in processes
- **Data Privacy**: GDPR/privacy policy compliance
- **Technical Issues**: Backup email capture methods
- **Launch Delays**: Flexible communication if date shifts

## Next Steps Priority Order
1. **Database Migration** - Add email_waitlist table
2. **Email Capture Page** - Build `/early-access` route and page
3. **API Endpoint** - Handle email submissions with validation
4. **Button Redirects** - Update all signup/get started buttons
5. **Homepage Section** - Add launch announcement area with email capture
6. **Testing Setup** - Manual testing approach and validation
7. **Analytics** - Track conversions and optimize
8. **Email Service** - AWS SES integration for notifications
9. **Legal Compliance** - Privacy policy and terms updates
10. **Launch Campaign** - Social media and marketing content

---

*This document serves as the single source of truth for our pre-launch strategy. All team members should reference this for implementation details and timeline expectations.*