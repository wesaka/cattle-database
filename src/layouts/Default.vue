<template>
  <div class="grid-container">
    <b-navbar class="navbar">
      <b-navbar-brand>Cattle Management</b-navbar-brand>
      <b-navbar-nav class="nav">
        <g-link class="nav__link" to="/">Home</g-link>
        <g-link class="nav__link" to="/cattle/">Cattle</g-link>
        <g-link class="nav__link" to="/operations/">Operations</g-link>
        <g-link class="nav__link" to="/ranch/">Ranch Info</g-link>
      </b-navbar-nav>
      <b-navbar-nav class="nav ml-auto">
        <b-button v-if="credentials" variant="outline-danger" v-on:click="logout">Logout</b-button>
        <b-dropdown v-else text="Register or Login" ref="dropdown" @hide="controlDropdownHide" v-on:click="hideDropdown">
          <b-dropdown-form>
            <b-form-input placeholder="Username" v-model="username" @submit.stop.prevent required></b-form-input>
            <b-form-input placeholder="Password" class="mt-1" v-model="password" type="password" required></b-form-input>
            <b-button @click="login" class="mt-1">OK</b-button>
          </b-dropdown-form>
        </b-dropdown>
      </b-navbar-nav>
    </b-navbar>
    <div class="content">
      <slot/>
    </div>
  </div>
</template>

<static-query>
query {
  metadata {
    siteName
  }
}
</static-query>

<script>
import { eraseCookie, setCookie, getCookie } from "../utilities/cookieManager";

export default {
  data() {
    return {
      username: undefined,
      password: undefined,
      credentials: undefined,
      okToHide: false
    }
  },
  // watch: {
  //   credentials: function () {
  //     if (this.credentials === undefined) {
  //       this.username = undefined
  //       this.password = undefined
  //     }
  //   }
  // },
  methods: {
    logout() {
      eraseCookie('username')
      eraseCookie('password')
      this.credentials = undefined
      this.username = undefined
      this.password = undefined
      console.log(this.credentials)
    },
    login() {
      setCookie('username', this.username)
      setCookie('password', this.password)

      const u = getCookie('username')
      const p = getCookie('password')

      if (u === undefined || u === '' || p === undefined || p === '') {
        return
      }

      // TODO This is where I need to set the login details and get from the database
      this.credentials = 'username:' + getCookie('username') + ';' + 'password:' + getCookie('password')
      console.log(this.credentials)

      if (this.credentials !== undefined) {
        this.hideDropdown()
      }
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
