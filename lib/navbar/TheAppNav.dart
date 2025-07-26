// ignore_for_file: file_names

import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

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
          height: 100,
          child: GNav(
            backgroundColor: Colors.transparent,
            selectedIndex:
                value.Isdevicefound == true && value.Current_screen == 3
                    ? 2
                    : value.Current_screen,
            tabActiveBorder: Border.all(color: FIGMA.Gray, width: 3),
            tabMargin: const EdgeInsets.only(right: 2, left: 2),
            tabBorderRadius: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            color: Colors.grey,
            activeColor: FIGMA.Prn,
            tabBackgroundColor: FIGMA.Wrn,
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            tabs: [
              GButton(
                iconSize: iconSize,
                icon: Icons.wifi_rounded,
                text: "نت وانا",
                textStyle: const TextStyle(
                    fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Prn),
              ),
              GButton(
                iconSize: iconSize,
                icon: Icons.color_lens_rounded,
                text: "افکت ها",
                textStyle: const TextStyle(
                    fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Prn),
              ),
              GButton(
                iconSize: iconSize,
                icon: Icons.home,
                text: "خانه",
                textStyle: const TextStyle(
                    fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Prn),
              ),
            ],
            onTabChange: (index) {
              value.Change_current_screen(index);
            },
          ),
        );
      },
    );
  }
}
