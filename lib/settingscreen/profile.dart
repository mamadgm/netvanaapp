import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/BLE/screens/Setting/espsettings.dart';
import 'package:netvana/Login/Login.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/ButtonIcon.dart';
import 'package:netvana/customwidgets/cylander.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

class ProfileScr extends StatefulWidget {
  const ProfileScr({super.key});

  @override
  State<ProfileScr> createState() => _ProfileScrState();
}

class _ProfileScrState extends State<ProfileScr> {
  void setup() {
    final funcy = context.read<ProvData>();
    var sdcard = Hive.box(FIGMA.HIVE);

    var token = sdcard.get("access_token", defaultValue: "empty");

    if (token != "empty") {
      String s1 = sdcard.get("phone", defaultValue: "empty");
      String s2 = sdcard.get("name", defaultValue: "empty");
      String s3 = sdcard.get("last", defaultValue: "empty");
      String s4 = sdcard.get("token", defaultValue: "empty");

      funcy.Set_Userdetails(s1, s2, s3, s4);
      var products = sdcard.get("products", defaultValue: "empty");

      if (products != "empty") {
        funcy.setProducts(products);
      } else {
        debugPrint("no products");
      }

      for (var i = 0; i < 5; i++) {
        funcy.Defalult_colors[i] =
            sdcard.get("COLOR$i", defaultValue: 0xFFFFFF);
      }
    } else {
      debugPrint("no token");
    }
    funcy.setIsUserLoggedIn(false);
    funcy.hand_update();
  }

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
                lampColor: (!value.nextmoveisconnect | value.isConnectedWifi)
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
                  onTap: () {},
                ),
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
