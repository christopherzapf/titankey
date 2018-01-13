<template>
  <div id="key">
    <b-container>
      <h4>Your Keys</h4>
        <img src="/static/icons/refresh.png" @click="getAllPublicKeysfromUser()" width="20px">
        <div v-if="user.hasKeys">
          <b-nav tabs v-for="_cur in publicKey.currency">
            <b-nav-item :to="{query:{ cur:_cur.cur}}">{{ _cur.cur }}</b-nav-item>

            <KeyTable
              :publicKey="publicKey"
              :cur="_cur.cur"
            />
            <b-nav-item class="active">test</b-nav-item>
          </b-nav>

        </div>
        <div v-else="user.hasKeys">
          <p>No Keys on Ethereum Blockchain for {{ user.email }} ({{ user.coinbase }}) </p>
        </div>
     </b-container>
  </div>
</template>

<script type="text/javascript">
  export default {
    name: 'keys',
    components: {
      KeyForm,
      KeyTable
    },
    methods: {
      ...mapActions([
        ACTION_TYPES.GETKEYS
      ]),
      getAllPublicKeysfromUser () {
        Keys['getPublicKeys'](this.$store.state) // Lade die Keys
        .then((userKeys) => {
          this[ACTION_TYPES.GETKEYS](userKeys) // Übergabe async die Keys an State
          .then((userKeys) => {
            console.log('getAllPublicKeysfromUser > Success')
          }) // Fehler, wenn State nicht geht
          .catch((err) => {
            console.error(err)
          }) // Fehler wenn Solidity nicht geht
        })
        .catch((err) => {
          console.error(err)
        })
      }
    },
    props: [ 'user', 'publicKey' ]
  }

  import { mapActions } from 'vuex'
  import { ACTION_TYPES } from '../../../util/constants'
  import KeyForm from '../keys/KeyForm'
  import Keys from '../../../js/Keys'
  import KeyTable from './KeyTable'

</script>

<style scoped>
</style>
