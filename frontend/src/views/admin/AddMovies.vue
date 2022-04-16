<script setup>
import { reactive, ref } from "@vue/reactivity";
import Header from "../../components/admin/Header.vue"
import axios from "axios"
import { createToast } from 'mosha-vue-toastify';
import 'mosha-vue-toastify/dist/style.css'
import { useRoute, useRouter } from "vue-router";

const router = useRouter()

const img = ref("");
const previewImage = ref("");
const movie_data = reactive({
    img: "",
    name: "",
    description: "",
    genre: "",
    status: "",
})

const uploadImage = async(e)=>{
    const file = e.target.files[0]
    movie_data.img = file
    previewImage.value = URL.createObjectURL(file)
}

const addMovie = async()=>{
    // console.log(movie_data)
    const formData = new FormData();
    formData.append('image', movie_data.img)
    formData.append('name', movie_data.name)
    formData.append('desc', movie_data.description)
    formData.append('genre', movie_data.genre)
    formData.append('status', movie_data.status)
    console.log(formData)
    try {
        await axios.post("/api/movies/add_movie", formData).then((res)=>{
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
                setTimeout(()=>{
                    router.push({name:"Home"})
                },3000)
            }
        })
    } catch (err) {
        console.log(err)
    }
}
</script>

<template>
    <div class="bg-gray-200 h-screen">
        <div>
            <Header />
        </div>
        <div style="width: 1200px; max-height: 800px; overflow-y: auto" class="m-auto bg-white mt-7 rounded-lg shadow-lg p-5 pb-12">
            <h1 class="text-left text-2xl font-bold tracking-normal border-b-4 pb-2">Add Movie</h1>
            <form @submit.prevent="addMovie()" enctype="multipart/form-data" method="POST">
                <div class="flex mt-10 gap-5">
                    <div class="flex-0 w-96 text-center p-5">
                        <img v-if="previewImage" :src="previewImage">   
                        <input required type="file" name="image" accept="image/*" @change="uploadImage($event)" class="mt-5">
                    </div>
                    <div class="flex-1 pl-10">
                        <div>
                            <h3 class="font-bold text-xl">Name</h3>
                            <input 
                                name="name"
                                type="text" 
                                placeholder="Insert movie name here..." 
                                class="border w-4/6 mt-2 border-slate-500 py-2 px-2 rounded-lg focus:outline-none"
                                v-model="movie_data.name"
                            />
                        </div>
                        <div class="mt-5">
                            <h3 class="font-bold text-xl">Description</h3>
                            <textarea placeholder="Insert description..." name="desc" class="border w-4/6 mt-2 border-slate-500 py-2 px-2 rounded-lg focus:outline-none" v-model="movie_data.description"></textarea> 
                        </div>
                        <div class="mt-3">
                            <h3 class="font-bold text-xl">Genre</h3>
                            <input 
                                name="genre"
                                type="text" 
                                placeholder="Ex: Horror, Thriller, Comedy" 
                                class="border w-4/6 mt-2 border-slate-500 py-2 px-2 rounded-lg focus:outline-none"
                                v-model="movie_data.genre"
                            />
                        </div>
                        <div class="mt-5">
                            <h3 class="font-bold text-xl">Movie Status</h3>
                            <select v-model="movie_data.status" required 
                            class="border w-4/6 mt-2 border-slate-500 py-3 px-2 rounded-lg focus:outline-none">
                                <option value="" disabled>Choose Status</option>
                                <option value="premiere">Premiere</option>
                                <option value="coming_soon">Coming Soon</option>
                            </select>
                        </div>
                        <div class="mt-10">
                            <button class="w-4/6 bg-blue-500 text-white text-center text-lg p-2 rounded-full">Add</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>