import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/ButtonIcon.dart';

import 'package:netvana/screens/qr_scanner_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NoDevicesScreen extends StatelessWidget {
  const NoDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: FIGMA.Back,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'هیچ دستگاهی پیدا نشد',
                  style: TextStyle(
                      fontFamily: FIGMA.estbo,
                      color: FIGMA.Wrn,
                      fontSize: 15.sp),
                ),
                const Spacer(),
                Icon(
                  LucideIcons.searchX,
                  color: FIGMA.Orn,
                  size: 48.sp,
                ),
                const Spacer(),
                Column(
                  children: [
                    WiFiItem(
                      leadingIcon: Icons.arrow_back_ios_new_rounded,
                      title: "اضافه کردن دستگاه جدید",
                      trailingIcon: LucideIcons.plus,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QrScannerScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    WiFiItem(
                      leadingIcon: Icons.arrow_back_ios_new_rounded,
                      title: "خرید دستگاه",
                      trailingIcon: LucideIcons.shoppingCart,
                      onTap: () async {
                        final url = Uri.parse('https://site.netvana.ir');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          )),
    );
  }
}
