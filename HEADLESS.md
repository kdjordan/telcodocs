# TELODOX UI Migration: Headless UI + Tailwind 3

## Overview
Migrating from the current mixed UI approach (NuxtUI + PrimeVue + Custom) to a clean, consistent Headless UI + Tailwind 3 implementation. This includes downgrading from the unstable Tailwind 4 to the production-ready Tailwind 3.

## Current State Analysis
- **NuxtUI**: 2% usage (only UApp wrapper and useToast)
- **PrimeVue**: 3% usage (only in /pages/auth/reset-password.vue and /pages/admin/users.vue)
- **Custom Components**: 95% usage (already built and working)

## Migration Strategy

### Phase 1: Setup & Dependencies (30 minutes)
1. **Install Headless UI and vue-sonner**
   ```bash
   npm install @headlessui/vue vue-sonner
   ```

2. **Downgrade to Tailwind CSS 3**
   ```bash
   npm uninstall tailwindcss @tailwindcss/postcss
   npm install tailwindcss@^3.4.0 @tailwindcss/forms@^0.5.7 @tailwindcss/typography@^0.5.10
   ```

3. **Remove unused dependencies**
   ```bash
   npm uninstall @nuxt/ui primevue @primevue/themes
   ```

4. **Update nuxt.config.ts**
   - Remove '@nuxt/ui' from modules
   - Remove any PrimeVue configuration
   - Ensure Tailwind 3 compatible config

5. **Update tailwind.config.js**
   - Migrate any Tailwind 4 specific syntax back to v3
   - Ensure custom colors and theme work with v3

### Phase 2: Create Headless UI Wrapper Components (1 day)

Create standardized wrapper components that match current design system:

1. **`/components/ui/HeadlessSelect.vue`**
   - Wraps Headless UI Listbox
   - Applies dark theme styling
   - Matches current form input design

2. **`/components/ui/HeadlessCombobox.vue`**
   - Searchable select using Combobox
   - Includes loading states and empty states

3. **`/components/ui/HeadlessModal.vue`**
   - Replaces any modal/dialog needs
   - Dark overlay, smooth transitions

4. **`/components/ui/HeadlessDropdown.vue`**
   - Replaces UserMenuDropdown implementation
   - Uses Menu component

5. **Toast System with vue-sonner**
   - No wrapper needed - use directly
   - Headless by default, perfect for our dark theme
   - Replaces useToast from NuxtUI

### Phase 3: Migration Tasks (2-3 days)

#### 3.1 Remove NuxtUI (2 hours)
- **`/app.vue`**: Remove `<UApp>` wrapper, replace with simple `<div id="app">`
- **Toast notifications**: Set up vue-sonner with dark theme

#### 3.2 Refactor PrimeVue Pages (1 day)
- **`/pages/auth/reset-password.vue`**:
  - Replace PrimeVue Card → Custom card component
  - Replace Password component → Standard input with show/hide toggle
  - Replace Button → Existing GlowButton component
  
- **`/pages/admin/users.vue`**:
  - Replace DataTable → Custom `DataTable.vue` component
  - Build simple, clean table with sorting and filtering
  - Match existing dark theme aesthetic

#### 3.3 Update Existing Components (1 day)
- Audit all form inputs across the app
- Replace basic selects with HeadlessSelect
- Update dropdowns to use HeadlessDropdown
- Ensure consistent styling

### Phase 4: Component Inventory & Standardization (1 day)

1. **Document all UI components** in `/components/ui/README.md`
2. **Create component showcase** at `/pages/styleguide.vue`
3. **Establish patterns**:
   - Form components: HeadlessSelect, inputs, checkboxes
   - Feedback: HeadlessToast, loading states
   - Overlays: HeadlessModal, HeadlessDropdown
   - Layout: Existing card system, grids

### Phase 5: Testing & Cleanup (4 hours)
1. Test all interactive components for:
   - Keyboard navigation
   - Screen reader compatibility
   - Mobile touch interactions
2. Remove any orphaned styles
3. Update component imports across codebase
4. Run build and check for errors

## Implementation Checklist

### Dependencies
- [ ] Install @headlessui/vue
- [ ] Install vue-sonner
- [ ] Downgrade to Tailwind CSS 3.4.x
- [ ] Remove @nuxt/ui from package.json
- [ ] Remove primevue and @primevue/themes
- [ ] Update nuxt.config.ts
- [ ] Update tailwind.config.js for v3 syntax

### Component Creation
- [ ] Create HeadlessSelect.vue
- [ ] Create HeadlessCombobox.vue
- [ ] Create HeadlessModal.vue
- [ ] Create HeadlessDropdown.vue
- [ ] Create DataTable.vue (custom table component)
- [ ] Configure vue-sonner for dark theme

### Page Migrations
- [ ] Migrate /app.vue (remove UApp)
- [ ] Migrate /pages/auth/reset-password.vue
- [ ] Migrate /pages/admin/users.vue
- [ ] Update toast usage throughout

### Documentation
- [ ] Create /components/ui/README.md
- [ ] Build /pages/styleguide.vue showcase
- [ ] Update CLAUDE.md with new UI approach

### Quality Assurance
- [ ] Test all form interactions
- [ ] Verify accessibility with keyboard
- [ ] Check mobile interactions
- [ ] Run full build
- [ ] Check bundle size improvement

## Expected Outcomes

### Bundle Size
- **Before**: ~450KB (with unused UI libraries + Tailwind 4 alpha)
- **After**: ~320KB (25-30KB for Headless UI + stable Tailwind 3)
- **Savings**: ~130KB (29% reduction)

### Developer Experience
- Single source of truth for UI components
- No style conflicts between libraries
- Full control over component appearance
- Consistent dark theme throughout

### Maintenance
- Fewer dependencies to update
- Clearer component ownership
- Easier to onboard new developers
- Better alignment with custom design system

## Migration Notes

### Library Choices Rationale

**vue-sonner for Toasts**
- Headless by default - perfect for custom styling
- Lightweight (12KB gzipped)
- Great DX with promise-based API
- Matches our "control the UI" philosophy

**Custom DataTable Component**
- Full control over styling and behavior
- No unnecessary features or bundle bloat
- Can optimize for our specific use cases
- Consistent with our 95% custom approach

### Key Headless UI Components We'll Use
1. **Listbox** - Custom styled selects
2. **Combobox** - Searchable/filterable selects
3. **Dialog** - Modals and confirmations
4. **Menu** - Dropdowns and context menus
5. **Disclosure** - Accordions/collapsibles (if needed)
6. **Switch** - Toggle switches (if needed)

### Components We'll Keep Custom
- Buttons (GlowButton)
- Cards (bento-card, dark-card)
- Inputs (existing styled inputs)
- Tables (DataTable.vue - new custom component)
- Navigation (existing NavItem components)
- Toasts (using vue-sonner with custom styling)

### Styling Approach
- Headless UI provides unstyled, accessible components
- We apply our existing Tailwind classes
- Dark theme by default
- Consistent with current design language:
  - Dark backgrounds (#28282B, #1a1a1a)
  - Accent color (#22D3EE)
  - Smooth transitions
  - No borders, subtle shadows

## Code Patterns

### Example: HeadlessSelect Pattern
```vue
<!-- Before (if using PrimeVue) -->
<Dropdown v-model="selected" :options="options" />

<!-- After (with Headless UI) -->
<HeadlessSelect v-model="selected" :options="options" />
```

### Example: Toast Notifications with vue-sonner
```vue
<!-- Before (NuxtUI) -->
<script setup>
const toast = useToast()
toast.add({ title: 'Success!' })
</script>

<!-- After (vue-sonner) -->
<script setup>
import { toast } from 'vue-sonner'
toast.success('Success!')
</script>
```

Our wrapper will handle:
- Dark theme styling
- Consistent padding/sizing
- Error states
- Loading states
- Keyboard navigation (from Headless UI)
- Accessibility (from Headless UI)

This approach gives us the best of both worlds: battle-tested accessibility and interaction patterns from Headless UI, with complete control over the visual design to match our custom dark aesthetic.