import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/ProfilePages/About.dart';
import 'package:netvana/ProfilePages/Account.dart';
import 'package:netvana/ProfilePages/Sleep.dart';
import 'package:netvana/ProfilePages/Update.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/ButtonIcon.dart';
import 'package:netvana/customwidgets/Lampwidet.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:provider/provider.dart';

class ProfileScr extends StatefulWidget {
  const ProfileScr({super.key});

  @override
  State<ProfileScr> createState() => _ProfileScrState();
}

class _ProfileScrState extends State<ProfileScr> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
      builder: (context, value, child) {
        return SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        height: 300.h,
                        width: 140.w,
                        child: Center(
                          child: LampWidget(
                            glowIntensity: 1,
                            lampColor:
                                (value.selectedDevice.isOnline |
                                    value.bleIsConnected)
                                ? colorFromString(value.maincycle_color)
                                : colorFromString("0xFF555555"),
                            height: 300.h,
                            width: 160.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 200.h,
                child: EasyContainer(
                  height: 400.h,
                  borderRadius: 40,
                  elevation: 0,
                  margin: 0,
                  padding: 8,
                  color: FIGMA.Back,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SettingItem(
                        leadingIcon: Icons.arrow_back_ios_new_rounded,
                        title: "حساب کاربری",
                        trailingIcon: LucideIcons.user,
                        onTap: () {
                          showAccount(context, value);
                        },
                      ),
                      dev(),
                      SettingItem(
                        leadingIcon: Icons.arrow_back_ios_new_rounded,
                        title: "حالت خواب",
                        trailingIcon: LucideIcons.moon,
                        onTap: () {
                          showSleepSetting(context, value);
                        },
                      ),
                      dev(),
                      SettingItem(
                        leadingIcon: Icons.arrow_back_ios_new_rounded,
                        title: "درباره ما",
                        trailingIcon: LucideIcons.info,
                        onTap: () {
                          showAboutUs(context, value);
                        },
                      ),
                      dev(),
                      SettingItem(
                        leadingIcon: Icons.arrow_back_ios_new_rounded,
                        title: "خروج",
                        trailingIcon: LucideIcons.arrowBigRight,
                        onTap: () {
                          showUpdate(context, value);
                        },
                      ),
                      dev(),
                      Center(
                        child: SizedBox(
                          height: 105.h,
                          width: 375.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "نوروانا",
                                    style: TextStyle(
                                      fontFamily: FIGMA.abrlb,
                                      fontSize: 12.sp,
                                      color: FIGMA.Wrn,
                                    ),
                                  ),
                                  Text(
                                    "نسخه‌ی ۱.۱.۲ (۷۰۴۰۳۱)",
                                    style: TextStyle(
                                      fontFamily: FIGMA.estre,
                                      fontSize: 9.sp,
                                      color: FIGMA.Gray4,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 3.sp),
                              SvgPicture.asset(
                                "assets/Logo.svg",
                                height: 36.h,
                                width: 36.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget dev() {
    return Column(
      children: [
        Container(height: 0.5.h, color: Colors.transparent, width: 290.w),
        Container(height: 0.5.h, color: FIGMA.Gray3, width: 290.w),
      ],
    );
  }
}
