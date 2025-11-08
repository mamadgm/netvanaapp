import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as ws_status;
import 'dart:js' as js;

class NetvanaWS {
  // --- Singleton setup ---
  NetvanaWS._internal();
  static final NetvanaWS _instance = NetvanaWS._internal();
  factory NetvanaWS() => _instance;

  // --- Internal State ---
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  String? _token;
  ProvData? _provData;

  // --- Public helpers ---
  bool get isConnected => _channel != null;
  WSStatus get status => _provData?.wsChannel ?? WSStatus.disconnected;

  // --- Connect (entry point) ---
  void connect(String token, ProvData provData) {
    _closeExistingBrowserWebSockets(); // 👈 Add this line first

    _token = token;
    _provData = provData;

    if (_isConnecting || _channel != null) {
      debugPrint('WS: Already connected or connecting');
      return;
    }

    _createConnection();
  }

  void _createConnection() {
    if (_token == null || _provData == null) return;

    final prov = _provData!;
    final token = _token!;

    _isConnecting = true;
    prov.setWsChannel(WSStatus.connecting);

    debugPrint('WS: Connecting...');
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://api.netvana.ir/devices/up'),
      );

      // Send auth once connected
      _channel!.sink.add(jsonEncode({"token": token, "type": "auth"}));
      prov.setWsChannel(WSStatus.connected);
      _isConnecting = false;
      debugPrint('WS: Connected and authenticated');

      _subscription = _channel!.stream.listen(
        (message) => _onMessage(message, prov),
        onError: (error) => _onError(error, prov),
        onDone: () => _onDone(prov),
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('WS: Exception while connecting $e');
      _onError(e, prov);
    }
  }

  void _onMessage(dynamic message, ProvData prov) {
    // debugPrint('WS ⇢ $message');
    try {
      final decoded = jsonDecode(message);
      if (!decoded.containsKey('is_online')) {
        prov.Set_Screen_Values_From_JSON(decoded);
      } else {
        prov.selectedDevice.isOnline = decoded["is_online"] as bool;
        prov.hand_update();
      }
    } catch (e) {
      debugPrint('WS: Error decoding message $e');
    }
  }

  void _onError(Object error, ProvData prov) {
    debugPrint('WS: Error $error');
    prov.setWsChannel(WSStatus.error);
    _scheduleReconnect();
  }

  void _onDone(ProvData prov) {
    debugPrint('WS: Connection closed');
    prov.setWsChannel(WSStatus.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _disposeChannel();

    if (_reconnectTimer?.isActive ?? false) return;
    debugPrint('WS: Reconnecting in 5s...');
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      _reconnectTimer = null;
      _createConnection();
    });
  }

  void send(Map<String, dynamic> data) {
    try {
      _channel?.sink.add(jsonEncode(data));
    } catch (e) {
      debugPrint('WS: Send failed $e');
    }
  }

  void disconnect() {
    debugPrint('WS: Manual disconnect');
    _disposeChannel();
    _reconnectTimer?.cancel();
  }

  void _disposeChannel() {
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close(ws_status.normalClosure);
    _channel = null;
    _isConnecting = false;
  }

  void _closeExistingBrowserWebSockets() {
    try {
      js.context.callMethod('eval', [
        """
      (function() {
        if (!window._nv_ws_list) window._nv_ws_list = [];
        for (let ws of window._nv_ws_list) {
          try { ws.close(); } catch (e) {}
        }
        window._nv_ws_list = [];
        console.log('[NetvanaWS] Existing WebSockets closed');
      })();
    """
      ]);
    } catch (e) {
      debugPrint('JS WebSocket cleanup failed: $e');
    }
  }
}

// Global instance
final ws = NetvanaWS();
