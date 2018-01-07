import Vue from 'vue'
import App from './components/App'
import router from './router'
import store from './store'
import 'babel-polyfill'
import Datatable from 'vue2-datatable-component'

Vue.config.devtools = true
Vue.config.productionTip = false

/* eslint-disable no-new */

Vue.use(Datatable)

new Vue({
  el: '#app',
  router,
  store,
  template: '<App />',
  components: { App }
})
