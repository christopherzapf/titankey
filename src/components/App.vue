<template>
  <div id="app">
    <router-view
      :current-view="currentView"
      :user="user"
      :publicKey="publicKey"
    >
      </router-view>
  </div>
</template>
<!-- router-view rendert den "currentView" - siehe unten  -->
<script>
export default {
  name: 'app',
  computed: {
    ...mapState({
      hasInjectedWeb3: state => state.web3.isInjected,
      hasWeb3InjectedBrowser: state => state.user.hasWeb3InjectedBrowser,
      isConnectedToApprovedNetwork: state => state.user.isConnectedToApprovedNetwork,
      hasCoinbase: state => state.user.hasCoinbase,
      networkId: state => state.web3.networkId,
      coinbase: state => state.web3.coinbase,
      currentRoute: state => state.currentRoute,
      user: state => state.user,
      publicKey: state => state.publicKey
    }),
    currentView () {
      if (/^\/keys.+/.test(this.$route.path) && !(/^\/keys\/add/.test(this.$route.path))) return KeyTable
      switch (this.$route.path) {
        case '/home':
          return Web3Message
        case '/dashboard':
          return Profile
        case '/sign-up':
          return ProfileForm
        case '/profile/edit':
          return ProfileForm
        case '/keys':
          return Keys
        case '/keys/add':
          return AddKey
        default:
          return Web3Message
      }
    },
    isLoggedIn () {
      return this.$store.state.user.isLoggedIn
    }
  },
  components: {
    Profile,
    ProfileForm,
    Keys,
    AddKey,
    Web3Message
  },
  beforeCreate: function () {
    this.$store.dispatch(ACTION_TYPES.REGISTER_WEB3_INSTANCE)
    .then(() => {
      this.$store.dispatch(ACTION_TYPES.UPDATE_USER_BLOCKCHAIN_STATUS)
    })
    .catch((result) => {
      console.log("We've encountered problems with your Web3 connection")
    })
  },
  created: function () {
    this[ACTION_TYPES.CHANGE_CURRENT_ROUTE_TO](this.$route)
  },
  methods: {
    ...mapActions([
      ACTION_TYPES.CHANGE_CURRENT_ROUTE_TO,
      ACTION_TYPES.UPDATE_USER_BLOCKCHAIN_STATUS
    ])
  },
  watch: {
    hasInjectedWeb3: function (web3ConnectionValue) {
      console.log('hasInjectedWeb3: ', web3ConnectionValue)
    },
    networkId: function (networkId) {
      console.log('networkId: ' + networkId)
    },
    coinbase: function (coinbase) {
      console.log('coinbase: ' + coinbase)
    },
    $route: function (newRoute) {
      this[ACTION_TYPES.CHANGE_CURRENT_ROUTE_TO](newRoute)
    },
    isLoggedIn: function (newValue) {
      if (!newValue) this.$router.push('/')
    }
  }
}

import { mapState, mapActions } from 'vuex'
import { ACTION_TYPES } from '../util/constants'
import Profile from './sections/users/Profile'
import ProfileForm from './sections/users/ProfileForm'
import Keys from './sections/keys/Keys'
import AddKey from './sections/keys/KeyForm'
import KeyTable from './sections/keys/KeyTable'
import Web3Message from './sections/Web3Message'
</script>

<style lang="scss">
@import '../../scss/custom.scss';
@import '../../node_modules/bootstrap/scss/bootstrap.scss';
</style>
