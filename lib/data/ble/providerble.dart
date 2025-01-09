// ignore_for_file: non_constant_identifier_names

import 'package:netvana/const/figma.dart';
import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';

class ProvData extends ChangeNotifier {
  //App
  String Device_UUID = "null";
  String Device_NAME = "null";
  bool Isdevicefound = false;
  int Current_screen = 0;
  //netvana
  bool nextmoveisconnect = true;
  int current_sync_pos = 0;
  int current_selected_slider = 0;
  List<BleDevice> mynetvanaDevices = <BleDevice>[];
  bool isConnected = false;
  int appsync = FIGMA.FLUTTER_ESSENTIALS;
  //Setting Screen
  bool NetvanaFlag = false;
  bool NetvanaUpdateFlag = false;
  TextEditingController r_ssid_netvana = TextEditingController();
  TextEditingController r_pass_netvana = TextEditingController();
  //Nooran
  bool isdeviceon = false;
  bool isnooranNet = false;
  int whereami = 0;
  int timeroffvalue = 0;
  int Brightness = 0;
  int maincycle_color = 0;
  int maincycle_mode = 0;
  int maincycle_speed = 0;
  int smartdelaysec = 0;
  int smarttimerpos = 0;
  int smarttimercolor = 0;
  bool issmarttimerpaused = true;
  int ESPVersion = 10;
  List<int> Defalult_colors = [0xFF0000, 1900288, 0x0000FF, 0xFFFFFF, 0x00A594];
  //Loggin
  int login_Counter = 0;
  bool Issigned = false;
  String username = 'mamad';
  String email = "ss";
  String Token = "";
  List Products = [];
  //Test
  String TEST_DATA = "EMPTY";
  //Smarttimer

  void set_Defalult_colors(int p, int which) {
    Defalult_colors[which] = p;
    notifyListeners();
  }

  // Setters
  void setProducts(List products) {
    Products = products;

    for (var i = 0; i < Products.length; i++) {
      debugPrint("product $i = ${Products[i]}");
    }
    notifyListeners();
  }

  void setIsDeviceOn(bool value) {
    isdeviceon = value;
    notifyListeners();
  }

  void setIssigned(bool p, String token) {
    Issigned = p;
    if (p) {
      Token = token;
    }
    // notifyListeners();
  }

  void Set_Userdetails(
      String Email, String Name, int Login_counter, bool update) {
    login_Counter = Login_counter;
    username = Name;
    email = Email;
    debugPrint('user logged In $email $username $login_Counter $Token');
    if (update) {
      notifyListeners();
    }
  }

  void setIsNooranNet(bool value) {
    isnooranNet = value;
    notifyListeners();
  }

  void setWhereAmI(int value) {
    whereami = value;
    notifyListeners();
  }

  void setTimerOffValue(int value) {
    timeroffvalue = value;
    notifyListeners();
  }

  void setBrightness(int value) {
    Brightness = value;
    notifyListeners();
  }

  void setMainCycleColor(int value) {
    maincycle_color = value;
    notifyListeners();
  }

  void setMainCycleMode(int value) {
    maincycle_mode = value;
    notifyListeners();
  }

  void setMainCycleSpeed(int value) {
    maincycle_speed = value;
    notifyListeners();
  }

  void setSmartDelaySec(int value) {
    smartdelaysec = value;
    notifyListeners();
  }

  void setSmartTimerPos(int value) {
    smarttimerpos = value;
    notifyListeners();
  }

  void setSmartTimerColor(int value) {
    smarttimercolor = value;
    notifyListeners();
  }

  void setSmartTimerPaused(bool value) {
    issmarttimerpaused = value;
    notifyListeners();
  }

  void netvana_update_connected(bool p) {
    isConnected = p;
    notifyListeners();
  }

  void Set_TEST_DATA(String input) {
    TEST_DATA = input;
    notifyListeners();
  }

  void update_Appsync(int input) {
    appsync = input;
    notifyListeners();
  }

  void update_netvana(bool input) {
    NetvanaFlag = input;
    notifyListeners();
  }

  void update_NetvanaUpdateFlag(bool input) {
    NetvanaUpdateFlag = input;
    notifyListeners();
  }

  void update_mynetvanadevice() {
    mynetvanaDevices = mynetvanaDevices;
    notifyListeners();
  }

  //
  void change_nextmoveisconnect(bool input) {
    nextmoveisconnect = input;
    notifyListeners();
  }

  void change_slider(int input) {
    current_selected_slider = input;
    notifyListeners();
  }

  void change_sync_pos(int input) {
    current_sync_pos = input;
    notifyListeners();
  }

  void SetDevice(String uuid, String name) {
    Device_UUID = uuid;
    Device_NAME = name;
    notifyListeners();
  }

  void ChangeDeviceFound(bool value) {
    Isdevicefound = value;
    Change_current_screen(2);
    notifyListeners();
  }

  void Change_current_screen(int input) {
    switch (Isdevicefound) {
      case false:
        Current_screen = input;
        break;
      case true:
        if (input == 2) {
          Current_screen = 3;
        } else {
          Current_screen = input;
        }
        break;
    }
    notifyListeners();
  }

  void Show_Snackbar(String value, int dur) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: FIGMA.Gray,
        duration: Duration(milliseconds: dur),
        content: Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
              fontFamily: FIGMA.abrlb, fontSize: 12, color: FIGMA.Grn),
        ),
      ),
    );
  }

  void extractNumbers_UI(String input) {
    List<int> result = [];
    RegExp regExp = RegExp(r'([A-L])(\d+)');
    Iterable<RegExpMatch> matches = regExp.allMatches(input);

    for (var match in matches) {
      String number = match.group(2)!;
      result.add(int.parse(number));
    }
    TEST_DATA = "";
    for (var i = 0; i < 12; i++) {
      // debugPrint("letter : $i is ${result[i]}");
      TEST_DATA = "$TEST_DATA $i -> ${result[i]} \n";
    }
    isdeviceon = result[0].toInt() == 1;
    isnooranNet = result[1].toInt() == 1;
    whereami = result[2];
    timeroffvalue = result[3];
    Brightness = result[4];
    maincycle_color = result[5];
    maincycle_mode = result[6];
    maincycle_speed = result[7];
    smartdelaysec = result[8];
    smarttimerpos = result[9];
    smarttimercolor = result[10];
    ESPVersion = result[11];
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
    notifyListeners();
  }
}

/*
db.PowerNooran, 
db.getNetstatus(),
db.whereami, 
db.Timeroffvalue,
db.getBrightness(),
db.getMainCycelMode_color(),
db.getMainCycelMode_mode(),
db.getMainCycelMode_speed(),
db.getSmarttimerdelaysec(), 
db.Smarttimerpos, 
db.getSmarttimerColor1()
*/
