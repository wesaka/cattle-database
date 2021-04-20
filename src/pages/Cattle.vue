<template>
  <Layout>
    <div>
      <b-table striped hover :items="items"></b-table>
    </div>
    <div>
      <b-button block size="lg" class="mb-2" v-b-modal.add-entry-modal>
        <b-icon icon="plus-circle-fill" aria-label="Add new entry"></b-icon>
      </b-button>
    </div>
    <b-modal id="add-entry-modal" title="Add new entry">
      <Insert/>
    </b-modal>
  </Layout>
</template>

<script>
const axios = require('axios')

import { BIconPlusCircleFill } from 'bootstrap-vue'
import Insert from '../components/Insert.vue'

export default {
  metaInfo: {
    title: 'About us'
  },
  data() {
    return {
      items: []
    }
  },
  components: {
    BIconPlusCircleFill,
    Insert
  },
  mounted() {
    // TODO change the connection details to include password and user and add some more testing data

    axios.get('http://wkaa.heliohost.us/api/db_api.php').then( resp => {
      console.log(resp)
      this.items = [resp.data[0]]
    }).catch( err => {
      console.error(err)
    })
  }
}
</script>

<style>

</style>
