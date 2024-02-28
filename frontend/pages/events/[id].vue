<template>
  <div class="event-page">
    <div class="cover-image">
      <img src="https://via.placeholder.com/1920x1080" alt="Cover Image" />
    </div>
    <div class="event-info">
      <h1 class="font-bold text-4xl">{{ event.title }}</h1>
      <p class="font-thin text-lg">{{ event.description }}</p>
      <ul class="grid grid-cols-2 p-5 space-y-4">
        <li v-for="talk in event.talks" :key="talk.id" class="flex flex-row">
          <div class="self-center px-3">
            <img class="rounded-full" src="https://via.placeholder.com/100" alt="Speaker Image" />
          </div>
          <div>
            <h2 class="font-bold text-xl">{{ talk.title }}</h2>
            <p class="font-thin text-lg">{{ talk.description }}</p>
            <p class="font-thin text-lg">{{ talk.speaker }}</p>
            <p class="font-semibold text-sm">{{ talk.time }}</p>
          </div>
        </li>
      </ul>
    </div>
    <div class="footer">
      <div class="sm:w-full sm:flex-row flex flex-col justify-items-center justify-around self-center">
        <div class="sm:block px-2">
          <p class="text-white text-xl font-semibold">
            Data
          </p>
          <p class="text-white text-2xl font-semibold">
            12/12/2022
          </p>
        </div>
        <div class="sm:block hidden">
          <p class="text-white text-xl font-semibold">
            Hora
          </p>
          <p class="text-white text-2xl font-semibold">
            12:00 - 18:00
          </p>
        </div>

        <div class="sm:block hidden">
          <p class="text-white text-xl font-semibold">
            Local
          </p>
          <p class="text-white text-2xl font-semibold">
            Unama - Ananindeua
          </p>
        </div>
      </div>

      <div class="flex flex-1 justify-end justify-items-center self-center px-4">
        <button class="subscribe-button" @click="subscribe">Inscreva-se</button>
      </div>

    </div>
  </div>
</template>

<script>
import { ref } from 'vue';

export default {
  setup() {
    const event = ref({
      id: null,
      title: 'Mocked Event',
      description: 'This is a mocked event description.',
      date: '2022-01-01',
      location: 'Mocked Location',
      coverImage: 'https://example.com/cover-image.jpg',
      talks: [
        {
          id: 1,
          title: 'Talk 1',
          description: 'This is a mocked talk description asoidjasoid asoijdidoasjid ajsojidsa.',
          speaker: 'Mocked Speaker',
          time: '12:00 - 13:00',
        },
        {
          id: 2,
          title: 'Talk 2',
          description: 'This is a mocked talk description.',
          speaker: 'Mocked Speaker',
          time: '13:00 - 14:00',
        },
        {
          id: 3,
          title: 'Talk 3',
          description: 'This is a mocked talk description.',
          speaker: 'Mocked Speaker',
          time: '13:00 - 14:00',
        },
        {
          id: 4,
          title: 'Talk 4',
          description: 'This is a mocked talk description.',
          speaker: 'Mocked Speaker',
          time: '13:00 - 14:00',
        },
      ],
    });

    const subscribe = () => {
      // Implement your subscribe action here
    };

    return {
      event,
      subscribe,
    };
  },
};
</script>

<style scoped>
.event-page {
  display: grid;
  grid-template-rows: 0.4fr 1fr auto;
  height: 100vh;
  overflow: hidden;
}

.cover-image {
  @apply text-center;
}

.cover-image img {
  @apply w-full max-h-72 object-cover;
}

.event-info {
  @apply p-4 container mx-auto;
}

.footer {
  @apply flex flex-1 space-x-10 justify-center sticky bottom-0 w-full h-28 bg-green-500 rounded-t-3xl;
}

.subscribe-button {
  @apply w-40 h-16 text-lg bg-black font-semibold text-white rounded-xl;
}
</style>
