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
    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>?> getProducts(String token) async {
    var response = await http.post(
      Uri.parse('${FIGMA.urlnetwana}/api/get_products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}), // Empty body
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch products');
    }
  }
}
