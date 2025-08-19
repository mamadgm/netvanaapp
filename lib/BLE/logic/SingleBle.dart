// ignore_for_file: file_names
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:universal_ble/universal_ble.dart';

class SingleBle {
  static final SingleBle _instance = SingleBle._internal();
  factory SingleBle() => _instance;
  SingleBle._internal();

  static SingleBle get instance => _instance;

  List<BleDevice> discoveredDevices = [];
  String? connectedDeviceId;

  ScanFilter? scanFilter = ScanFilter(withServices: [FIGMA.ESP32_SERVICE_ID]);

  late ProvData _provider;

  void init(ProvData providerInstance) {
    _provider = providerInstance;
  }

  Future<void> startScan() async {
    discoveredDevices.clear();
    UniversalBle.onScanResult = (result) {
      int index =
          discoveredDevices.indexWhere((e) => e.deviceId == result.deviceId);
      if (index == -1) {
        discoveredDevices.add(result);
      } else {
        discoveredDevices[index] = result;
      }

      debugPrint("Discovered device: ${result.deviceId}, Name: ${result.name}");
    };
    await UniversalBle.startScan(scanFilter: scanFilter);
    debugPrint("Started BLE scan");
  }

  Future<void> stopScan() async {
    await UniversalBle.stopScan();
    debugPrint("Stopped BLE scan");
  }

  Future<bool> connectToDevice(String deviceId, int loginCounter) async {
    try {
      await UniversalBle.connect(deviceId);
      connectedDeviceId = deviceId;
      debugPrint("Connected to device: $deviceId");

      await listenToNotifications();
      await Future.delayed(const Duration(milliseconds: 1000));
      await loginTheClient();
      return true;
    } catch (e) {
      debugPrint("Failed to connect to $deviceId: $e");
      return false;
    }
  }

  Future<void> loginTheClient() async {
    String jsonPayload = jsonEncode({"Scrt": "7382641987836gsjhd"});
    await sendMain(jsonPayload);
    debugPrint("Sent login payload: $jsonPayload");
  }

  Future<void> disconnect() async {
    if (connectedDeviceId != null) {
      await UniversalBle.disconnect(connectedDeviceId!);
      debugPrint("Disconnected from $connectedDeviceId");
      connectedDeviceId = null;
    }
  }

  Future<void> sendToEsp32(String value, String characteristicId,
      {bool showwhathappened = false}) async {
    if (connectedDeviceId == null) {
      debugPrint("No device connected.");
      return;
    }

    Uint8List output;
    try {
      output = Uint8List.fromList(utf8.encode(value));
    } catch (e) {
      debugPrint('WriteError: Invalid value format: $e');
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
        debugPrint('Wrote to $characteristicId: $value');
      }
    } catch (e) {
      debugPrint('WriteError: $e');
    }
  }

  Future<void> listenToNotifications() async {
    if (connectedDeviceId == null) {
      debugPrint("No device connected to listen to.");
      return;
    }

    final device = discoveredDevices.firstWhere(
      (d) => d.deviceId == connectedDeviceId,
      orElse: () => BleDevice(deviceId: connectedDeviceId!, name: "Unknown"),
    );

    try {
      final characteristic = await device.getCharacteristic(
        FIGMA.ESP32_SERVICE_Micro,
        service: FIGMA.ESP32_SERVICE_ID,
      );
      debugPrint("Subscribed to characteristic: ${characteristic.uuid}");
      await characteristic.notifications.subscribe();

      characteristic.onValueReceived.listen((value) async {
        String str = String.fromCharCodes(value);
        debugPrint("Received notification: $str");
        _provider.Set_Screen_Values(str);
      });
      debugPrint(
          "Subscribed to notifications for ${FIGMA.ESP32_SERVICE_Micro}");
    } catch (e) {
      debugPrint("Failed to set up notifications: $e");
    }
  }

  Future<Map<String, String>?> startScanAndGetDevice() async {
    try {
      await startScan();
      await Future.delayed(const Duration(seconds: 3));
      if (discoveredDevices.isNotEmpty) {
        var device = discoveredDevices.last;
        debugPrint("Found device: ${device.deviceId}, Name: ${device.name}");
        return {
          'deviceId': device.deviceId,
          'name': device.name ?? 'Unknown',
        };
      } else {
        debugPrint("No devices found during scan");
        return null;
      }
    } catch (e) {
      debugPrint("Scan Error: $e");
      return null;
    }
  }

  Future<String> triggerFunction() async {
    try {
      if (connectedDeviceId == null) {
        throw Exception("connectedDeviceId Is Null");
      }
      Uint8List input1 = await UniversalBle.read(connectedDeviceId!,
          FIGMA.ESP32_SERVICE_ID, FIGMA.ESP32_SERVICE_Micro);
      String result = String.fromCharCodes(input1);
      debugPrint("Read from ESP32: $result");
      return result;
    } catch (e) {
      debugPrint("Error in Reading From ESP32: $e");
      return "Error";
    }
  }

  Future<void> sendMain(String value) async {
    await sendToEsp32(value, FIGMA.ESP32_SERVICE_WHICH);
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
      test = "$test $i -> ${results[i]}\n";
    }
    return test;
  }
}
