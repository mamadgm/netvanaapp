// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:async';
import 'dart:ffi';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/screens/Settingble/Themeselect.dart';
import 'package:netvana/ble/logic/esp_ble.dart';
import 'package:netvana/ble/screens/Settingble/espsettings.dart';
import 'package:netvana/ble/screens/products/nooran/Buttons/mybuttons.dart';
import 'package:netvana/ble/screens/products/nooran/Spelco/spelco.dart';
import 'package:netvana/ble/screens/products/nooran/sliders/sliders.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/const/themes.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:provider/provider.dart';
import 'package:universal_ble/universal_ble.dart';
// import 'package:record/record.dart';
import 'smarttimer/smarttimer.dart';

class Nooran extends StatefulWidget {
  const Nooran({super.key});

  @override
  State<Nooran> createState() => _NooranState();
}

class _NooranState extends State<Nooran> {
  // double _loudness = 0;
  // final Record _record = Record();
  late List<Widget> Sliderwidgets;
  Future<void> startRecording() async {
    // if (await _record.hasPermission()) {
    //   await _record.start();
    //   _record
    //       .onAmplitudeChanged(const Duration(milliseconds: 200))
    //       .listen((amp) {
    //     final funcy = context.read<ProvData>();
    //     _loudness = (((amp.current + 60) / 60) * 100) - 30;

    //     if (funcy.maincycle_speed > 2500 && funcy.isConnected) {
    //       // NooranBle.SendCval(_loudness.toInt().toString());
    //       NooranBle.SendToEsp32("X${_loudness.toInt()}-");
    //     }
    //   });
    // }
  }

  @override
  void initState() {
    startRecording();
    debugPrint("NOORAN");
    super.initState();
    final funcy = context.read<ProvData>();
    final value = Provider.of<ProvData>(context, listen: false);
    NooranBle = Espnetvana(value, funcy);
    Sliderwidgets = [
      Speed_slider(
        senddata: (speed) {
          funcy.setMainCycleSpeed(int.parse(speed));
          NooranBle.SendAval(speed);
          NooranBle.SendToEsp32("Ls-");
        },
      ),
      Bright_slider(
        senddata: (bright) {
          debugPrint(bright);
          // debugPrint("brighttohex${NooranBle.EasyConvertuint8(bright)}");
          NooranBle.SendAval(bright);
          NooranBle.SendToEsp32("Lb-");
        },
        brightness: funcy.Brightness,
        netvana: 1,
      ),
      Color_Picker_HSV(
        senddata: (p0) {
          NooranBle.SendAval(p0);
          NooranBle.SendToEsp32("Lc-");
        },
        color: "0xFFFFFFFF",
        netvana: 1,
      ),
    ];
  }

  @override
  void dispose() {
    // _record.dispose();
    super.dispose();
    UniversalBle.onConnectionChange = null;
    UniversalBle.onValueChange = null;
    // Disconnect when leaving the page
    final value = Provider.of<ProvData>(context, listen: false);
    if (value.isConnected) UniversalBle.disconnect(value.Device_UUID);
    debugPrint("Dispose 2");
  }

  Timer? Connecttimer;

  void startTimer() {
    // Cancel any existing timer before starting a new one
    Connecttimer?.cancel();

    // Start a new timer that fires once after 1 second
    Connecttimer = Timer(const Duration(seconds: 2), () {
      debugPrint('Loging in');
      NooranBle.LoginTheClient(context);
    });
  }

  void TimerSend(int s) {
    calculateTimeStore(s);
    debugPrint("Minute $s");
    NooranBle.SendAval(s.toString());
    NooranBle.SendToEsp32("Tf-");
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

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
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EasyContainer(
                        color: FIGMA.Back,
                        borderWidth: 0,
                        elevation: 0,
                        customMargin: const EdgeInsets.only(right: 16),
                        padding: 0,
                        child: Container(
                          color: FIGMA.Back,
                          child: const Text(
                            "نوران",
                            style: TextStyle(
                                fontFamily: FIGMA.abrlb, fontSize: 24),
                          ),
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
                            customMargin:
                                const EdgeInsets.only(left: 4, right: 4),
                            padding: 6,
                            child: Icon(
                              value.isConnected
                                  ? Icons.settings_rounded
                                  : Icons.settings_rounded,
                              color: value.isConnected
                                  ? FIGMA.Orn
                                  : FIGMA.Orn.withOpacity(0.1),
                              size: 48,
                            ),
                            onTap: () {
                              value.isConnected == true
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Espsettings(),
                                      ),
                                    )
                                  : value.Show_Snackbar(
                                      "ابتدا به نوران متصل شوید", 1000);
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
                              final funcy = context.read<ProvData>();
                              debugPrint(value.nextmoveisconnect == true
                                  ? "Connect"
                                  : "DisConnect");
                              if (value.nextmoveisconnect == true) {
                                try {
                                  bool connected = await UniversalBle.connect(
                                    value.Device_UUID,
                                  );
                                  debugPrint("ConnectionResult $connected");
                                  startTimer();
                                  funcy.change_nextmoveisconnect(false);
                                } catch (e) {
                                  debugPrint('ConnectError $e');
                                }
                              } else {
                                UniversalBle.disconnect(value.Device_UUID);
                                funcy.change_nextmoveisconnect(true);
                              }
                            },
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: EasyContainer(
                              color: FIGMA.Gray,
                              borderWidth: 2,
                              borderRadius: 15,
                              elevation: 0,
                              customMargin:
                                  const EdgeInsets.only(right: 4, left: 20),
                              padding: 6,
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: value.isConnected
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.blue,
                                size: 48,
                              ),
                              onTap: () {
                                final funcy = context.read<ProvData>();
                                if (!value.isConnected) {
                                  value.mynetvanaDevices.clear();
                                  funcy.update_mynetvanadevice();
                                  funcy.change_nextmoveisconnect(true);
                                  value.ChangeDeviceFound(false);
                                  setState(() {});
                                } else {
                                  funcy.Show_Snackbar(
                                      "از دستگاه قطع شوید", 3000);
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
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
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                  height: GetGoodW(context, 74, 111).height,
                                  width: GetGoodW(context, 74, 111).width,
                                  child: Sleep_Button(
                                    state: value.Brightness == 5,
                                    onDataChange: (s) {
                                      NooranBle.SendAval("5");
                                      NooranBle.SendToEsp32("Lb-");
                                    },
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                height: GetGoodW(context, 74, 111).height,
                                width: GetGoodW(context, 74, 111).width,
                                child: NewPopup(
                                  TempleteColor: !(value.timeroffvalue > 0)
                                      ? FIGMA.Gray
                                      : FIGMA.Grn,
                                  Templete: [
                                    SvgPicture.asset(
                                      'ass/timer.svg',
                                      width: 32,
                                      color: !(value.timeroffvalue > 0)
                                          ? FIGMA.Grn
                                          : FIGMA.Wrn,
                                    ),
                                    Text(
                                      'تایمر',
                                      style: TextStyle(
                                          fontFamily: FIGMA.estsb,
                                          fontSize: 16,
                                          color: !(value.timeroffvalue > 0)
                                              ? FIGMA.Grn
                                              : FIGMA.Wrn),
                                    ),
                                    Text(
                                      value.timeroffvalue == 0
                                          ? "غیرفعال"
                                          : "${sdcard.get("Timeofdie", defaultValue: "00:00")}",
                                      style: TextStyle(
                                        fontFamily: FIGMA.estre,
                                        fontSize: 14,
                                        color: !(value.timeroffvalue > 0)
                                            ? FIGMA.Grn
                                            : FIGMA.Wrn,
                                      ),
                                    ),
                                  ],
                                  innerwidgets: [
                                    const Expanded(
                                      flex: 5,
                                      child: Text(
                                        "تایمر خاموش کننده",
                                        style: TextStyle(
                                            fontFamily: FIGMA.abrlb,
                                            fontSize: 19),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            height: GetGoodW(context, 156, 73).height,
                            width: GetGoodW(context, 156, 73).width,
                            child: Power_Button(
                                onof: true,
                                onDataChange: () {
                                  value.isdeviceon == true
                                      ? NooranBle.SendToEsp32("Co-")
                                      : NooranBle.SendToEsp32("Cp-");
                                },
                                netvana: 1),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: EasyContainer(
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
                        onTap: () {
                          // NooranBle.manualTrigger();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                EasyContainer(
                  color: FIGMA.Back,
                  borderWidth: 0,
                  borderRadius: 15,
                  padding: 4,
                  margin: 16,
                  child: SmartTimer(
                    timepace: (p0) {
                      NooranBle.set_Intervaltimer(p0);
                    },
                    start: () {
                      NooranBle.SendAval("4");
                      NooranBle.SendToEsp32("Cs-");
                    },
                    resume: () {
                      NooranBle.SendAval("3");
                      NooranBle.SendToEsp32("Cs-");
                    },
                    stop: () {
                      NooranBle.SendAval("2");
                      NooranBle.SendToEsp32("Cs-");
                    },
                    exit: () {
                      NooranBle.SendAval("1");
                      NooranBle.SendToEsp32("Cs-");
                    },
                  ),
                  onTap: () async {
                    // try {
                    //   await NooranBle.readmanual();
                    // } catch (e) {
                    //   debugPrint(e.toString());
                    // }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: GetGoodW(context, 329, 80).height,
                  width: GetGoodW(context, 329, 80).width,
                  child: Spelco(
                      which: 0,
                      handlechange: (index) {
                        final funcy = context.read<ProvData>();
                        funcy.change_slider(index);
                      }),
                ),
                const SizedBox(
                  height: 9,
                ),
                SizedBox(
                  height: GetGoodW(context, 329, 70).height,
                  child: Sliderwidgets[value.current_selected_slider],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: GetGoodW(context, 320, 160).height,
                        width: GetGoodW(context, 320, 160).width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(Allthemes[findThemeIndex(
                                    Allthemes, value.maincycle_mode)]
                                .path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                          height: GetGoodW(context, 320, 160).height,
                          width: GetGoodW(context, 320, 160).width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.6),
                          )),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              Allthemes[findThemeIndex(
                                      Allthemes, value.maincycle_mode)]
                                  .name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28, // Adjust the font size
                                fontWeight: FontWeight.bold,
                                fontFamily: FIGMA.estbo,
                              ),
                            ),
                            Text(
                              Allthemes[findThemeIndex(
                                      Allthemes, value.maincycle_mode)]
                                  .property,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14, // Adjust the font size
                                fontWeight: FontWeight.bold,
                                fontFamily: FIGMA.estbo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    value.isConnected == true
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThemeSelect(
                                update: (int p) {
                                  NooranBle.SendAval(
                                      Allthemes[p].value.toString());
                                  NooranBle.SendToEsp32("Lm-");
                                },
                              ),
                            ),
                          )
                        : value.Show_Snackbar("ابتدا به نوران متصل شوید", 1000);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                EasyContainer(
                  height: 80,
                  color: FIGMA.Gray,
                  borderWidth: 0,
                  elevation: 0,
                  customMargin: const EdgeInsets.only(
                      right: 16, left: 16, top: 6, bottom: 6),
                  padding: 6,
                  borderRadius: 17,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              child: Circlecolor(
                                color: value.Defalult_colors[index],
                                onDataChange: (String f) {
                                  value.set_Defalult_colors(
                                      int.parse(f), index);
                                  sdcard.put("COLOR$index", int.parse(f));
                                  NooranBle.SendAval(f);
                                  NooranBle.SendToEsp32("Lc-");
                                  debugPrint(f);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
