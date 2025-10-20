import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:netvana/const/figma.dart';
import 'package:netvana/models/HiveModel.dart';

class NetClass {
  static final NetClass _instance = NetClass._internal();
  NetClass._internal();

  factory NetClass() {
    return _instance;
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    var body = <String, String>{
      'username': email,
      'password': password,
    };

    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/auth/token'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body, // DO NOT jsonEncode this
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>?> sendOtp(String phone) async {
    var body = <String, String>{
      'phone_number': phone,
    };

    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/ownership/otp/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<User?> getUser(String token) async {
    final response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json);
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> setColor(
      String token, String id, String color) async {
    var response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/user/theme/$id/color/$color'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send color: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> setBright(
      String token, String id, String bright) async {
    var response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/user/theme/$id/brightness/$bright'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send color: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> setSpeed(
      String token, String id, String speed) async {
    var response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/user/theme/$id/speed/$speed'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send color: ${response.body}');
    }
  }

  Future<List<dynamic>> getThemes(String token) async {
    final response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/user/theme/?last_id=0&limit=30'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // اینجا لیست برمیگرده
    } else {
      throw Exception('Failed to load themes: ${response.body}');
    }
  }

  Future<void> setMode(String token, String id, String mode) async {
    final url = Uri.parse("${FIGMA.urlnetwana}/user/theme/set/");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // If your API requires auth
    };

    final body = jsonEncode({
      "theme_id": mode,
      "device_id": id,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        debugPrint("Theme 200");
      } else {
        debugPrint(
            "Failed to set theme: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("Error setting theme: $e");
    }
  }

  Future<void> editUserName(String token, String newusername) async {
    final url = Uri.parse("${FIGMA.urlnetwana}/update");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // If your API requires auth
    };

    final body = jsonEncode({
      "username": newusername,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        debugPrint("Data Updated successfully: ${response.body}");
      } else {
        debugPrint(
            "Failed to update: ${response.statusCode} - ${response.body}");
        throw Exception();
      }
    } catch (e) {
      debugPrint("Error setting Data: $e");
      throw Exception();
    }
  }

  Future<Map<String, dynamic>?> setPower(
      String token, String id, int power) async {
    var response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/user/theme/$id/power/$power'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send color: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> setTimer(
      String token, String id, int timer) async {
    var response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/user/theme/$id/power-timer/$timer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send color: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> getDeviceVariables(
      String token, String deviceId) async {
    try {
      var response = await http.get(
        Uri.parse('${FIGMA.urlnetwana}/devices/$deviceId/variables/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        return responseData;
      } else {
        throw Exception('Failed to get device variables: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching device variables: $e');
      return null;
    }
  }
}
