// ignore_for_file: file_names
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:netvana/const/figma.dart';
import 'package:universal_ble/universal_ble.dart';

class SingleBle {
  static final SingleBle _instance = SingleBle._internal();
  factory SingleBle() => _instance;
  SingleBle._internal();

  List<BleDevice> discoveredDevices = [];
  String? connectedDeviceId;

  ScanFilter? scanFilter = ScanFilter(withServices: [FIGMA.ESP32_SERVICE_ID]);

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
      bool connected = await UniversalBle.connect(deviceId);
      if (connected) {
        connectedDeviceId = deviceId;
        debugPrint("Connected to $deviceId");

        // Wait 2 seconds, then log in the client
        Future.delayed(const Duration(seconds: 2), () {
          loginTheClient(loginCounter);
        });

        return true; // Connection was successful
      } else {
        debugPrint("Failed to connect to $deviceId");
        return false; // Connection failed
      }
    } catch (e) {
      debugPrint("Connection failed: $e");
      return false; // Handle the exception
    }
  }

  void loginTheClient(int loginCounter) {
    sendAval("12345678");
    sendMain("Cl-");
  }

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
      await UniversalBle.writeValue(
        connectedDeviceId!,
        FIGMA.ESP32_SERVICE_ID,
        characteristicId,
        output,
        BleOutputProperty.withoutResponse,
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

  Future<String?> startScanAndGetDevice() async {
    try {
      await startScan(); // Start scanning (triggers the native UI)

      // Wait for the user to select a device
      await Future.delayed(
          const Duration(seconds: 2)); // Give some time for selection

      if (discoveredDevices.isNotEmpty) {
        return discoveredDevices
            .last.deviceId; // Return the last selected device
      } else {
        return null; // No device selected
      }
    } catch (e) {
      debugPrint("Scan Error: $e");
      return null;
    }
  }

  //Read Data
  Future<void> triggerFunction() async {
    try {
      if (connectedDeviceId == null) {
        throw Exception("connectedDeviceId Is Null");
      }
      Uint8List input1 = await UniversalBle.readValue(connectedDeviceId!,
          FIGMA.ESP32_SERVICE_ID, FIGMA.ESP32_SERVICE_FAVAL);
      String temp = extractNumbersUI(String.fromCharCodes(input1));
      debugPrint("data From Esp32\n$temp");
    } catch (e) {
      debugPrint("Error in Reading From ESP32 ${e.toString()}");
    }
  }

  // Specific functions for sending values to different characteristics
  Future<void> sendAval(String value) async {
    await sendToEsp32(value, FIGMA.ESP32_SERVICE_AVAL);
  }

  Future<void> sendMain(String value) async {
    await sendToEsp32(value, FIGMA.ESP32_SERVICE_WHICH);
  }

  Future<void> sendBval(String value) async {
    await sendToEsp32(value, FIGMA.ESP32_SERVICE_BVAL);
  }

  Future<void> sendCval(String value) async {
    await sendToEsp32(value, FIGMA.ESP32_SERVICE_CVAL);
  }

  void sendBigString(String input) {
    input = "$input[|]"; // Append the delimiter
    List<String> chunks = [];

    // Split input into chunks of 20 characters
    for (int i = 0; i < input.length; i += 20) {
      chunks.add(
          input.substring(i, i + 20 > input.length ? input.length : i + 20));
    }

    // Send chunks to corresponding characteristics
    if (chunks.isNotEmpty) sendAval(chunks[0]);
    if (chunks.length > 1) sendBval(chunks[1]);
    if (chunks.length > 2) sendCval(chunks[2]);
  }

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
    // isdeviceon = result[0].toInt() == 1;
    // isnooranNet = result[1].toInt() == 1;
    // whereami = result[2];
    // timeroffvalue = result[3];
    // Brightness = result[4];
    // maincycle_color = result[5];
    // maincycle_mode = result[6];
    // maincycle_speed = result[7];
    // smartdelaysec = result[8];
    // smarttimerpos = result[9];
    // smarttimercolor = result[10];
    // ESPVersion = result[11];
    // int Test = result[12];
    // debugPrint('isdeviceon: $isdeviceon');
    // debugPrint('isnooranNet: $isnooranNet');
    // debugPrint('whereami: $whereami');
    // debugPrint('timeroffvalue: $timeroffvalue');
    // debugPrint('Brightness: $Brightness');
    // debugPrint('maincycle_color: $maincycle_color');
    // debugPrint('maincycle_mode: $maincycle_mode');
    // debugPrint('maincycle_speed: $maincycle_speed');
    // debugPrint('smartdelaysec: $smartdelaysec');
    // debugPrint('smarttimerpos: $smarttimerpos');
    // debugPrint('smarttimercolor: $smarttimercolor');
    // debugPrint('ESPVersion: $ESPVersion');
    // notifyListeners();
  }
}
