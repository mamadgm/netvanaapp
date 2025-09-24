// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    double iconSize = 24.sp;
    return Consumer<ProvData>(
      builder: (context, value, child) {
        if (value.Current_screen != 3) {
          return SizedBox(
            height: 95.h,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: GNav(
                backgroundColor: FIGMA.Back,
                tabBackgroundColor: FIGMA.Gray,
                selectedIndex:
                    value.Isdevicefound == true && value.Current_screen == 3
                        ? 2
                        : value.Current_screen,
                tabActiveBorder: Border.all(
                  color: FIGMA.Gray2,
                  width: 1.5.sp,
                ),
                tabBorder: Border.all(
                  color: FIGMA.Gray2,
                  width: 1.5.sp,
                ),
                tabMargin: const EdgeInsets.only(right: 2, left: 2),
                tabBorderRadius: 20,
                // tabBorder: ,
                mainAxisAlignment: MainAxisAlignment.center,
                color: Colors.blue,
                activeColor: FIGMA.Prn2,
                // Remove tabBackgroundColor to avoid conflicts
                gap: 8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                tabs: [
                  GButton(
                    iconSize: iconSize,
                    icon: Icons.home_rounded,
                    leading: SvgPicture.asset(
                      "assets/Home.svg",
                      color:
                          value.Current_screen == 0 ? FIGMA.Prn2 : FIGMA.Gray3,
                    ),
                    text: "خانه",
                    textStyle: TextStyle(
                      fontFamily: FIGMA.estbo,
                      fontSize: 11.sp,
                      color: FIGMA.Prn2,
                    ),
                  ),
                  GButton(
                    iconSize: iconSize,
                    icon: LucideIcons.box,
                    leading: SvgPicture.asset(
                      "assets/Effects.svg",
                      color:
                          value.Current_screen == 1 ? FIGMA.Prn2 : FIGMA.Gray3,
                    ),
                    text: "افکت ها",
                    textStyle: TextStyle(
                      fontFamily: FIGMA.estbo,
                      fontSize: 11.sp,
                      color: FIGMA.Prn2,
                    ),
                  ),
                  GButton(
                    iconSize: iconSize,
                    icon: Icons.wifi_rounded,
                    leading: SvgPicture.asset(
                      "assets/Netvana.svg",
                      color:
                          value.Current_screen == 2 ? FIGMA.Prn2 : FIGMA.Gray3,
                    ),
                    text: "نت وانا",
                    textStyle: TextStyle(
                      fontFamily: FIGMA.estbo,
                      fontSize: 11.sp,
                      color: FIGMA.Prn2,
                    ),
                  ),
                  GButton(
                    iconSize: iconSize,
                    icon: Icons.settings_rounded,
                    leading: SvgPicture.asset(
                      "assets/Setting.svg",
                      color:
                          value.Current_screen == 3 ? FIGMA.Prn2 : FIGMA.Gray3,
                    ),
                    text: "تنظیمات",
                    textStyle: TextStyle(
                      fontFamily: FIGMA.estbo,
                      fontSize: 11.sp,
                      color: FIGMA.Prn2,
                    ),
                  ),
                ],
                onTabChange: (index) {
                  value.Change_current_screen(index);
                },
              ),
            ),
          );
        } else {
          return SizedBox(height: 0.h);
        }
      },
    );
  }
}
