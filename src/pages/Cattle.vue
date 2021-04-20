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
        <b-row class="my-1" v-for="field in fields" :key="field">
          <b-col sm="4">
            <label :for="`field-${field}`">{{ field }}:</label>
          </b-col>
          <b-col sm="8">
            <b-form-radio-group v-if="field === 'Origin'" :id="`field-${field}`" v-model="isBorn">
              <b-form-radio value="true" >Born in-premises</b-form-radio>
              <b-form-radio value="false" >Bought from a third party</b-form-radio>
            </b-form-radio-group>
            <b-form-datepicker v-else-if="field === 'Birthdate' || field === 'Date received'" :id="`field-${field}`"></b-form-datepicker>
            <div v-else-if="field === 'Parents'" style="display: flex">
              <b-form-input :id="`field-${field}`" placeholder="Mother UID" style="flex: 1"></b-form-input>
              <span style="flex: 0.02"></span>
              <b-form-input :id="`field=${field}-1`" placeholder="Father UID" style="flex: 1"></b-form-input>
              <!-- Soon this will allow for the user to select from a dropdown or something like that the parents, no need for unique IDS -->
            </div>
            <b-form-input v-else :id="`field-${field}`" :type="'text'"></b-form-input> <!-- This is the catchall -->
          </b-col>
        </b-row>
      </b-container>
    </b-modal>
  </Layout>
</template>

<script>
const axios = require('axios')

import { BIconPlusCircleFill } from 'bootstrap-vue'

export default {
  metaInfo: {
    title: 'About us'
  },
  watch: {
    isBorn: function (newVal, oldVal) {
      console.log(newVal, oldVal)
      if (oldVal === "true") {
        this.fields = [
          'Origin',
          'Tag Number',
          'Price Bought',
          'Weight at Birth',
          'Weight at Reception',
          'Birthdate',
          'Date received',
          'Parents',
          'Breed'
        ]
      } else {
        this.fields = [
          'Origin',
          'Tag Number',
          'Weight at Birth',
          'Birthdate',
          'Parents',
          'Breed'
        ]
      }
    }
  },
  data() {
    return {
      items: [],
      name: 'Insert',
      isBorn: "true",
      fields: [
        'Origin',
        'Tag Number',
        'Weight at Birth',
        'Birthdate',
        'Parents',
        'Breed'
      ]
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
      // Submit the insert query
      let input_elements = document.querySelectorAll('[id^="field-"]')
      input_elements.forEach((element) => {
        console.log(element.id)
      })
      // TODO make this work as intended
      axios.post('http://awesley.atwebpages.com/test_insert.php').then( resp => {
        console.log(resp)
      }).catch( err => {
        console.error(err)
      })
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

<style>

</style>
