<template>
  <div class="container mx-auto px-4 py-8">
    <div class="video-background">
      <video autoplay muted loop>
        <source
          src="https://images.latincielo.kr/Background/Video5.mp4"
          type="video/mp4"
        />
      </video>
    </div>
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
const { locale } = useI18n();
const history = ref([]);

// JSON 데이터 가져오기
const fetchHistoryData = async () => {
  try {
    const response = await fetch(`https://images.latincielo.kr/History/${locale.value}/data.json`);
    const data = await response.json();
    history.value = data.history;
  } catch (error) {
    console.error('히스토리 데이터를 불러오는데 실패했습니다:', error);
    history.value = []; // 에러 발생시 빈 배열로 초기화
  }
};

// locale이 변경될 때마다 데이터 다시 가져오기
watch(locale, () => {
  fetchHistoryData();
});

// 컴포넌트 마운트 시 초기 데이터 가져오기
onMounted(() => {
  fetchHistoryData();
});

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

.video-background {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: -1;
  overflow: hidden;
}

.video-background::after {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6); /* 여기서 투명도 조절 (0.2 = 60% 투명) */
}

.video-background video {
  min-width: 100%;
  min-height: 100%;
  width: auto;
  height: auto;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
</style>
