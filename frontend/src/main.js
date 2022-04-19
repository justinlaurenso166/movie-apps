import { createApp } from '../node_modules/vue'
import App from './App.vue'
import Router from "../src/router/index"
import "../src/assets/css/style.css"
import store from "../src/store/store"

createApp(App).use(Router).use(store).mount('#app')