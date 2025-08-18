// ignore_for_file: file_names

import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TheAppNav extends StatefulWidget {
  const TheAppNav({super.key});
  @override
  State<TheAppNav> createState() => _TheAppNavState();
}

class _TheAppNavState extends State<TheAppNav> {
  @override
  Widget build(BuildContext context) {
    double iconSize = 28;
    return Consumer<ProvData>(
      builder: (context, value, child) {
        return SizedBox(
          height: 120,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GNav(
              backgroundColor: Colors.transparent,
              selectedIndex:
                  value.Isdevicefound == true && value.Current_screen == 3
                      ? 2
                      : value.Current_screen,
              tabActiveBorder: Border.all(color: FIGMA.Gray2, width: 2),
              tabMargin: const EdgeInsets.only(right: 2, left: 2),
              tabBorderRadius: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              color: Colors.grey,
              activeColor: FIGMA.Prn2,
              tabBackgroundColor: FIGMA.Gray,
              gap: 8,
              // tabBorder: Border.all(color: FIGMA.Prn),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              tabs: [
                GButton(
                  iconSize: iconSize,
                  icon: Icons.home_rounded,
                  text: "خانه",
                  textStyle: const TextStyle(
                      fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Prn2),
                ),
                GButton(
                  iconSize: iconSize,
                  icon: LucideIcons.box,
                  text: "افکت ها",
                  textStyle: const TextStyle(
                      fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Prn2),
                ),
                GButton(
                  iconSize: iconSize,
                  icon: Icons.wifi_rounded,
                  text: "نت وانا",
                  textStyle: const TextStyle(
                      fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Prn2),
                ),
                GButton(
                  iconSize: iconSize,
                  icon: Icons.settings_rounded,
                  text: "تنظیمات",
                  textStyle: const TextStyle(
                      fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Prn2),
                ),
              ],
              onTabChange: (index) {
                value.Change_current_screen(index);
              },
            ),
          ),
        );
      },
    );
  }
}
