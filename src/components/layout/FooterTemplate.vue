<template>
  <div id="footer-template">
    <b-container fluid>
      <div class="text-center">From Munich with <i class="fa fa-heart text-danger" aria-hidden="true"></i></div>
    </b-container>
  </div>
</template>

<script type="text/javascript">
  export default {
    name: 'footer-template'
  }
</script>
<style scoped>
  #footer-template{
    position: absolute;
    bottom: 0;
    width: 100%;
    height: 60px;
    line-height: 60px;
    background-color: #f5f5f5;
  }
</style>
