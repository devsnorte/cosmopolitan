<template>
  <div :class="cardClasses" @mouseover="showPopover = true" @mouseleave="showPopover = false">
    <div class="card-content">
      <h2>{{ title }}</h2>
      <p>{{ description }}</p>
    </div>
    <div v-if="showPopover" class="popover">
      <slot name="popover"></slot>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue';

export default {
  name: 'CosmoCard',
  props: {
    size: {
      type: String,
      default: 'medium',
      validator: (value) => ['small', 'medium', 'large'].includes(value)
    },
    border: {
      type: Boolean,
      default: true
    },
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    }
  },
  setup(props) {
    const showPopover = ref(false);

    const cardClasses = computed(() => {
      return [
        'bg-white',
        'rounded-md',
        'p-4',
        'shadow-md',
        `w-${props.size}`,
        {
          'border': props.border
        }
      ];
    });

    return {
      showPopover,
      cardClasses
    };
  }
};
</script>

<style scoped>
.card-content {
  margin-bottom: 8px;
}

.popover {
  position: absolute;
  top: 100%;
  left: 0;
  width: 100%;
  background-color: #fff;
  border-radius: 4px;
  padding: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
</style>
