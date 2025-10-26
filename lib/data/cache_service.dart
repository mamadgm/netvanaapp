
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/const/figma.dart';

class CacheService {
  CacheService._privateConstructor();
  static final CacheService instance = CacheService._privateConstructor();

  late Box _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(FIGMA.HIVE2);
  }

  // Token
  String? get token => _box.get('token');

  Future<void> saveToken(String? token) async {
    if (token == null) {
      await _box.delete('token');
    } else {
      await _box.put('token', token);
    }
  }

  // Sleep Value
  int get sleepValue => _box.get('sleepValue', defaultValue: 5);

  Future<void> saveSleepValue(int value) async {
    await _box.put('sleepValue', value);
  }

  // Favorites
  List<int> get favorites => List<int>.from(_box.get('Favorites', defaultValue: <int>[]));

  Future<void> saveFavorites(List<int> favs) async {
    await _box.put('Favorites', favs);
  }

  // Timeofdie
  String get timeofdie => _box.get('Timeofdie', defaultValue: '00:00');

  Future<void> saveTimeofdie(String value) async {
    await _box.put('Timeofdie', value);
  }
}
