<template>
  <div id="key-form">
    <h3>Key Management for {{ user.email }} </h3>
    <div class="row">
      <label for="user-public-key-key">Add your Public Key</label>
      <input type="text" id="user-public-key-key" name="user-public-key-key" v-model="publicKey.key">
    </div>

    <div class="row">
      <label for="user-public-key-name">Give your Public Key a name</label>
      <input type="text" id="user-public-key-name" name="user-public-key-name" v-model="publicKey.name">
    </div>

    <div class="row">
      <label for="user-public-key-cur">Choose the right currency</label>
      <input type="text" id="user-public-key-cur" name="user-public-key-cur" v-model="publicKey.currency">
    </div>

    <div class="row">
      <label for="user-public-key-cur">Standard Key for this currency?</label>
      <input type="checkbox" id="user-public-key-standard" name="user-public-key-standard" v-model="publicKey.isDefault">
    </div>

    <div class="row">
      <input type="button" value="Submit" @click="submitProfileToTheBlockchain">
    </div>
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
  #key-form {
    width: 100%;
    height: 420px;
    position: relative;
    top: 100px;
  }

  h3 {
    margin: auto;
    margin-bottom: 20px;
  }

  .row {
    margin-top: 20px;
    font-size: 14px;
    width: 600px;
    height: 40px;
    display: block;
    margin: auto;
  }

  label {
    height: 100%;
    line-height: 40px;
    display: inline-block;
  }

  input[type=text] {
    height: 30px;
    line-height: 30px;
    width: 200px;
    display: inline-block;
    color: #4d4c49;
    outline: none;
  }

  input {
    height: 30px;
    line-height: 30px;
    float: right;
  }
</style>
