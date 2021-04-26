<template>
  <Layout>

    <b-alert v-model="showLoginAlert" variant="danger">
      <h4 class="alert-heading"><b-icon-exclamation-circle/>   Please REGISTER OR LOGIN first (Up there >>>)</h4>
      <p>
        Loading and inserting data into the database is dependent on you being logged in.
        <br/>
        This allows for the code to know what data you own and where to put the data you input in the next pages.
        <br/>
        Navigation will remain disabled until you successfully log in or register
      </p>
      <hr>
      <p class="mb-0">
        Also, don't worry, logging in is very simple:
        <br/>
        Just input some random username and password combination in the little dropdown up there -
        if the combination isn't found in the database, it will create a new entry, if the username is found and the
        password is correct, it will log you in right away, but if the password is incorrect, it will let you go no further.
        <br/>
        <br/>
        Thanks, and I hope you enjoy the website
      </p>
    </b-alert>

    <!-- Learn how to use images here: https://gridsome.org/docs/images -->
    <h1><span style="font-size: 70px">&#128004;</span>    Ranch Manager v.0</h1>

    <h3>What is this website?</h3>
    <p>
      This website was created to host and interface with the database created by
      <a href="https://github.com/wesaka" target="_blank" rel="noopener">Alvacir Wesley Kalatai Alberti</a>,
      for the Spring 2021's Introduction to Database class at Kent State University
    </p>

  </Layout>
</template>

<script>
import {getCookie} from "../utilities/cookieManager";

export default {
  metaInfo: {
    title: 'Ranch Manager'
  },
  mounted() {
    const uidCookie = getCookie('uid')
    this.showLoginAlert = !(uidCookie !== '' && uidCookie !== null && uidCookie !== undefined)
  },
  data() {
    return {
      showLoginAlert: true
    }
  }
}
</script>

<style>
.home-links a {
  margin-right: 1rem;
}
</style>
