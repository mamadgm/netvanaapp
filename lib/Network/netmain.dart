import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:netvana/const/figma.dart';

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

  Future<Map<String, dynamic>?> reset_password(
      String email, String password, String token) async {
    var body = <String, String>{
      'phone': email,
      'new_password': password,
    };

    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/admin/reset-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>?> getProducts(String token) async {
    var response = await http.get(
      Uri.parse('${FIGMA.urlnetwana}/me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch products: ${response.body}');
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
}
