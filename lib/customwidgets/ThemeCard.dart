// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/Network/netmain.dart';
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
  final List<ContentItem> content;

  const ThemeCard({
    Key? key,
    required this.id,
    required this.picUrl,
    required this.bigText,
    required this.smallText,
    required this.scale,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
      builder: (context, value, child) {
        final bool isSelected = value.maincycle_mode == content[0].m;
        final bool isFavorite = value.Favorites.contains(id);

        return EasyContainer(
          onTap: () async {
            debugPrint("Tapped Theme id: $id");

            if (value.nextmoveisconnect) {
              try {
                await NetClass().setMode(
                  value.token,
                  value.Products[0]["id"].toString(),
                  id.toString(),
                );
                debugPrint("✅ Theme set successfully");
              } catch (e) {
                debugPrint("⚠️ Failed to set theme: $e");
              }
            }

            // Extract m value for BLE
            int modeValue = 0;

            modeValue = content[0].m;

            // Prepare BLE payload
            String jsonPayload = jsonEncode({
              "Mode": [
                {
                  "s": 0,
                  "e": 15,
                  "m": modeValue,
                  "sc": scale,
                }
              ]
            });

            SingleBle().sendMain(jsonPayload);
          },
          padding: 8,
          borderRadius: 15,
          elevation: isSelected ? 5 : 0,
          color: isSelected ? FIGMA.Prn : FIGMA.Gray2,
          child: Column(
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: FIGMA.Wrn,
                      size: 32,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        value.Favorites.remove(id);
                      } else {
                        value.Favorites.add(id);
                      }
                      final sdcard = Hive.box(FIGMA.HIVE);
                      sdcard.put('Favorites', value.Favorites.toList());
                      value.hand_update();
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        bigText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: FIGMA.estsb,
                          color: FIGMA.Wrn,
                        ),
                      ),
                      Text(
                        smallText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: FIGMA.estre,
                          color: FIGMA.Wrn2,
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
            "اکتیو",
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
            "پاسیو",
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
