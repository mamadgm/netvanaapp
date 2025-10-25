import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'HiveModel.g.dart';

// -------------------- User --------------------
@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String phone;

  // NEW
  @HiveField(5)
  List<EspTheme> themes;

  @override
  String toString() {
    return 'User(phone: $phone, firstName: $firstName, lastName: $lastName)';
  }

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    List<EspTheme>? themes,
  }) : themes = themes ?? [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
    );
  }
}

// -------------------- Sdcard --------------------
@HiveType(typeId: 2)
class Sdcard extends HiveObject {
  @HiveField(0)
  String? token;

  @HiveField(1)
  User? user;

  @HiveField(2)
  int sleepValue;

  Sdcard({this.token, this.user, this.sleepValue = 5});
}

// -------------------- Themes --------------------
@HiveType(typeId: 4)
class ContentItem {
  @HiveField(0)
  int s;

  @HiveField(1)
  int e;

  @HiveField(2)
  int m;

  @HiveField(3)
  int sp;

  // Must be Hive-serializable at runtime (int/double/bool/String/Map/List/null)
  @HiveField(4)
  dynamic c;

  ContentItem({
    required this.s,
    required this.e,
    required this.m,
    required this.sp,
    this.c,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      s: json['s'],
      e: json['e'],
      m: json['m'],
      sp: json['sp'],
      c: json['c'],
    );
  }
}

@HiveType(typeId: 3)
class EspTheme {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<ContentItem> content;

  @HiveField(3)
  String description;

  @HiveField(4)
  String image_url;

  EspTheme({
    required this.id,
    required this.name,
    required this.content,
    required this.description,
    required this.image_url,
  });

  // Computed, not stored
  bool get isColorSingle => content.isNotEmpty && content.first.m == 0;

  factory EspTheme.fromJson(Map<String, dynamic> json) {
    return EspTheme(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image_url: json['image_url'],
      content: (json['content'] as List)
          .map((e) => ContentItem.fromJson(e))
          .toList(),
    );
  }
}
