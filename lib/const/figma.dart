// ignore_for_file: constant_identifier_names, unused_element, non_constant_identifier_names, prefer_const_constructors, prefer_const_declarations

import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class FIGMA {
  static const Prn = Color(0xFF00A594);
  static const Orn = Color(0xFFF3593A);
  static const Grn = Color(0xFF001916);
  static const Wrn = Color(0xFFFFFFFF);
  static const Back = Color(0xFFF9F9F9);
  static const Gray = Color(0xFFEEF2F5);

  static const abrlb = 'abrlb';
  static const abreb = 'abreb';
  static const estbo = 'estbo';
  // static const estel = 'estel';
  static const estre = 'estre';
  static const estsb = 'estsb';

  static const urlnetwana = "https://api.netvana.ir";
  // static const HIVE = "Neol-Tetad";
  static const HIVE = "Neol-Tetadme";
  static const int FLUTTER_ESSENTIALS = 1;
  // static const int FLUTTER_SPELCO = 2;
  // static const int FLUTTER_SMARTTIMER = 3;
  static const ESP32_SERVICE_ID = "a7e40a4c-eec9-4910-bf7e-113c6ed2381b";
  static const ESP32_SERVICE_WHICH = "d9a127a9-bf6c-48dd-9d70-ba5bc06a83e6";
  // static const ESP32_SERVICE_AVAL = "83d5317f-2c4d-4c0f-93bf-f2fa52d4e0dc";
  // static const ESP32_SERVICE_BVAL = "73398be2-a70a-4455-8560-abb4957666ab";
  // static const ESP32_SERVICE_CVAL = "4ea4edec-d39b-4ea6-9c4e-bd64ccd613a4";
  static const ESP32_SERVICE_Micro = "903ff0ee-4d92-4815-8dae-bcbc9aec61e4";
  // static const ESP32_SERVICE_FAVAL = "cede8c92-5dad-4b90-bb88-5300a5566598";
  // static const ESP32_SERVICE_FBVAL = "f1e50997-b8b4-475b-89c3-bc08fa1c4b2e";
  // static const ESP32_SERVICE_FCVAL = "66905ac6-9820-4942-bd40-79bac9c3501c";
}

Size GetGoodW(BuildContext context, double inwidth, double inheight) {
  double refrence = MediaQuery.of(context).size.width / 375;
  return Size(inwidth * refrence, inheight * refrence);
}

Widget FASELE({required int value}) {
  return Expanded(
    flex: value,
    child: SizedBox(),
  );
}
