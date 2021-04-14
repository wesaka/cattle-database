<template>
  <Layout>
    <h2>Ranch Information</h2>
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
    title: 'Ranch Information'
  },
  data() {
    return {
      name: 'Insert',
      isBorn: "true",
      fields: [
          ['Owner Full Name', 'Ex. John Doe',],
          ['Owner ID Number', 'Individual or Company ID Number'],
          ['State Registration', 'Registration Given by the State for Operating the Ranch'],
          ['Land Identification Number', 'If applicable'],
          ['Address', 'Full address with street name and city or locality'],
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
