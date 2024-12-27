import 'dart:async';

import 'package:netvana/ble/logic/esp_ble.dart';
import 'package:netvana/ble/screens/Settingble/espsettings.dart';
import 'package:netvana/ble/screens/products/nooran/Buttons/mybuttons.dart';
import 'package:netvana/ble/screens/products/nooran/Spelco/spelco.dart';
import 'package:netvana/ble/screens/products/nooran/sliders/sliders.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:provider/provider.dart';
import 'package:universal_ble/universal_ble.dart';

import 'smarttimer/smarttimer.dart';

class Nooran extends StatefulWidget {
  const Nooran({super.key});

  @override
  State<Nooran> createState() => _NooranState();
}

class _NooranState extends State<Nooran> {
  late List<Widget> Sliderwidgets;
  @override
  void initState() {
    debugPrint("NOORAN");
    super.initState();
    final funcy = context.read<ProvData>();
    final datky = Provider.of<ProvData>(context, listen: false);
    NooranBle = Espnetvana(datky, funcy);
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
          debugPrint("brighttohex${NooranBle.EasyConvertuint8(bright)}");
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
    debugPrint("DisposeDisposeDisposeDisposeDisposeDispose 1");
    super.dispose();
    UniversalBle.onConnectionChange = null;
    UniversalBle.onValueChange = null;
    // Disconnect when leaving the page
    final datky = Provider.of<ProvData>(context, listen: false);
    if (datky.isConnected) UniversalBle.disconnect(datky.Device_UUID);
    debugPrint("DisposeDisposeDisposeDisposeDisposeDispose 2");
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

  @override
  Widget build(BuildContext context) {
    final datky = Provider.of<ProvData>(context, listen: false);
    return Consumer<ProvData>(
        builder: (context, value, child) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
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
                                child: Text(
                                  "نوروانا",
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
                                    datky.isConnected
                                        ? Icons.settings_rounded
                                        : Icons.settings_rounded,
                                    color: datky.isConnected
                                        ? FIGMA.Orn
                                        : FIGMA.Orn.withOpacity(0.1),
                                    size: 48,
                                  ),
                                  onTap: () async {
                                    final funcy = context.read<ProvData>();

                                    datky.isConnected == true
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Espsettings(),
                                            ))
                                        : funcy.Show_Snackbar(
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
                                    datky.isConnected
                                        ? Icons.bluetooth_connected
                                        : Icons.bluetooth_disabled,
                                    color: datky.isConnected
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
                                        bool connected =
                                            await UniversalBle.connect(
                                          value.Device_UUID,
                                        );
                                        debugPrint(
                                            "ConnectionResult $connected");
                                        startTimer();
                                        funcy.change_nextmoveisconnect(false);
                                      } catch (e) {
                                        debugPrint('ConnectError $e');
                                      }
                                    } else {
                                      UniversalBle.disconnect(
                                          value.Device_UUID);
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
                                    customMargin: const EdgeInsets.only(
                                        right: 4, left: 20),
                                    padding: 6,
                                    child: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: datky.isConnected
                                          ? Colors.blue.withOpacity(0.1)
                                          : Colors.blue,
                                      size: 48,
                                    ),
                                    onTap: () {
                                      final funcy = context.read<ProvData>();
                                      if (!datky.isConnected) {
                                        datky.mynetvanaDevices.clear();
                                        funcy.update_mynetvanadevice();
                                        funcy.change_nextmoveisconnect(true);
                                        datky.ChangeDeviceFound(false);
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
                                        height:
                                            GetGoodW(context, 74, 111).height,
                                        width: GetGoodW(context, 74, 111).width,
                                        child: Sleep_Button(
                                          state: true,
                                          onDataChange: (s) {
                                            final funcy =
                                                context.read<ProvData>();
                                            funcy.update_Appsync(
                                                FIGMA.FLUTTER_ESSENTIALS);
                                            NooranBle.SendAval(FIGMA
                                                .FLUTTER_ESSENTIALS
                                                .toString());
                                            NooranBle.SendToEsp32("As-");
                                          },
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SizedBox(
                                      height: GetGoodW(context, 74, 111).height,
                                      width: GetGoodW(context, 74, 111).width,
                                      child: Timer_Button(
                                        time: 15,
                                        state: true,
                                        onDataChange: () {
                                          final funcy =
                                              context.read<ProvData>();
                                          funcy.update_Appsync(
                                              FIGMA.FLUTTER_SPELCO);
                                          NooranBle.SendAval(
                                              FIGMA.FLUTTER_SPELCO.toString());
                                          NooranBle.SendToEsp32("As-");
                                        },
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
                                        datky.isdeviceon == true
                                            ? NooranBle.SendToEsp32("Cp-")
                                            : NooranBle.SendToEsp32("Co-");
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
                                NooranBle.manualTrigger();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            EasyContainer(
                              color: FIGMA.Back,
                              borderWidth: 0,
                              elevation: 0,
                              customMargin: const EdgeInsets.only(right: 16),
                              padding: 4,
                              child: Container(
                                color: FIGMA.Back,
                                child: Container(
                                  color: Colors.amber,
                                  width: 360,
                                  height: 150,
                                  /*
                                  Text(
                                    value.TEST_DATA,
                                    style: TextStyle(
                                        fontFamily: FIGMA.abrlb, fontSize: 7),
                                  ),
                                  */
                                  child: SmartTimer(
                                    start: () {
                                      NooranBle.SendAval("4");
                                      NooranBle.SendToEsp32("Cs-");
                                    },
                                    stop: () {
                                      NooranBle.SendAval("2");
                                      NooranBle.SendToEsp32("Cs-");
                                    },
                                  ),
                                ),
                              ),
                              onTap: () async {
                                try {
                                  await NooranBle.readmanual();
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
                            Circlecolor(
                              color: "0xFF00A594",
                              onDataChange: (String f) {
                                NooranBle.SendAval("0");
                                NooranBle.SendToEsp32("Lm-");
                              },
                            ),
                            FASELE(value: 1),
                            Circlecolor(
                              color: "0xFFF3593A",
                              onDataChange: (String f) {
                                NooranBle.SendAval("1");
                                NooranBle.SendToEsp32("Lm-");
                              },
                            ),
                            FASELE(value: 1),
                            Circlecolor(
                              color: "0xFFffeb3b",
                              onDataChange: (String f) {
                                NooranBle.SendAval("9");
                                NooranBle.SendToEsp32("Lm-");
                              },
                            ),
                            FASELE(value: 1),
                            Circlecolor(
                              color: "0xFF4caf50",
                              onDataChange: (String f) {
                                NooranBle.SendAval("24");
                                NooranBle.SendToEsp32("Lm-");
                              },
                            ),
                            FASELE(value: 1),
                            Circlecolor(
                              color: "0xFF0000FF",
                              onDataChange: (String f) {
                                NooranBle.SendAval("55");
                                NooranBle.SendToEsp32("Lm-");
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
