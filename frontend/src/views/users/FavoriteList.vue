<script setup>
import Header from "../../components/user/Header.vue"
import axios from "axios"
import store from "../../store/store"
import { onMounted, ref } from "@vue/runtime-core"

const user_id = store.state.user_data.user_id
const favorites = ref([])

const getFavorite = async()=>{
    try {
        await axios.get("/api/user_favorite/user/"+user_id).then((res)=>{
            if(res.status === 200){
                console.log(res.data)
                if(res.data.length > 0){
                    favorites.value= res.data.filter((item)=>item.user_id === store.state.user_data.user_id)
                }
            }
        })
    } catch (error) {
        console.log(error)
    }
}

onMounted(async()=>{
    await getFavorite()
})
</script>

<template>
    <div class="bg-gray-200 h-screen max-h-screen overflow-y-auto">
        <Header />
        <div class="pt-10 pb-6">
            <div class="w-3/4 m-auto flex flex-col gap-5">
                <div class="flex justify-between border-b-2 border-black pb-4 mb-6">
                    <h1 class="text-2xl font-bold tracking-wide ml-2">Your Favorite List</h1>
                </div>
                <div class="grid grid-cols-4 gap-10">
                    <div v-for="fav in favorites" :key="fav.id" @click="$router.push({name:'DetailMovie', params:{id: fav.movie_id}})">
                        <img :src="`/images/${fav.image}`" class="rounded-lg">
                        <h4 class="uppercase font-bold text-center mt-4">{{fav.name}}</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>