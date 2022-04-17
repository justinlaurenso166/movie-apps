<script setup>
import { ref } from "@vue/reactivity"
import modal from "../ModalConfirm.vue"
import store from "../../store/store"
import { reactive } from "@vue/reactivity";
import axios from "axios"
import { createToast } from 'mosha-vue-toastify';
import 'mosha-vue-toastify/dist/style.css'
import { useRouter } from "vue-router";

const router = useRouter()
const logoutBox = ref(false)
const showLoginBox = ref(false);
const register = ref(false);
const login = ref(true);
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

const logout = ()=>{
    store.dispatch("resetAllStore");
    logoutBox.value = false;
    router.push("/")
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
            }else{

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

</script>

<template>
    <div class="">
        <header class="bg-white px-8 py-8 flex justify-between shadow-lg z-50 relative">
            <h1 class="font-bold text-2xl tracking-wider hover:cursor-pointer" @click="$router.push({name:'Mainpage'})">MOVIES APP</h1>
            <div class="menu" v-if="!$store.state.islogin">
                <ul class="flex items-center gap-8 font-semibold tracking-normal capitalize">
                    <li @click="showLoginBox = true">Welcome, Guest</li>
                </ul>
            </div>
            <div class="menu" v-else>
                <ul class="flex items-center gap-8 font-semibold tracking-normal capitalize cursor-pointer">
                    <li @click="$router.push({name: 'FavoriteList'})">Favorite List</li>
                    <li>Welcome, {{$store.state.user_data.full_name}}</li>
                    <li>
                        <button @click="logoutBox = true" class="bg-red-500 text-white font-semibold py-2 px-3 rounded-xl -mt-0.5">Logout</button>
                    </li>
                </ul>
            </div>
        </header>
        <modal v-if="logoutBox">
            <template v-slot:header>
                <div class="font-bold text-xl border-b-2 pb-3 tracking-wide">Confirmation</div>
            </template>
            <template v-slot:body>
                <div class="mt-4">
                    <h2 class="text-lg tracking-wide">Are you sure to logout</h2>
                </div>
                <div class="flex justify-end gap-5 mt-10">
                    <div class="bg-red-500 text-white text-lg px-2 py-1 rounded-md hover:cursor-pointer" @click="logoutBox = false">Cancel</div>
                    <div class="bg-blue-600 text-white text-lg px-2 py-1 rounded-md hover:cursor-pointer" @click="logout()">Yes</div>
                </div>
            </template>
        </modal>
        <modal v-if="showLoginBox">
            <template v-slot:header>
                <div class="font-bold text-xl border-b-2 pb-3 tracking-wide text-center">{{login ? "Login to your account" : "Create an account"}} </div>
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
                        <button type="button" class="bg-red-500 text-white w-full text-center text-lg px-2 py-1 rounded-md hover:cursor-pointer" @click="showLoginBox = false; clearForm()">Cancel</button>
                        <button type="submit" class="bg-blue-600 text-white w-full text-center text-lg px-2 py-1 rounded-md hover:cursor-pointer" >Login</button>
                    </div>
                </form>

                <form @submit.prevent="userRegister()" v-if="register" @keyup.enter="userRegister()">
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
                        <button type="button" class="bg-red-500 text-white w-full text-center text-lg px-2 py-1 rounded-md hover:cursor-pointer" @click="showLoginBox = false; login = true; register = false; clearForm()">Cancel</button>
                        <button type="submit" class="bg-blue-600 text-white w-full text-center text-lg px-2 py-1 rounded-md hover:cursor-pointer" >Register</button>
                    </div>
                </form>
            </template>
        </modal>
    </div>
</template>