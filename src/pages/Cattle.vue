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
    <b-modal
        id="add-entry-modal"
        title="Add new entry"
        @ok="modalHandleOK"
    >
      <b-container fluid class="insert" :key="isBorn">
        <!--
        This is how the following works:
        There is a v-for to create all the fields based on the keys that will be present in the creation
        If the animal was born in-premises there is one ser of keys, and if they were bought there is another
        Each set of keys have the pertinent values for each origin
        This v-for has some v-if's for sorting out all the types of input and a final catchall that defaults to number
        -->
        <b-row class="my-1" v-for="field in Object.keys(fields)" :key="field">
          <b-col sm="4">
            <label :for="`field-${field}`">{{ fields[field][1] }}:</label>
          </b-col>
          <b-col sm="8">
            <b-form-radio-group v-if="field === 'origin'" :id="`field-${field}`" v-model="isBorn">
              <b-form-radio value="true" >Born in-premises</b-form-radio>
              <b-form-radio value="false" >Bought from a third party</b-form-radio>
            </b-form-radio-group>
            <b-form-datepicker v-else-if="field.includes('date')" :id="`field-${field}`" v-model="fields[field][0]"></b-form-datepicker>
            <b-form-checkbox v-else-if="field.includes('purebred')" :id="`field-${field}`" v-model="fields[field][0]"></b-form-checkbox>
            <b-form-input v-else :id="`field-${field}`" :type="'number'" v-model="fields[field][0]"></b-form-input> <!-- This is the catchall -->
          </b-col>
        </b-row>
      </b-container>
    </b-modal>
  </Layout>
</template>

<static-query>
query {
  metadata {
    DB_URL
  }
}
</static-query>

<script>
const axios = require('axios')

import { BIconPlusCircleFill } from 'bootstrap-vue'

// Using objects for the filed make it easier to get the values from the form, as we can use v-model on the objects
// The objects are structured in a way that the column name in the database is the same as the keys for the values
// The values have the label value that is going to be present in the front end and the "value value" for the key
const bornFields = {
  origin: ['', 'Origin'],
  tag: ['', 'Tag Number'],
  weight_birth: ['', 'Weight at Birth'],
  date_born: ['', 'Birthdate'],
  parent_1: ['', 'Parent 1'],
  parent_2: ['', 'Parent 2'],
  breed: ['', 'Breed'],
  purebred: ['', 'Purebred?']
}

const additionalBoughtFields = {
  price_bought: ['', 'Price Bought'],
  weight_received: ['', 'Weight at Reception'],
  date_bought: ['', 'Date received']
}

const boughtFields = {...bornFields, ...additionalBoughtFields}

export default {
  metaInfo: {
    title: 'About us'
  },
  computed: {
    db_url: function () {
      return this.$static.metadata.DB_URL
    }
  },
  watch: {
    isBorn: function (newVal, oldVal) {
      console.log(newVal, oldVal)
      if (oldVal === "true") {
        this.fields = boughtFields
      } else {
        this.fields = bornFields
      }
    }
  },
  data() {
    return {
      items: [],
      name: 'Insert',
      isBorn: "true",
      fields: bornFields
    }
  },
  components: {
    BIconPlusCircleFill
  },
  methods: {
    modalHandleOK(bvModalEvt) {
      // Prevent the modal from closing
      bvModalEvt.preventDefault()

      // Trigger the submit handler
      this.modalHandleSubmit()
    },
    modalHandleSubmit() {
      // Send the insert query with the values from fields
      let toSend = {}
      for (const key in this.fields) {
        if (this.fields[key][0] !== '' && this.fields[key][0] !== undefined) {
          toSend[key] = `'${this.fields[key][0]}'` // Send as string so it doesn't mess up the date
        }
      }

      // Manually add owner while we don't have the login TODO fix it
      toSend['owner'] = '1'

      axios.post(this.db_url + 'test_insert.php', toSend, { headers: { 'Content-Type': 'text/json' } }).then( resp => {
        console.log(resp)
      }).catch( err => {
        console.error(err)
      })
    }
  },
  mounted() {
    // TODO change the connection details to include password and user and add some more testing data

    axios.get(this.db_url + 'db_api.php').then( resp => {
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
