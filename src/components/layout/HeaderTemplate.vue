<template>
  <div id="header-template" class="sticky header">
    <div class="content">
      <router-link to="/" class="logo"></router-link>
      <div class="mainNav">
        <router-link to="/sign-up" class="mainNavLink" v-if="!user.isLoggedIn">Sign Up</router-link> <span v-if="!user.isLoggedIn" class="divider"></span>
        <router-link to="/keys" class="mainNavLink" v-if="user.isLoggedIn">Keys</router-link> <span v-if="user.isLoggedIn" class="divider"></span>
        <input type="button" class="mainNavLink" v-if="!user.isLoggedIn" value="Login" @click="logUserIn"> <span v-if="!user.isLoggedIn" class="divider"></span>
        <router-link to="/profile/edit" class="mainNavLink" v-if="user.isLoggedIn">Edit Profile</router-link> <span v-if="user.isLoggedIn" class="divider"></span>
        <input type="button" class="mainNavLink" v-if="user.isLoggedIn" value="Logout" @click="logUserOut"> <span v-if="user.isLoggedIn" class="divider"></span>
      </div>
    </div>
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
  #header-template {
    width: 100%;
  }

  .sticky {
    position: fixed;
    padding: 5px 20px;
    top: 0px;
    height: 80px;
    background: #109F94;
    width: 100%;
    box-sizing: border-box;
    z-index: 666;
  }

  .content {
    height: 60px;
    line-height: 60px;
  }

  .logo {
    background-image: url(../../assets/titankey-logo-white.png);
    float: left;
    width: 260px;
    height: 40px;
    background-size: contain;
    background-repeat: no-repeat;
    margin: 15px 0px;
    text-decoration: none;
    color: #4d4c49;
  }

  .mainNav {
    float: right;
    margin-right: 30px;
    height: 80px;
  }

  .mainNav:before {
    content: '|||||';
    color: #fff;
    position: absolute;
    right: 20px;
    height: 20px;
    line-height: 20px;
    top: 40px;
  }

  .mainNav:hover a {
    display: block;
  }

  .mainNav a {
    display: none;
    width: 150px;
    height: 50px;
    line-height: 50px;
    font-size: 16px;
    text-decoration: none;
    text-align: center;
    position: absolute;
    right: 20px;
  }

  .mainNav a:last-child {
    border: none;
  }

  .divider {
    display: none;
    color: #fff;
  }

  .mainNavLink {
    color: #fff;
    background: transparent;
    font-size: 16px;
    border: none;
  }

  @media only screen and (min-width: 720px) {
    .mainNav:before {
      display: none;
    }

    .mainNav:hover a {
      display: inline-block;
    }

    .mainNav a:hover {
      background: transparent;
      color: #4c4e49;
    }

    .mainNav a {
      display: inline-block;
      width: auto;
      margin-top: 5px;
      color: #fff;
      border: none;
      position: relative;
      top: 0px;
      background: transparent;
      right: 0px;
    }

    .divider {
      color: #fff;
      display: inline-block;
    }

    .divider:before {
      content: "|";
    }
  }
</style>
