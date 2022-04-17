<script setup>
import Header from "../../components/admin/Header.vue"
import axios from "axios"
import { ref } from "@vue/reactivity"
import { onMounted } from "@vue/runtime-core";
import { createToast } from 'mosha-vue-toastify';
import 'mosha-vue-toastify/dist/style.css'
import modal from "../../components/ModalConfirm.vue"

const list_movies = ref([]);
const showDeleteBox = ref(false)
const remove_id = ref("")

const getListMovies = async()=>{
    try {
        await axios.get("/api/movies/all").then((res)=>{
            console.log(res.data)
            if(res.status === 200){
                list_movies.value = res.data
            }
        })
    } catch (error) {
        console.log(error)
    }
}

const deleteMovie = async()=>{
    try {
        await axios.delete("/api/movies/delete/"+remove_id.value).then((res)=>{
            console.log(res.data)
            if(res.status === 200){
                showDeleteBox.value = false;
                remove_id.value = "";
                getListMovies();
                createToast(res.data,{
                    type: 'success',
                    position: 'top-right',
                    transition: 'slide',
                    timeout: 3000,
                    hideProgressBar: false,
                    showIcon: true,
                })
            }
        })
    } catch (error) {
        console.log(error)
    }
}

onMounted(async()=>{
    await getListMovies();
})
</script>

<style scoped>

</style>

<template>
    <div class="bg-gray-200 h-screen">
        <div>
            <Header />
        </div>
        <div style="max-height: 800px; overflow-y: auto; overflow-x: auto" class="2xl:w-3/4 xl:w-4/5 m-auto bg-white mt-7 rounded-lg shadow-lg p-5">
            <button class="bg-slate-500 text-white py-2 px-4 text-lg rounded-md" @click="$router.push({name: 'AddMovies'})">
                Add
            </button>

            <table class="table-fixed w-full mt-8 crop-table">
                <thead>
                    <tr>
                        <th class="border-2 py-1 w-12">No</th>
                        <th class="border-2 py-1 w-48">Image</th>
                        <th class="border-2 py-1 w-60">Name</th>
                        <th class="border-2 py-1">Description</th>
                        <th class="border-2 py-1 w-36">Status</th>
                        <th class="border-2 py-1 w-32">Genre</th>
                        <th class="border-2 py-1 w-40">Action</th>
                    </tr>
                </thead>
                <tbody class="text-center">
                    <tr v-for="(movie, idx) in list_movies" :key="movie.id">
                        <td class="border-2 w-12 font-bold">{{idx+1}}</td>
                        <td class="border-2 p-5">
                            <img :src="`/images/`+movie.image" class="w-32 h-42 m-auto">
                        </td>
                        <td class="border-2 p-6 font-bold">
                            <span class="hover:underline hover:cursor-pointer" @click="$router.push({name: 'DetailMovieAdmin', params:{id: movie.id}})">
                                {{movie.name}}
                            </span>
                        </td>
                        <td class="border-2 py-2 px-4 text-justify">
                            <span
                                style="
                                overflow: hidden;
                                text-overflow: ellipsis;
                                display: -webkit-box; 
                                -webkit-line-clamp: 5; 
                                line-clamp: 5; 
                                -webkit-box-orient: vertical;"
                            >
                                {{movie.description}}
                            </span>
                        </td>
                        <td class="border-2 p-1 capitalize font-bold">
                            {{(movie.status).split('_').join(' ')}}
                        </td>
                        <td class="border-2 p-2">
                            {{movie.genre}}
                        </td>
                        <td class="border-2">
                            <span class="flex items-center justify-center gap-7">
                                <div class="bg-red-500 rounded-lg p-1 hover:cursor-pointer" @click="remove_id= movie.id; showDeleteBox = true;">
                                    <img src="../../assets/svg/Trash_alt.svg" class="w-7">
                                </div>
                                <div class="bg-green-500 rounded-lg p-1 hover:cursor-pointer" @click="$router.push({name: 'EditMovies', params:{id: movie.id}})">
                                    <img src="../../assets/svg/Edit.svg" class="w-7">
                                </div>
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <modal v-if="showDeleteBox">
            <template v-slot:header>
                <div class="font-bold text-xl border-b-2 pb-3 tracking-wide">Confirmation</div>
            </template>
            <template v-slot:body>
                <div class="mt-4">
                    <h2 class="text-lg tracking-wide">Are you sure you want delete this movie ?</h2>
                </div>
                <div class="flex justify-end gap-5 mt-10">
                    <div class="bg-red-500 text-white text-lg px-2 py-1 rounded-md hover:cursor-pointer" @click="showDeleteBox = false">Cancel</div>
                    <div class="bg-blue-600 text-white text-lg px-2 py-1 rounded-md hover:cursor-pointer" @click="deleteMovie()">Yes, delete</div>
                </div>
            </template>
        </modal>
    </div>
</template>