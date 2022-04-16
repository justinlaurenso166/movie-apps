import { createStore } from "vuex"
import createPersistedState from "vuex-persistedstate"

//create a new store instance
const store = createStore({
    plugins: [createPersistedState({
        path: ["user_data", "islogin"],
    })],

    state: () => ({
        user_data: null,
        islogin: false,
    }),
    mutations: {
        MUTATE_USER_DATA(state, payload) {
            if (payload !== null) {
                state.user_data = payload[0];
            } else {
                state.user_data = null;
            }
        },
        MUTATE_USER_LOGIN(state, payload) {
            state.islogin = payload
        }
    },
    actions: {
        resetAllStore({ commit }) {
            commit("MUTATE_USER_DATA", null);
            commit("MUTATE_USER_LOGIN", false)
        }
    },
})

export default store;