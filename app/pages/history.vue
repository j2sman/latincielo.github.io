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
            <!-- <p class="text-gray-800">{{ item.description }}</p> -->
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const { locale } = useI18n();
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
    // [소라&달콩] 일상-Vlog 재생 목록 기준
    // https://www.youtube.com/watch?v=ik-GwMbKacg&list=PLDyLj6U7XhNgojuqKRv7TOsUSulOD-b1Z
    // CORS 우회를 위한 프록시 서버 사용
    const PROXY_URL = "https://api.allorigins.win/raw?url=";
    const PLAYLIST_ID = "PLDyLj6U7XhNgojuqKRv7TOsUSulOD-b1Z";
    const RSS_URL = `https://www.youtube.com/feeds/videos.xml?playlist_id=${PLAYLIST_ID}`;

    const response = await fetch(PROXY_URL + encodeURIComponent(RSS_URL));
    const xmlText = await response.text();
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(xmlText, "text/xml");

    const entries = xmlDoc.querySelectorAll("entry");
    youtubeVideos.value = Array.from(entries)
      .slice(0, 5)
      .map((entry) => ({
        type: "youtube",
        title: entry.querySelector("title").textContent,
        // description: entry.querySelector("media\\:description, description")
        //   .textContent,
        date: new Date(
          entry.querySelector("published").textContent
        ).toLocaleDateString(),
        url: entry.querySelector("link").getAttribute("href"),
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
</script>

<style scoped>
.container {
  max-width: 1200px;
}

/* grid 아이템 높이 조정 */
.grid > div {
  min-height: 400px; /* 높이 더 증가 */
  display: flex;
  align-items: stretch;
}

.grid > div > div {
  width: 100%;
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

/* 미디어 섹션 스타일 추가 */
.md\:w-1\/3 {
  height: 100%;
  display: flex;
  align-items: center;
}

/* iframe 크기 조정 */
iframe.w-full {
  width: 100%;
  height: 300px; /* 고정 높이 설정 */
  object-fit: cover;
}

/* 이미지 크기 조정 */
img.w-full {
  width: 100%;
  height: 300px;
  object-fit: cover;
}

/* 콘텐츠 섹션 스타일링 */
.md\:w-2\/3 {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 20px;
}

/* 타이틀 스타일링 */
.text-xl {
  font-size: 1.5rem;
  line-height: 1.4;
  margin-bottom: 1rem;
  color: #333;
  font-weight: 600;
  word-break: keep-all; /* 한글 단어 분리 방지 */
}

/* 날짜 스타일링 */
.text-gray-600 {
  font-size: 1rem;
  color: #666;
  margin-bottom: 1rem;
}

/* 미디어 섹션과 콘텐츠 섹션 사이 간격 조정 */
.gap-6 {
  gap: 2rem;
}

/* 반응형 조정 */
@media (max-width: 768px) {
  .text-xl {
    font-size: 1.25rem;
    margin-bottom: 0.75rem;
  }

  .text-gray-600 {
    font-size: 0.875rem;
  }

  .md\:w-2\/3 {
    padding: 15px;
  }
}
</style>
