<template>
  <div id="profile-form" class="w-50 m-auto">

    <b-container>
      <h2 class="text-center">{{ this.$route.path === '/sign-up' ? 'Sign Up' : 'Edit Profile' }}</h2>

      <b-alert show variant="info" align-self="center" dismissable>Your Public Key: {{ user.coinbase }}</b-alert>

      <b-form submit="submitProfileToTheBlockchain">

        <b-form-group label="First name:" label-for="exampleInput1">
          <b-form-input type="text" v-model="user.firstName" required placeholder="Enter first name"></b-form-input>
        </b-form-group>

        <b-form-group label="Last name:" label-for="exampleInput1">
          <b-form-input type="text" v-model="user.lastName" required placeholder="Enter last name"></b-form-input>
        </b-form-group>

        <b-form-group label="Email:" label-for="exampleInput1">
          <b-form-input type="email" v-model="user.email" required placeholder="Enter email" description="We'll never share your email with anyone else."></b-form-input>
        </b-form-group>
        <!-- @TODO WARUM WIRD DAS SCHEISS BOX NICHT ANGEZEIGT? / mit Hilfe der bootstrapVue componente -->
        <b-form-group>
            <input type="checkbox" v-model="user.emailIsName" class="titankey-control-input" id="customCheck1"></b-form-checkbox>
            <label class="custom-control-label" for="customCheck1">TitanKey</label>
        </b-form-group>
        <!-- @TODO Validation geht nicht?!?-->
        <b-button type="submit" variant="primary" @click="submitProfileToTheBlockchain">{{ this.$route.path === '/sign-up' ? 'Sign Up' : 'Edit Profile' }}</b-button>

      </b-form>
  </b-container>
  </div>
</template>

<script type="text/javascript">
  export default {
    methods: {
      ...mapActions([ // mapActions gibt ein Object zurück, dass eigentlich den gesamten "Platz" von Methods ausfüllt. Mit ... kann man noch zusätzliche Objekte hinzufügen
        ACTION_TYPES.LOGIN
      ]),
      submitProfileToTheBlockchain (evt) {
        evt.target.disabled = true
        const action = this.$route.path === '/sign-up' ? 'signup' : 'editProfile'
        const userProfileData = {
          firstName: this.user.firstName,
          lastName: this.user.lastName,
          email: this.user.email,
          emailIsName: this.user.emailIsName
        }
        Auth[action](this.$store.state, userProfileData)
        .then((userData) => {
          this[ACTION_TYPES.LOGIN](userData)
          .then((userData) => {
            evt.target.disabled = false
            console.log(action === 'signup' ? 'Signed up and logged In' : 'Successfully updated profile')
            if (this.user.email === '' || !this.user.isLoggedIn) {
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
      }
    },
    props: [ 'user' ]
  }

  import { mapActions } from 'vuex'
  import { ACTION_TYPES } from '../../../util/constants'
  import Auth from '../../../js/Auth'
</script>

<style scoped>
</style>
