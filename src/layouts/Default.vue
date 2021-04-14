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
