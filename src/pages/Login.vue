<template>
  <div class="login">
    <div>
      <form @submit.prevent="submit">
        <div>
          <label for="username">Username:</label>
          <input type="text" id="username" name="username" v-model="form.username" />
        </div>
        <div>
          <label for="password">Password:</label>
          <input type="password" id="password" name="password" v-model="form.password" />
        </div>
        <button type="submit">Submit</button>
      </form>
      <p v-if="showError" id="error">Username or Password is incorrect</p>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: "Login",
  components: {},
  methods: {
    ...mapActions(['Login']),
    async submit() {
      const User = new FormData()
      User.append('username', this.form.username)
      User.append('password', this.form.password)
      try {
        await this.Login(User);
        await this.$router.push('/')
        this.showError = false
      } catch (error) {
        this.showError = true
      }
    }
  },
  data () {
    return {
      form: {
        username: '',
        password: ''
      },
      showError: false
    }
  }
}
</script>

<style scoped>

</style>