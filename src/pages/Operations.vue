<template>
  <Layout>
    <h1>Operations</h1>
    <p>This page is used for the majority of operations:</p>
    <ul>
      <li>Inserting new entries</li>
      <li>Updating a particular animal data</li>
      <li>Consulting data about an animal</li>
    </ul>
    <div>
      <b-button class="operations-button" v-on:click="visible = 'Insert'">Insert</b-button>
      <b-button class="operations-button" v-on:click="visible = 'Update'">Update</b-button>
      <b-button class="operations-button" v-on:click="visible = 'Lookup'">Lookup</b-button>
    </div>

    <Insert v-if="visible === 'Insert'"/>
    <p v-else-if="visible === 'Update'">Update</p>
    <p v-else-if="visible === 'Lookup'">Lookup</p>
  </Layout>
</template>

<script>
import Insert from '../components/Insert.vue'

export default {
  metaInfo: {
    title: 'About us'
  },
  components: {
    Insert
  },
  data() {
    return {
      visible: 'Insert'
    }
  }
}
</script>

<style>
.operations-button {
  margin: 0 5px;
}
</style>
