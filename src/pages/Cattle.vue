<template>
  <Layout>
    <div>
      <b-table striped hover :items="items" :fields="tableFields" :busy="isBusy">
        <template #table-busy>
          <div class="text-center text-danger my-2">
            <b-spinner class="align-middle"></b-spinner>
            <strong>Loading data...</strong>
          </div>
        </template>
        <template #cell(actions)="row">
          <b-button-group size="md">
            <b-button v-b-tooltip title="View Details" v-on:click="showDetails(row.item.UID)"><b-icon-eye/></b-button>
            <b-button v-b-tooltip title="Edit Entry" v-on:click="editEntry(row.item.UID)"><b-icon-pencil-square/></b-button>
            <b-button v-b-tooltip title="Sell" v-on:click="sellEntry(row.item.UID)"><b-icon-cash-stack/></b-button>
            <b-button v-b-tooltip title="Delete Entry" v-on:click="deleteEntry(row.item.UID)"><b-icon-trash/></b-button>
          </b-button-group>
        </template>
      </b-table>
    </div>
    <div>
      <b-button block size="lg" class="mb-2" @click="showEntryModal=true; disableTextFields=false; editData=false">
        <b-icon icon="plus-circle-fill" aria-label="Add new entry"></b-icon>
      </b-button>
    </div>

    <b-modal
        id="add-entry-modal"
        title="Add new entry"
        @ok="modalHandleOK"
        v-model="showEntryModal"
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
            <b-form-radio-group v-if="field === 'origin'" :id="`field-${field}`" v-model="isBorn" :disabled="disableTextFields">
              <b-form-radio value="true" >Born in-premises</b-form-radio>
              <b-form-radio value="false" >Bought from a third party</b-form-radio>
            </b-form-radio-group>
            <b-form-datepicker v-else-if="field.includes('date')" :id="`field-${field}`" v-model="fields[field][0]" :disabled="disableTextFields"></b-form-datepicker>
            <b-form-checkbox v-else-if="field.includes('purebred')" :id="`field-${field}`" v-model="fields[field][0]" :disabled="disableTextFields"></b-form-checkbox>
            <b-form-input v-else :id="`field-${field}`" :type="'number'" v-model="fields[field][0]" :disabled="disableTextFields"></b-form-input> <!-- This is the catchall -->
          </b-col>
        </b-row>
      </b-container>
    </b-modal>

    <b-modal id="sell-modal" title="Sell animal" v-model="showSellModal" @ok="handleSell" @hidden="clearSell">
      <b-row class="my-1" v-for="item in Object.keys(sellValues)" :key="item">
        <b-col sm="4">
          <label :for="`field-sell-${item}`">{{ item }}:</label>
        </b-col>
        <b-col sm="8">
          <b-form-datepicker :id="`field-sell-${item}`" v-if="item.includes('date')" v-model="sellValues[item]"></b-form-datepicker>
          <b-form-input :id="`field-sell-${item}`" v-else-if="item.includes('er')" v-model="sellValues[item]" placeholder="Enter the username of the buyer"></b-form-input>
          <b-form-input :id="`field-sell-${item}`" v-else v-model="sellValues[item]" :type="'number'"></b-form-input>
        </b-col>
      </b-row>
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
import {getCookie, setCookie, eraseCookie} from "../utilities/cookieManager";

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
  data() {
    return {
      items: [],
      tableFields: ['UID', 'tag', 'actions'],
      name: 'Insert',
      isBorn: "true",
      fields: bornFields,
      isBusy: false,
      showEntryModal: false,
      disableTextFields: false,
      editData: false,
      showSellModal: false,
      sellValues: {
        uid: undefined,
        buyer: undefined,
        date: undefined,
        price: undefined
      }
    }
  },
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
      if (newVal === "false") {
        this.fields = boughtFields
      } else {
        this.fields = bornFields
      }
    }
  },
  components: {
    BIconPlusCircleFill
  },
  methods: {
    updateTable(resp) {
      // I don't know why, but the response from server have indexes and my table doesn't play nice with them
      // So I have to do this
      let respItems = []
      resp.data.forEach(row => {
        respItems = respItems.concat(row)
      })
      this.items = respItems
      this.isBusy = false
    },
    /*** Handlers for the insert new entry modal ***/
    modalHandleOK(bvModalEvt) {
      // Prevent the modal from closing
      bvModalEvt.preventDefault()

      if (this.disableTextFields) {
        this.showEntryModal = false
        this.disableTextFields = false
        this.editData = false
      } else {
        // Trigger the submit handler
        // If "editData" is true, then run an UPDATE on server, if not, run INSERT
        this.modalHandleSubmit()
        this.clearFields()
      }
    },
    modalHandleSubmit() {
      // Send the insert query with the values from fields
      let toSend = {}
      for (const key in this.fields) {
        if (this.fields[key][0] !== '' && this.fields[key][0] !== undefined) {
          toSend[key] = `'${this.fields[key][0]}'` // Send as string so it doesn't mess up the date
        }
      }

      // Get owner id from cookies
      toSend['owner'] = getCookie('uid')

      // Append db_url for when we go on production
      toSend['db_url'] = this.$static.metadata.DB_URL

      // Check if we are editing data or inserting new one
      if (this.editData) {
        // EDITING EXISTING
        // First set editData to false, so it doesn't mess up with next data entries
        this.editData = false

        // As we are updating we need to send the uid along with the request
        // I am getting the uid from cookie because
        toSend['uid'] = getCookie('cattleUid')
        eraseCookie('cattleUid')

        axios.post(this.db_url + 'edit_cattle_entry.php', toSend, { headers: { 'Content-Type': 'text/json' } }).then( resp => {
          console.log(resp)
          // Update the data in the table according to the new data
          this.updateTable(resp)
        }).catch( err => {
          console.error(err)
        })
      } else {
        // INSERTING NEW
        axios.post(this.db_url + 'insert_data.php', toSend, { headers: { 'Content-Type': 'text/json' } }).then( resp => {
          console.log(resp)
          // Update the data in the table according to the new data
          if (resp.data === 0) {
            // Insert query unsuccessful
            console.log("Insert data failed")
          } else {
            let respItems = []
            resp.data.forEach(row => {
              console.log(row)
              respItems = respItems.concat(row)
            })
            this.items = respItems
            this.isBusy = false
          }
        }).catch( err => {
          console.error(err)
        })
      }

      // Hide the input modal and clear temp variables
      this.showEntryModal = false
      this.disableTextFields = false
      this.editData = false
      this.clearFields()
    },
    /*** Handlers for the buttons ***/
    showDetails(uid) {
      // Get the complete data from the database and show on a modal
      axios.post(this.db_url + 'select_data.php', JSON.stringify({
        db_url:this.$static.metadata.DB_URL,
        // This is done to get if the cow was bought or not - if returns 0 is bought, if 1 is born locally
        fields:`date_bought IS NULL AS origin,tag,weight_birth,date_born,parent_1,parent_2,breed,purebred`,
        uid: uid
      }), { headers: { 'Content-Type': 'application/json' } }).then( resp => {

        console.log(resp)
        let respItems = []
        resp.data.forEach(row => {
          respItems = respItems.concat(row)
        })
        this.setFields(respItems)

        // Open a modal for editing data, update on database and then return the updated data for rendering
        this.showEntryModal = true
        this.disableTextFields = true
        this.editData = false
        setCookie('cattleUid', uid)
      }).catch( err => {
        console.error(err)
      })

    },
    editEntry(uid) {
      // There are actually two operations for this
      // 1st get data from the database regarding this UID for showing to the user (that's why we can't do it all on mysql)
      // This is done so we don't need to store every single entry locally in the website (Imagine a thousand cattle)
      // 2nd is to get that data and perform an update on mysql
      axios.post(this.db_url + 'select_data.php', JSON.stringify({
        db_url:this.$static.metadata.DB_URL,
        // This is done to get if the cow was bought or not - if returns 0 is bought, if 1 is born locally
        fields:`date_bought IS NULL AS origin,tag,weight_birth,date_born,parent_1,parent_2,breed,purebred`,
        uid: uid
      }), { headers: { 'Content-Type': 'application/json' } }).then( resp => {

        console.log(resp)
        let respItems = []
        resp.data.forEach(row => {
          respItems = respItems.concat(row)
        })
        this.setFields(respItems)

        // Open a modal for editing data, update on database and then return the updated data for rendering
        this.showEntryModal = true
        this.disableTextFields = false
        this.editData = true
        setCookie('cattleUid', uid)
      }).catch( err => {
        console.error(err)
      })

    },
    deleteEntry(uid) {
      // Delete the entry in the database and return the updated data for rendering
      // DO NOT PASS THE DATABASE URL WITH THE FUNCTION - PHP IS WEIRD
      axios.post(this.db_url + 'delete_cattle_entry.php', {db_url:this.$static.metadata.DB_URL, uid:uid}, { headers: { 'Content-Type': 'application/json' } }).then( resp => {
        const response = resp.data.toString()
        // Update the data in the table according to the new data
        if (response === "1") {
          for (let i = 0; i < this.items.length; i++) {
            if (this.items[i].UID === uid) {
              this.items.splice(i, 1)
            }
          }
        }
      }).catch( err => {
        console.error(err)
      })
    },
    sellEntry(uid) {
      this.sellValues.uid = uid
      this.showSellModal = true
    },
    clearSell() {
      console.log("Clearing sell")
      this.showSellModal = false
      for (let sellValuesKey in this.sellValues) {
        this.sellValues[sellValuesKey] = undefined
      }
    },
    handleSell() {
      console.log(JSON.stringify({db_url:this.$static.metadata.DB_URL, ...this.sellValues}))
      axios.post(this.db_url + 'sell_cattle.php', JSON.stringify({db_url:this.$static.metadata.DB_URL, ...this.sellValues}), { headers: { 'Content-Type': 'application/json' } }).then( resp => {
        console.log(resp)
        // resp.data should be 1 when the transaction is sucessfull
        // Setting a new owner is responsability of the sold table transaction "update_owner"
      }).catch( err => {
        console.error(err)
      })
    },
    /*** Methods for handling the variables that make all this mess work ***/
    clearFields() {
      Object.keys(this.fields).forEach(key => {
        this.fields[key][0] = ''
      })
    },
    setFields(values) {
      console.log(values[0])
      Object.keys(values[0]).forEach(key => {
        console.log(key)
        console.log("Values key", values[0][key.toString()], "Fields key", this.fields[key.toString()])
        this.fields[key][0] = values[0][key]
      })
      console.log(this.fields)
    }
  },
  mounted() {
    this.isBusy = true

    // Sending the post request follows the following logic
    // 1st the database url, to discern if we are in production or development
    // 2nd the values JSON.stringify'ed
    // 3rd the username
    // 4th headers Content-Type application/json
    axios.post(this.db_url + 'select_data.php', JSON.stringify({db_url:this.db_url, fields:'UID,tag', username: getCookie('username')}), { headers: { 'Content-Type': 'application/json' } }).then( resp => {
      console.log(resp)
      this.updateTable(resp)
    }).catch( err => {
      console.error(err)
    })
  }
}
</script>
