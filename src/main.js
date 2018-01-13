import Vue from 'vue'
import App from './components/App'
import router from './router'
import store from './store'
import 'babel-polyfill'
import BootstrapVue from 'bootstrap-vue/dist/bootstrap-vue.esm'
import Datatable from 'vue2-datatable-component'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.config.devtools = true
Vue.config.productionTip = false

/* eslint-disable no-new */
Vue.use(BootstrapVue)
Vue.use(Datatable)

new Vue({
  el: '#app',
  router,
  store,
  template: '<App />',
  components: { App }
})
