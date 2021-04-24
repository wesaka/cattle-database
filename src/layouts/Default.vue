<template>
  <div class="grid-container">
    <b-navbar class="navbar">
      <b-navbar-brand>Ranch Manager</b-navbar-brand>
      <b-navbar-nav class="nav">
        <g-link class="nav__link" to="/">Home</g-link>
        <g-link class="nav__link" to="/cattle/">Cattle</g-link>
        <g-link class="nav__link" to="/operations/">Operations</g-link>
        <g-link class="nav__link" to="/ranch/">Ranch Info</g-link>
      </b-navbar-nav>
      <b-navbar-nav class="nav ml-auto">
        <b-button v-if="loggedIn" :key="loggedIn" variant="outline-danger" v-on:click="eraseCredentials" href="/">Logout</b-button>
        <b-dropdown v-else text="Register or Login" ref="dropdown" @hide="controlDropdownHide" v-on:click="hideDropdown">
          <b-dropdown-form>
            <b-form-input placeholder="Username" v-model="username" @submit.stop.prevent required></b-form-input>
            <b-form-input placeholder="Password" v-model="password" class="mt-1" type="password" autocomplete="on" required></b-form-input>
            <b-button @click="login" class="mt-1">OK</b-button>
          </b-dropdown-form>
        </b-dropdown>
      </b-navbar-nav>
    </b-navbar>
    <div class="content">
      <slot/>
    </div>

    <b-modal ref="modal-incorrect-password" id="modal-incorrect-password" hide-footer>
      <template #modal-title>
        <b-icon-exclamation-circle />
        Attention
      </template>
      <div class="d-block text-center">
        <p>User already exists and the password is incorrect.</p>
      </div>
      <b-button block class="mt-3" @click="$bvModal.hide('modal-incorrect-password')">Dismiss</b-button>
    </b-modal>
  </div>
</template>

<static-query>
query {
  metadata {
    siteName
    DB_URL
  }
}
</static-query>

<script>
import axios from 'axios'
import { eraseCookie, setCookie, getCookie } from "../utilities/cookieManager"

export default {
  data() {
    return {
      username: undefined,
      password: undefined,
      okToHide: false,
      loggedIn: false
    }
  },
  mounted() {
    this.loadCredentials()
  },
  methods: {
    login() {
      const u = this.username
      const p = this.password

      if (u === undefined || u === '' || p === undefined || p === '') {
        return
      }

      axios.post(this.$static.metadata.DB_URL + 'auth.php', {db_url:this.$static.metadata.DB_URL, username:u, password:p}, { headers: { 'Content-Type': 'text/json' } }).then( resp => {
        if (resp.data === 0) {
          // If not, it means that the user already exists
          this.eraseCredentials()
          this.loggedIn = false

          // Raise an alert to the user
          this.$refs["modal-incorrect-password"].show()
        } else {
          // If the response is anything other than 0 that means we are logged in (and created a new user if it didn't exist before)!
          // The number it returns from the server is the UID of the owner - used for inserting new data in the DB
          setCookie('username', u, 1)
          setCookie('password', p, 1)
          setCookie('uid', resp.data.toString(), 1);
          this.loggedIn = true
          this.hideDropdown()

          // Calling a reload is far simpler than anything I would have to do here
          location.reload()
        }
      }).catch( err => {
        console.error(err)
      })
    },
    loadCredentials() {
      const u = getCookie('username')
      const p = getCookie('password')

      // Javascript is dumb, this is dumb
      if (u !== undefined && u !== '' && u !== null && p !== undefined && p !== '' && p !== null) {
        this.username = u;
        this.password = p;
        this.loggedIn = true
      }
    },
    eraseCredentials() {
      eraseCookie('username')
      eraseCookie('password')
      eraseCookie('uid')
      this.username = undefined
      this.password = undefined
      this.loggedIn = false
    },
    hideDropdown() {
      this.okToHide = true
      this.$refs.dropdown.hide()
      // TODO fix the dropdown hide
    },
    controlDropdownHide(bvEvent) {
      if (this.okToHide) {
        this.okToHide = false
      } else {
        bvEvent.preventDefault()
      }
    }
  }
}
</script>

<style>
body {
  font-family: -apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;
  margin:0;
  padding:0;
  line-height: 1.5;
}

.nav__link {
  margin-left: 20px;
  float: left;
  clear: left;
}

.grid-container {
  display: grid;
  grid-template-columns: 1fr;
  grid-template-rows: 0.2fr 1.8fr;
  gap: 0px 0px;
  grid-template-areas:
    "navbar"
    "content";
}

.navbar {
  grid-area: navbar;
  box-shadow: 0 1px 12px 2px rgba(0,0,0,0.5);
  -webkit-box-shadow: 0 1px 12px 2px rgba(0,0,0,0.5);
  -moz-box-shadow: 0 1px 12px 2px rgba(0,0,0,0.5);
}
.content {
  grid-area: content;
  padding: 15px;
}


</style>
