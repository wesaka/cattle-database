<template>
  <div class="register">
    <div>
      <form @submit.prevent="submit">
        <div>
          <label for="username">Username:</label>
          <input type="text" id="username" name="username" v-model="form.username">
        </div>
        <div>
          <label for="full_name">Full Name:</label>
          <input type="text" id="full_name" name="full_name" v-model="form.full_name">
        </div>
        <div>
          <label for="password">Password:</label>
          <input type="password" id="password" name="password" v-model="form.password">
        </div>
        <button type="submit"> Submit</button>
      </form>
    </div>
    <p v-if="showError" id="error">Username already exists</p>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: "Register",
  components: {},
  methods: {
    ...mapActions(['Register']),
    async submit() {
      try {
        await this.Register(this.form)
        this.showError = false
      } catch (error) {
        this.showError = true
      }
    }
  },
  data() {
    return {
      form: {
        username: '',
        full_name: '',
        password: ''
      },
      showError: false
    }
  }
}
</script>

<style scoped>

</style>