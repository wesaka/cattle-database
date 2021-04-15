<template>
  <b-container fluid class="insert" :key="isBorn">
    <!--
    This is how the following works:
    There is a v-for to create all the fields based on the keys that will be present in the creation
    If the animal was born in-premises there is one ser of keys, and if they were bought there is another
    Each set of keys have the pertinent values for each origin
    This v-for has some v-if's for sorting out all the types of input and a final catchall that defaults to number
    -->
    <b-row class="my-1" v-for="field in fields" :key="field">
      <b-col sm="2">
        <label :for="`field-${field}`">{{ field }}:</label>
      </b-col>
      <b-col sm="10">
        <b-form-radio-group v-if="field === 'Origin'" id="radio-origin" v-model="isBorn">
          <b-form-radio value="true" >Born in-premises</b-form-radio>
          <b-form-radio value="false" >Bought from a third party</b-form-radio>
        </b-form-radio-group>
        <b-form-datepicker v-else-if="field === 'Birthdate' || field === 'Date received'" :id="`field-${field}`"></b-form-datepicker>
        <div v-else-if="field === 'Parents'" style="display: flex">
          <b-form-input :id="`field-${field}`" placeholder="Mother Unique ID" style="flex: 1"></b-form-input>
          <span style="flex: 0.01"></span>
          <b-form-input placeholder="Father Unique ID" style="flex: 1"></b-form-input>
          <!-- Soon this will allow for the user to select from a dropdown or something like that the parents, no need for unique IDS -->
        </div>
        <b-form-input v-else :id="`field-${field}`" :type="'number'"></b-form-input> <!-- This is the catchall -->
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
export default {
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
          'Parents'
        ]
      } else {
        this.fields = [
          'Origin',
          'Tag Number',
          'Weight at Birth',
          'Birthdate',
          'Parents'
        ]
      }
    }
  },
  data() {
    return {
      name: 'Insert',
      isBorn: "true",
      fields: [
        'Origin',
        'Tag Number',
        'Weight at Birth',
        'Birthdate',
        'Parents'
      ]
    }
  }
}
</script>

<style>
.insert {
  padding: 12px;
}
</style>