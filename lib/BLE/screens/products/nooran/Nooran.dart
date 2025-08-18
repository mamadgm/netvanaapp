// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:async';
import 'dart:convert';
// import 'dart:ffi';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/screens/products/nooran/Buttons/mybuttons.dart';
import 'package:netvana/BLE/screens/products/nooran/Spelco/spelco.dart';
import 'package:netvana/BLE/screens/products/nooran/sliders/sliders.dart';
import 'package:netvana/Network/netmain.dart';
// import 'package:netvana/ble/logic/esp_ble.dart';

import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/cylander.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
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
          value.nextmoveisconnect
              ? NetClass().setSpeed(
                  value.token, value.Products[0]["id"].toString(), speed)
              : null;
          value.setMainCycleSpeed(int.parse(speed));
          String jsonPayload = jsonEncode({"Ls": speed});
          SingleBle().sendMain(jsonPayload);
        },
      ),
      Bright_slider(
        senddata: (bright) {
          value.nextmoveisconnect
              ? NetClass().setBright(
                  value.token, value.Products[0]["id"].toString(), bright)
              : null;
          value.setBrightness(int.parse(bright));
          String jsonPayload = jsonEncode({"Lb": bright});
          SingleBle().sendMain(jsonPayload);
        },
        brightness: value.Brightness,
        netvana: 1,
      ),
      Color_Picker_HSV(
        senddata: (p0) {
          value.setMainCycleColor(p0);
          value.nextmoveisconnect
              ? NetClass()
                  .setColor(value.token, value.Products[0]["id"].toString(), p0)
              : null;
          String jsonPayload = jsonEncode({"Lc": p0});
          SingleBle().sendMain(jsonPayload);
        },
        color: "0xFFFF5000",
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
    return Consumer<ProvData>(builder: (context, value, child) {
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
                                fontFamily: FIGMA.abrlb,
                                fontSize: 28,
                                color: FIGMA.Wrn),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: EasyContainer(
                                  height: GetGoodW(context, 73, 73).height,
                                  width: GetGoodW(context, 73, 73).width,
                                  color: FIGMA.Back,
                                  showBorder: true,
                                  borderWidth: 3,
                                  borderColor: FIGMA.Gray2,
                                  borderRadius: 17,
                                  elevation: 0,
                                  margin: 0,
                                  padding: 4,
                                  child: Icon(
                                    value.isConnectedWifi
                                        ? Icons.wifi_rounded
                                        : Icons.wifi_off_rounded,
                                    color: value.isConnectedWifi
                                        ? FIGMA.Prn
                                        : FIGMA.Gray2,
                                    size: 42,
                                  ),
                                  onTap: () async {
                                    var box = Hive.box(FIGMA.HIVE);

                                    var meResponse = await NetClass()
                                        .getProducts(value.token)
                                        .timeout(const Duration(seconds: 5));

                                    if (meResponse != null) {
                                      value.setProducts(meResponse["devices"]);
                                      box.put(
                                          "products", meResponse["devices"]);
                                      box.put("name", meResponse["first_name"]);
                                      box.put("last", meResponse["last_name"]);
                                      box.put("phone", meResponse["phone"]);

                                      debugPrint("Got Devices");

                                      // TODO: add setup
                                    }

                                    if (value.Products[0]["is_online"] ==
                                        false) {
                                      value.wifi_update_connected(false);
                                      value.Show_Snackbar(
                                          " ...دستگاه متصل نیست . راه اندازی مجدد",
                                          1000);
                                    } else {
                                      value.wifi_update_connected(true);
                                      return;
                                    }

                                    if (value.isConnected) {
                                      // show the WiFi Menu

                                      showWiFiDialog(context);
                                    } else {
                                      value.Show_Snackbar(
                                          "برای تنظیم ابتدا به بلوتوث متصل شوید",
                                          1000);
                                    }

                                    value.hand_update();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: EasyContainer(
                                    height: GetGoodW(context, 73, 73).height,
                                    width: GetGoodW(context, 73, 73).width,
                                    color: FIGMA.Back,
                                    showBorder: true,
                                    borderWidth: 3,
                                    borderColor: FIGMA.Gray2,
                                    borderRadius: 17,
                                    elevation: 0,
                                    margin: 0,
                                    padding: 4,
                                    child: Icon(
                                      value.isConnected
                                          ? Icons.bluetooth_connected
                                          : Icons.bluetooth_disabled,
                                      color: value.isConnected
                                          ? FIGMA.Prn
                                          : FIGMA.Gray2,
                                      size: 42,
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
                                          debugPrint("YOHO GET OUT");
                                          return;
                                        } else {
                                          debugPrint("Wellcome");
                                        }

                                        debugPrint(
                                            "Attempting to connect to $selectedDeviceId...");
                                        bool connected = await SingleBle()
                                            .connectToDevice(
                                                selectedDeviceId, 200);

                                        if (connected) {
                                          value.change_nextmoveisconnect(false);
                                          value.ble_update_connected(true);
                                          debugPrint(
                                              "Successfully Connected to $selectedDeviceId");

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
                                          value.ble_update_connected(false);
                                          debugPrint("Failed to Connect.");
                                        }
                                      } catch (e) {
                                        value.ble_update_connected(false);
                                        debugPrint('Connection Error: $e');
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
                                      value.nextmoveisconnect
                                          ? NetClass().setBright(
                                              value.token,
                                              value.Products[0]["id"]
                                                  .toString(),
                                              "5")
                                          : null;
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
                                // setPower
                                onof: value.isdeviceon,
                                onDataChange: () {
                                  String jsonPayload =
                                      jsonEncode({"Cp": !value.isdeviceon});
                                  value.nextmoveisconnect
                                      ? NetClass().setPower(
                                          value.token,
                                          value.Products[0]["id"].toString(),
                                          !value.isdeviceon == true ? 1 : 0)
                                      : null;

                                  SingleBle().sendMain(jsonPayload);
                                },
                                netvana: 1),
                          ),
                        )
                      ],
                    ),
                    EasyContainer(
                      color: (!value.nextmoveisconnect | value.isConnectedWifi)
                          ? FIGMA.Grn
                          : FIGMA.Gray2,
                      height: GetGoodW(context, 165, 192).height,
                      width: GetGoodW(context, 165, 192).width,
                      margin: 4,
                      padding: 0,
                      showBorder:
                          (!value.nextmoveisconnect | value.isConnectedWifi),
                      borderWidth: 3,
                      borderColor: FIGMA.Prn,
                      borderRadius: 17,
                      child: LampWidget(
                        glowIntensity: value.Brightness.toDouble() / 50,
                        key: lampKey,
                        //        0xFF5000

                        lampColor: colorFromString(value.maincycle_color),
                        height: GetGoodW(context, 80, 150).height,
                        width: GetGoodW(context, 80, 150).width,
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
                        style: TextStyle(
                            fontFamily: FIGMA.abrlb,
                            fontSize: 18,
                            color: FIGMA.Wrn),
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

  Color colorFromString(String colorStr) {
    colorStr = colorStr.trim();

    // Case 1: hex string starting with 0x / 0X / #
    if (colorStr.startsWith("0x") ||
        colorStr.startsWith("0X") ||
        colorStr.startsWith("#")) {
      String cleaned = colorStr.toUpperCase().replaceAll("#", "");
      if (cleaned.startsWith("0X")) cleaned = cleaned.substring(2);
      if (cleaned.length == 6) cleaned = "FF$cleaned"; // add alpha
      return Color(int.parse(cleaned, radix: 16));
    }

    // Case 2: decimal number string
    int? value = int.tryParse(colorStr);
    if (value != null) {
      // Ensure alpha channel exists
      if (value <= 0xFFFFFF) value |= 0xFF000000;
      return Color(value);
    }

    // Fallback to white
    return const Color(0xFFFFFFFF);
  }

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
            backgroundColor: FIGMA.Back,
            content: StatefulBuilder(builder: (context, setState) {
              return EasyContainer(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height * 0.5,
                color: FIGMA.Back,
                borderWidth: 0,
                elevation: 0,
                margin: 0,
                padding: 0,
                borderRadius: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: connected
                      ? [
                          const Icon(Icons.check_circle,
                              size: 80, color: Colors.green),
                          const Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              "مراحل اتصال تکمیل شد!",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FIGMA.abrlb,
                                  color: FIGMA.Wrn),
                            ),
                          ),
                          EasyContainer(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 95,
                            borderRadius: 15,
                            color: FIGMA.Orn,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text("خروج",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: FIGMA.abreb,
                                    color: FIGMA.Wrn)),
                          ),
                        ]
                      : [
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "اتصال به شبکه نوروانا",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FIGMA.abrlb,
                                  color: FIGMA.Wrn),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "لطفا کادر های زیر را برای اتصال کامل کنید",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FIGMA.abrlb,
                                  color: FIGMA.Wrn),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: ssidController,
                              obscureText: true,
                              textAlign: TextAlign.right, // For RTL alignment
                              decoration: InputDecoration(
                                hintText: " WiFi نام", // Or "Password"
                                hintStyle: const TextStyle(color: FIGMA.Wrn2),

                                filled: true,
                                fillColor: Colors.white,

                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 22,
                                ), // Big height/width

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Curved border
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .grey.shade700), // Darker on focus
                                ),

                                // Remove all effects (e.g., shadows, glow)
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                              ),
                              cursorColor: Colors.grey.shade700,
                              style: const TextStyle(
                                  fontSize: 16, color: FIGMA.Wrn),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: passController,
                              obscureText: true,
                              textAlign: TextAlign.right, // For RTL alignment
                              decoration: InputDecoration(
                                hintText: "رمز عبور", // Or "Password"
                                hintStyle: const TextStyle(color: FIGMA.Wrn2),

                                filled: true,
                                fillColor: Colors.white,

                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 22,
                                ), // Big height/width

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12), // Curved border
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .grey.shade700), // Darker on focus
                                ),

                                // Remove all effects (e.g., shadows, glow)
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                              ),
                              cursorColor: Colors.grey.shade700,
                              style: const TextStyle(
                                  fontSize: 16, color: FIGMA.Wrn),
                            ),
                          ),
                          Column(
                            children: [
                              EasyContainer(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 95,
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
                                child: const Text("ارسال اطلاعات",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: FIGMA.abreb,
                                        color: FIGMA.Wrn)),
                              ),
                              const SizedBox(height: 1),
                              EasyContainer(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 95,
                                borderRadius: 15,
                                color: FIGMA.Orn,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("خروج",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: FIGMA.abreb,
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
}

class ShortTimer extends StatelessWidget {
  const ShortTimer({super.key});

  @override
  Widget build(BuildContext context) {
    void TimerSend(int s, ProvData value) {
      calculateTimeStore(s);
      debugPrint("Minute $s");

      value.nextmoveisconnect
          ? NetClass()
              .setTimer(value.token, value.Products[0]["id"].toString(), s)
          : null;

      String jsonPayload = jsonEncode({"Tf": s.toString()});
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
            child: TimerButton(
              state: value.timeroffvalue > 0,
              Templete: [
                SvgPicture.asset(
                  'assets/timer.svg',
                  width: 32,
                  color: FIGMA.Wrn,
                ),
                const Text(
                  'تایمر',
                  style: TextStyle(
                      fontFamily: FIGMA.estsb, fontSize: 16, color: FIGMA.Wrn),
                ),
                Text(
                  value.timeroffvalue == 0
                      ? "غیرفعال"
                      : "${sdcard.get("Timeofdie", defaultValue: "00:00")}",
                  style: const TextStyle(
                    fontFamily: FIGMA.estre,
                    fontSize: 14,
                    color: FIGMA.Wrn,
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
                        fontSize: 19,
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
