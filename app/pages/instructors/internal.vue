<template>
  <div class="container mx-auto px-4 py-8">
    <div class="video-background">
      <video autoplay muted loop>
        <source
          src="https://images.latincielo.kr/Background/Video4.mp4"
          type="video/mp4"
        />
      </video>
    </div>
    <h1 class="text-4xl font-bold mb-8">
      {{ $t("internalInstructors.title") }}
    </h1>
    <div class="grid md:grid-cols-3 gap-6">
      <div
        v-for="(instructor, index) in localizedInstructors"
        :key="index"
        class="bg-white rounded-lg shadow-lg p-6"
      >
        <img
          :src="instructor.image"
          :alt="instructor.name"
          class="w-full h-48 object-cover rounded-lg mb-4"
        />
        <h2 class="text-xl font-bold mb-2">{{ instructor.name }}</h2>
        <p class="text-gray-600 mb-4">{{ instructor.description }}</p>
        <!-- <a
          :href="`/${locale}/instructors/${instructor.id || ''}`"
          target="_blank"
          class="inline-block bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600"
        >
          {{ $t("internalInstructors.viewProfile") }}
        </a> -->
      </div>
    </div>
  </div>
</template>

<script setup>
const { t, tm, locale } = useI18n();

const localizedInstructors = computed(() => {
  try {
    const instructors = tm("internalInstructors.instructors", undefined, {
      returnObjects: true,
    });

    if (Array.isArray(instructors)) {
      if (process.env.NODE_ENV === "development") {
        return instructors.map((instructor) => ({
          id: instructor.id,
          name:
            instructor.name?.body?.static || instructor.name?.loc?.source || "",
          description:
            instructor.description?.body?.static ||
            instructor.description?.loc?.source ||
            "",
          image:
            instructor.image?.body?.static ||
            instructor.image?.loc?.source ||
            "",
          taplinkUrl:
            instructor.taplinkUrl?.body?.static ||
            instructor.taplinkUrl?.loc?.source ||
            "",
        }));
      } else {
        return instructors.map((instructor) => ({
          id: instructor.id,
          name: instructor.name?.b?.s || "",
          description: instructor.description?.b?.s || "",
          image: instructor.image?.b?.s || "",
          taplinkUrl: instructor.taplinkUrl?.b?.s || "",
        }));
      }
    }

    return [];
  } catch (error) {
    console.error("Error loading instructors:", error);
    return [];
  }
});

useHead({
  title: `${t("internalInstructors.title")} - LatinCielo`,
  meta: [
    {
      name: "description",
      content: t("internalInstructors.title"),
    },
  ],
});
</script>

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
