<script setup>
const { t, locale } = useI18n();
const { $device } = useNuxtApp();

useHead({
  title: `${t("regularClass.title")} - LatinCielo`,
  meta: [{ name: "description", content: t("regularClass.description") }],
});
</script>

<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <div class="video-background">
      <video autoplay muted loop>
        <source src="https://i.imgur.com/xmj9N5z.mp4" type="video/mp4" />
      </video>
    </div>
    <UContainer>
      <h1 class="text-3xl font-bold mb-8">{{ t("regularClass.title") }}</h1>

      <!-- 이미지 섹션 -->
      <div
        class="w-full bg-gray-100 dark:bg-gray-800 rounded-lg overflow-hidden"
      >
        <img
          class="w-full h-auto"
          src="https://i.imgur.com/lMdyFqv.png"
          :alt="t('regularClass.cardTitle')"
        />
      </div>

      <!-- 로딩 중이거나 임베드 실패시 대체 컨텐츠 -->
      <div class="mt-6">
        <UCard>
          <template #header>
            <h2 class="text-xl font-semibold">
              {{ t("regularClass.cardTitle") }}
            </h2>
          </template>

          <div class="space-y-4">
            <p>{{ t("regularClass.content.intro") }}</p>
            <p>{{ t("regularClass.content.notice") }}</p>
          </div>

          <template #footer>
            <div class="flex gap-4">
              <UButton
                icon="i-heroicons-arrow-right"
                :to="locale === 'ko' ? '/schedule' : `/${locale}/schedule`"
                variant="soft"
              >
                {{ t("regularClass.viewSchedule") }}
              </UButton>
              <UButton
                icon="i-heroicons-arrow-right"
                :to="
                  locale === 'ko'
                    ? '/instructors/main'
                    : `/${locale}/instructors/main`
                "
                variant="soft"
              >
                {{ t("regularClass.viewMainInstructors") }}
              </UButton>
            </div>
          </template>
        </UCard>
      </div>

      <!-- CTA 섹션 추가 -->
      <div class="mt-12 text-center space-y-4">
        <div class="flex flex-wrap justify-center gap-4">
          <UButton
            icon="i-simple-icons-naver"
            :to="'https://cafe.naver.com/latinblack'"
            target="_blank"
            size="lg"
            color="green"
          >
            {{ $t("regularClass.naverCafe") }}
          </UButton>

          <UButton
            icon="i-simple-icons-instagram"
            :to="'https://www.instagram.com/latin_cielo'"
            target="_blank"
            size="lg"
            color="purple"
          >
            {{ $t("regularClass.instagram") }}
          </UButton>
          <UButton
            icon="i-simple-icons-youtube"
            :to="'https://www.youtube.com/channel/UCNjCsd6dFwTH4pHAk8xDgNw'"
            target="_blank"
            size="lg"
            color="red"
          >
            {{ $t("regularClass.youtube") }}
          </UButton>
          <UButton
            v-if="$device.isMobile.value"
            icon="i-simple-icons-kakaotalk"
            :to="'http://qr.kakao.com/talk/0ZzaZPyp0t6FGXYprSIP_MsO23w-'"
            target="_blank"
            size="lg"
            color="yellow"
          >
            {{ $t("regularClass.kakaotalk") }}
          </UButton>
        </div>
      </div>
    </UContainer>
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
