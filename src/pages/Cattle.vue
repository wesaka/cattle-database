<template>
  <Layout>
    <div>
      <b-table striped hover :items="items"></b-table>
    </div>
  </Layout>
</template>

<script>
const axios = require('axios')

export default {
  metaInfo: {
    title: 'About us'
  },
  data() {
    return {
      items: []
    }
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
