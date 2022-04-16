<script setup>
import Header from "../../components/user/Header.vue"
 // Import Swiper Vue.js components
import { Swiper, SwiperSlide } from 'swiper/vue';
import 'swiper/css';
import "swiper/css/pagination";
import { Pagination, Autoplay } from "swiper";
import axios from "axios"
import { onMounted } from "@vue/runtime-core";
import { ref } from "@vue/reactivity";

const modules = [Autoplay,Pagination]

const premiere_movie_limit = ref([]);
const upcoming_movie_limit = ref([]);

const getPremiereMovie = async()=>{
    try {
        await axios.get("/api/movies/premiere").then((res)=>{
            if(res.status === 200){
                console.log(res.data)
                premiere_movie_limit.value = res.data;
            }
        })
    } catch (error) {
        console.log(error)
    }
}

const getUpcomingMovie = async()=>{
    try {
        await axios.get("/api/movies/coming_soon").then((res)=>{
            if(res.status === 200){
                console.log(res.data)
                upcoming_movie_limit.value = res.data;
            }
        })
    } catch (error) {
        console.log(error)
    }
}

onMounted(async()=>{
    await getPremiereMovie();
    await getUpcomingMovie();
})

</script>

<style scoped>

</style>

<template>
    <div class="bg-gray-200 h-screen max-h-screen overflow-y-auto">
        <Header />
        <div class="bg-white pt-10 pb-6">
            <div class="w-3/4 m-auto flex flex-col gap-5">
                <div class="flex justify-between border-b-2 border-black pb-4 mb-6">
                    <h1 class="text-2xl font-bold tracking-wide ml-2">HOT SHOWING IN CINEMAS</h1>
                </div>
                <div>
                    <swiper
                        :slidesPerView="4"
                        :spaceBetween="30"
                        :pagination="{
                            clickable: true,
                        }"
                        :modules="modules"
                        class="mySwiper"
                        :autoplay="{
                            delay: 2500,
                            disableOnInteraction: false,
                        }"
                        :loop="true"
                        :loopFillGroupWithBlank="true"
                    >
                        <swiper-slide v-for="movie in premiere_movie_limit" :key="movie.id" class="mb-8">
                            <div class="cursor-pointer" @click="$router.push({name: 'DetailMovie', params:{id: movie.id}})">
                                <img :src="`/images/${movie.image}`" class="w-80 m-auto rounded-lg">
                                <div>
                                    <h3 class="uppercase text-center font-bold py-5 tracking-wide">
                                        {{movie.name}}
                                    </h3>
                                </div>
                            </div>
                        </swiper-slide>
                    </swiper>
                </div>
            </div>
        </div>
        <div class="pt-10 pb-6">
            <div class="w-3/4 m-auto flex flex-col gap-5">
                <div class="flex justify-between border-b-2 border-black pb-4 mb-6">
                    <h1 class="text-2xl font-bold tracking-wide ml-2">UPCOMING</h1>
                </div>
                <div>
                    <swiper
                        :slidesPerView="4"
                        :spaceBetween="30"
                        :pagination="{
                            clickable: true,
                        }"
                        :modules="modules"
                        class="mySwiper"
                        :autoplay="{
                            delay: 3000,
                            disableOnInteraction: false,
                        }"
                        :loop="true"
                        :loopFillGroupWithBlank="true"
                    >
                        <swiper-slide v-for="movie in upcoming_movie_limit" :key="movie.id" class="mb-8">
                            <div class="cursor-pointer" @click="$router.push({name: 'DetailMovie', params:{id: movie.id}})">
                                <img :src="`/images/${movie.image}`" class="w-80 m-auto rounded-lg">
                                <div>
                                    <h3 class="uppercase text-center font-bold py-5 tracking-wide">
                                        {{movie.name}}
                                    </h3>
                                </div>
                            </div>
                        </swiper-slide>
                    </swiper>
                </div>
            </div>
        </div>
        <footer class="bg-slate-500">
            <h3 class="text-center text-white font-semibold text-md py-4">Made by Justin Laurenso</h3>
        </footer>
    </div>
</template>