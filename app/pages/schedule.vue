<template>
  <div class="container mx-auto px-4 py-8">
    <div class="video-background">
      <video autoplay muted loop>
        <source src="https://i.imgur.com/bsjLtfv.mp4" type="video/mp4" />
      </video>
    </div>
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-4xl font-bold">
        {{ $t("schedule.title") }}
      </h1>
      <UButton
        icon="i-heroicons-arrow-top-right-on-square"
        size="lg"
        color="primary"
        @click="openNotionSchedule"
      >
        {{ $t("schedule.viewNotionSchedule") }}
      </UButton>
    </div>

    <!-- 요일별 그리드를 주간 달력 형태로 변경 -->
    <div class="grid grid-cols-7 gap-2 md:gap-4 bg-gray-800/20 rounded-xl p-2 md:p-4">
      <template v-for="weekday in 7" :key="weekday-1">
        <div class="flex flex-col">
          <h2 class="text-sm md:text-lg font-semibold mb-1 md:mb-2 text-white-800 text-center border-b pb-1 md:pb-2 truncate">
            {{ weekdayName(weekday-1) }}
          </h2>
          <div class="flex flex-col gap-4">
            <div
              v-for="(regularClass, index) in (groupedImages[weekday-1] || [])"
              :key="index"
              class="group relative aspect-square cursor-pointer overflow-hidden rounded-xl"
              @click="openModal(regularClass)"
            >
              <img
                :src="regularClass.image"
                :alt="regularClass.title"
                class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
              />
              <div
                class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition-all duration-300 flex items-center justify-center"
              >
                <h3
                  class="text-white text-sm font-medium opacity-0 group-hover:opacity-100 transition-opacity duration-300 text-center px-2"
                >
                  {{ regularClass.title }}
                </h3>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>

    <!-- 이미지 모달 -->
    <UModal v-model="isModalOpen" :transition="false">
      <div class="relative">
        <img
          v-if="selectedImage"
          :src="selectedImage.image"
          :alt="selectedImage.title"
          class="max-w-full max-h-[80vh] object-contain rounded-lg"
        />
        <button
          @click="closeModal"
          class="absolute top-2 right-2 p-2 bg-black bg-opacity-50 rounded-full text-white hover:bg-opacity-70 transition-colors"
        >
          <Icon name="i-heroicons-x-mark" class="w-6 h-6" />
        </button>
      </div>
    </UModal>
  </div>
</template>

<script setup>
const { t, tm, locale } = useI18n();
const isModalOpen = ref(false);
const selectedImage = ref(null);

const regularClassImages = computed(() => {
  try {
    const regularClasses = tm("schedule.regularClasses");

    if (Array.isArray(regularClasses)) {
      if (process.env.NODE_ENV === "development") {
        return regularClasses.map((regularClass) => ({
          id: regularClass.id,
          title:
            regularClass.title?.body?.static ||
            regularClass.title?.loc?.source ||
            "",
          description:
            regularClass.description?.body?.static ||
            regularClass.description?.loc?.source ||
            "",
          image:
            regularClass.image?.body?.static ||
            regularClass.image?.loc?.source ||
            "",
          weekday:
            regularClass.weekday?.body?.static ||
            regularClass.weekday?.loc?.source ||
            0,
        }));
      } else {
        return regularClasses.map((regularClass) => ({
          id: regularClass.id,
          title: regularClass.title?.b?.s || "",
          description: regularClass.description?.b?.s || "",
          image: regularClass.image?.b?.s || "",
          weekday: parseInt(regularClass.weekday?.b?.s) || 0,
        }));
      }
    }

    return [];
  } catch (error) {
    console.error("Error loading instructors:", error);
    return [];
  }
});

const groupedImages = computed(() => {
  const groups = {};
  regularClassImages.value.forEach((item) => {
    if (!groups[item.weekday]) {
      groups[item.weekday] = [];
    }
    groups[item.weekday].push(item);
  });
  return groups;
});

function openModal(image) {
  selectedImage.value = image;
  isModalOpen.value = true;
}

function closeModal() {
  isModalOpen.value = false;
  selectedImage.value = null;
}

function weekdayName(weekday) {
  const weekdays = [
    t("schedule.weekdays.sunday"),
    t("schedule.weekdays.monday"),
    t("schedule.weekdays.tuesday"),
    t("schedule.weekdays.wednesday"),
    t("schedule.weekdays.thursday"),
    t("schedule.weekdays.friday"),
    t("schedule.weekdays.saturday"),
  ];
  return weekdays[weekday];
}

// Notion 스케줄 페이지 열기 함수 추가
function openNotionSchedule() {
  window.open(
    "https://dashboard.latincielo.kr",
    "_blank",
    "noopener,noreferrer"
  );
}
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

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
