<template>
  <div class="container mx-auto px-4 py-8">
    <div class="video-background">
      <video autoplay muted loop preload="none">
        <source
          src="https://images.latincielo.kr/Background/Video_History.mp4"
          type="video/mp4"
        />
      </video>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      <div
        v-for="(item, index) in sortedHistory"
        :key="index"
        class="bg-black/30 backdrop-blur-sm rounded-lg shadow-md p-6"
      >
        <div class="w-full">
          <iframe
            class="w-full aspect-video rounded"
            :src="getYoutubeEmbedUrl(item.url)"
            frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
          <p class="text-center mt-4 text-white/50">{{ item.date }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const { t, tm, locale } = useI18n();
const history = ref([]);
const youtubeVideos = ref([]);

// // JSON 데이터 가져오기
// const fetchHistoryData = async () => {
//   try {
//     const response = await fetch(`https://images.latincielo.kr/History/${locale.value}/data.json`);
//     const data = await response.json();
//     history.value = data.history;
//   } catch (error) {
//     console.error('히스토리 데이터를 불러오는데 실패했습니다:', error);
//     history.value = []; // 에러 발생시 빈 배열로 초기화
//   }
// };

// YouTube RSS 피드에서 데이터 가져오기
const fetchYoutubeVideos = async () => {
  try {
    // 라틴씨엘로 💚소셜/공연/뮤비영상💚
    // https://www.youtube.com/watch?v=ik-GwMbKacg&list=PLDyLj6U7XhNjDzg1WJcgB2mU3q27TQRZL
    // CORS 우회를 위한 프록시 서버 사용
    const PROXY_URL = "https://api.allorigins.win/raw?url=";
    const PLAYLIST_ID = "PLDyLj6U7XhNjDzg1WJcgB2mU3q27TQRZL";
    const RSS_URL = `https://www.youtube.com/feeds/videos.xml?playlist_id=${PLAYLIST_ID}`;

    const response = await fetch(PROXY_URL + encodeURIComponent(RSS_URL));
    const xmlText = await response.text();
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(xmlText, "text/xml");

    const entries = xmlDoc.querySelectorAll("entry");

    const videoCount = 12;
    youtubeVideos.value = Array.from(entries)
      .map((entry) => ({
        type: "youtube",
        title: entry.querySelector("title").textContent,
        date: new Date(entry.querySelector("published").textContent),
        url: entry.querySelector("link").getAttribute("href"),
      }))
      .sort((a, b) => b.date - a.date)
      .slice(0, videoCount)
      .map((video) => ({
        ...video,
        date: video.date.toLocaleDateString(),
      }));
  } catch (error) {
    console.error("YouTube 데이터를 불러오는데 실패했습니다:", error);
    youtubeVideos.value = [];
  }
};

// // locale이 변경될 때마다 데이터 다시 가져오기
// watch(locale, () => {
//   fetchHistoryData();
// });

// 컴포넌트 마운트 시 초기 데이터 가져오기
onMounted(() => {
  // fetchHistoryData();
  fetchYoutubeVideos();
});

// 날짜 기준 내림차순 정렬 및 YouTube 비디오 통합
const sortedHistory = computed(() => {
  const combinedHistory = [...history.value, ...youtubeVideos.value];
  return combinedHistory.sort((a, b) => new Date(b.date) - new Date(a.date));
});

// YouTube URL을 임베드 URL로 변환
function getYoutubeEmbedUrl(url) {
  const videoId = url.split("v=")[1];
  return `https://www.youtube.com/embed/${videoId}`;
}

useHead({
  title: `${t("history.title")} - LatinCielo`,
  meta: [
    {
      name: "description",
      content: t("history.description"),
    },
  ],
});
</script>

<style scoped>
.container {
  max-width: 1400px;
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

.grid > div {
  min-height: auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: transform 0.2s ease-in-out;
}

.grid > div:hover {
  transform: translateY(-5px);
}

iframe.w-full {
  width: 100%;
  height: 250px;
  object-fit: cover;
}

@media (max-width: 1024px) {
  iframe.w-full {
    height: 300px;
  }
}

@media (max-width: 768px) {
  iframe.w-full {
    height: 250px;
  }
}
</style>
