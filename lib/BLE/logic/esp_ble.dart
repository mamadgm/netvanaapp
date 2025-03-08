// // ignore_for_file: non_constant_identifier_names

// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:async';
// import 'package:netvana/const/figma.dart';
// import 'package:netvana/data/ble/providerble.dart';
// import 'package:convert/convert.dart';
// import 'package:flutter/material.dart';
// import 'package:universal_ble/universal_ble.dart';

// late Espnetvana NooranBle;

// class Espnetvana {
//   set_Intervaltimer(bool isfast) {
//     isfast ? interval = 2 : interval = 2;
//     _resetTimer();
//   }

//   Timer? _timer;
//   int interval = 2; // Interval in seconds
//   late ProvData datky;
//   late ProvData funcy;

//   List<BleService> discoveredServices = [];

//   Espnetvana(ProvData datkyvalue, dynamic funcyvalue) {
//     _setHandlers();
//     _startTimer();
//     datky = datkyvalue;
//     funcy = funcyvalue;
//   }

//   update_provider(ProvData datkyvalue, dynamic funcyvalue) {
//     datky = datkyvalue;
//     funcy = funcyvalue;
//   }

//   ({
//     BleService service,
//     BleCharacteristic characteristic
//   })? selectedCharacteristic;

//   void _removePreviousHandlers() {
//     UniversalBle.onConnectionChange = null;
//     UniversalBle.onValueChange = null;
//   }

//   void _setHandlers() {
//     debugPrint("SoftDispose");
//     _removePreviousHandlers();
//     UniversalBle.onConnectionChange = _handleConnectionChange;
//     UniversalBle.onValueChange = _handleValueChange;
//   }

//   void _handleConnectionChange(
//     String deviceId,
//     bool isConnected,
//   ) {
//     debugPrint('_handleConnectionChange $deviceId, $isConnected');

//     if (deviceId == datky.Device_UUID) {
//       funcy.netvana_update_connected(isConnected);
//     }

//     // Auto Discover Services
//     if (datky.isConnected) {
//       _setHandlers();
//       _discoverServices();
//       //_setnotif();
//     }
//   }

//   void LoginTheClient(context) {
//     String Command = "[X]0000[F]";
//     int client = datky.login_Counter;
//     if (client < 10) {
//       Command = "[X]000$client[F]";
//     } else if (client < 100) {
//       Command = "[X]00$client[F]";
//     } else if (client < 1000) {
//       Command = "[X]0$client[F]";
//     } else {
//       Command = "[X]$client[F]";
//     }

//     SendAval(Command);
//     SendBval({datky.login_Counter + 1}.toString());
//     SendToEsp32("Cl-");
//   }

//   // void _setnotif() {
//   //   UniversalBle.setNotifianetvana(datky.Device_UUID, FIGMA.ESP32_SERVICE_ID,
//   //       FIGMA.ESP32_SERVICE_Micro, netvanaInputProperty.notification);
//   // }

//   void _handleValueChange(
//       String deviceId, String characteristicId, Uint8List value) {
//     // String s = String.fromCharCodes(value);
//     // String data = '$s\nraw :  ${value.toString()}';
//     // debugPrint('_handleValueChange $deviceId, $characteristicId, $s');
//     // Future.delayed(const Duration(milliseconds: 500));

//     //funcy.Show_Snackbar("Value ", 500);
//   }

//   Future<void> _discoverServices() async {
//     try {
//       var services = await UniversalBle.discoverServices(datky.Device_UUID);
//       debugPrint('${services.length} services discovered');
//       discoveredServices.clear();
//       //TODO
//       discoveredServices = services;
//     } catch (e) {
//       debugPrint("79$e");
//     }
//   }

//   bool _hasSelectedCharacteristicProperty(
//       List<CharacteristicProperty> properties) {
//     return properties.any((property) =>
//         selectedCharacteristic?.characteristic.properties.contains(property) ??
//         false);
//   }

//   String EasyConvertuint8(String input) {
//     List<int> bytes = utf8.encode(input);
//     String hex =
//         bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
//     return hex;
//   }

//   // Future<void> readmanual() async {
//   //   debugPrint("Reading");
//   //   try {
//   //     Uint8List input3 = await UniversalBle.readValue(datky.Device_UUID,
//   //             FIGMA.ESP32_SERVICE_ID, FIGMA.ESP32_SERVICE_FAVAL)
//   //         .timeout(const Duration(seconds: 5));
//   //     debugPrint("FLUTTER_SMARTTIMER${String.fromCharCodes(input3)}");
//   //     funcy.Show_Snackbar("Code is : ${String.fromCharCodes(input3)}", 5000);
//   //     funcy.Set_TEST_DATA(input3.toString());
//   //   } catch (e) {
//   //     funcy.Set_TEST_DATA(e.toString());
//   //     funcy.Show_Snackbar("Error is : ${e.toString()}", 5000);
//   //     debugPrint(e.toString());
//   //     throw e.toString();
//   //   }
//   // }

//   //TIMERS
//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(Duration(seconds: interval), (timer) {
//       if (datky.isConnected) {
//         _triggerFunction();
//       } else {
//         // debugPrint("Sync Timer : device is Disconnected");
//       }
//     });
//   }

//   Future<void> _triggerFunction() async {
//     // debugPrint('netvana Function triggered!');
//     // Your function logic here
//     //funcy.update_Appsync(FIGMA.FLUTTER_ESSENTIALS);

//     await Future.delayed(const Duration(milliseconds: 100));
//     Uint8List input1 = await UniversalBle.readValue(
//         datky.Device_UUID, FIGMA.ESP32_SERVICE_ID, FIGMA.ESP32_SERVICE_FAVAL);
//     // debugPrint(String.fromCharCodes(input1));
//     funcy.extractNumbers_UI(String.fromCharCodes(input1));
//   }

//   void _resetTimer() {
//     _timer?.cancel();
//     _startTimer();
//   }

//   void send_big_string(String input) {
//     input = "$input[|]";
//     List<String> result = ["", "", ""];

//     if (input.length <= 20) {
//       result[0] = input;
//       NooranBle.SendAval(result[0]);
//     } else if (input.length <= 40) {
//       result[0] = input.substring(0, 20);
//       result[1] = input.substring(20);
//       NooranBle.SendAval(result[0]);
//       NooranBle.SendBval(result[1]);
//     } else {
//       result[0] = input.substring(0, 20);
//       result[1] = input.substring(20, 40);
//       result[2] = input.substring(40);
//       NooranBle.SendAval(result[0]);
//       NooranBle.SendBval(result[1]);
//       NooranBle.SendCval(result[2]);
//     }
//   }

//   //===============================netvana FUNCTIONS REALY IMPORTANT
//   Future<void> SendAval(String value) async {
//     Uint8List output;
//     try {
//       output = Uint8List.fromList(hex.decode(EasyConvertuint8(value)));
//     } catch (e) {
//       return;
//     }
//     try {
//       await UniversalBle.writeValue(
//         datky.Device_UUID,
//         FIGMA.ESP32_SERVICE_ID,
//         FIGMA.ESP32_SERVICE_AVAL,
//         output,
//         _hasSelectedCharacteristicProperty(
//                 [CharacteristicProperty.writeWithoutResponse])
//             ? BleOutputProperty.withoutResponse
//             : BleOutputProperty.withResponse,
//       );
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Future<void> SendBval(String value) async {
//     Uint8List output;
//     try {
//       output = Uint8List.fromList(hex.decode(EasyConvertuint8(value)));
//     } catch (e) {
//       return;
//     }
//     try {
//       await UniversalBle.writeValue(
//         datky.Device_UUID,
//         FIGMA.ESP32_SERVICE_ID,
//         FIGMA.ESP32_SERVICE_BVAL,
//         output,
//         _hasSelectedCharacteristicProperty(
//                 [CharacteristicProperty.writeWithoutResponse])
//             ? BleOutputProperty.withoutResponse
//             : BleOutputProperty.withResponse,
//       );
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Future<void> SendCval(String value) async {
//     Uint8List output;
//     try {
//       output = Uint8List.fromList(hex.decode(EasyConvertuint8(value)));
//     } catch (e) {
//       return;
//     }
//     try {
//       await UniversalBle.writeValue(
//         datky.Device_UUID,
//         FIGMA.ESP32_SERVICE_ID,
//         FIGMA.ESP32_SERVICE_CVAL,
//         output,
//         _hasSelectedCharacteristicProperty(
//                 [CharacteristicProperty.writeWithoutResponse])
//             ? BleOutputProperty.withoutResponse
//             : BleOutputProperty.withResponse,
//       );
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Future<void> SendToEsp32(String value,
//       {bool showwhathappened = false}) async {
//     Uint8List output;
//     try {
//       output = Uint8List.fromList(hex.decode(EasyConvertuint8(value)));
//     } catch (e) {
//       debugPrint('WriteError');
//       return;
//     }

//     try {
//       await UniversalBle.writeValue(
//         datky.Device_UUID,
//         FIGMA.ESP32_SERVICE_ID,
//         FIGMA.ESP32_SERVICE_WHICH,
//         output,
//         _hasSelectedCharacteristicProperty(
//                 [CharacteristicProperty.writeWithoutResponse])
//             ? BleOutputProperty.withoutResponse
//             : BleOutputProperty.withResponse,
//       );

//       if (showwhathappened) {
//         debugPrint('Write$value');
//         funcy.Show_Snackbar("دیتا ارسال شد", 300);
//       }
//     } catch (e) {
//       debugPrint('WriteError$e');
//       funcy.Show_Snackbar("مشکلی پیش آمد", 1200);
//     }
//   }
// }
