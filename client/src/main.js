import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import Dashboard from './views/Dashboard.vue'
import Inventory from './views/Inventory.vue'
import Orders from './views/Orders.vue'
import Demand from './views/Demand.vue'
import Spending from './views/Spending.vue'
import Reports from './views/Reports.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'dashboard', component: Dashboard, meta: { titleKey: 'nav.overview' } },
    { path: '/inventory', name: 'inventory', component: Inventory, meta: { titleKey: 'nav.inventory' } },
    { path: '/orders', name: 'orders', component: Orders, meta: { titleKey: 'nav.orders' } },
    { path: '/spending', name: 'spending', component: Spending, meta: { titleKey: 'nav.finance' } },
    { path: '/demand', name: 'demand', component: Demand, meta: { titleKey: 'nav.demandForecast' } },
    { path: '/reports', name: 'reports', component: Reports, meta: { titleKey: 'nav.reports' } }
  ]
})

const app = createApp(App)
app.use(router)
app.mount('#app')
