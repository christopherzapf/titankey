<template>
  <div id="key">
    <b-container>
      <h4>Your Keys</h4>
        <button type="button" class="btn btn-primany btn-l" @click="getAllPublicKeysfromUser()">
          <span class="glyphicon glyphicon-refresh"></span> Refresh
        </button>
        <div v-if="user.hasKeys" v-for="_cur in publicKey.currency">

          <b-card :title="_cur.cur"
            img-src="https://lorempixel.com/600/300/food/5/"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2">
            <p class="card-text">
              {{ _cur.cur }}
            </p>
            <b-button variant="primary" :to="{ name: 'keys', params: { _cur: _cur.cur }}">{{ _cur.cur }}</b-button>
          </b-card>

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
