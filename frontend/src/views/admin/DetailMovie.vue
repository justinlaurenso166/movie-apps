<script setup>
import { reactive, ref } from "@vue/reactivity";
import Header from "../../components/admin/Header.vue"
import axios from "axios"
import { createToast } from 'mosha-vue-toastify';
import 'mosha-vue-toastify/dist/style.css'
import { useRoute, useRouter } from "vue-router";
import { onMounted } from "@vue/runtime-core";
import Rating from "vue3-star-ratings";

const router = useRouter()
const route = useRoute();

const img = ref("");
const total_rating = ref(0)
const previewImage = ref("");
const movie_data = reactive({
    img: "",
    name: "",
    description: "",
    genre: "",
    status: "",
})
const id = route.params.id;

const getMovieByid = async()=>{
    try {
        await axios.get(`/api/movies/movie/${id}`).then((res)=>{
            if(res.status === 200){
                previewImage.value = './../images/'+res.data[0].image
                movie_data.img = res.data[0].image
                movie_data.name = res.data[0].name
                movie_data.description = res.data[0].description
                movie_data.genre = res.data[0].genre
                movie_data.status = res.data[0].status
                console.log(movie_data)
                setTimeout(async()=>{
                    await getRatingById()
                },0)
            }
        })
    } catch (error) {
        console.log(error)
    }
}

const getRatingById = async()=>{
    try {
        await axios.get(`/api/movie_rating/movie/${id}`).then((res)=>{
            if(res.status === 200){
                if(res.data.length > 0){
                    let sum_rating = 0;
                    res.data.forEach((e)=>{
                        sum_rating = sum_rating += e.rating
                    })
                    total_rating.value = Math.ceil((sum_rating / res.data.length) * 10) / 10;
                }
            }
            console.log(total_rating.value)
        })
    } catch (error) {
        console.log(error)
    }
}

const uploadImage = async(e)=>{
    const file = e.target.files[0]
    movie_data.img = file
    previewImage.value = URL.createObjectURL(file)
}

const editMovie = async()=>{
    // console.log(movie_data)
    const formData = new FormData();
    formData.append('image', movie_data.img)
    formData.append('name', movie_data.name)
    formData.append('desc', movie_data.description)
    formData.append('genre', movie_data.genre)
    formData.append('status', movie_data.status)
    console.log(formData)
    try {
        await axios.put("/api/movies/edit/"+id, formData).then((res)=>{
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

onMounted(async()=>{
    await getMovieByid();
})
</script>

<template>
    <div class="bg-gray-200 h-screen">
        <div>
            <Header />
        </div>
        <div style="width: 1200px; max-height: 800px; overflow-y: auto" class="m-auto bg-white mt-7 rounded-lg shadow-lg p-5 pb-12">
            <h1 class="text-left text-2xl font-bold tracking-normal border-b-4 pb-2 uppercase">{{movie_data.name}}</h1>
            <form @submit.prevent="editMovie()" enctype="multipart/form-data" method="POST">
                <div class="flex mt-10 gap-5">
                    <div class="flex-0 w-96 m-auto text-center px-5">
                        <img v-if="previewImage" :src="`./../../images/${movie_data.img}`" class="rounded-lg">   
                    </div>
                    <div class="flex-1 pl-10 pr-20">
                        <div>
                            <h3 class="font-bold text-xl">Name</h3>
                            <p class="text-lg mt-1">{{movie_data.name}}</p>
                        </div>
                        <div class="mt-5">
                            <h3 class="font-bold text-xl">Description</h3>
                            <p class="text-lg mt-1 text-justify">{{movie_data.description}}</p>
                        </div>
                        <div class="mt-3">
                            <h3 class="font-bold text-xl">Genre</h3>
                            <p class="text-lg mt-1">{{movie_data.genre}}</p>
                        </div>
                        <div class="mt-5">
                            <h3 class="font-bold text-xl">Movie Status</h3>
                            <p class="text-lg mt-1 capitalize">{{(movie_data.status).split("_").join(" ")}}</p>
                        </div>
                        <div class="mt-5">
                            <h3 class="font-bold text-xl">Total Rating <span class="text-base ml-2 -mt-1">({{total_rating !== 0 ? total_rating : 0}} / 5)</span></h3>
                            <p class="text-lg capitalize w-56 -mt-10 -mb-7 -ml-9">
                                <Rating v-if="total_rating !== 0" v-model="total_rating"  :showControl="false"  :disableClick="true"/>
                                <Rating v-if="total_rating === 0" v-model="total_rating"  :showControl="false"  :disableClick="true"/>
                            </p>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>