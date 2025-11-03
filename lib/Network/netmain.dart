import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/provMain.dart';

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
    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/ownership/otp/send/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"phone_number": phone}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>?> checkOtp(String phone, String otp) async {
    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/ownership/otp/check/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"phone_number": phone, "otp_code": otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>?> signUp(String token, String first, String last,
      String birth, String user, String pass1, String pass2) async {
    //         "birth_dt": "2025-10-20T10:11:14.973Z",
    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/ownership/complete-user-profile/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "first_name": first,
        "last_name": last,
        "birth_dt": birth,
        "username": user,
        "password": pass1,
        "password_conf": pass2
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>?> registerDevice(
      String token, String code) async {
    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/ownership/set/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "transfer_code": code,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>?> getUser(String token) async {
    final response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
/*
  {
  "id": 2,
  "first_name": "محمدعلی",
  "last_name": "گلمکانی",
  "phone": "09016888626",
  "username": "mamadgm",
  "partner_message": [],
  "devices": []
}

OR

{
  "id": 0,
  "first_name": "string",
  "last_name": "string",
  "phone": "string",
  "username": "string",
  "partner_message": [
    "string"
  ],
  "devices": [
    {
      "id": 0,
      "mac_address": "string",
      "part_number": 0,
      "is_online": true,
      "assembled_at": "2025-10-26T07:03:48.719Z",
      "category_name": "string",
      "weather_city": "string",
      "version_name": "string"
    }
  ]
}
*/
      final json = jsonDecode(response.body);
      return json;
    } else {
      throw Exception('Failed to fetch user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> setColor(
      String token, String id, String color, ProvData value) async {
    await value.checkTheme();
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
        // debugPrint("Theme 200");
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
  // /user/theme/{device_id}/fap/

  Future<Map<String, dynamic>?> setDeviceOffline(
      String token, String id) async {
    var response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/user/theme/$id/fap/'),
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
