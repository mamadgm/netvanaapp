import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/models/HiveModel.dart';

class SdcardService {
  SdcardService._privateConstructor();
  static final SdcardService instance = SdcardService._privateConstructor();

  late Box<Sdcard> _box;
  late Sdcard sdcard;

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(DeviceAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(SdcardAdapter());
    Hive.registerAdapter(EspThemeAdapter());
    Hive.registerAdapter(ContentItemAdapter());

    _box = await Hive.openBox<Sdcard>(FIGMA.HIVE1);
    await Hive.openBox(FIGMA.HIVE2);

    // Load existing Sdcard or create new
    if (_box.isNotEmpty) {
      sdcard = _box.getAt(0)!;
      sdcard.user?.themes = sdcard.user?.themes ?? [];
    } else {
      sdcard = Sdcard();
      await _box.add(sdcard);
    }
  }

  String? get token => sdcard.token;
  User? get user => sdcard.user;
  List<Device> get products => sdcard.user?.devices ?? [];

  Device? get firstDevice =>
      sdcard.user?.devices.isNotEmpty == true ? sdcard.user!.devices[0] : null;

  Future<void> updateUser(String token) async {
    final fetchedUser = await NetClass().getUser(token);
    if (fetchedUser != null) {
      // preserve existing cached themes
      final existingThemes = sdcard.user?.themes ?? [];
      fetchedUser.themes = existingThemes;

      sdcard.user = fetchedUser;
      sdcard.token = token;

      debugPrint("Fetched User is Now \n ${sdcard.user!.toString()}");
      await sdcard.save();
    }
  }
}
// THEMES

extension ThemeHelpers on SdcardService {
  List<EspTheme> get cachedThemes => sdcard.user?.themes ?? [];

  EspTheme? getThemeById(int id) {
    try {
      return cachedThemes.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<EspTheme>> refreshThemes() async {
    if (sdcard.user == null || token == null) {
      debugPrint("No user/token; cannot refresh themes.");
      return cachedThemes;
    }

    try {
      final res = await NetClass().getThemes(token!);

      final themes = (res).map((e) => EspTheme.fromJson(e)).toList();

      // cache into user
      sdcard.user!.themes = themes;
      await sdcard.save(); // persists nested user graph

      return themes;
    } catch (e) {
      debugPrint("Error fetching themes (using cache): $e");
      return cachedThemes;
    }
  }

  Future<void> clearCachedThemes() async {
    if (sdcard.user == null) return;
    sdcard.user!.themes = [];
    await sdcard.save();
  }
}
