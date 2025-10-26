// ignore_for_file: file_names
import 'dart:convert';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:provider/provider.dart';

class ThemeCard extends StatelessWidget {
  final int id;
  final String picUrl;
  final String bigText;
  final String smallText;
  final int scale;
  final List<dynamic> content;

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
        final bool isSelected = value.maincycle_mode == content[0]['m'];
        final bool isFavorite = value.Favorites.contains(id);
        return EasyContainer(
          onTap: () async {
            if (value.bleIsConnected) {
              int modeValue = 0;
              modeValue = content[0]['m'];
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
              lampKey.currentState?.shake();
              return;
            }
            if (value.netvanaIsConnected) {
              await NetClass().setMode(
                CacheService.instance.token!,
                value.selectedDevice.id.toString(),
                id.toString(),
              );
              return;
            }
            showCannotSend(value);
          },
          padding: 8,
          margin: 0,
          borderRadius: 15,
          elevation: isSelected ? 5 : 0,
          color: isSelected ? FIGMA.Prn : FIGMA.Gray2,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    (id % 2 == 0) ? picUrl : picUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Optional: Handle image loading errors
                      return Icon(
                        HugeIcons.strokeRoundedWifiError01,
                        color: FIGMA.Wrn,
                        size: 36.sp,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      // Optional: Show a loading indicator
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
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
                      CacheService.instance.saveFavorites(value.Favorites);
                      value.hand_update();
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        bigText,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: FIGMA.estsb,
                          color: FIGMA.Wrn,
                        ),
                      ),
                      Text(
                        smallText,
                        style: TextStyle(
                          fontSize: 9.sp,
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
  TextStyle enabled =
      TextStyle(color: FIGMA.Wrn, fontFamily: FIGMA.estsb, fontSize: 12.sp);
  TextStyle disabled = enabled;
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilterChip(
          padding: EdgeInsets.all(14.sp),
          backgroundColor: FIGMA.Gray2,
          showCheckmark: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: BorderSide(
            color: prov.selectedFilter == ThemeFilter.liked
                ? FIGMA.Prn
                : FIGMA.Gray2,
            width: prov.selectedFilter == ThemeFilter.liked ? 1.sp : 0,
          ),
          disabledColor: FIGMA.Gray2,
          selectedColor: FIGMA.Grn,
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
          padding: EdgeInsets.all(14.sp),
          backgroundColor: FIGMA.Gray2,
          showCheckmark: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: BorderSide(
              color: prov.selectedFilter == ThemeFilter.single
                  ? FIGMA.Prn
                  : FIGMA.Gray2,
              width: prov.selectedFilter == ThemeFilter.single ? 1.sp : 0),
          disabledColor: FIGMA.Gray2,
          selectedColor: FIGMA.Grn,
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
          padding: EdgeInsets.all(14.sp),
          backgroundColor: FIGMA.Gray2,
          showCheckmark: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: BorderSide(
            color: prov.selectedFilter == ThemeFilter.multiple
                ? FIGMA.Prn
                : FIGMA.Gray2,
            width: prov.selectedFilter == ThemeFilter.multiple ? 1.sp : 0,
          ),
          disabledColor: FIGMA.Gray2,
          selectedColor: FIGMA.Grn,
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
