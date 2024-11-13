<script setup>
// finalizePendingLocaleChange == locale 변경 시 transition을 위한 함수 추가
const { t, locale, locales, setLocale, finalizePendingLocaleChange } =
  useI18n();
const { copy } = useClipboard();
const toast = useToast();
const switchLocalePath = useSwitchLocalePath();
const links = computed(() => [
  {
    label: t("nav.regularClass"),
    to: locale.value === "ko" ? "/" : `/${locale.value}`,
  },
  {
    label: t("nav.schedule"),
    to: locale.value === "ko" ? "/schedule" : `/${locale.value}/schedule`,
  },
  {
    label: t("nav.mainInstructors"),
    to:
      locale.value === "ko"
        ? "/instructors/main"
        : `/${locale.value}/instructors/main`,
  },
  {
    label: t("nav.internalInstructors"),
    to:
      locale.value === "ko"
        ? "/instructors/internal"
        : `/${locale.value}/instructors/internal`,
  },
]);

const title = useI18n().t("app.title");
const description = useI18n().t("app.description");

// useSeoMeta({
//   title,
//   description,
//   ogTitle: title,
//   ogDescription: description,
//   ogImage: "/social-card.png",
//   twitterImage: "/social-card.png",
//   twitterCard: "summary_large_image",
// });

const availableLocales = computed(() => {
  return locales.value.filter((i) => i.code !== locale.value);
});

useHead({
  meta: [{ name: "viewport", content: "width=device-width, initial-scale=1" }],
  link: [{ rel: "icon", href: "/favicon.ico" }],
  htmlAttrs: {
    lang: computed(() =>
      import.meta.client ? localStorage.getItem("locale") || "ko" : "ko"
    ),
  },
});

// 앱 초기화 시 한 번만 locale 체크
onBeforeMount(async () => {});

const onBeforeEnter = async () => {
  await finalizePendingLocaleChange();
};
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <UNotifications />
    <UHeader :links="links">
      <template #logo>
        <NuxtLink to="/" class="text-xl font-bold">LatinCielo</NuxtLink>
      </template>

      <template #right>
        <div class="flex items-center gap-4">
          <UPopover mode="click" :popper-class="'!p-0'">
            <UButton
              color="gray"
              variant="ghost"
              :label="t('app.bankAccount')"
              icon="i-heroicons-credit-card"
            />

            <template #panel>
              <div class="p-4 flex flex-col gap-2">
                <p class="text-sm font-medium">{{ t("app.wooriBank") }}</p>
                <div class="flex items-center gap-2">
                  <span class="text-sm">010-5008-5774</span>
                  <UButton
                    color="gray"
                    variant="ghost"
                    icon="i-heroicons-document-duplicate"
                    size="xs"
                    @click="
                      () => {
                        copy('01050085774');
                        toast.add({
                          id: 'bank-account-copied',
                          title: t('app.bankAccountCopied'),
                          timeout: 2000,
                          color: 'green',
                          icon: 'i-heroicons-check-circle',
                        });
                      }
                    "
                  />
                </div>
              </div>
            </template>
          </UPopover>

          <NuxtLink
            v-for="curLocale in availableLocales"
            :key="curLocale.code"
            :to="switchLocalePath(curLocale.code)"
          >
            {{ curLocale.name }}
          </NuxtLink>

          <UColorModeButton />
        </div>
      </template>
    </UHeader>

    <UMain class="flex-grow">
      <NuxtPage
        :transition="{
          name: 'page',
          mode: 'out-in',
          onBeforeEnter,
        }"
      />
    </UMain>

    <UFooter>
      <template #left>
        {{ $t("app.copyright", { year: new Date().getFullYear() }) }}
      </template>
    </UFooter>
  </div>
</template>

<style>
.page-enter-active,
.page-leave-active {
  transition: opacity 0.2s;
}
.page-enter,
.page-leave-active {
  opacity: 0;
}
</style>
