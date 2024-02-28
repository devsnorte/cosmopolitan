<template>
  <main class="bg-black text-white h-screen p-5 space-y-10">

    <nav class="flex justify-center align-middle">
      <button class="text-2xl font-bold bg-green-500 text-white rounded-l-xl px-4 py-2"
        :class="{ 'bg-green-500': activeFilter === 'upcoming', 'bg-green-700': activeFilter !== 'upcoming' }"
        @click="activeFilter = 'upcoming'">Eventos Agendados</button>
      <button class="text-2xl font-bold bg-green-500 text-white rounded-r-xl px-4 py-2"
        :class="{ 'bg-green-500': activeFilter === 'past', 'bg-green-700': activeFilter !== 'past' }"
        @click="activeFilter = 'past'">Eventos Passados</button>
    </nav>

    <section class="space-y-2">
      <ul class="flex space-x-2">
        <li v-for="event in events" :key="event.id">
          <NuxtLink :to="`/events/${event.id}`">
            <cosmo-card
              :title="event.title"
              :description="event.description"
              :date="event.date"
            ></cosmo-card>
          </NuxtLink>
        </li>
      </ul>

    </section>
  </main>
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
      ],
    };
  },
  setup() {
    const activeFilter = ref("upcoming");

    return {
      activeFilter,
    };
  },
};
</script>

<style scoped>
.style_star__93stM {
  position: absolute;
  top: -10px;
  right: -10px;
  width: 20px;
  height: 20px;
}
</style>
