import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'HiveModel.g.dart';

// -------------------- Device --------------------
@HiveType(typeId: 0)
class Device extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String macAddress;

  @HiveField(2)
  int partNumber;

  @HiveField(3)
  bool isOnline;

  @HiveField(4)
  DateTime assembledAt;

  @HiveField(5)
  String categoryName;

  @HiveField(6)
  String? weatherCity;

  @HiveField(7)
  String versionName;

  Device({
    required this.id,
    required this.macAddress,
    required this.partNumber,
    required this.isOnline,
    required this.assembledAt,
    required this.categoryName,
    this.weatherCity,
    required this.versionName,
  });

  @override
  String toString() {
    return 'Device(id: $id, name: $partNumber, type: $categoryName , online: $isOnline)';
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      macAddress: json['mac_address'],
      partNumber: json['part_number'],
      isOnline: json['is_online'],
      assembledAt: DateTime.parse(json['assembled_at']),
      categoryName: json['category_name'],
      weatherCity: json['weather_city'],
      versionName: json['version_name'],
    );
  }
}

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

  @HiveField(4)
  List<Device> devices;

  @override
  String toString() {
    return 'User(phone: $phone, firstName: $firstName, lastName: $lastName, devices: $devices)';
  }

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    List<Device>? devices,
  }) : devices = devices ?? [];

  factory User.fromJson(Map<String, dynamic> json) {
    var devicesJson = json['devices'] as List<dynamic>? ?? [];
    List<Device> devicesList =
        devicesJson.map((d) => Device.fromJson(d)).toList();

    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      devices: devicesList,
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

  Sdcard({
    this.token,
    this.user,
  });
}

extension SdcardHelpers on Sdcard {
  Device? get firstDevice =>
      user?.devices.isNotEmpty == true ? user!.devices[0] : null;
}
