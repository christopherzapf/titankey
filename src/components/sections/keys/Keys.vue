<template>
  <div id="key">
    <h4>Key Management for {{ user.email }} </h4>
    <router-link to="/keys/add" class="link2">Add Keys</router-link>

    <hr>
    <h4> Your Keys </h4>
      <img src="/static/icons/refresh.png" @click="getAllPublicKeysfromUser()" width="20px">
      <div v-if="user.hasKeys">
        <div v-for="_cur in publicKey.currency">
          <h5>{{ _cur.cur }}</h5>
          <KeyTable
            :publicKey="publicKey"
            :cur="_cur.cur"
          />
        </div>
      </div>
      <div v-else="user.hasKeys">
        <p>No Keys on Ethereum Blockchain for {{ user.email }} ({{ user.coinbase }}) </p>
      </div>
    <hr>

    <KeyForm
      :user="user"
      :publicKey="publicKey"
     />
  </div>
</template>

<script type="text/javascript">
  export default {
    name: 'keys',
    computed: {
      ...mapState({
        publicKey: state => state.publicKey
      })
    },
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
    props: [ 'user' ]
  }

  import { mapState, mapActions } from 'vuex'
  import { ACTION_TYPES } from '../../../util/constants'
  import KeyForm from '../keys/KeyForm'
  import Keys from '../../../js/Keys'
  import KeyTable from './KeyTable'

</script>

<style scoped>
  #key {
    width: 100%;
    text-align: center;
  }

  h3 {
    margin: auto;
    margin-bottom: 20px;
  }

  .table {
    margin-top: 20px;
    font-size: 14px;
    text-align: center;
    width: 600px;
    height: 40px;
    margin: auto;
    border: 1px solid black;
  }
</style>
