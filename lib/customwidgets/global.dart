import 'dart:convert';

import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/data/cache_service.dart';

void showWiFiDialog(BuildContext context) {
  bool connected = false;
  final ssidController = TextEditingController();
  final passController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "popup",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return Center(
        child: AlertDialog(
          scrollable: true,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          backgroundColor: FIGMA.Gray,
          content: StatefulBuilder(builder: (context, setState) {
            return EasyContainer(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height * 0.60,
              color: FIGMA.Gray,
              borderWidth: 0,
              elevation: 0,
              margin: 0,
              padding: 6,
              borderRadius: 30,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: connected
                    ? [
                        SizedBox(height: 50.h),
                        Icon(LucideIcons.checkCircle,
                            size: 80.sp, color: Colors.green),
                        SizedBox(height: 10.h),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            "مراحل اتصال تکمیل شد!",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: FIGMA.estsb,
                                color: FIGMA.Wrn),
                          ),
                        ),
                        const Spacer(),
                        EasyContainer(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 95,
                          borderRadius: 15,
                          color: FIGMA.Orn,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text("برگشت",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: FIGMA.estsb,
                                  color: FIGMA.Wrn)),
                        ),
                      ]
                    : [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "اتصال به شبکه نوروانا",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: FIGMA.estsb,
                                color: FIGMA.Wrn),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "لطفا کادر های زیر را برای اتصال کامل کنید",
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: FIGMA.estre,
                                color: FIGMA.Gray4),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        SizedBox(
                            width: 269.w,
                            height: 68.h,
                            child: EyeTextField(
                              controller: ssidController,
                              hintText: "WiFi نام",
                              showEye: false,
                            )),
                        SizedBox(
                            width: 269.w,
                            height: 68.h,
                            child: EyeTextField(
                              controller: passController,
                              hintText: "رمز عبور",
                            )),
                        Column(
                          children: [
                            EasyContainer(
                              padding: 0,
                              margin: 0,
                              elevation: 0,
                              width: 269.w,
                              height: 68.h,
                              borderRadius: 15,
                              color: FIGMA.Prn,
                              onTap: () {
                                if (ssidController.text.isNotEmpty &&
                                    passController.text.isNotEmpty) {
                                  setState(() {
                                    String jsonPayload = jsonEncode({
                                      "Np": passController.text,
                                      "Ns": ssidController.text,
                                    });
                                    SingleBle().sendMain(jsonPayload);
                                    connected = true;
                                  });
                                }
                              },
                              child: Text("ارسال اطلاعات",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: FIGMA.estbo,
                                      color: FIGMA.Wrn)),
                            ),
                            SizedBox(height: 8.h),
                            EasyContainer(
                              padding: 0,
                              margin: 0,
                              elevation: 0,
                              width: 269.w,
                              height: 68.h,
                              borderRadius: 15,
                              color: FIGMA.Orn,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text("خروج",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: FIGMA.estbo,
                                      color: FIGMA.Wrn)),
                            ),
                          ],
                        ),
                      ],
              ),
            );
          }),
        ),
      );
    },
  );
}

Future<void> setup(ProvData funcy) async {
  debugPrint("start");
  final service = CacheService.instance;

  // Check if token exists
  if (service.token != null && service.token!.isNotEmpty) {
    funcy.setIsUserLoggedIn(true);

    // Load default colors from Hive if you still need them
    var sdcardBox = Hive.box(FIGMA.HIVE2);
    for (var i = 0; i < 5; i++) {
      funcy.Defalult_colors[i] =
          sdcardBox.get("COLOR$i", defaultValue: 0xFFFFFF);
    }

    await funcy.getDetailsFromNet();
    // await CacheService.instance.updateUser(service.token!);
  } else {
    debugPrint("no token found in SdcardService");
  }
  debugPrint("end");
}

void showCannotSend(ProvData value) {
  value.Show_Snackbar("هیچ اتصالی وجود ندارد", 1000);
}

Future<void> checkModeColors(ProvData value) async {
  int idOfStatic = 1;
  int maincycleMode = value.maincycle_mode;
  // for (var theme in value.themes) {
  //   var item = theme.content[0];

  //   if (item.m == 0) {
  //     idOfStatic = theme.id;
  //   }

  //   if (item.m == maincycleMode) {
  //     value.setMainCycleMode(item.m);
  //     if (item.c != null) {
  //       if (value.bleIsConnected) {
  //         int modeValue = 0;
  //         modeValue = 0;
  //         String jsonPayload = jsonEncode({
  //           "Mode": [
  //             {
  //               "s": 0,
  //               "e": 15,
  //               "m": modeValue,
  //               "sc": 100,
  //             }
  //           ]
  //         });
  //         SingleBle().sendMain(jsonPayload);
  //         lampKey.currentState?.shake();
  //         value.Show_Snackbar("تم برای رنگ تغییر کرد", 500);
  //         return;
  //       }
  //       if (value.netvanaIsConnected) {
  //         await NetClass().setMode(
  //           CacheService.instance.token!,
  //           value.selectedDevice.id.toString(),
  //           idOfStatic.toString(),
  //         );
  //         value.Show_Snackbar("تم برای رنگ تغییر کرد", 500);
  //         return;
  //       }
  //       showCannotSend(value);
  //     }
  //   }
  // }
}

int getIdbyMode(ProvData value) {
  int maincycleMode = value.maincycle_mode;
  // for (var theme in value.themes) {
  //   var item = theme.content[0];

  //   if (item.m == maincycleMode) {
  //     return theme.id;
  //   }
  // }

  return 0;
}
