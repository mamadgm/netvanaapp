// ignore_for_file: non_constant_identifier_names
//import 'dart:core';

class EspTheme {
  int value;
  final String name;
  final String path;
  final String property;
  final bool isColorSingle;
  EspTheme(
      {required this.name,
      required this.value,
      required this.path,
      required this.property,
      this.isColorSingle = false});
}

//    uint8_t Selected_Modes[13] = {0, 1, 2, 7, 9, 11, 22, 24, 40, 41, 42, 55, 59};
List<EspTheme> Allthemes = [
  EspTheme(
      name: "تک رنگ",
      value: 0,
      path: "ass/themes/static.png",
      property: "نمایش یک رنگ ثابت",
      isColorSingle: true),
  EspTheme(
      name: "آکواریوم",
      value: 9,
      path: "ass/themes/fish.png",
      property: "پیکسل های رنگی"),
  EspTheme(
      name: "رنگین کمان",
      value: 11,
      path: "ass/themes/rainbow.png",
      property: "رنگ های مختلف"),
  EspTheme(
      name: "نفس کشیدن",
      value: 2,
      path: "ass/themes/fade.png",
      property: "نور فید می شود",
      isColorSingle: true),
  EspTheme(
      name: "چشمک زن",
      value: 1,
      path: "ass/themes/blink.png",
      property: "لامپ چشمک می زند",
      isColorSingle: true),
  EspTheme(
      name: "دریا",
      value: 55,
      path: "ass/themes/sea.png",
      property: "احساسی از موج های دریا",
      isColorSingle: true),
  EspTheme(
      name: "رنگ آمیزی",
      value: 7,
      path: "ass/themes/paint.png",
      property: "لامپ رنگ آمیزی می شود"),
  EspTheme(
      name: "جشن و پارتی",
      value: 22,
      path: "ass/themes/party.png",
      property: "هنگام جشن استفاده شود"),
  EspTheme(
      name: "نور فراری",
      value: 24,
      path: "ass/themes/run.png",
      property: "نوری که فرار می کند",
      isColorSingle: true),
  EspTheme(
      name: "نور چرخان",
      value: 40,
      path: "ass/themes/circle.png",
      property: "نور دور لامپ می چرخد",
      isColorSingle: true),
  EspTheme(
      name: "پلیسی",
      value: 41,
      path: "ass/themes/police.png",
      property: "همان رنگ آبی و قرمز"),
  EspTheme(
      name: "نور چرخان رنگی",
      value: 42,
      path: "ass/themes/circle2.png",
      property: "نور رنگی می چرخد"),
  EspTheme(
      name: "رقص",
      value: 59,
      path: "ass/themes/dance.png",
      property: "رقص و جشن",
      isColorSingle: true),
];
int findThemeIndex(List<EspTheme> themes, int maincycleMode) {
  for (int i = 0; i < themes.length; i++) {
    if (themes[i].value == maincycleMode) {
      return i;
    }
  }
  return -1;
}
