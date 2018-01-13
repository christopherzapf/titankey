<template v-if="isLoggedIn">
  <div id="profile">
    <div class="content">
      <div class="message">
        <div>
          Welcome to your Profile Page {{ user.firstName }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'profile',
    props: [ 'user' ]
  }
</script>

<style scoped>
</style>
