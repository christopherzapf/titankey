<template>
  <div id="key-form">
    <b-container>
      <h3>Key Management for {{ user.email }} </h3>

      <b-form @submit="submitProfileToTheBlockchain">

        <b-form-group label="Public Key:" label-for="publicKey">
          <b-form-input type="text" v-model="publicKey.key" required placeholder="Enter Public Key"></b-form-input>
        </b-form-group>

        <b-form-group label="Name:" label-for="keyName" description:"Identify your key by his name">
          <b-form-input type="text" v-model="publicKey.name" required placeholder="Enter key name"></b-form-input>
        </b-form-group>

        <b-form-group label="Currency:" label-for="currency" description:"Choose the currency of the public key">
          <b-form-input type="text" v-model="publicKey.curreny" required placeholder="Enter currency"></b-form-input>
        </b-form-group>

        <b-form-group>
          <b-form-checkbox-group v-model="publicKey.isDefault">
            <b-form-checkbox>Yes, this is my default key for this currency</b-form-checkbox>
          </b-form-checkbox-group>
        </b-form-group>

        <b-button type="submit" variant="primary">Save on blockchain</b-button>
    </b-form>
  </b-container>
</div>
</template>
<script type="text/javascript">
  export default {
    methods: {
      submitProfileToTheBlockchain (evt) {
        evt.target.disabled = true
        const userProfileData = {
          key: this.publicKey.key,
          name: this.publicKey.name,
          currency: this.publicKey.currency,
          isDefault: this.publicKey.isDefault
        }
        Keys['addPublicKeyToUser'](this.$store.state, userProfileData)
          // ZIEL: Keys gehen in den Blockchain und zurück kommt das gesamte Array mit Keys und die überschreiben den State
        .catch((err) => {
          evt.target.disabled = false
          console.error(err)
        })
        evt.target.disabled = false
      }
    },
    props: [ 'user', 'publicKey' ]
  }

  import Keys from '../../../js/Keys'

</script>

<style scoped>
</style>
