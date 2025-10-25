// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/screens/products/nooran/Buttons/mybuttons.dart';
import 'package:netvana/BLE/screens/products/nooran/Spelco/spelco.dart';
import 'package:netvana/BLE/screens/products/nooran/sliders/sliders.dart';
import 'package:netvana/Network/netmain.dart';
// import 'package:netvana/ble/logic/esp_ble.dart';

import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/Lampwidet.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:netvana/models/SingleHive.dart';
import 'package:provider/provider.dart';
// import 'package:universal_ble/universal_ble.dart';
// import 'package:record/record.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';

class Nooran extends StatefulWidget {
  const Nooran({super.key});

  @override
  State<Nooran> createState() => _NooranState();
}

class _NooranState extends State<Nooran> {
  // double _loudness = 0;
  // final Record _record = Record();
  late List<Widget> Sliderwidgets;
  Future<void> startRecording() async {}

  @override
  void initState() {
    startRecording();
    super.initState();
    final value = Provider.of<ProvData>(context, listen: false);
    value.loadFavoritesFromHive();

    SingleBle().init(value);
    Sliderwidgets = [
      Speed_slider(
        senddata: (speed) {
          if (value.bleIsConnected) {
            String jsonPayload = jsonEncode({"Ls": speed});
            SingleBle().sendMain(jsonPayload);
            value.setMainCycleSpeed(int.parse(speed));
            return;
          }
          if (value.netvanaIsConnected) {
            NetClass().setSpeed(SdcardService.instance.token!,
                value.selectedDevice.id.toString(), speed);
            value.setMainCycleSpeed(int.parse(speed));
            return;
          }
          showCannotSend(value);
        },
      ),
      Bright_slider(
        senddata: (bright) {
          if (value.bleIsConnected) {
            String jsonPayload = jsonEncode({"Lb": bright});
            SingleBle().sendMain(jsonPayload);

            value.setBrightness(int.parse(bright));
            return;
          }
          if (value.netvanaIsConnected) {
            NetClass().setBright(SdcardService.instance.token!,
                value.selectedDevice.id.toString(), bright);
            value.setBrightness(int.parse(bright));
            return;
          }
          showCannotSend(value);
        },
        brightness: value.Brightness,
        netvana: 1,
      ),
      Color_Picker_HSV(
        senddata: (p0) async {
          await checkModeColors(value);

          if (value.bleIsConnected) {
            String jsonPayload = jsonEncode({"Lc": p0});
            SingleBle().sendMain(jsonPayload);
            value.setMainCycleColor(p0);
            return;
          }
          if (value.netvanaIsConnected) {
            NetClass().setColor(SdcardService.instance.token!,
                value.selectedDevice.id.toString(), p0);
            value.setMainCycleColor(p0);
            return;
          }
          showCannotSend(value);
        },
        netvana: 1,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  Timer? Connecttimer;

  @override
  Widget build(BuildContext context) {
    var sdcard = Hive.box(FIGMA.HIVE2);

    return Consumer<ProvData>(builder: (context, value, child) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 0, left: 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 6.h,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    width: 329.w,
                    height: 70.h,
                    child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Text(
                            "نوروانا",
                            style: TextStyle(
                                fontFamily: FIGMA.abrlb,
                                fontSize: 24.sp,
                                color: FIGMA.Wrn),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: EasyContainer(
                                  height: 70.h,
                                  width: 70.w,
                                  color: FIGMA.Back,
                                  showBorder: true,
                                  borderWidth: 1.sp,
                                  borderColor: FIGMA.Gray2,
                                  borderRadius: 20,
                                  elevation: 0,
                                  margin: 0,
                                  padding: 0,
                                  child: Icon(
                                    value.netvanaIsConnected
                                        ? Icons.wifi_rounded
                                        : Icons.wifi_off_rounded,
                                    color: value.netvanaIsConnected
                                        ? FIGMA.Prn
                                        : FIGMA.Gray3,
                                    size: 24.sp,
                                  ),
                                  onTap: () async {
                                    final service = SdcardService.instance;

                                    try {
                                      await service.updateUser(service.token!);
                                    } catch (e) {
                                      debugPrint("error in update user $e");
                                    }

                                    final firstDevice = value.selectedDevice;

                                    if (!firstDevice.isOnline) {
                                      value.wifi_update_connected(false);
                                      value.Show_Snackbar(
                                          "دستگاه متصل نیست . راه اندازی مجدد ...",
                                          1000);

                                      if (value.bleIsConnected) {
                                        showWiFiDialog(context);
                                      } else {
                                        value.Show_Snackbar(
                                            "برای تنظیم ابتدا به بلوتوث متصل شوید",
                                            1000);
                                      }
                                    } else {
                                      value.wifi_update_connected(true);
                                    }

                                    value.hand_update();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: EasyContainer(
                                    height: 70.h,
                                    width: 70.w,
                                    color: FIGMA.Back,
                                    showBorder: true,
                                    borderWidth: 1.sp,
                                    borderColor: FIGMA.Gray2,
                                    borderRadius: 20,
                                    elevation: 0,
                                    margin: 0,
                                    padding: 0,
                                    child: Icon(
                                      value.bleIsConnected
                                          ? Icons.bluetooth_connected
                                          : Icons.bluetooth_disabled,
                                      color: value.bleIsConnected
                                          ? FIGMA.Prn
                                          : FIGMA.Gray3,
                                      size: 24.sp,
                                    ),
                                    onTap: () async {
                                      if (value.bleIsConnected == true) {
                                        await SingleBle().disconnect();
                                        value.setBleIsConnected(false);
                                        // debugPrint("Device Disconnected");
                                        return;
                                      }
                                      try {
                                        debugPrint("[B] S");
                                        var result = await SingleBle()
                                            .startScanAndGetDevice();
                                        String? selectedDeviceId;
                                        if (result != null) {
                                          selectedDeviceId = result['deviceId'];
                                        }

                                        if (selectedDeviceId == null) {
                                          // debugPrint("No device selected.");
                                          return;
                                        } else {
                                          // debugPrint("Wellcome");
                                        }

                                        debugPrint("[B] ...");
                                        bool connected = await SingleBle()
                                            .connectToDevice(
                                                selectedDeviceId, 200);

                                        if (connected) {
                                          value.setBleIsConnected(true);
                                          debugPrint("[B] Ok");

                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1200),
                                              () async {
                                            switch (
                                                value.current_selected_slider) {
                                              case 0:
                                                value.change_slider(1);
                                                break;
                                              default:
                                                value.change_slider(0);
                                            }
                                          });
                                        } else {
                                          value.setBleIsConnected(false);
                                          debugPrint("[B] F");
                                        }
                                      } catch (e) {
                                        value.setBleIsConnected(false);
                                        // debugPrint('Connection Error: $e');
                                        debugPrint('[B] E');
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: SizedBox(
                                  height: 111.h,
                                  width: 74.w,
                                  child: Sleep_Button(
                                    state:
                                        value.Brightness == value.sleepBright,
                                    onDataChange: (s) {
                                      int Bright = value.sleepBright;
                                      if (value.Brightness ==
                                          value.sleepBright) {
                                        Bright = 255;
                                      }
                                      if (value.bleIsConnected) {
                                        String jsonPayload =
                                            jsonEncode({"Lb": Bright});
                                        SingleBle().sendMain(jsonPayload);
                                        return;
                                      }
                                      if (value.netvanaIsConnected) {
                                        NetClass().setBright(
                                            SdcardService.instance.token!,
                                            value.selectedDevice.id.toString(),
                                            Bright.toString());
                                        return;
                                      }
                                      showCannotSend(value);
                                    },
                                  )),
                            ),
                            const ShortTimer(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            height: 73.h,
                            width: 156.w,
                            child: Power_Button(
                                // setPower
                                onof: value.isdeviceon,
                                onDataChange: () {
                                  if (value.bleIsConnected) {
                                    String jsonPayload =
                                        jsonEncode({"Cp": !value.isdeviceon});
                                    SingleBle().sendMain(jsonPayload);

                                    return;
                                  }
                                  if (value.netvanaIsConnected) {
                                    NetClass().setPower(
                                        SdcardService.instance.token!,
                                        value.selectedDevice.id.toString(),
                                        !value.isdeviceon == true ? 1 : 0);
                                    return;
                                  }
                                  showCannotSend(value);
                                },
                                netvana: 1),
                          ),
                        )
                      ],
                    ),
                    EasyContainer(
                      color: FIGMA.Gray2,
                      height: 196.h,
                      width: 165.w,
                      margin: 4,
                      padding: 0,
                      showBorder: false,
                      borderWidth: 1.5.sp,
                      borderColor: FIGMA.Prn,
                      borderRadius: 17,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LampWidget(
                            glowIntensity: (value.bleIsConnected |
                                    value.netvanaIsConnected)
                                ? value.Brightness.toDouble() / 90
                                : 2,
                            key: lampKey,
                            lampColor: (value.bleIsConnected |
                                    value.netvanaIsConnected)
                                ? colorFromString(value.maincycle_color)
                                : colorFromString("0xFF555555"),
                            height: 120.h,
                            width: 64.w,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "${value.selectedDevice.categoryName}-${value.selectedDevice.partNumber}",
                              style: const TextStyle(color: FIGMA.Wrn2),
                            ),
                          )
                        ],
                      ),
                      onTap: () async {
                        if (value.netvanaIsConnected) {
                          await value.getDetailsFromNet();
                          return;
                        }
                        showCannotSend(value);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 80.h,
                  width: 329.w,
                  child: Spelco(handlechange: (index) {
                    if (value.netvanaIsConnected | value.bleIsConnected) {
                      value.change_slider(index);
                      return;
                    }
                    showCannotSend(value);
                  }),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 70.h,
                  width: 329.w,
                  child: Sliderwidgets[value.current_selected_slider],
                ),
                SizedBox(height: 24.h),
                Container(
                  height: 102.h,
                  width: 329.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://api.netvana.ir${SdcardService.instance.getThemeById(getIdbyMode(value))?.image_url.toString() ?? "/media/images/theme/267022d16cad47d0ad087d3d92363d24.png"}"),
                      fit: BoxFit.cover,
                      colorFilter:
                          (value.bleIsConnected | value.netvanaIsConnected)
                              ? null
                              : const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.saturation,
                                ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      EasyContainer(
                        color: FIGMA.Back,
                        width: 90.w,
                        height: 44.h,
                        elevation: 0,
                        borderRadius: 15,
                        onTap: () {
                          value.Change_current_screen(1);
                        },
                        child: Text(
                          "ویرایش",
                          style: TextStyle(
                            color: FIGMA.Wrn,
                            fontSize: 13.sp,
                            fontFamily: FIGMA.estsb,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            SdcardService.instance
                                    .getThemeById(getIdbyMode(value))
                                    ?.name
                                    .toString() ??
                                "تک رنگ",
                            style: TextStyle(
                              color: FIGMA.Wrn,
                              fontSize: 18.sp,
                              fontFamily: FIGMA.abrlb,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Stroke color (adjustable)
                                  offset: const Offset(
                                      1, 1), // Small offset for stroke effect
                                  blurRadius: 1, // Small blur for smooth stroke
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(-1,
                                      -1), // Opposite direction for full outline
                                  blurRadius: 1,
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset:
                                      const Offset(1, -1), // Covers all sides
                                  blurRadius: 1,
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(-1, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            SdcardService.instance
                                    .getThemeById(getIdbyMode(value))
                                    ?.description
                                    .toString() ??
                                "نمایش یک رنگ ثابت",
                            style: TextStyle(
                              color: FIGMA.Wrn,
                              fontSize: 11.sp,
                              fontFamily: FIGMA.estre,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(
                                      0.5), // Stroke color (adjustable)
                                  offset: const Offset(
                                      1, 1), // Small offset for stroke effect
                                  blurRadius: 1, // Small blur for smooth stroke
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(-1,
                                      -1), // Opposite direction for full outline
                                  blurRadius: 1,
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset:
                                      const Offset(1, -1), // Covers all sides
                                  blurRadius: 1,
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(-1, 1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: EasyContainer(
                    height: 72.h,
                    width: 329.w,
                    color: FIGMA.Gray2,
                    borderWidth: 0,
                    elevation: 0,
                    margin: 0,
                    padding: 0,
                    borderRadius: 17,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.sp),
                            child: Circlecolor(
                              color: value.Defalult_colors[index],
                              onDataChange: (String f) {
                                value.set_Defalult_colors(int.parse(f), index);
                                sdcard.put("COLOR$index", int.parse(f));
                                if (value.bleIsConnected) {
                                  String jsonPayload = jsonEncode({"Lc": f});
                                  SingleBle().sendMain(jsonPayload);
                                  value.setMainCycleColor(f);
                                  return;
                                }
                                if (value.netvanaIsConnected) {
                                  NetClass().setColor(
                                      SdcardService.instance.token!,
                                      value.selectedDevice.id.toString(),
                                      f);
                                  value.setMainCycleColor(f);

                                  return;
                                }

                                showCannotSend(value);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ShortTimer extends StatelessWidget {
  const ShortTimer({super.key});

  @override
  Widget build(BuildContext context) {
    void TimerSend(int s, ProvData value) {
      if (value.bleIsConnected) {
        String jsonPayload = jsonEncode({"Tf": s.toString()});
        SingleBle().sendMain(jsonPayload);
        calculateTimeStore(s);
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        return;
      }
      if (value.netvanaIsConnected) {
        NetClass().setTimer(SdcardService.instance.token!,
            value.selectedDevice.id.toString(), s);
        calculateTimeStore(s);
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        return;
      }
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    }

    return Consumer<ProvData>(
      builder: (context, value, child) {
        var sdcard = Hive.box(FIGMA.HIVE2);
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: 74.w,
            height: 111.h,
            child: TimerButton(
              state: value.timeroffvalue > 0,
              Templete: [
                SvgPicture.asset(
                  'assets/timer.svg',
                  width: 24.w,
                  color: FIGMA.Wrn,
                ),
                SizedBox(height: 8.h),
                Text(
                  'تایمر',
                  style: TextStyle(
                      fontFamily: FIGMA.estsb,
                      fontSize: 13.sp,
                      color: FIGMA.Wrn),
                ),
                Text(
                  value.timeroffvalue == 0
                      ? "غیرفعال"
                      : "${sdcard.get("Timeofdie", defaultValue: "00:00")}",
                  style: TextStyle(
                    fontFamily: FIGMA.estre,
                    fontSize: 11.sp,
                    color: FIGMA.Wrn,
                  ),
                ),
              ],
              innerwidgets: [
                Expanded(
                  flex: 5,
                  child: Text(
                    "تایمر خاموش کننده",
                    style: TextStyle(
                        fontFamily: FIGMA.abrlb,
                        fontSize: 19.sp,
                        color: FIGMA.Wrn),
                  ),
                ),
                FASELE(value: 2),
                TimerMinutes(
                  Time: "15",
                  onDataChange: (s) {
                    TimerSend(s, value);
                  },
                  Time_int: 15,
                ),
                TimerMinutes(
                  Time: "30",
                  onDataChange: (s) {
                    TimerSend(s, value);
                  },
                  Time_int: 30,
                ),
                TimerMinutes(
                  Time: "60",
                  onDataChange: (s) {
                    TimerSend(s, value);
                  },
                  Time_int: 90,
                ),
                TimerMinutes(
                  Time: "90",
                  onDataChange: (s) {
                    TimerSend(s, value);
                  },
                  Time_int: 90,
                ),
                TimerMinutes(
                  Time: "999",
                  onDataChange: (s) {
                    TimerSend(0, value);
                  },
                  Time_int: 999,
                ),
                Expanded(
                    flex: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: EasyContainer(
                            margin: 4,
                            padding: 0,
                            borderRadius: 17,
                            color: FIGMA.Orn,
                            child: Text(
                              "خروج",
                              style: TextStyle(
                                  fontFamily: FIGMA.estsb,
                                  fontSize: 16.sp,
                                  color: FIGMA.Wrn),
                            ),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
