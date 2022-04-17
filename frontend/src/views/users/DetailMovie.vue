<script setup>
import { ref } from "@vue/reactivity"
import { onMounted } from "@vue/runtime-core";
import axios from "axios"
import { useRoute } from "vue-router";
import Header from "../../components/user/Header.vue"
import Rating from "vue3-star-ratings";
import { watch } from "@vue/runtime-core";
import { reactive } from "@vue/reactivity";
import store from "../../store/store"
import modal from "../../components/ModalConfirm.vue"
import { createToast } from 'mosha-vue-toastify';
import 'mosha-vue-toastify/dist/style.css'

const route = useRoute();

const movie_id = route.params.id;

//ref and reactive state;
const detail_movie = ref([]);
const showLoginBox = ref(false)
const register= ref(false)
const login = ref(true)
const showConfirmFavorite = ref(false);

const add_rating = reactive({
    rating: 0,
    user_id: "",
    movie_id: "",
})

const add_favorite = reactive({
    is_favorite: false,
    user_id: store.state.user_data === null?  "" : store.state.user_data.user_id,
    movie_id: movie_id,
})

const register_data = reactive({
    username : "",
    fullname: "",
    password: "",
    confirm_password: ""
})

const login_data = reactive({
    username: "",
    password: "",
})

const error = reactive({
    show: false,
    msg: "",
})

const getMovieByid = async()=>{
    try {
        await axios.get(`/api/movies/movie/${movie_id}`).then((res)=>{
            if(res.status === 200){
                console.log(res.data)
                detail_movie.value = res.data[0];

                if(store.state.islogin === true){
                    setTimeout(async()=>{
                        await getRating()
                        await getFavorite()
                    }, 0)
                }
            }
        })
    } catch (error) {
        console.log(error)
    }
}

const getRating = async()=>{
    let find_rating = {
        user_id: store.state.user_data.user_id,
        movie_id: movie_id,
    }
    try {
        await axios.post("/api/movie_rating/user", find_rating).then((res)=>{
            if(res.status === 200){
                if(res.data.length > 0){
                    add_rating.rating = res.data[0].rating
                }
                else{
                    add_rating.rating = 0
                }
            }
        })
    } catch (error) {
        console.log(error)
    }
}

const formatStatus = (status)=>{
    let formatted = String(status);

    formatted = formatted.split("_").join(" ")

    return formatted
}

watch(()=>add_rating.rating, async function(){
    add_rating.user_id = store.state.user_data.user_id;
    add_rating.movie_id = movie_id;
})

const addStar = async()=>{
    if(store.state.islogin === false){
        showLoginBox.value = true;
    }
    else{
        try {
        await axios.post("/api/movie_rating/rate", add_rating).then((res)=>{
            console.log(res.data)
        })
        } catch (error) {
            console.log(error)
        }
    }
}

const addFavorite = async()=>{
    console.log("add")
    setTimeout(async()=>{
        try {
            await axios.post("/api/user_favorite/add", add_favorite).then((res)=>{
            console.log(res.data)
            })
        } catch (error) {
            console.log(error)
        }
    }, 500)
}

const getFavorite = async()=>{
    let find_favorite = {
        user_id: store.state.user_data.user_id,
        movie_id: movie_id,
    }
    try {
        await axios.post("/api/user_favorite/user", find_favorite).then((res)=>{
            if(res.status === 200){
                console.log(res.data)
                if(res.data.length > 0){
                    add_favorite.is_favorite = true
                }
                else{
                    add_favorite.is_favorite = false
                }
            }
        })
    } catch (error) {
        console.log(error)
    }
}

const clearForm = () =>{
    register_data.username = ""
    register_data.fullname= ""
    register_data.password= ""
    register_data.confirm_password= ""
    login_data.username = ""
    login_data.password= ""
}

const userLogin = async()=>{
    try {
        await axios.post("/api/user/login", login_data).then((res)=>{
            if(res.status === 200){
                createToast("Login Success",{
                    type: 'success',
                    position: 'top-right',
                    transition: 'slide',
                    timeout: 3000,
                    hideProgressBar: false,
                    showIcon: true,
                })
                store.commit("MUTATE_USER_DATA", res.data);
                store.commit("MUTATE_USER_LOGIN", true);
                showLoginBox.value = false;
                register.value = false;
                login.value = true;
                setTimeout(async()=>{
                    await getMovieByid();
                },0)
            }
        })
    } catch (err) {
        if(err.response){
            error.show = true;
            error.msg = err.response.data;
            setTimeout(()=>{
                error.show = false;
            }, 3000)
        }
    }
}

const userRegister = async() => {
    try {
        if(register_data.password === register_data.confirm_password){
            await axios.post("/api/user/register", register_data).then((res)=>{
                console.log(res.data)
                if(res.status === 200){
                    createToast(res.data,{
                        type: 'success',
                        position: 'top-right',
                        transition: 'slide',
                        timeout: 3000,
                        hideProgressBar: false,
                        showIcon: true,
                    })
                    login.value = true;
                    register.value = false;
                }
            })
        }
        else{
            createToast("Password and Confirm Password is not the same",{
                type: 'danger',
                position: 'top-right',
                transition: 'slide',
                timeout: 3000,
                hideProgressBar: false,
                showIcon: true,
            })
        }
    } catch (error) {
        console.log(error)
        if(error.response){
            console.log(error.response.data)
            createToast(error.response.data,{
                    type: 'danger',
                    position: 'top-right',
                    transition: 'slide',
                    timeout: 3000,
                    hideProgressBar: false,
                    showIcon: true,
                })
        }
    }
}

watch(()=>store.state.islogin, function(){
    if(store.state.islogin === false){
        add_rating.rating = 0;
    }
})

onMounted(async()=>{
    await getMovieByid();
})

</script>

<template>
    <div class="bg-gray-200 h-screen max-h-screen overflow-y-auto">
        <Header />
        <div class="bg-white w-2/3 mt-10 m-auto shadow-lg rounded-lg p-10">
            <div class="border-b-2 border-gray-400 pb-4 flex justify-between">
                <h2 class="text-xl font-bold tracking-wide uppercase">
                    {{detail_movie.name}}
                </h2>
                <div v-if="detail_movie.status !== 'coming_soon'">
                    <img v-if="!$store.state.islogin" src="../../assets/svg/Heart.svg" class="w-10 hover:cursor-pointer" @click="showLoginBox = true;">
                    <img v-else :src="add_favorite.is_favorite ? `../../src/assets/svg/Heart_fill.svg` : `../../src/assets/svg/Heart.svg`" class="w-10 hover:cursor-pointer" @click="add_favorite.is_favorite = !add_favorite.is_favorite; addFavorite()">
                </div>
            </div>
            <div class="mt-8 flex flex-row gap-10">
                <div class="w-60 text-center flex-0">
                    <img :src="`/images/${detail_movie.image}`" class="rounded-lg">
                </div>
                <div class="text-lg flex-1 pl-4 ">
                    <div>
                        <h3 class="font-bold text-lg tracking-wide">Movie Name</h3>
                        <p class="mt-0.5">{{detail_movie.name}}</p>
                    </div>
                    <div class="mt-3">
                        <h3 class="font-bold text-lg tracking-wide">Movie Description</h3>
                        <p class="mt-0.5 text-justify">{{detail_movie.description}}</p>
                    </div>
                    <div class="mt-3">
                        <h3 class="font-bold text-lg tracking-wide">Movie Genre</h3>
                        <p class="mt-0.5">{{detail_movie.genre}}</p>
                    </div>
                    <div class="mt-3">
                        <h3 class="font-bold text-lg tracking-wide">Movie Status</h3>
                        <p class="mt-0.5 capitalize">{{formatStatus(detail_movie.status)}}</p>
                    </div>
                    <div class="mt-3" v-if="detail_movie.status !== 'coming_soon'">
                        <h3 class="font-bold text-lg tracking-wide">Rate this movie</h3>
                        <div class="capitalize w-56 -mt-10 -mb-7 -ml-9">
                            <Rating v-if="add_rating.rating === 0" v-model="add_rating.rating"  :showControl="false"  :disableClick="!$store.state.islogin" @click="addStar"/>
                            <Rating v-else :showControl="false" v-model="add_rating.rating" :disableClick="!$store.state.islogin" @click="addStar"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <modal v-if="showLoginBox">
            <template v-slot:header>
                <div class="font-bold text-xl border-b-2 pb-3 tracking-wide text-center">{{login ? "Login to your account to have access" : "Create an account"}} </div>
            </template>
            <template v-slot:body>
                <form @submit.prevent="userLogin()" @keyup.enter="userLogin()" v-if="login">
                    <div class="mt-4">
                        <h4 class="font-bold">Username</h4>
                        <input required type="text" class="w-full border-2 border-slate-500 rounded-lg focus:outline-none px-3 py-2 mt-2" placeholder="Username" v-model="login_data.username">

                        <h4 class="font-bold mt-5">Password</h4>
                        <input required type="password" class="w-full border-2 border-slate-500 rounded-lg focus:outline-none px-3 py-2 mt-2" placeholder="Password" v-model="login_data.password">

                        <p class="text-center mt-5">Don't have an account ? <span class="cursor-pointer underline font-bold" @click="register = true; login = false;">Register Now !</span></p>

                        <div v-if="error.show">
                            <p class="text-red-500 font-bold text-center mt-5">{{error.msg}}</p>
                        </div>
                    </div>
                    <div class="flex justify-between gap-5 mt-10">
                        <button type="button" class="bg-red-500 text-white w-full text-center text-lg px-2 py-1 rounded-md hover:cursor-pointer" @click="showLoginBox = false; add_rating.rating = 0; clearForm()">Cancel</button>
                        <button type="submit" class="bg-blue-600 text-white w-full text-center text-lg px-2 py-1 rounded-md hover:cursor-pointer" >Login</button>
                    </div>
                </form>

                <form @submit.prevent="userRegister()" @keyup.enter="userRegister()" v-if="register">
                    <div class="mt-4">
                        <h4 class="font-bold">Username</h4>
                        <input required type="text" class="w-full border-2 border-slate-500 rounded-lg focus:outline-none px-3 py-2 mt-2" placeholder="Username" v-model="register_data.username">

                        <h4 class="font-bold mt-5">Fullname</h4>
                        <input required type="text" class="w-full border-2 border-slate-500 rounded-lg focus:outline-none px-3 py-2 mt-2" placeholder="Username" v-model="register_data.fullname">

                        <h4 class="font-bold mt-5">Password</h4>
                        <input required type="password" class="w-full border-2 border-slate-500 rounded-lg focus:outline-none px-3 py-2 mt-2" placeholder="Password" v-model="register_data.password">

                        <h4 class="font-bold mt-5">Confirm Password</h4>
                        <input required type="password" class="w-full border-2 border-slate-500 rounded-lg focus:outline-none px-3 py-2 mt-2" placeholder="Password" v-model="register_data.confirm_password">

                        <p class="text-center mt-5">Already have an account ? <span class="cursor-pointer underline font-bold" @click="register = false; login = true;">Login Now !</span></p>
                    </div>
                    <div class="flex justify-between gap-5 mt-10">
                        <button type="button" class="bg-red-500 text-white w-full text-center text-lg px-2 py-1 rounded-md hover:cursor-pointer" @click="showLoginBox = false; login = true; register = false; add_rating.rating = 0; clearForm()">Cancel</button>
                        <button type="submit" class="bg-blue-600 text-white w-full text-center text-lg px-2 py-1 rounded-md hover:cursor-pointer" >Register</button>
                    </div>
                </form>
            </template>
        </modal>
    </div>
</template>