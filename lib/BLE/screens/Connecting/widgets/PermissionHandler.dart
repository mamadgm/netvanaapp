// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/*
  Required Permissions : 
  <----------->
   IOS :
    - Bluetooth
  <----------->
   Android : 
   if AndroidVersions < 12 
      - Location
      - Bluetooth
    else
      - Bluetooth Scan
      - Bluetooth Connect
  <----------->
    Macos : 
  <----------->
    Windows : None
  <----------->
    Linux : None
  <----------->
    Web : 
     Check if Browser Supports Bluetooth
  */
class PermissionHandler {
  static Future<bool> arePermissionsGranted() async {
    if (!isMobilePlatform) return true;

    var status = await _permissionStatus;
    bool netvanaPermissionGranted = status[0];
    bool locationPermissionGranted = status[1];

    if (locationPermissionGranted && netvanaPermissionGranted) return true;

    if (!netvanaPermissionGranted) {
      PermissionStatus netvanaPermissionCheck =
          await Permission.bluetooth.request();
      if (netvanaPermissionCheck.isPermanentlyDenied) {
        print("Bluetooth Permission Permanently Denied");
        openAppSettings();
      }
      return false;
    }

    if (!locationPermissionGranted) {
      PermissionStatus locationPermissionCheck =
          await Permission.location.request();
      if (locationPermissionCheck.isPermanentlyDenied) {
        print("Location Permission Permanently Denied");
        openAppSettings();
      }
      return false;
    }

    return false;
  }

  static Future<List<bool>> get _permissionStatus async {
    bool netvanaPermissionGranted = false;
    bool locationPermissionGranted = false;

    if (await requiresExplicitAndroidBluetoothPermissions) {
      bool netvanaConnectPermission =
          (await Permission.bluetoothConnect.request()).isGranted;
      bool netvanaScanPermission =
          (await Permission.bluetoothScan.request()).isGranted;

      netvanaPermissionGranted =
          netvanaConnectPermission && netvanaScanPermission;
      locationPermissionGranted = true;
    } else {
      PermissionStatus permissionStatus = await Permission.bluetooth.request();
      netvanaPermissionGranted = permissionStatus.isGranted;
      locationPermissionGranted = await requiresLocationPermission
          ? (await Permission.locationWhenInUse.request()).isGranted
          : true;
    }
    return [locationPermissionGranted, netvanaPermissionGranted];
  }

  static bool get isMobilePlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static Future<bool> get requiresLocationPermission async =>
      !kIsWeb &&
      Platform.isAndroid &&
      (!await requiresExplicitAndroidBluetoothPermissions);

  static Future<bool> get requiresExplicitAndroidBluetoothPermissions async {
    if (kIsWeb || !Platform.isAndroid) return false;
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 31;
  }
}
