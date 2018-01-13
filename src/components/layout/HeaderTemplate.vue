<template>
  <div id="header-template">
      <b-navbar type="light" sticky variant="primary" toggleable class="navbar-static-top">

        <b-navbar-brand to="/" class="d-block">
          <img src="../../assets/titankey-logo-white.png" alt="TITANKEY" height="36px" class="align-middle mt-2">
        </b-navbar-brand>

        <b-navbar-nav class="mr-auto" v-if="user.isLoggedIn">
          <b-nav-item-dropdown>
            <template slot="button-content">Keys</template>
            <b-dropdown-item to="/keys">Overview</b-dropdown-item>
            <b-dropdown-item to="/keys/add">Add Keys</b-dropdown-item>
          </b-nav-item-dropdown>
        </b-navbar-nav>

        <b-navbar-nav class="ml-auto mr-5">
          <b-nav-item-dropdown v-if="user.isLoggedIn">

            <template slot="button-content">
              <span class="glyphicon glyphicon-user pr-2"></span><span class="align-middle username"> {{ user.firstName }}</span>
            </template>

            <b-dropdown-item v-if="user.isLoggedIn" @click="logUserOut">Logout</b-dropdown-item>
            <b-dropdown-item to="/profile/edit" v-if="user.isLoggedIn">Edit Profile</b-dropdown-item>
          </b-nav-item-dropdown>
          <b-nav-item v-if="!user.isLoggedIn" @click="logUserIn">Login via MegaMask</b-nav-item>
          <b-nav-item to="/sign-up" v-if="!user.isLoggedIn">Sign Up</b-nav-item>
        </b-navbar-nav>

      </b-navbar>
  </div>
</template>

<script type="text/javascript">
  export default {
    name: 'header-template',
    methods: {
      ...mapActions([
        ACTION_TYPES.LOGIN,
        ACTION_TYPES.LOGOUT
      ]),
      logUserIn (evt) { // evt = die event variable im DOM Tree (tag z.b tag name)
        evt.target.disabled = true
        if (!this.user.isLoggedIn) {
          Auth.login(this.$store.state) // Start des Logins, Übergabe an Auth, dann zurück und an mutation
          .then((userData) => {
            this[ACTION_TYPES.LOGIN](userData)
            .then((userData) => {
              evt.target.disabled = false
              if (!this.user.isLoggedIn) {
                this.$router.push('/')
              } else {
                this.$router.push('/dashboard')
              }
            })
            .catch((err) => {
              evt.target.disabled = false
              console.error(err)
            })
          })
          .catch((err) => {
            evt.target.disabled = false
            console.error(err)
          })
        } else {
          evt.target.disabled = false
        }
      },
      logUserOut (evt) {
        evt.target.disabled = true
        this[ACTION_TYPES.LOGOUT]()
        .then(() => {
          evt.target.disabled = false
          this.$router.push('/')
        })
      }
    },
    props: [ 'user' ]
  }

  import { mapActions } from 'vuex'
  import Auth from '../../js/Auth'
  import { ACTION_TYPES } from '../../util/constants'
</script>

<style scoped>
span.glyphicon-user {
  font-size: 1.3em;
  color: #fff;
}
.nav-link.active {
  font-weight: bold;
}
.username {
  text-transform: capitalize;
}
</style>
