<template>
  <div class="container mx-auto px-4 py-8">
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
