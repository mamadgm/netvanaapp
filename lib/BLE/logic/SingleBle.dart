// ignore_for_file: file_names
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';
import 'package:universal_ble/universal_ble.dart';

class SingleBle {
  static final SingleBle _instance = SingleBle._internal();
  factory SingleBle() => _instance;
  SingleBle._internal();

  // Add explicit instance getter
  static SingleBle get instance => _instance;

  List<BleDevice> discoveredDevices = [];
  String? connectedDeviceId;

  ScanFilter? scanFilter = ScanFilter(withServices: [FIGMA.ESP32_SERVICE_ID]);

  late ProvData _provider;

  void init(ProvData providerInstance) {
    _provider = providerInstance;
  }

  // Start scanning for devices
  Future<void> startScan() async {
    discoveredDevices.clear(); // Clear any previously discovered devices

    // Start scanning and listen to scan results
    UniversalBle.onScanResult = (result) {
      int index =
          discoveredDevices.indexWhere((e) => e.deviceId == result.deviceId);
      if (index == -1) {
        discoveredDevices.add(result);
      } else {
        discoveredDevices[index] = result;
      }
    };

    await UniversalBle.startScan(scanFilter: scanFilter);
  }

  // Stop scanning
  Future<void> stopScan() async {
    await UniversalBle.stopScan();
  }

  Future<bool> connectToDevice(String deviceId, int loginCounter) async {
    try {
      await UniversalBle.connect(deviceId);

      connectedDeviceId = deviceId;
      debugPrint("Connected to $deviceId");
      await listenToNotifications();
      return true; // Connection was successful
    } catch (e) {
      debugPrint("Failed to connect to $deviceId");
      debugPrint("Connection failed: $e");
      return false; // Connection failed
    }
  }

  // void loginTheClient(int loginCounter) {
  //   sendAval("12345678");
  //   sendMain("Cl-");
  // }

  // Disconnect from the device
  Future<void> disconnect() async {
    if (connectedDeviceId != null) {
      await UniversalBle.disconnect(connectedDeviceId!);
      connectedDeviceId = null;
    }
  }

  // Generic function to send data to ESP32
  Future<void> sendToEsp32(String value, String characteristicId,
      {bool showwhathappened = false}) async {
    if (connectedDeviceId == null) {
      debugPrint("No device connected.");
      return;
    }

    Uint8List output;
    try {
      output = Uint8List.fromList(hex.decode(easyconvertunit8(value)));
    } catch (e) {
      debugPrint('WriteError: Invalid value format');
      return;
    }

    try {
      await UniversalBle.write(
        connectedDeviceId!,
        FIGMA.ESP32_SERVICE_ID,
        characteristicId,
        output,
      );

      if (showwhathappened) {
        debugPrint('Write: $value');
        // Call snackbar or UI update function if needed
      }
    } catch (e) {
      debugPrint('WriteError: $e');
      // Call error UI update function if needed
    }
  }

  Future<void> listenToNotifications() async {
    if (connectedDeviceId == null) {
      debugPrint("No device connected to listen to.");
      return;
    }

    final device = discoveredDevices.firstWhere(
      (d) => d.deviceId == connectedDeviceId,
      orElse: () {
        debugPrint("Connected device not found in discoveredDevices.");
        return BleDevice(deviceId: connectedDeviceId!, name: "Unknown");
      },
    );

    try {
      final characteristic = await device.getCharacteristic(
        FIGMA.ESP32_SERVICE_Micro,
        service: FIGMA.ESP32_SERVICE_ID,
      );

      debugPrint("characteristic micro${characteristic.uuid}");

      await characteristic.notifications.subscribe();

      characteristic.onValueReceived.listen((value) async {
        String str = String.fromCharCodes(value);
        _provider.Set_Screen_Values(str); // <— use directly
        _provider.Show_Snackbar("🔔 Notification received", 500);
      });
      _provider.Show_Snackbar("✅ Subscribed to notifications.", 500);
    } catch (e) {
      _provider.Show_Snackbar("❌ Failed to set up notifications: $e", 200);
    }
  }

  Future<Map<String, String>?> startScanAndGetDevice() async {
    try {
      await startScan(); // Start scanning

      await Future.delayed(const Duration(seconds: 1)); // Wait

      if (discoveredDevices.isNotEmpty) {
        var device = discoveredDevices.last;
        return {
          'deviceId': device.deviceId,
          'name': device.name ?? 'Unknown',
        };
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Scan Error: $e");
      return null;
    }
  }

  //Read Data
  Future<String> triggerFunction() async {
    try {
      if (connectedDeviceId == null) {
        throw Exception("connectedDeviceId Is Null");
      }
      Uint8List input1 = await UniversalBle.read(connectedDeviceId!,
          FIGMA.ESP32_SERVICE_ID, FIGMA.ESP32_SERVICE_Micro);
      return String.fromCharCodes(input1);
    } catch (e) {
      debugPrint("Error in Reading From ESP32 ${e.toString()}");
    }
    return "Error";
  }

  // Specific functions for sending values to different characteristics
  // Future<void> sendAval(String value) async {
  //   await sendToEsp32(value, FIGMA.ESP32_SERVICE_AVAL);
  // }

  Future<void> sendMain(String value) async {
    await sendToEsp32(value, FIGMA.ESP32_SERVICE_WHICH);
  }

  // Future<void> sendBval(String value) async {
  //   await sendToEsp32(value, FIGMA.ESP32_SERVICE_BVAL);
  // }

  // Future<void> sendCval(String value) async {
  //   await sendToEsp32(value, FIGMA.ESP32_SERVICE_CVAL);
  // }

  // void sendBigString(String input) {
  //   input = "$input[|]"; // Append the delimiter
  //   List<String> chunks = [];

  //   // Split input into chunks of 20 characters
  //   for (int i = 0; i < input.length; i += 20) {
  //     chunks.add(
  //         input.substring(i, i + 20 > input.length ? input.length : i + 20));
  //   }

  //   // Send chunks to corresponding characteristics
  //   if (chunks.isNotEmpty) sendAval(chunks[0]);
  //   if (chunks.length > 1) sendBval(chunks[1]);
  //   if (chunks.length > 2) sendCval(chunks[2]);
  // }

  String easyconvertunit8(String input) {
    List<int> bytes = utf8.encode(input);
    String hex =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return hex;
  }

  String extractNumbersUI(String input) {
    List<int> results = [];
    RegExp regExp = RegExp(r'([A-L])(\d+)');
    Iterable<RegExpMatch> matches = regExp.allMatches(input);

    for (var match in matches) {
      String number = match.group(2)!;
      results.add(int.parse(number));
    }
    String test = "";
    for (int i = 0; i < results.length; i++) {
      // debugPrint("letter : $i is ${result[i]}");
      test = "$test $i -> ${results[i]}\n";
    }

    return test;
  }
}
