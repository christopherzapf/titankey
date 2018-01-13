<template>
  <component class="body-template"
    :is="currentView"
    :user="user"
    :publicKey="publicKey"
  >
  </component>
</template>

<script>
  export default {
    name: 'body-template',
    props: ['currentView', 'user', 'publicKey']
  }
</script>

<style scoped>
  .body-template {
    width: 100%;
  }
</style>
