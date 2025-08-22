import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/ButtonIcon.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:netvana/customwidgets/NewScreen.dart';
import 'package:netvana/customwidgets/cylander.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:netvana/models/SingleHive.dart';
import 'package:provider/provider.dart';

class ProfileScr extends StatefulWidget {
  const ProfileScr({super.key});

  @override
  State<ProfileScr> createState() => _ProfileScrState();
}

class _ProfileScrState extends State<ProfileScr> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(builder: (context, value, child) {
      return SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Center(
            child: SizedBox(
              height: 240.h,
              width: 120.w,
              child: LampWidget(
                glowIntensity: 1,
                lampColor: (value.netvanaIsConnected)
                    ? colorFromString(value.maincycle_color)
                    : colorFromString("0xFF555555"),
                height: 150.h,
                width: 80.w,
              ),
            ),
          ),
          EasyContainer(
            height: 400.h,
            borderRadius: 40,
            elevation: 0,
            margin: 0,
            padding: 8,
            color: FIGMA.Back,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                WiFiItem(
                    leadingIcon: Icons.arrow_back_ios_new_rounded,
                    title: "حساب کاربری",
                    trailingIcon: LucideIcons.user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomScreen(
                            title: "حساب کاربری",
                            body: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 8.h),
                                SizedBox(
                                  width: 329.w,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "نام کاربری",
                                      style: TextStyle(
                                          fontFamily: FIGMA.estsb,
                                          fontSize: 12.sp,
                                          color: FIGMA.Gray4),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                SizedBox(
                                  height: 68.h,
                                  width: 329.w,
                                  child: EyeTextField(
                                    controller: value.UserNameController,
                                    showEye: false,
                                    hintText: "username",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                WiFiItem(
                  leadingIcon: Icons.arrow_back_ios_new_rounded,
                  title: "حالت خواب",
                  trailingIcon: LucideIcons.moon,
                  onTap: () {},
                ),
                WiFiItem(
                  leadingIcon: Icons.arrow_back_ios_new_rounded,
                  title: "بروزرسانی",
                  trailingIcon: LucideIcons.downloadCloud,
                  onTap: () {},
                ),
                WiFiItem(
                  leadingIcon: Icons.arrow_back_ios_new_rounded,
                  title: "درباره ما",
                  trailingIcon: LucideIcons.info,
                  onTap: () {},
                ),
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 70.h,
                        width: 140.w,
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
                                      fontSize: 14.sp,
                                      color: FIGMA.Wrn),
                                ),
                                Text(
                                  "نسخه‌ی ۱.۱.۲ (۷۰۴۰۳۰)",
                                  style: TextStyle(
                                      fontFamily: FIGMA.estre,
                                      fontSize: 10.sp,
                                      color: FIGMA.Gray4),
                                ),
                              ],
                            ),
                            SizedBox(width: 3.sp),
                            SvgPicture.asset("assets/Logo.svg",
                                height: 36.h, width: 36.w),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16.w,
                      child: EasyContainer(
                        height: 64.h,
                        width: 64.w,
                        color: FIGMA.Back,
                        showBorder: true,
                        borderWidth: 1.sp,
                        borderColor: FIGMA.Gray2,
                        borderRadius: 20,
                        elevation: 0,
                        margin: 0,
                        padding: 0,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: FIGMA.Gray3,
                          size: 24.sp,
                        ),
                        onTap: () {
                          value.Change_current_screen(0);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ));
    });
  }
}
