<template>
  <div class="container mx-auto px-4 py-8">
    <h1 class="text-4xl font-bold mb-8">
      {{ $t("schedule.title") }}
    </h1>

    <!-- 이미지 그리드 -->
    <div class="mb-8">
      <div
        v-for="(group, weekday) in groupedImages"
        :key="weekday"
        class="mb-12"
      >
        <h2 class="text-2xl font-semibold mb-6 text-white-800 border-b pb-2">
          {{ weekdayName(weekday) }}
        </h2>
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          <div
            v-for="(regularClass, index) in group"
            :key="index"
            class="group relative aspect-square cursor-pointer overflow-hidden rounded-xl max-w-[200px] max-h-[300px]"
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
                class="text-white text-lg font-medium opacity-0 group-hover:opacity-100 transition-opacity duration-300"
              >
                {{ regularClass.title }}
              </h3>
            </div>
          </div>
        </div>
      </div>
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

    <!-- 노션 캘린더 연동 컴포넌트 자리 -->
    <div class="bg-white rounded-lg shadow-lg p-6">
      <p class="text-gray-600">노션 캘린더가 연동될 예정입니다.</p>
    </div>
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
</style>
