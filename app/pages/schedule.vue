<template>
  <div class="container mx-auto px-4 py-8">
    <div class="video-background">
      <video autoplay muted loop>
        <source
          src="https://images.latincielo.kr/Background/Video3.mp4"
          type="video/mp4"
        />
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
    <div
      class="grid grid-cols-7 gap-2 md:gap-4 bg-gray-800/20 rounded-xl p-2 md:p-4"
    >
      <!-- 온라인 수업 섹션 추가 -->
      <div class="col-span-7 mb-4">
        <h2
          class="text-lg md:text-xl font-semibold mb-2 text-white-800 border-b pb-2"
        >
          {{ $t("schedule.onlineClasses") }}
        </h2>
        <div
          class="grid grid-cols-7 gap-2 md:gap-4"
        >
          <div
            v-for="(onlineClass, index) in onlineClasses"
            :key="index"
            class="group relative aspect-square cursor-pointer overflow-hidden rounded-xl"
            @click="openModal(onlineClass)"
          >
            <img
              :src="onlineClass.image"
              :alt="onlineClass.title"
              class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
            />
            <div
              class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition-all duration-300 flex items-center justify-center"
            >
              <h3
                class="text-white text-sm font-medium opacity-0 group-hover:opacity-100 transition-opacity duration-300 text-center px-2"
              >
                {{ onlineClass.title }}
              </h3>
            </div>
          </div>
        </div>
      </div>

      <!-- 기존 요일별 그리드 -->
      <template v-for="weekday in 7" :key="weekday - 1">
        <div class="flex flex-col">
          <h2
            class="text-sm md:text-lg font-semibold mb-1 md:mb-2 text-white-800 text-center border-b pb-1 md:pb-2 truncate"
          >
            {{ weekdayName(weekday - 1) }}
          </h2>
          <div class="flex flex-col gap-4">
            <div
              v-if="!regularClassImagesData.length"
              class="text-center text-gray-400"
            >
              로딩 중...
            </div>
            <div
              v-else
              v-for="(regularClass, index) in groupedImages[weekday - 1] || []"
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
const regularClassImagesData = ref([]);

const loadRegularClassImages = async () => {
  try {
    const regularClasses = tm("schedule.regularClasses");

    if (Array.isArray(regularClasses)) {
      const processClasses = (classes) => {
        return classes
          .map((regularClass) => {
            const imageUrl =
              process.env.NODE_ENV === "development"
                ? regularClass.image?.body?.static ||
                  regularClass.image?.loc?.source ||
                  ""
                : regularClass.image?.b?.s || "";

            return {
              title:
                process.env.NODE_ENV === "development"
                  ? regularClass.title?.body?.static ||
                    regularClass.title?.loc?.source ||
                    ""
                  : regularClass.title?.b?.s || "",
              description:
                process.env.NODE_ENV === "development"
                  ? regularClass.description?.body?.static ||
                    regularClass.description?.loc?.source ||
                    ""
                  : regularClass.description?.b?.s || "",
              image: imageUrl,
              weekday:
                process.env.NODE_ENV === "development"
                  ? parseInt(regularClass.weekday?.body?.static) ||
                    parseInt(regularClass.weekday?.loc?.source) ||
                    0
                  : parseInt(regularClass.weekday?.b?.s) || 0,
            };
          })
          .filter((item) => item.image);
      };

      regularClassImagesData.value = processClasses(regularClasses);
    }
  } catch (error) {
    console.error("수업 정보 로딩 중 오류:", error);
    regularClassImagesData.value = [];
  }
};

const onlineClasses = computed(() => {
  return regularClassImagesData.value.filter((item) => item.weekday === -1);
});

const groupedImages = computed(() => {
  const groups = {};
  regularClassImagesData.value
    .filter((item) => item.weekday !== -1) // 온라인 수업 제외
    .forEach((item) => {
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

// 컴포넌트가 마운트될 때 데이터 로드
onMounted(() => {
  loadRegularClassImages();
});
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
