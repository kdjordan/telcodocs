# Local Subdomain Testing Setup

## Overview
This guide helps you test multi-tenant subdomains locally using `.localhost` domains.

## Setup Instructions

### 1. Using .localhost domains (Recommended - No hosts file needed)
Modern browsers automatically resolve `*.localhost` to 127.0.0.1, so you can use:
- `http://tenant1.localhost:3000`
- `http://tenant2.localhost:3000`
- `http://acme.localhost:3000`

### 2. Alternative: Edit hosts file (if .localhost doesn't work)
Add these entries to your hosts file:

**macOS/Linux:** `/etc/hosts`
**Windows:** `C:\Windows\System32\drivers\etc\hosts`

```
127.0.0.1   telodox.local
127.0.0.1   tenant1.telodox.local
127.0.0.1   tenant2.telodox.local
127.0.0.1   acme.telodox.local
```

Then access via:
- `http://tenant1.telodox.local:3000`
- `http://tenant2.telodox.local:3000`

## Testing Multi-tenancy

1. Create test tenants in the database
2. Access different subdomains to test tenant isolation
3. Each subdomain should show the specific tenant's data

## Environment Configuration

Update your `.env` file for local development:
```env
APP_DOMAIN=localhost:3000
```