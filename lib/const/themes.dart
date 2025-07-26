// ignore_for_file: non_constant_identifier_names
//import 'dart:core';

class EspTheme {
  int value;
  final String name;
  final String path;
  final String property;
  final bool isColorSingle;
  final int speedScale;

  EspTheme({
    required this.name,
    required this.value,
    required this.path,
    required this.property,
    this.isColorSingle = false,
    this.speedScale = 1, // default scale
  });
}

List<EspTheme> Allthemes = [
  EspTheme(
    name: "تک رنگ",
    value: 0,
    path: "ass/themes/static.png",
    property: "نمایش یک رنگ ثابت",
    isColorSingle: true,
    speedScale: 0,
  ),
  EspTheme(
    name: "آکواریوم",
    value: 9,
    path: "ass/themes/fish.png",
    property: "پیکسل های رنگی",
    speedScale: 1,
  ),
  EspTheme(
    name: "رنگین کمان",
    value: 11,
    path: "ass/themes/rainbow.png",
    property: "رنگ های مختلف",
    speedScale: 32,
  ),
  EspTheme(
    name: "نفس کشیدن",
    value: 2,
    path: "ass/themes/fade.png",
    property: "نور فید می شود",
    isColorSingle: true,
    speedScale: 2,
  ),
  EspTheme(
    name: "چشمک زن",
    value: 1,
    path: "ass/themes/blink.png",
    property: "لامپ چشمک می زند",
    isColorSingle: true,
    speedScale: 4,
  ),
  EspTheme(
    name: "دریا",
    value: 55,
    path: "ass/themes/sea.png",
    property: "احساسی از موج های دریا",
    isColorSingle: true,
    speedScale: 1,
  ),
  EspTheme(
    name: "رنگ آمیزی",
    value: 7,
    path: "ass/themes/paint.png",
    property: "لامپ رنگ آمیزی می شود",
    speedScale: 1,
  ),
  EspTheme(
    name: "جشن و پارتی",
    value: 22,
    path: "ass/themes/party.png",
    property: "هنگام جشن استفاده شود",
    speedScale: 1,
  ),
  EspTheme(
    name: "نور فراری",
    value: 24,
    path: "ass/themes/run.png",
    property: "نوری که فرار می کند",
    isColorSingle: true,
    speedScale: 1,
  ),
  EspTheme(
    name: "نور چرخان",
    value: 40,
    path: "ass/themes/circle.png",
    property: "نور دور لامپ می چرخد",
    isColorSingle: true,
    speedScale: 1,
  ),
  EspTheme(
    name: "پلیسی",
    value: 41,
    path: "ass/themes/police.png",
    property: "همان رنگ آبی و قرمز",
    speedScale: 1,
  ),
  EspTheme(
    name: "نور چرخان رنگی",
    value: 42,
    path: "ass/themes/circle2.png",
    property: "نور رنگی می چرخد",
    speedScale: 2,
  ),
  EspTheme(
    name: "رقص",
    value: 59,
    path: "ass/themes/dance.png",
    property: "رقص و جشن",
    isColorSingle: true,
    speedScale: 2,
  ),
];

int findThemeIndex(List<EspTheme> themes, int maincycleMode) {
  for (int i = 0; i < themes.length; i++) {
    if (themes[i].value == maincycleMode) {
      return i;
    }
  }
  return -1;
}
