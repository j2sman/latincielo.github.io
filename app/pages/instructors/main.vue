<script setup>
const { t, locale } = useI18n();

const title = t("mainInstructors.title");
const description = t("mainInstructors.description");

useHead({
  title: `${title} - LatinCielo`,
  meta: [{ name: "description", content: description }],
});
</script>

<template>
  <div class="relative min-h-screen">
    <!-- 배경 이미지 -->
    <!-- <div
      class="absolute inset-0 z-0"
      style="
        background-image: url('https://i.imgur.com/meC5drd.png');
        background-size: cover;
        background-position: center;
        opacity: 0.15;
      "
    ></div> -->
    <div class="video-background">
      <video autoplay muted loop>
        <source src="https://i.imgur.com/Aylh5wo.mp4" type="video/mp4" />
      </video>
    </div>

    <!-- 컨텐츠 -->
    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <UContainer>
        <h1 class="text-4xl font-bold mb-12 text-center">{{ title }}</h1>
        <div class="grid md:grid-cols-2 gap-8">
          <!-- 소라쌤 소개 -->
          <UCard class="relative overflow-hidden h-full">
            <div
              class="absolute inset-0 z-0 w-full h-full"
              style="
                background-image: url('https://i.imgur.com/6fEEKU0.png');
                background-size: 100% 100%;
                background-position: center;
                opacity: 0.15;
              "
            />
            <template #header>
              <h2 class="text-2xl font-semibold relative z-10">
                {{ $t("mainInstructors.sora.name") }}
              </h2>
            </template>

            <div class="space-y-4 relative z-10">
              <p class="text-lg">{{ $t("mainInstructors.mainInstructor") }}</p>
              <ul class="list-disc list-inside space-y-2">
                <li>{{ $t("mainInstructors.sora.intro1") }}</li>
                <li>{{ $t("mainInstructors.sora.intro2") }}</li>
                <li>{{ $t("mainInstructors.sora.intro3") }}</li>
              </ul>

              <!-- 유튜브 영상 추가 -->
              <div class="aspect-w-16 aspect-h-9 mt-4">
                <iframe
                  class="w-full h-full"
                  src="https://www.youtube.com/embed/g3zexF6hoWU"
                  frameborder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowfullscreen
                ></iframe>
              </div>
            </div>
          </UCard>

          <!-- 달콩쌤 소개 -->
          <UCard class="relative overflow-hidden h-full">
            <div
              class="absolute inset-0 z-0 w-full h-full"
              style="
                background-image: url('https://i.imgur.com/jtJOXt7.png');
                background-size: 100% 100%;
                background-position: center;
                opacity: 0.15;
              "
            />
            <template #header>
              <h2 class="text-2xl font-semibold relative z-10">
                {{ $t("mainInstructors.dalkong.name") }}
              </h2>
            </template>

            <div class="space-y-4 relative z-10">
              <p class="text-lg">{{ $t("mainInstructors.mainInstructor") }}</p>
              <ul class="list-disc list-inside space-y-2">
                <li>{{ $t("mainInstructors.dalkong.intro1") }}</li>
                <li>{{ $t("mainInstructors.dalkong.intro2") }}</li>
                <li>{{ $t("mainInstructors.dalkong.intro3") }}</li>
              </ul>

              <!-- 유튜브 영상 추가 -->
              <div class="aspect-w-16 aspect-h-9 mt-4">
                <iframe
                  class="w-full h-full"
                  src="https://www.youtube.com/embed/d6UAhyKu2FU"
                  frameborder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowfullscreen
                ></iframe>
              </div>
            </div>
          </UCard>
        </div>
      </UContainer>
    </div>
  </div>
</template>

<style scoped>
.min-h-screen {
  min-height: calc(100vh - 64px); /* 헤더 높이만큼 빼기 */
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
