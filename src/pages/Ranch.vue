<template>
  <Layout>
    <h2>My Ranches</h2>
    <b-container fluid class="form">
      <b-row class="my-1" v-for="field in fields" :key="field[0]">
        <b-col sm="2">
          <label :for="`field-${field[0]}`">{{ field[0] }}:</label>
        </b-col>
        <b-col sm="10">
          <b-form-datepicker v-if="field[0].includes('Date')" :id="`field-${field[0]}`" :placeholder="field[1]"></b-form-datepicker>
          <b-form-input v-else-if="field[0].includes('ID') || field[0].includes('Identification') || field[0].includes('Registration')" :placeholder="field[1]"></b-form-input>
          <b-form-input v-else :id="`field-${field[0]}`" :type="'text'" :placeholder="field[1]"></b-form-input> <!-- This is the catchall -->
        </b-col>
      </b-row>
    </b-container>
  </Layout>
</template>

<script>

export default {
  metaInfo: {
    title: 'My Ranches'
  },
  data() {
    return {
      name: 'Insert',
      isBorn: "true",
      fields: [
          ['Ranch Name', 'A name for your ranch'],
          ['Local Registration Number', 'Registration number or id given by the State or local government office'],
          ['Tax Number', 'A number that is used for tax purposes, if applicable'],
          ['Street', 'Street or locality name'],
          ['Street Number', 'Street number of leave empty if not applicable'],
          ['City', 'City'],
          ['State', 'State or Province'],
          ['Country', 'Country'],
          ['Reference Point', 'If applicable'],
          ['Latitude Longitude', 'Ex. -25.123456, -50.123456'],
          ['Phone Number', 'Ex. (123)555-1234'],
          ['Establishment Date','']
          // The fields are organized in the following way
          // Field name, placeholder
          // This is an improvement from the insert form
      ]
    }
  }
}
</script>

<style>
.form {
  padding: 12px;
}
</style>
