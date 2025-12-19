// ignore_for_file: non_constant_identifier_names, file_names

import 'package:easy_container/easy_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/ButtonIcon.dart';
import 'package:netvana/customwidgets/Lampwidet.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:netvana/data/errors/error_login.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class Netvana extends StatelessWidget {
  const Netvana({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ProvData>(
        builder: (context, value, child) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          height: 300.h,
                          width: 140.w,
                          child: LampWidget(
                            glowIntensity: 1,
                            lampColor: (value.selectedDevice.isOnline)
                                ? colorFromString(value.maincycle_color)
                                : colorFromString("0xFF555555"),
                            height: 150.h,
                            width: 80.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: EasyContainer(
                      borderRadius: 40,
                      elevation: 0,
                      margin: 0,
                      padding: 15,
                      color: FIGMA.Back,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          WiFiItem(
                            leadingIcon: Icons.arrow_back_ios_new_rounded,
                            title: "وای فای جدید",
                            trailingIcon: LucideIcons.plus,
                            onTap: () {
                              if (value.selectedDevice.isOnline) {
                                value.Show_Snackbar(
                                  "دستگاه شما متصل است",
                                  1000,
                                  type: 2,
                                );
                                return;
                              }
                              showWiFiDialog(context);
                            },
                          ),
                          WiFiItem(
                            leadingIcon: Icons.arrow_back_ios_new_rounded,
                            title: "قطع دستگاه از مودم",
                            trailingIcon: Icons.wifi_off_rounded,
                            onTap: () async {
                              if (!value.selectedDevice.isOnline) {
                                value.Show_Snackbar(
                                  "دستگاه شما اکنون قطع میباشد",
                                  1000,
                                  type: 1,
                                );
                                return;
                              }
                              try {
                                await NetClass().setDeviceOffline(
                                  CacheService.instance.token!,
                                  (value.selectedDevice.id).toString(),
                                );
                              } catch (e) {
                                final detail = extractDetailFromException(e);
                                value.Show_Snackbar(detail!, 1000, type: 3);
                              }
                            },
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: value.selectedDevice.isOnline
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          EasyContainer(
                            height: 60.h,
                            showBorder: true,
                            borderColor: FIGMA.Gray2,
                            color: FIGMA.Gray,
                            customPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            elevation: 0,
                            shadowColor: FIGMA.Gray2,
                            borderWidth: 3,
                            borderRadius: 30,
                            child: Row(
                              children: [
                                Text(
                                  "Wifi:",
                                  style: TextStyle(
                                    color: FIGMA.Gray4,
                                    fontFamily: FIGMA.estre,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                Text(
                                  value.Device_SSID,
                                  style: TextStyle(
                                    color: FIGMA.Wrn,
                                    fontFamily: FIGMA.estsb,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          EasyContainer(
                            height: 60.h,
                            width: 148.w,
                            showBorder: true,
                            borderColor: FIGMA.Gray2,
                            color: FIGMA.Gray,
                            padding: 16,
                            elevation: 5,
                            shadowColor: FIGMA.Gray2,
                            borderWidth: 3,
                            borderRadius: 30,
                            child: Row(
                              children: [
                                Text(
                                  "عالی",
                                  style: TextStyle(
                                    color: FIGMA.Prn2,
                                    fontFamily: FIGMA.estsb,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  ":وضعیت اتصال",
                                  style: TextStyle(
                                    color: FIGMA.Gray4,
                                    fontFamily: FIGMA.estre,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : EasyContainer(
                        width: 240.w,
                        height: 60.h,
                        showBorder: true,
                        borderColor: FIGMA.Gray2,
                        color: FIGMA.Gray,
                        customPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        elevation: 0,
                        shadowColor: FIGMA.Gray2,
                        borderWidth: 3,
                        borderRadius: 30,
                        child: Text(
                          "دستگاه شما به نتوانا متصل نیست",
                          style: TextStyle(
                            color: FIGMA.Gray4,
                            fontFamily: FIGMA.estre,
                            fontSize: 13.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
