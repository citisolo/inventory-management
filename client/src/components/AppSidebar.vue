<template>
  <div class="sidebar-backdrop" v-if="isMobileOpen" @click="closeMobileSidebar" />
  <nav
    class="sidebar"
    :class="{ collapsed: isCollapsed, 'mobile-open': isMobileOpen }"
    :style="{ width: sidebarWidth }"
  >
    <!-- 1. Logo area -->
    <div class="sidebar-logo">
      <div v-if="!isCollapsed" class="logo-full">
        <h2>{{ t('nav.companyName') }}</h2>
        <p>{{ t('nav.subtitle') }}</p>
      </div>
      <div v-else class="logo-collapsed" aria-label="Company initials">CC</div>
    </div>

    <!-- 2. Navigation links -->
    <div class="sidebar-nav">
      <router-link
        v-for="item in navItems"
        :key="item.path"
        :to="item.path"
        :class="['nav-item', { active: $route.path === item.path }]"
        @click="closeMobileSidebar"
      >
        <!-- dashboard icon -->
        <svg v-if="item.icon === 'dashboard'" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none" width="20" height="20">
          <rect x="3" y="3" width="7" height="7" rx="1"/>
          <rect x="14" y="3" width="7" height="7" rx="1"/>
          <rect x="3" y="14" width="7" height="7" rx="1"/>
          <rect x="14" y="14" width="7" height="7" rx="1"/>
        </svg>
        <!-- inventory icon -->
        <svg v-else-if="item.icon === 'inventory'" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none" width="20" height="20">
          <path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
        </svg>
        <!-- orders icon -->
        <svg v-else-if="item.icon === 'orders'" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none" width="20" height="20">
          <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
        </svg>
        <!-- finance icon -->
        <svg v-else-if="item.icon === 'finance'" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none" width="20" height="20">
          <path d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <!-- demand icon -->
        <svg v-else-if="item.icon === 'demand'" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none" width="20" height="20">
          <path d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
        </svg>
        <!-- reports icon -->
        <svg v-else-if="item.icon === 'reports'" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none" width="20" height="20">
          <path d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
        </svg>
        <span class="nav-label">{{ t(item.labelKey) }}</span>
      </router-link>
    </div>

    <!-- 3. User section -->
    <div class="sidebar-user" @click="$emit('show-profile-details')">
      <div class="user-avatar">{{ getInitials(currentUser.name) }}</div>
      <span class="user-name" v-if="!isCollapsed">{{ currentUser.name }}</span>
    </div>

    <!-- 4. Collapse toggle -->
    <button
      class="collapse-toggle"
      @click="toggleSidebar"
      :title="isCollapsed ? t('sidebar.expand') : t('sidebar.collapse')"
    >
      <!-- Chevron left when expanded, chevron right when collapsed -->
      <svg v-if="!isCollapsed" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none" width="20" height="20">
        <path d="M15 19l-7-7 7-7"/>
      </svg>
      <svg v-else viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5" fill="none" width="20" height="20">
        <path d="M9 5l7 7-7 7"/>
      </svg>
      <span class="toggle-label" v-if="!isCollapsed">{{ t('sidebar.collapse') }}</span>
    </button>
  </nav>
</template>

<script>
import { useRoute } from 'vue-router'
import { useSidebar } from '../composables/useSidebar'
import { useI18n } from '../composables/useI18n'
import { useAuth } from '../composables/useAuth'

export default {
  name: 'AppSidebar',
  emits: ['show-profile-details', 'show-tasks'],
  setup(props, { emit }) {
    const route = useRoute()

    const { isCollapsed, isMobileOpen, toggleSidebar, closeMobileSidebar, sidebarWidth } = useSidebar()
    const { t } = useI18n()
    const { currentUser, getInitials } = useAuth()

    const navItems = [
      { path: '/', labelKey: 'nav.overview', icon: 'dashboard' },
      { path: '/inventory', labelKey: 'nav.inventory', icon: 'inventory' },
      { path: '/orders', labelKey: 'nav.orders', icon: 'orders' },
      { path: '/spending', labelKey: 'nav.finance', icon: 'finance' },
      { path: '/demand', labelKey: 'nav.demandForecast', icon: 'demand' },
      { path: '/reports', labelKey: 'nav.reports', icon: 'reports' }
    ]

    return {
      route,
      isCollapsed,
      isMobileOpen,
      toggleSidebar,
      closeMobileSidebar,
      sidebarWidth,
      t,
      currentUser,
      getInitials,
      navItems
    }
  }
}
</script>

<style scoped>
.sidebar-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.3);
  z-index: 99;
  display: none; /* shown via media query */
}

.sidebar {
  position: fixed;
  left: 0;
  top: 0;
  bottom: 0;
  z-index: 100;
  background: #ffffff;
  border-right: 1px solid #e2e8f0;
  display: flex;
  flex-direction: column;
  transition: width 0.2s ease;
  overflow: hidden;
}

/* 1. Logo area */
.sidebar-logo {
  padding: 20px 16px;
  border-bottom: 1px solid #e2e8f0;
  min-height: 64px;
  display: flex;
  align-items: center;
}

.logo-full {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.logo-full h2 {
  margin: 0;
  font-size: 1rem;
  font-weight: 700;
  color: #0f172a;
  white-space: nowrap;
}

.logo-full p {
  margin: 0;
  font-size: 0.7rem;
  color: #64748b;
  white-space: nowrap;
}

.logo-collapsed {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #2563eb;
  color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 0.75rem;
  flex-shrink: 0;
}

/* 2. Navigation */
.sidebar-nav {
  flex: 1;
  padding: 12px 8px;
  display: flex;
  flex-direction: column;
  gap: 2px;
  overflow-y: auto;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  border-radius: 8px;
  text-decoration: none;
  color: #64748b;
  font-size: 0.875rem;
  font-weight: 500;
  transition: all 0.15s ease;
  position: relative;
  white-space: nowrap;
}

.nav-item:hover {
  background: #f1f5f9;
  color: #0f172a;
}

.nav-item.active {
  background: #eff6ff;
  color: #2563eb;
  border-left: 3px solid #2563eb;
  /* compensate left padding for the 3px border so icon stays aligned */
  padding-left: 9px;
}

.nav-item svg {
  flex-shrink: 0;
}

.nav-label {
  opacity: 1;
  transition: opacity 0.15s ease;
  overflow: hidden;
}

.collapsed .nav-label {
  opacity: 0;
  width: 0;
}

.collapsed .nav-item {
  justify-content: center;
  padding: 10px;
}

/* 3. User section */
.sidebar-user {
  padding: 12px 16px;
  border-top: 1px solid #e2e8f0;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.sidebar-user:hover {
  background: #f8fafc;
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #e0e7ff;
  color: #4338ca;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 0.8rem;
  flex-shrink: 0;
}

.user-name {
  font-size: 0.875rem;
  color: #334155;
  font-weight: 500;
  overflow: hidden;
  white-space: nowrap;
}

.collapsed .sidebar-user {
  justify-content: center;
  padding: 12px 8px;
}

.collapsed .user-name {
  display: none;
}

/* 4. Collapse toggle */
.collapse-toggle {
  padding: 12px 16px;
  border-top: 1px solid #f1f5f9;
  background: none;
  border-left: none;
  border-right: none;
  border-bottom: none;
  cursor: pointer;
  color: #94a3b8;
  display: flex;
  align-items: center;
  gap: 8px;
  width: 100%;
  font-size: 0.8rem;
  transition: all 0.15s ease;
}

.collapse-toggle:hover {
  background: #f1f5f9;
  color: #64748b;
}

.collapse-toggle svg {
  flex-shrink: 0;
}

.toggle-label {
  overflow: hidden;
  white-space: nowrap;
}

.collapsed .collapse-toggle {
  justify-content: center;
  padding: 12px 8px;
}

/* Responsive: tablet — force collapsed sidebar */
@media (max-width: 1024px) {
  .sidebar {
    width: 64px !important;
  }

  .nav-label,
  .user-name,
  .toggle-label,
  .logo-full {
    opacity: 0;
    width: 0;
    overflow: hidden;
  }

  .nav-item,
  .sidebar-user,
  .collapse-toggle {
    justify-content: center;
  }

  .logo-collapsed {
    display: flex !important;
  }
}

/* Responsive: mobile — sidebar becomes an overlay drawer */
@media (max-width: 768px) {
  .sidebar {
    transform: translateX(-100%);
    width: 240px !important;
  }

  .sidebar.mobile-open {
    transform: translateX(0);
  }

  .sidebar-backdrop {
    display: block;
  }

  /* restore labels when the drawer is open on mobile */
  .nav-label,
  .user-name,
  .toggle-label,
  .logo-full {
    opacity: 1;
    width: auto;
  }

  .nav-item,
  .sidebar-user,
  .collapse-toggle {
    justify-content: flex-start;
  }
}
</style>
