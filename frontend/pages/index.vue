<template>
  <div>
    <h1>Events</h1>
    <ul>
      <li v-for="event in events" :key="event.id">
        <cosmo-card
          :title="event.title"
          :description="event.description"
          size="small"
          :border="false"
        ></cosmo-card>
      </li>
    </ul>
  </div>
</template>

<script>
import CosmoCard from "@/components/CosmoCard.vue";

export default {
  components: {
    CosmoCard,
  },
  data() {
    return {
      events: [
        {
          id: 1,
          title: "Event 1",
          description: "This is event 1",
          date: "2022-01-01",
          location: "Location 1",
        },
        {
          id: 2,
          title: "Event 2",
          description: "This is event 2",
          date: "2022-02-02",
          location: "Location 2",
        },
        // Add more events here
      ],
    };
  },
};
</script>

<style scoped>
li {
  margin-bottom: 8px;
}
</style>
