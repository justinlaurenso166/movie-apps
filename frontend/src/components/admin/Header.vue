<script setup>

</script>

<template>
    <div>
        <div class="flex">
            <div class="flex-1">
                <header class="py-6 border-b-2 px-6 bg-white flex justify-between">
                    <h1 class="flex-0 font-semibold text-2xl text-black tracking-normal w-full cursor-pointer" @click="$router.push({name: 'Home'})">
                        MOVIE APPS
                    </h1>
                    <div class="flex flex-1 gap-8 items-center">
                        <h2 class="flex-1 tracking-wide text-lg hover:cursor-pointer" @click="$router.push({name:'Mainpage'})">Homepage</h2>
                        <h2 class="flex-1 mr-8 font-bold text-lg tracking-wide">{{$store.state.user_data.autorithy === 1 ? 'Administrator' : ''}}</h2>
                    </div>
                </header>
            </div>
        </div>
    </div>
</template>