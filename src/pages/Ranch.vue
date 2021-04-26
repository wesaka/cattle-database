<template>
  <Layout>
    <h2>My Ranch</h2>
    <b-container fluid class="form">
      <b-row class="my-1" v-for="field in fields" :key="field[0]">
        <b-col sm="2">
          <label :for="`field-${field[0]}`">{{ field[0] }}:</label>
        </b-col>
        <b-col sm="10">
          <b-form-datepicker v-if="field[0].includes('Date')" :id="`field-${field[0]}`" :placeholder="field[1]" v-model="values[field[2]]"></b-form-datepicker>
          <b-form-input v-else-if="field[0].includes('ID') || field[0].includes('Identification') || field[0].includes('Registration')" :placeholder="field[1]" v-model="values[field[2]]"></b-form-input>
          <b-form-input v-else :id="`field-${field[0]}`" :type="'text'" :placeholder="field[1]" v-model="values[field[2]]"></b-form-input> <!-- This is the catchall -->
        </b-col>
      </b-row>
      <b-button block v-on:click="saveRanchInfo">Save</b-button>
    </b-container>
  </Layout>
</template>

<script>

import {getCookie} from "../utilities/cookieManager";
import axios from "axios";

export default {
  metaInfo: {
    title: 'My Ranch'
  },
  methods: {
    saveRanchInfo() {
      console.log(this.values)
      // Put data to server
      // If the owner uid can't be found, alert the user that he isn't logged in
      const ownerUid = getCookie('uid')
      if (ownerUid === '' || ownerUid === null || ownerUid === undefined) {
        alert('Not logged in'); // I will use this. Really. You shouldn't be able to reach here without authentication
      } else {
        // Resume operations normally
        let toSend = {}
        toSend['uid'] = ownerUid
        for (const [key, value] of Object.entries(this.values)) {
          toSend[key] = value
        }
        console.log(JSON.stringify(toSend))
        axios.post(process.env.GRIDSOME_PRODUCTION_DB_URL + 'insert_ranch_info.php', JSON.stringify(toSend), { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).then( resp => {
          console.log(resp)
        }).catch( err => {
          console.error(err)
        })
      }
    }
  },
  mounted() {
    // Load data from the database
    const ownerUid = getCookie('uid')
    if (ownerUid === '' || ownerUid === null || ownerUid === undefined) {
      alert('Not logged in'); // I will use this. Really. You shouldn't be able to reach here without authentication
    } else {
      // Resume operations normally
      console.log('owner', ownerUid)
      axios.post(process.env.GRIDSOME_PRODUCTION_DB_URL + 'select_ranch_info.php', JSON.stringify({uid: ownerUid}), {headers: {'Content-Type': 'application/x-www-form-urlencoded'}}).then(resp => {
        console.log(resp)
        if (resp.data === null) {
          console.log('No ranch found')
        } else {
          // Populate the data fields according to what the server has sent us
          this.values = resp.data
          delete this.values['UID']
        }
      }).catch(err => {
        console.error(err)
      })
    }
  },
  data() {
    return {
      name: 'Insert',
      isBorn: "true",
      fields: [
          ['Ranch Name', 'A name for your ranch', 'ranch_name'],
          ['Local Registration Number', 'Registration number or id given by the State or local government office', 'local_registration'],
          ['Tax Number', 'A number that is used for tax purposes, if applicable', 'tax_number'],
          ['Street', 'Street or locality name', 'street'],
          ['Street Number', 'Street number of leave empty if not applicable', 'street_number'],
          ['City', 'City', 'city'],
          ['State', 'State or Province', 'state'],
          ['Country', 'Country', 'country'],
          ['Reference Point', 'If applicable', 'additional_information'],
          ['Latitude', 'Ex. -25.123456', 'latitude'],
          ['Longitude', 'The other part, i.e. -50.123456', 'longitude']
          // The fields are organized in the following way
          // Field name, placeholder
          // This is an improvement from the insert form
          // The third entry in the fields is the exact name from the columns in the database

      ],
      values: {}
    }
  }
  // It's really that simple :P
}
</script>

<style>
.form {
  padding: 12px;
}
</style>
