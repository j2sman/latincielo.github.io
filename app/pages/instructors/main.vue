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
    <div
      class="absolute inset-0 z-0"
      style="
        background-image: url('https://i.imgur.com/7MN0F1F.png');
        background-size: cover;
        background-position: center;
        opacity: 0.15;
      "
    ></div>

    <!-- 컨텐츠 -->
    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
      <UContainer>
        <h1 class="text-4xl font-bold mb-12 text-center">{{ title }}</h1>

        <!-- CTA 섹션을 여기로 이동 -->
        <div class="mb-12 text-center space-y-4">
          <div class="flex justify-center gap-4">
            <UButton
              icon="i-heroicons-calendar"
              :to="'/schedule'"
              size="lg"
              color="primary"
            >
              {{ $t("mainInstructors.viewSchedule") }}
            </UButton>

            <UButton
              icon="i-simple-icons-naver"
              :to="'https://cafe.naver.com/latinblack'"
              target="_blank"
              size="lg"
              color="green"
            >
              {{ $t("mainInstructors.naverCafe") }}
            </UButton>

            <UButton
              icon="i-simple-icons-instagram"
              :to="'https://www.instagram.com/latin_cielo'"
              target="_blank"
              size="lg"
              color="purple"
            >
              {{ $t("mainInstructors.instagram") }}
            </UButton>
          </div>
        </div>

        <div class="grid md:grid-cols-2 gap-8">
          <!-- 소라쌤 소개 -->
          <UCard class="relative overflow-hidden h-full">
            <div
              class="absolute inset-0 z-0 w-full h-full"
              style="
                background-image: url('https://i.imgur.com/pleWGEZ.png');
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
                background-image: url('https://i.imgur.com/qxIr5RR.png');
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
</style>
