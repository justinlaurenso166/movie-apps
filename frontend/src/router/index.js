import { createRouter, createWebHistory } from "vue-router";
import LoginAdmin from "../views/admin/Login.vue"
import HomeAdmin from "../views/admin/Home.vue"
import AddMovies from "../views/admin/AddMovies.vue"
import EditMovies from "../views/admin/EditMovies.vue"
import DetailMovieAdmin from "../views/admin/DetailMovie.vue"

import HomeUser from "../views/users/Home.vue"
import DetailMovie from "../views/users/DetailMovie.vue"
import FavoriteList from "../views/users/FavoriteList.vue"
import store from "../store/store";

const routes = [
    //default
    { path: '/', redirect: "/home" },
    //admin
    { path: '/admin', name: "Login", component: LoginAdmin, meta: { requireAccess: false } },
    { path: '/dashboard', name: "Home", component: HomeAdmin, meta: { requireAccess: true } },
    { path: '/add', name: "AddMovies", component: AddMovies, meta: { requireAccess: true } },
    { path: '/edit/:id', name: "EditMovies", component: EditMovies, meta: { requireAccess: true } },
    { path: '/movie/admin/:id', name: "DetailMovieAdmin", component: DetailMovieAdmin, meta: { requireAccess: true } },
    //user
    { path: '/home', name: "Mainpage", component: HomeUser, meta: { requireAccess: false } },
    { path: '/movie/:id', name: "DetailMovie", component: DetailMovie, meta: { requireAccess: false } },
    { path: '/favorite', name: "FavoriteList", component: FavoriteList, meta: { requireAccess: false } },
]

const router = createRouter({
    history: createWebHistory(),
    routes,
    scrollBehavior(to, from, last) {
        // always scroll to top when entering page
        return { top: 0 };
    },
});

router.beforeEach(function(to, from, next) {
    if (to.meta.requireAccess === true) {
        if (to.path !== "/admin" && store.state.user_data === null) {
            next("/admin")
        } else {
            if (store.state.user_data.autorithy === 1) {
                next();
            } else {
                router.go(-1)
            }
        }
    } else {
        if (store.state.user_data === null) {
            next()
        } else {
            if (to.path === "/admin" && store.state.user_data.autorithy === 1) {
                next("/dashboard")
            } else {
                next()
            }
        }
    }
});

export default router;