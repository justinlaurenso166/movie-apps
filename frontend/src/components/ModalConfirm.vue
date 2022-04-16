<template>
  <div class="modal-backdrop">
    <div class="modal" style="width: 450px">
      <header class="modal-header">
        <slot name="header"></slot>
      </header>
      <section class="modal-body">
        <slot name="body"></slot>
      </section>
    </div>
  </div>
</template>

<style>
.modal-backdrop {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.4);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 999 !important;
}

.modal {
  background: #ffffff;
  overflow-x: auto;
  width: auto;
  border-radius: 10px;
  padding: 30px;
  /* margin-top: -100px; */
}

.modal-header {
  position: relative;
  border-bottom: 1px solid #eeeeee;
  color: #1a1d29;
  text-align: left;
}

.modal-footer {
  border-top: 1px solid #eeeeee;
  flex-direction: column;
}

.modal-body {
  position: relative;
}
</style>

<script>
export default {
  name: "Modal",
  methods: {
    close() {
      this.$emit("close");
    },
  },
};
</script>
