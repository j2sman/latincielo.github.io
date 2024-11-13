<script setup>
const { t, locale } = useI18n();

useHead({
  title: `${t("regularClass.title")} - LatinCielo`,
  meta: [{ name: "description", content: t("regularClass.description") }],
});
</script>

<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
    <UContainer>
      <h1 class="text-3xl font-bold mb-8">{{ t("regularClass.title") }}</h1>

      <!-- 이미지 섹션 -->
      <div
        class="w-full bg-gray-100 dark:bg-gray-800 rounded-lg overflow-hidden"
      >
        <img
          class="w-full h-auto"
          src="https://i.imgur.com/F5lyJml.png"
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
    </UContainer>
  </div>
</template>
