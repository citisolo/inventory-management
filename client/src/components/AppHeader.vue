<template>
  <header class="app-header">
    <div class="header-left">
      <button class="hamburger-btn" @click="$emit('toggle-sidebar')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <path d="M4 6h16M4 12h16M4 18h16"/>
        </svg>
      </button>
      <h1 class="page-title">{{ t(route.meta?.titleKey || 'nav.overview') }}</h1>
    </div>
    <div class="header-right">
      <LanguageSwitcher />
      <ProfileMenu
        @show-profile-details="$emit('show-profile-details')"
        @show-tasks="$emit('show-tasks')"
      />
    </div>
  </header>
</template>

<script>
import { useRoute } from 'vue-router'
import { useI18n } from '../composables/useI18n'
import LanguageSwitcher from './LanguageSwitcher.vue'
import ProfileMenu from './ProfileMenu.vue'

export default {
  name: 'AppHeader',
  components: { LanguageSwitcher, ProfileMenu },
  emits: ['show-profile-details', 'show-tasks', 'toggle-sidebar'],
  setup() {
    const route = useRoute()
    const { t } = useI18n()
    return { route, t }
  }
}
</script>

<style scoped>
.app-header {
  height: 56px;
  background: #ffffff;
  border-bottom: 1px solid #e2e8f0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  position: sticky;
  top: 0;
  z-index: 50;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.hamburger-btn {
  display: none; /* shown on mobile */
  align-items: center;
  justify-content: center;
  padding: 8px;
  border: none;
  background: none;
  border-radius: 6px;
  color: #64748b;
  cursor: pointer;
  transition: all 0.15s ease;
}
.hamburger-btn:hover {
  background: #f1f5f9;
  color: #0f172a;
}

.page-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #0f172a;
  letter-spacing: -0.025em;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

@media (max-width: 768px) {
  .hamburger-btn {
    display: flex;
  }
}
</style>
