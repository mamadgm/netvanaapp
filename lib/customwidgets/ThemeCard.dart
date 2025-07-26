// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/const/themes.dart';
import 'package:provider/provider.dart';
import 'package:easy_container/easy_container.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';

class ThemeCard extends StatelessWidget {
  final int id;
  final String picUrl;
  final String bigText;
  final String smallText;
  final int scale;
  const ThemeCard(
      {Key? key,
      required this.id,
      required this.picUrl,
      required this.bigText,
      required this.smallText,
      required this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Here?
    return Consumer<ProvData>(
      builder: (context, value, child) {
        final bool isSelected = value.maincycle_mode == id;
        final bool isFavorite = value.Favorites.contains(id);

        return EasyContainer(
          onTap: () {
            String jsonPayload = jsonEncode({
              "Mode": [
                {"s": 0, "e": 15, "m": id, "sc": scale},
              ]
            });
            SingleBle().sendMain(jsonPayload);
          },
          padding: 8,
          borderRadius: 15,
          elevation: isSelected ? 5 : 0,
          color: isSelected ? FIGMA.Prn : FIGMA.Back,
          child: Column(
            children: [
              // 1:1 Aspect Ratio Image
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    picUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Bottom Row: Text + Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon (left)
                  IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: isSelected ? Colors.white : FIGMA.Orn,
                      size: 32,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        value.Favorites.remove(id);
                      } else {
                        value.Favorites.add(id);
                      }

                      // Save updated favorites list to Hive
                      final sdcard = Hive.box(FIGMA.HIVE);
                      sdcard.put('Favorites', value.Favorites.toList());

                      value.hand_update();
                    },
                  ),

                  // Texts (right)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        bigText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: FIGMA.estsb,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        smallText,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FIGMA.estre,
                          color: isSelected ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildFilters(BuildContext context) {
  final prov = Provider.of<ProvData>(context);
  TextStyle enabled = const TextStyle(
      color: Colors.black, fontFamily: FIGMA.estsb, fontSize: 20);
  TextStyle disabled = const TextStyle(
      color: Colors.grey, fontFamily: FIGMA.estsb, fontSize: 20);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilterChip(
          backgroundColor: FIGMA.Back,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          disabledColor: FIGMA.Back,
          selectedColor: Colors.white,
          label: Text(
            "مورد علاقه",
            style:
                prov.selectedFilter == ThemeFilter.liked ? enabled : disabled,
          ),
          selected: prov.selectedFilter == ThemeFilter.liked,
          onSelected: (_) => prov.toggleFilter(ThemeFilter.liked),
        ),
        const SizedBox(width: 8),
        FilterChip(
          backgroundColor: FIGMA.Back,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          disabledColor: FIGMA.Back,
          selectedColor: Colors.white,
          label: Text(
            "پاسیو",
            style:
                prov.selectedFilter == ThemeFilter.single ? enabled : disabled,
          ),
          selected: prov.selectedFilter == ThemeFilter.single,
          onSelected: (_) => prov.toggleFilter(ThemeFilter.single),
        ),
        const SizedBox(width: 8),
        FilterChip(
          backgroundColor: FIGMA.Back,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          disabledColor: FIGMA.Back,
          selectedColor: Colors.white,
          label: Text(
            "اکتیو",
            style: prov.selectedFilter == ThemeFilter.multiple
                ? enabled
                : disabled,
          ),
          selected: prov.selectedFilter == ThemeFilter.multiple,
          onSelected: (_) => prov.toggleFilter(ThemeFilter.multiple),
        ),
      ],
    ),
  );
}

List<EspTheme> getFilteredAndSortedThemes(
    ProvData prov, List<EspTheme> allThemes) {
  List<EspTheme> filtered = [];

  switch (prov.selectedFilter) {
    case ThemeFilter.liked:
      filtered =
          allThemes.where((t) => prov.Favorites.contains(t.value)).toList();
      break;
    case ThemeFilter.single:
      filtered = allThemes.where((t) => t.isColorSingle).toList();
      break;
    case ThemeFilter.multiple:
      filtered = allThemes.where((t) => !t.isColorSingle).toList();
      break;
    case ThemeFilter.none:
      filtered = [...allThemes];
  }

  // Move favorites to top
  filtered.sort((a, b) {
    final aFav = prov.Favorites.contains(a.value);
    final bFav = prov.Favorites.contains(b.value);
    if (aFav == bFav) return 0;
    return aFav ? -1 : 1;
  });

  return filtered;
}
