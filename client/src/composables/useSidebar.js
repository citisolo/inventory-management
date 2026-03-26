import { ref, computed } from 'vue'

// Singleton: sidebar state is shared across the entire app and persisted to localStorage
const isCollapsed = ref(localStorage.getItem('sidebar-collapsed') === 'true')
// Mobile overlay state is separate from desktop collapsed state
const isMobileOpen = ref(false)

export function useSidebar() {
  const toggleSidebar = () => {
    isCollapsed.value = !isCollapsed.value
    localStorage.setItem('sidebar-collapsed', isCollapsed.value)
  }

  const toggleMobileSidebar = () => {
    isMobileOpen.value = !isMobileOpen.value
  }

  const closeMobileSidebar = () => {
    isMobileOpen.value = false
  }

  const sidebarWidth = computed(() => isCollapsed.value ? '64px' : '240px')

  return { isCollapsed, isMobileOpen, toggleSidebar, toggleMobileSidebar, closeMobileSidebar, sidebarWidth }
}
