import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ESP32 Bluetooth',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BluetoothHome(),
      );
}

class BluetoothHome extends StatefulWidget {
  @override
  _BluetoothHomeState createState() => _BluetoothHomeState();
}

class _BluetoothHomeState extends State<BluetoothHome> {
  BluetoothConnection? connection;
  String log = '';
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToESP32();
  }

  Future<void> _connectToESP32() async {
    try {
      List<BluetoothDevice> devices =
          await FlutterBluetoothSerial.instance.getBondedDevices();

      final espDevice = devices.firstWhere((d) => d.name == 'ESP32_BT',
          orElse: () => throw 'ESP32_BT not paired');

      BluetoothConnection.toAddress(espDevice.address).then((_connection) {
        connection = _connection;
        setState(() => isConnected = true);
        _addLog('Connected to ${espDevice.name}');

        connection!.input!.listen((Uint8List data) {
          String received = utf8.decode(data);
          _addLog('ESP32: $received');
        }).onDone(() {
          _addLog('Connection closed by ESP32');
          setState(() => isConnected = false);
        });
      });
    } catch (e) {
      _addLog('Error: $e');
    }
  }

  void _sendMessage(String message) {
    if (connection != null && isConnected) {
      connection!.output.add(utf8.encode('$message\n'));
      _addLog('Me: $message');
    }
  }

  void _addLog(String message) {
    setState(() {
      log = '$message\n$log';
    });
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('ESP32 Bluetooth')),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: isConnected
                  ? () => _sendMessage("Hello from Flutter!")
                  : null,
              child: Text("Send Message"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Logs:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Text(log),
              ),
            ),
          ],
        ),
      );
}
