// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/screens/products/nooran/Buttons/mybuttons.dart';
import 'package:netvana/BLE/screens/products/nooran/Spelco/spelco.dart';
import 'package:netvana/BLE/screens/products/nooran/sliders/sliders.dart';
// import 'package:netvana/ble/logic/esp_ble.dart';

import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/newtab.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:netvana/settingscreen/profile.dart';
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
    debugPrint("NOORAN");
    super.initState();
    final value = Provider.of<ProvData>(context, listen: false);
    value.loadFavoritesFromHive();
    value.loadTimersFromHive();

    SingleBle().init(value);
    Sliderwidgets = [
      Speed_slider(
        senddata: (speed) {
          value.setMainCycleSpeed(int.parse(speed));
          String jsonPayload = jsonEncode({"Ls": speed});
          SingleBle().sendMain(jsonPayload);
        },
      ),
      Bright_slider(
        senddata: (bright) {
          value.setBrightness(int.parse(bright));
          String jsonPayload = jsonEncode({"Lb": bright});
          SingleBle().sendMain(jsonPayload);
        },
        brightness: value.Brightness,
        netvana: 1,
      ),
      Color_Picker_HSV(
        senddata: (p0) {
          String jsonPayload = jsonEncode({"Lc": p0});
          SingleBle().sendMain(jsonPayload);
        },
        color: "0xFFFFFFFF",
        netvana: 1,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    //TODO: Disconnect when leaving the page
  }

  Timer? Connecttimer;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(builder: (context, value, child) {
      var sdcard = Hive.box(FIGMA.HIVE);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    width: GetGoodW(context, 329, 80).width,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            "نوروانا",
                            style: TextStyle(
                                fontFamily: FIGMA.abrlb, fontSize: 28),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            EasyContainer(
                              color: FIGMA.Gray,
                              borderWidth: 2,
                              borderRadius: 15,
                              elevation: 0,
                              margin: 0,
                              padding: 6,
                              child: const Icon(
                                Icons.person,
                                color: FIGMA.Prn,
                                size: 48,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NewTab(
                                      appbartext: "پروفایل",
                                      childrens: [ProfileScr()],
                                    ),
                                  ),
                                );
                              },
                            ),
                            EasyContainer(
                                color: FIGMA.Gray,
                                borderWidth: 2,
                                borderRadius: 15,
                                elevation: 0,
                                customMargin:
                                    const EdgeInsets.only(right: 4, left: 4),
                                padding: 6,
                                child: Icon(
                                  value.isConnected
                                      ? Icons.bluetooth_connected
                                      : Icons.bluetooth_disabled,
                                  color: value.isConnected
                                      ? Colors.greenAccent
                                      : Colors.red,
                                  size: 48,
                                ),
                                onTap: () async {
                                  debugPrint(value.nextmoveisconnect
                                      ? "Connect"
                                      : "Disconnect");

                                  if (value.nextmoveisconnect == false) {
                                    // Device is connected → Disconnect
                                    await SingleBle().disconnect();
                                    value.ble_update_connected(false);
                                    value.change_nextmoveisconnect(true);
                                    debugPrint("Device Disconnected");
                                    return;
                                  }

                                  // Device is NOT connected → Start Scan
                                  try {
                                    debugPrint("Starting BLE Scan...");

                                    var result = await SingleBle()
                                        .startScanAndGetDevice();
                                    String? selectedDeviceId;
                                    String? selectedDeviceName;
                                    if (result != null) {
                                      selectedDeviceId = result['deviceId'];
                                      selectedDeviceName = result['name'];
                                    }

                                    if (selectedDeviceId == null) {
                                      debugPrint("No device selected.");
                                      return;
                                    } else if (!value.Products.any((product) =>
                                        "${product["category_name"]}-${product["part_number"]}" ==
                                        selectedDeviceName)) {
                                      value.Show_Snackbar(
                                          "این دستگاه مال شما نیست", 1000);
                                      // return;
                                    }

                                    debugPrint(
                                        "Attempting to connect to $selectedDeviceId...");
                                    bool connected = await SingleBle()
                                        .connectToDevice(selectedDeviceId, 200);

                                    if (connected) {
                                      value.change_nextmoveisconnect(false);
                                      value.ble_update_connected(true);
                                      debugPrint(
                                          "Successfully Connected to $selectedDeviceId");

                                      Future.delayed(
                                          const Duration(milliseconds: 1200),
                                          () async {
                                        switch (value.current_selected_slider) {
                                          case 0:
                                            value.change_slider(1);
                                            break;
                                          default:
                                            value.change_slider(0);
                                        }
                                      });
                                    } else {
                                      value.ble_update_connected(false);
                                      debugPrint("Failed to Connect.");
                                    }
                                  } catch (e) {
                                    value.ble_update_connected(false);
                                    debugPrint('Connection Error: $e');
                                  }
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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
                                  height: GetGoodW(context, 74, 111).height,
                                  width: GetGoodW(context, 74, 111).width,
                                  child: Sleep_Button(
                                    state: value.Brightness == 5,
                                    onDataChange: (s) {
                                      String jsonPayload =
                                          jsonEncode({"Lb": 5});
                                      SingleBle().sendMain(jsonPayload);
                                    },
                                  )),
                            ),
                            const ShortTimer(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                            height: GetGoodW(context, 156, 73).height,
                            width: GetGoodW(context, 156, 73).width,
                            child: Power_Button(
                                onof: value.isdeviceon,
                                onDataChange: () {
                                  String jsonPayload =
                                      jsonEncode({"Cp": !value.isdeviceon});
                                  SingleBle().sendMain(jsonPayload);
                                },
                                netvana: 1),
                          ),
                        )
                      ],
                    ),
                    EasyContainer(
                      color: FIGMA.Gray,
                      height: GetGoodW(context, 165, 192).height,
                      width: GetGoodW(context, 165, 192).width,
                      margin: 4,
                      padding: 0,
                      borderRadius: 17,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "ass/icon.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () async {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    width: GetGoodW(context, 329, 80).width,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        "تنظیمات اختصاصی",
                        style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: GetGoodW(context, 329, 80).height,
                  width: GetGoodW(context, 329, 80).width,
                  child: Spelco(handlechange: (index) {
                    value.change_slider(index);
                  }),
                ),
                const SizedBox(
                  height: 9,
                ),
                SizedBox(
                  height: GetGoodW(context, 329, 70).height,
                  width: GetGoodW(context, 329, 70).width,
                  child: Sliderwidgets[value.current_selected_slider],
                ),
                const SizedBox(
                  height: 20,
                ),
                // EasyContainer(
                //   height: 80,
                //   color: FIGMA.Gray,
                //   borderWidth: 0,
                //   elevation: 0,
                //   customMargin: const EdgeInsets.only(
                //       right: 16, left: 16, top: 6, bottom: 6),
                //   padding: 6,
                //   borderRadius: 17,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Row(
                //         children: List.generate(
                //           5,
                //           (index) {
                //             return Padding(
                //               padding: const EdgeInsets.only(right: 8, left: 8),
                //               child: Circlecolor(
                //                 color: value.Defalult_colors[index],
                //                 onDataChange: (String f) {
                //                   value.set_Defalult_colors(
                //                       int.parse(f), index);
                //                   sdcard.put("COLOR$index", int.parse(f));
                //                   String jsonPayload = jsonEncode({"Lc": f});
                //                   SingleBle().sendMain(jsonPayload);

                //                   debugPrint(f);
                //                 },
                //               ),
                //             );
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
    void TimerSend(int s) {
      calculateTimeStore(s);
      debugPrint("Minute $s");
      String jsonPayload = jsonEncode({"Td": s.toString()});
      SingleBle().sendMain(jsonPayload);
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
    }

    return Consumer<ProvData>(
      builder: (context, value, child) {
        var sdcard = Hive.box(FIGMA.HIVE);
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: GetGoodW(context, 74, 111).height,
            width: GetGoodW(context, 74, 111).width,
            child: NewPopup(
              TempleteColor:
                  !(value.timeroffvalue > 0) ? FIGMA.Gray : FIGMA.Grn,
              Templete: [
                SvgPicture.asset(
                  'ass/timer.svg',
                  width: 32,
                  color: !(value.timeroffvalue > 0) ? FIGMA.Grn : FIGMA.Wrn,
                ),
                Text(
                  'تایمر',
                  style: TextStyle(
                      fontFamily: FIGMA.estsb,
                      fontSize: 16,
                      color:
                          !(value.timeroffvalue > 0) ? FIGMA.Grn : FIGMA.Wrn),
                ),
                Text(
                  value.timeroffvalue == 0
                      ? "غیرفعال"
                      : "${sdcard.get("Timeofdie", defaultValue: "00:00")}",
                  style: TextStyle(
                    fontFamily: FIGMA.estre,
                    fontSize: 14,
                    color: !(value.timeroffvalue > 0) ? FIGMA.Grn : FIGMA.Wrn,
                  ),
                ),
              ],
              innerwidgets: [
                const Expanded(
                  flex: 5,
                  child: Text(
                    "تایمر خاموش کننده",
                    style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 19),
                  ),
                ),
                FASELE(value: 2),
                TimerMinutes(
                  Time: "15",
                  onDataChange: (s) {
                    TimerSend(s);
                  },
                  Time_int: 15,
                ),
                TimerMinutes(
                  Time: "30",
                  onDataChange: (s) {
                    TimerSend(s);
                  },
                  Time_int: 30,
                ),
                TimerMinutes(
                  Time: "60",
                  onDataChange: (s) {
                    TimerSend(s);
                  },
                  Time_int: 90,
                ),
                TimerMinutes(
                  Time: "90",
                  onDataChange: (s) {
                    TimerSend(s);
                  },
                  Time_int: 90,
                ),
                TimerMinutes(
                  Time: "999",
                  onDataChange: (s) {
                    TimerSend(0);
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
                            child: const Text(
                              "خروج",
                              style: TextStyle(
                                  fontFamily: FIGMA.estsb,
                                  fontSize: 16,
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
