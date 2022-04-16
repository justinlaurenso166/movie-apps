<script setup>
import axios from "axios"
import { reactive } from "@vue/reactivity";
import { useRouter } from "vue-router"
import store from "../../store/store.js"

const router = useRouter();

// REACTIVE STATE
const data_login = reactive({
    username: "",
    password: "",
})
const error = reactive({
    show: false,
    msg: "",
})

// METHODS
const login = async()=>{
    console.log(data_login)
    try {
        await axios.post("/api/user/login", data_login).then((response)=>{
            console.log(response.data)
            if(response.status === 200){
                if(response.data[0].autorithy === 1){
                    router.push("/dashboard")
                    store.commit("MUTATE_USER_DATA", response.data)
                    store.commit("MUTATE_USER_LOGIN", true)
                }
                else{
                    error.show = true;
                    error.msg = "You have no access";
                    setTimeout(()=>{
                        error.show = false;
                    }, 3000)
                }
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
</script>

<template>
    <div class="h-screen flex items-center justify-center bg-slate-500">
        <div class="bg-white py-7 px-8 rounded-lg" style="width: 500px">
            <div>
                <h1 class="font-bold text-2xl text-center">LOGIN</h1>
            </div>
            <div class="flex flex-col mt-7">
                <form @submit.prevent="login()">
                    <input 
                        type="text" 
                        placeholder="Username.." 
                        class="w-full border-2 border-blue-400 p-2 text-lg rounded-md focus:outline-none"
                        v-model="data_login.username" 
                    />
                    <input
                        type="password" 
                        placeholder="Password..." 
                        class="w-full border-2 border-blue-400 p-2 text-lg mt-6 rounded-md focus:outline-none" 
                        v-model="data_login.password"
                    />
                    <div v-if="error.show">
                        <p class="text-red-500 font-bold text-center mt-5">{{error.msg}}</p>
                    </div>
                    <button
                        type="submit" 
                        class="w-full mt-6 text-center bg-blue-600 text-white font-semibold py-2.5 rounded-md">
                        Login
                    </button>
                </form>
            </div>
        </div>
    </div>
</template>