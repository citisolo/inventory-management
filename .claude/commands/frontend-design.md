---
description: Redesign a Vue 3 app's UI based on user-provided design requirements
---

# Frontend Design Skill

You are executing the `frontend-design` skill. The user has provided design requirements in their prompt (e.g., "vertical sidebar", "card layouts", "SaaS aesthetic"). Your job is to explore the existing Vue 3 app, understand its structure, then redesign the UI to match those requirements.

**Rules:**
- Do NOT add new npm dependencies -- use inline SVGs for icons, native CSS for layout
- Preserve ALL existing functionality (routing, state, events, modals, i18n, auth)
- Delegate ALL `.vue` file creation and modification to the `vue-expert` subagent
- Use `AskUserQuestion` only if you encounter genuinely ambiguous decisions you cannot resolve from context
- Follow any project-level CLAUDE.md instructions (e.g., subagent delegation rules, MCP tool usage)

---

## Phase 1: Discovery

Explore the frontend codebase to understand the current structure. Use the Explore subagent to find:

1. **Entry point & layout**: Find `App.vue` (or equivalent). Read the full file -- understand the current layout structure (top nav, sidebar, header, footer, etc.), what components it imports, and what logic lives in it (modals, state, event handlers).

2. **Router configuration**: Find where routes are defined (could be `main.js`, `router/index.js`, `router.js`, etc.). List all routes with their paths, component names, and any existing metadata.

3. **Navigation structure**: Identify how navigation is currently implemented -- top nav bar, tab bar, sidebar, drawer, etc. Note which components handle navigation (could be inline in App.vue or a separate NavBar/Header component).

4. **Shared components**: Find components used across the app -- FilterBar, ProfileMenu, LanguageSwitcher, Breadcrumbs, etc. Note their props, events, and where they're placed in the layout hierarchy.

5. **Design tokens**: Read the current styling approach -- CSS variables, color palette, spacing system, typography, border-radius conventions, shadow patterns. Check both `App.vue` global styles and any shared CSS/SCSS files.

6. **Composables & state**: List composables in use (useAuth, useFilters, useI18n, etc.) and understand which ones are relevant to the layout (e.g., a sidebar state composable may already exist).

7. **i18n**: Check if the app uses internationalization. If so, note the locale file locations and the translation key pattern for navigation labels.

Write down your findings before proceeding -- you'll reference them throughout.

---

## Phase 2: Design Mapping

Map the user's design requirements to concrete changes. For each requirement, determine:

- Which files need to change
- What new components (if any) need to be created
- What existing functionality must be preserved during the change
- What CSS/layout approach to use

**Common design patterns and how to implement them:**

### Vertical Sidebar Navigation
- Create a new `AppSidebar.vue` component (or equivalent name)
- Create a `useSidebar.js` composable for collapse/expand state (persisted to localStorage)
  - Include separate mobile state (`isMobileOpen`) for overlay behavior on small screens
- Move navigation links from the current nav component into the sidebar
- Use inline SVG icons (20x20, viewBox="0 0 24 24", stroke-based) for each nav item
- Active state: left border accent + background highlight + accent text color
- Sidebar should be `position: fixed; left: 0; top: 0; bottom: 0` with the main content using `margin-left` matching the sidebar width
- Support collapsed mode (icon-only, ~64px) and expanded mode (~240px)
- Include a collapse toggle button (chevron icon)
- Place user profile/avatar section at the bottom of the sidebar

### Top Header Bar (for sidebar layouts)
- Create a new `AppHeader.vue` component
- Display dynamic page title derived from the current route's metadata
- Move utility items (language switcher, profile menu, notifications) to the right side
- Keep it lightweight: ~56px height, subtle bottom border and shadow
- Include a mobile hamburger button (hidden on desktop, visible below 768px)

### Card Layouts
- Ensure consistent card styling: white background, subtle border (#e2e8f0), rounded corners (8-10px), consistent padding (16-20px)
- Use CSS Grid for card grids: `grid-template-columns: repeat(auto-fit, minmax(280px, 1fr))`
- Consistent hover effects: border color change + subtle shadow elevation
- Standardize card-header pattern: title on left, actions on right, bottom border separator

### Professional SaaS Aesthetic
- 8px spacing grid (all margins/paddings in multiples of 8)
- Smooth transitions on interactive elements (0.15-0.2s ease)
- Muted color palette with one accent color for active/primary states
- Clean typography hierarchy: page title > section title > card title > body > label
- Subtle shadows (avoid heavy drop shadows)
- Proper z-index layering: sidebar (100) > header (50) > sticky elements (40) > content

### Responsive Behavior
- 1024px breakpoint: auto-collapse sidebar to icon-only
- 768px breakpoint: sidebar becomes off-screen overlay with backdrop, hamburger menu in header, content takes full width

---

## Phase 3: Implementation

Execute the changes in this order. Each step should be independently functional -- if something breaks, it can be isolated.

### Step 1: Composables and utilities (direct -- no vue-expert needed)
Create any new composables needed (e.g., `useSidebar.js`). These are plain JS files.
- Add comments explaining non-obvious patterns (e.g., module-level singleton refs for shared state)

### Step 2: Route metadata (direct -- no vue-expert needed)
Add `name` and `meta.titleKey` to each route definition so new layout components can derive page titles dynamically.

### Step 3: i18n keys (direct -- no vue-expert needed)
If the app uses i18n, add any missing translation keys needed for new UI elements (e.g., sidebar labels, collapse/expand tooltips). Check for hardcoded strings in the current navigation that should use translation keys.

### Step 4: New layout components (DELEGATE TO vue-expert)
Create new components one at a time. Provide vue-expert with:
- Exact specifications (dimensions, colors, spacing, behavior)
- Which composables to import and use
- Which existing components to incorporate (e.g., ProfileMenu moves into the header)
- Event contracts (what events to emit and what the parent handles)
- Inline SVG icon paths for nav items (specify exact SVG markup -- do not leave this to guesswork)

### Step 5: Restructure the main layout (DELEGATE TO vue-expert)
Modify `App.vue` (or the layout root) to use the new components. This is the most critical step.
- Provide the exact new template structure
- List exactly which imports to add and remove
- Call out any imports/state that must NOT be removed (e.g., auth composable used by task logic)
- List all old styles to remove and new styles to add
- Ensure all existing event handlers, modals, and state management remain intact

### Step 6: Adjust dependent components (DELEGATE TO vue-expert)
Update any components whose positioning depends on the old layout (e.g., sticky elements that referenced the old header height, components with max-width constraints that should now be fluid).

### Step 7: Polish pass (DELEGATE TO vue-expert)
Review all new and modified components together for:
- Spacing consistency (8px grid)
- Transition smoothness
- z-index layering (modals > sidebar > header > sticky content)
- Collapse/expand animation cleanliness
- Check dropdown menus (profile, language) render above the sidebar

### Step 8: Responsive breakpoints (DELEGATE TO vue-expert)
Add media queries for responsive behavior. Key considerations:
- Desktop collapse and mobile overlay are SEPARATE states (different composable refs)
- Mobile sidebar needs a backdrop overlay and auto-close on navigation
- Content area margin must be overridden on mobile

---

## Phase 4: Verification

Use Playwright MCP tools to verify the redesign:

1. Navigate to the app's frontend URL and take a screenshot
2. Verify the new layout is rendered correctly (sidebar, header, content area)
3. Click each navigation link -- verify routing works and active state updates
4. Test any collapse/expand functionality
5. Verify filters, dropdowns, and other interactive elements still work
6. Verify modals still open correctly (z-index above new layout elements)
7. If i18n exists, switch language and verify new UI elements translate
8. Take a final screenshot and report results

Fix any issues found during verification before completing.
