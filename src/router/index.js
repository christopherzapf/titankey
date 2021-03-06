import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Dashboard from '@/components/Dashboard'

Vue.use(Router)

export default new Router({
  routes: [
    {
      mode: 'history',
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      mode: 'history',
      path: '/home',
      component: Home
    },
    {
      mode: 'history',
      path: '/dashboard',
      component: Dashboard
    },
    {
      mode: 'history',
      path: '/sign-up',
      component: Home
    },
    {
      mode: 'history',
      path: '/keys/:_cur',
      name: 'keys',
      component: Dashboard
    },
    {
      mode: 'history',
      path: '/keys',
      component: Dashboard
    },
    {
      mode: 'history',
      path: '/keys/add',
      component: Dashboard
    },
    {
      mode: 'history',
      path: '/profile/edit',
      component: Dashboard
    }
  ]
})

// Wo wird bestimmt, welcher Route angezeigt wird? Link in der Navi; -> Verweise auf compoment: Dashboard
