<template>
  <div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold mb-8">{{ $t("history.title") }}</h1>

    <div class="grid gap-8">
      <div
        v-for="(item, index) in sortedHistory"
        :key="index"
        class="bg-white rounded-lg shadow-md p-6"
      >
        <div class="flex flex-col md:flex-row gap-6">
          <!-- 미디어 섹션 -->
          <div class="md:w-1/3">
            <template v-if="item.type === 'youtube'">
              <iframe
                class="w-full aspect-video rounded"
                :src="getYoutubeEmbedUrl(item.url)"
                frameborder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowfullscreen
              ></iframe>
            </template>
            <template v-else-if="item.type === 'image'">
              <img
                :src="item.url"
                :alt="item.title"
                class="w-full h-auto rounded"
              />
            </template>
          </div>

          <!-- 콘텐츠 섹션 -->
          <div class="md:w-2/3">
            <h2 class="text-xl font-semibold mb-2">{{ item.title }}</h2>
            <p class="text-gray-600 mb-4">{{ item.date }}</p>
            <p class="text-gray-800">{{ item.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const history = ref([
  {
    type: "youtube",
    url: "https://www.youtube.com/watch?v=example1",
    title: "2024 봄 공연",
    date: "2024-03-15",
    description: "봄 시즌 정기 공연 하이라이트",
  },
  {
    type: "image",
    url: "/images/concert-2023.jpg",
    title: "2023 겨울 워크샵",
    date: "2023-12-20",
    description: "연말 워크샵 및 공연 준비 모습",
  },
  // 더 많은 활동 내역을 여기에 추가할 수 있습니다
]);

// 날짜 기준 내림차순 정렬
const sortedHistory = computed(() => {
  return [...history.value].sort((a, b) => new Date(b.date) - new Date(a.date));
});

// YouTube URL을 임베드 URL로 변환
function getYoutubeEmbedUrl(url) {
  const videoId = url.split("v=")[1];
  return `https://www.youtube.com/embed/${videoId}`;
}
</script>

<style scoped>
.container {
  max-width: 1200px;
}
</style>
