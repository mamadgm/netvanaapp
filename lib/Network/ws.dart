import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NetvanaWS {
  WebSocketChannel? _channel;

  void connect(String token, ProvData provData) {
    final uri = Uri.parse('wss://api.netvana.ir/devices/up');

    try {
      _channel = WebSocketChannel.connect(uri);
      send({"token": token, "type": "auth"});

      _channel!.stream.listen(
        (message) {
          debugPrint('$message');
          final decoded = jsonDecode(message);
          provData.Set_Screen_Values_From_JSON(decoded);
        },
        onError: (error) => debugPrint('WebSocket Error: $error'),
        onDone: () => debugPrint('WebSocket closed'),
      );
    } catch (e) {
      debugPrint('WebSocket connect failed: $e');
    }
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
