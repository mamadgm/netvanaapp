// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:flutter/material.dart';
import 'package:netvana/const/themes.dart';
import 'package:universal_ble/universal_ble.dart';

enum ThemeFilter { liked, single, multiple, none }

class ProvData extends ChangeNotifier {
  //App
  String Device_UUID = "null";
  String Device_NAME = "null";
  String Device_SSID = "null";
  bool Isdevicefound = false;
  int Current_screen = 0;

  List<Duration> SmartTimerTime = [
    const Duration(minutes: 5),
    const Duration(minutes: 30),
    const Duration(minutes: 60)
  ];
  List<Duration> Remaining = [
    const Duration(minutes: 5),
    const Duration(minutes: 30),
    const Duration(minutes: 60)
  ];
  List<String> SmartTimerColor = ["0xFFFF00FF", "0xFFFFFF00", "0xFFFFFF00"];
  List<String> SmartTimerTitle = ["تایمر هوشمند", "پومودورو", "تایمر طولانی"];
  List<bool> SmarttimerActive = [false, false, false];

  List<int> Favorites = [];
  //netvana

  List<EspTheme> themes = [];

  bool nextmoveisconnect = true;
  int current_sync_pos = 0;
  int current_selected_slider = 0;
  List<BleDevice> mynetvanaDevices = <BleDevice>[];
  bool isConnected = false;
  bool isConnectedWifi = false;
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
  String maincycle_color = "0xFFFFFF00";
  int maincycle_mode = 0;
  int maincycle_speed = 0;
  int smartdelaysec = 0;
  int smarttimerpos = 0;
  int smarttimercolor = 0;
  bool issmarttimerpaused = true;
  int ESPVersion = 10;
  List<int> Defalult_colors = [0xFF0000, 1900288, 0x0000FF, 0xFFFFFF, 0x00A594];
  //Loggin
  String name_last = 'mamad';
  String phone_number = "ss";
  String token = "empty";
  String DeviceBleName = "";
  List Products = [];
  //Test
  String TEST_DATA = "EMPTY";
  //Smarttimer

  ThemeFilter selectedFilter = ThemeFilter.none;

  bool isUserLoggedIn = false;

  void setIsUserLoggedIn(bool p, {bool update = false}) {
    isUserLoggedIn = p;
  }

  void toggleFilter(ThemeFilter filter) {
    if (selectedFilter == filter) {
      selectedFilter = ThemeFilter.none; // اگر دوباره زدن، فیلتر رو غیرفعال کن
    } else {
      selectedFilter = filter;
    }
    notifyListeners(); // حتماً این رو بذار تا ویجت‌ها رفرش بشن
  }

  void loadFavoritesFromHive() {
    final box = Hive.box(FIGMA.HIVE);
    final stored = box.get('Favorites', defaultValue: []);
    Favorites = List<int>.from(stored);
  }

  void setSmartTimerMinSec(int index, int hour, int minute, String color,
      {bool update = false}) {
    final duration = Duration(hours: hour, minutes: minute);

    if (index >= SmartTimerTime.length) return;

    SmartTimerTime[index] = duration;
    Remaining[index] = duration;
    SmartTimerColor[index] = color;

    if (update) {
      final box = Hive.box(FIGMA.HIVE);

      // Combine all values into a list of maps
      final timers = List.generate(
          SmartTimerTime.length,
          (i) => {
                "time": SmartTimerTime[i].inSeconds,
                "remaining": Remaining[i].inSeconds,
                "color": SmartTimerColor[i],
              });

      box.put("timers", timers);

      notifyListeners();
    }
  }

  disable_Smarttimer(int index, {bool value = false}) {
    SmarttimerActive[index] = value;
    notifyListeners();
  }

  are_all_false() {
    for (var i = 0; i < SmartTimerTime.length; i++) {
      if (SmarttimerActive[i]) {
        // debugPrint("FALSE $i");
        return false;
      }
    }
    return true;
  }

  Future<void> loadTimersFromHive() async {
    final box = Hive.box(FIGMA.HIVE);
    final stored = box.get("timers");

    SmartTimerTime = [];
    Remaining = [];
    SmartTimerColor = [];

    if (stored != null && stored is List) {
      for (var item in stored) {
        if (item is Map) {
          SmartTimerTime.add(Duration(seconds: item["time"] ?? 300));
          Remaining.add(Duration(seconds: item["remaining"] ?? 300));
          SmartTimerColor.add(item["color"] ?? "0xFFFFFFFF");
        }
      }
    } else {
      // fallback default values
      SmartTimerTime = List.generate(3, (_) => const Duration(seconds: 300));
      Remaining = List.from(SmartTimerTime);
      SmartTimerColor = List.generate(3, (_) => "0xFFFFFFFF");
    }
  }

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
  }

  void setIsDeviceOn(bool value) {
    isdeviceon = value;
    notifyListeners();
  }

  void Set_Userdetails(String phone, String Name, String Last, String Token) {
    name_last = "$Name $Last";
    phone_number = phone;
    token = Token;
    // notifyListeners();
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
    lampKey.currentState?.shake();
    Brightness = value;
    notifyListeners();
  }

  void setMainCycleColor(String value) {
    lampKey.currentState?.shake();
    maincycle_color = value;
    notifyListeners();
  }

  void setMainCycleMode(int value) {
    lampKey.currentState?.shake();
    maincycle_mode = value;
    notifyListeners();
  }

  void setMainCycleSpeed(int value) {
    maincycle_speed = value;
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

  void ble_update_connected(bool p) {
    isConnected = p;
    notifyListeners();
  }

  void wifi_update_connected(bool p) {
    isConnectedWifi = p;
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

  void Change_current_screen(int input) {
    Current_screen = input;
    notifyListeners();
  }

  void Show_Snackbar(String value, int dur) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: FIGMA.Gray2,
        duration: Duration(milliseconds: dur),
        content: Text(
          value,
          textAlign: TextAlign.end,
          style: TextStyle(
              fontFamily: FIGMA.abrlb, fontSize: 14.sp, color: FIGMA.Wrn),
        ),
      ),
    );
  }

  Future<void> fetchThemes() async {
    try {
      final res = await NetClass().getThemes(token);
      // res یک List<dynamic> هست

      themes = res.map((e) => EspTheme.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching themes: $e");
    }
  }

  final SingleBle singleble = SingleBle.instance; // Use the singleton instance

  void Set_Screen_Values(String input) {
    debugPrint("Received encoded string: $input");

    // Parse numeric fields (A to L)
    List<int> result = [];
    RegExp regExp = RegExp(r'([A-L])(\d+)');
    Iterable<RegExpMatch> matches = regExp.allMatches(input);

    for (var match in matches) {
      String number = match.group(2)!;
      result.add(int.parse(number));
    }

    // Parse device name (M field)
    String deviceName = "Unknown";
    RegExp nameRegExp = RegExp(r'M([A-Za-z0-9_-]+)');
    var nameMatch = nameRegExp.firstMatch(input);
    if (nameMatch != null) {
      deviceName = nameMatch.group(1)!;
      debugPrint("Parsed device name: $deviceName");
    } else {
      debugPrint("No device name found in input string");
    }

    // Assign values
    TEST_DATA = "";
    for (var i = 0; i < result.length; i++) {
      TEST_DATA = "$TEST_DATA $i -> ${result[i]} \n";
    }

    // Ensure result has enough values to avoid index errors
    isdeviceon = result.length > 0 ? result[0] == 1 : false;
    isnooranNet = result.length > 1 ? result[1] == 1 : false;
    whereami = result.length > 2 ? result[2] : 0;
    timeroffvalue = result.length > 3 ? result[3] : 0;
    Brightness = result.length > 4 ? result[4] : 0;
    maincycle_color = result.length > 5 ? result[5].toString() : "";
    maincycle_mode = result.length > 6 ? result[6] : 0;
    maincycle_speed = result.length > 7 ? result[7] : 0;
    smartdelaysec = result.length > 8 ? result[8] : 0;
    smarttimerpos = result.length > 9 ? result[9] : 0;
    smarttimercolor = result.length > 10 ? result[10] : 0;
    ESPVersion = result.length > 11 ? result[11] : 0;
    DeviceBleName = deviceName; // Store the parsed device name
    notifyListeners();
    if (deviceName !=
        "${Products[0]["category_name"] + "-" + Products[0]["part_number"].toString()}") {
      SingleBle().disconnect();
      return;
    }
  }

  void Set_Screen_Values_From_JSON(Map<String, dynamic>? jsonResponse) {
    if (jsonResponse == null || jsonResponse['data'] == null) {
      debugPrint("Invalid or null JSON response");
      return;
    }

    final data = jsonResponse['data'];

    // Assign values from JSON, providing defaults if fields are missing
    isdeviceon = data['power'] as bool? ?? false;
    isnooranNet = false; // Not present in JSON, set to default
    whereami = 0; // Not present in JSON, set to default
    timeroffvalue = data['timeroff'] as int? ?? 0;
    Brightness = data['bright'] as int? ?? 0;
    maincycle_color = (data['color'] as int? ?? 0).toString();
    maincycle_mode = data['theme'] != null
        ? (jsonDecode(data['theme']) as List<dynamic>).isNotEmpty
            ? jsonDecode(data['theme'])[0]['m'] as int? ?? 0
            : 0
        : 0; // Parse theme string and extract 'm'
    maincycle_speed = data['speed'] as int? ?? 0;
    smartdelaysec = 0; // Not present in JSON, set to default
    smarttimerpos = 0; // Not present in JSON, set to default
    smarttimercolor = 0; // Not present in JSON, set to default
    Device_SSID = data['ssid'] as String;
    ESPVersion = int.tryParse(data['version'] as String? ?? '0') ?? 0;

    debugPrint("device mode $maincycle_mode");
    debugPrint("device color $maincycle_color");

    notifyListeners();
  }

  Future<void> getDetailsFromNet() async {
    try {
      var result = await NetClass()
          .getDeviceVariables(token, Products[0]["id"].toString());
      Set_Screen_Values_From_JSON(result);
    } catch (e) {
      debugPrint("Error in vars $e");
    }
  }

  void hand_update() {
    notifyListeners();
  }

  Color StringToColor(String input) {
    // debugPrint("input : $input");
    try {
      // Strip "0x" if present
      input = input.trim().replaceAll("0x", "");

      // Parse hex string as int
      int temp = int.parse(input, radix: 16);

      // Ensure color is ARGB by forcing full opacity if not specified
      if (input.length <= 6) {
        temp |= 0xFF000000;
      }

      // debugPrint("temp : $temp");
      return Color(temp);
    } catch (e) {
      debugPrint("Invalid color string: $input");
      return Colors.red;
    }
  }
}
