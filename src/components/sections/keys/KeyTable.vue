<template>
  <div>
    <datatable v-bind="$data">
    </datatable>
  </div>
</template>
<script>

import Vue from 'vue'
import mockKey from './mockKeys'
import components from '../../util/vue2-datatable/'

export default {
  components,
  name: 'KeyTable', // `name` is required as a recursive component
  props: ['cur'], // from the parent FriendsTable (if exists)
  data () {
    const amINestedComp = !!this.row

    return {
      supportBackup: true,
      HeaderSettings: false,
      supportNested: true,
      pagination: false,
      pageSizeOptions: [10, 20, 50],
      columns: (() => {
        const cols = [
          { title: 'Name', field: 'name', label: 'Name', sortable: true },
          { title: 'Public key', label: 'Public Key', field: 'key' },
          { title: 'Default key', field: 'isDefault', sortable: true }
        ]
        const groupsDef = {}
        return cols.map(col => {
          Object.keys(groupsDef).forEach(groupName => {
            if (groupsDef[groupName].includes(col.title)) {
              col.group = groupName
            }
          })
          return col
        })
      })(),
      data: [],
      total: 0,
      summary: {},
      // `query` will be initialized to `{ limit: 10, offset: 0, sort: '', order: '' }` by default
      // other query conditions should be either declared explicitly in the following or set with `Vue.set / $vm.$set` manually later
      // otherwise, the new added properties would not be reactive
      query: amINestedComp ? {} : {},
      // any other staff that you want to pass to dynamic components (thComp / tdComp / nested components)
      xprops: {
        eventbus: new Vue() // only for the current Datatable instance
      }
    }
  },
  watch: {
    query: {
      handler () {
        this.handleQueryChange()
      },
      deep: false
    }
  },
  methods: {
    handleQueryChange () {
      mockKey(this.query, this.cur, this.$store.state.publicKey).then(({ rows, total, summary }) => {
        this.data = rows
        this.total = total
        this.summary = summary
      })
    }
  }
}
</script>
<style>
</style>
