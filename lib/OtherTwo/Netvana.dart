// ignore_for_file: non_constant_identifier_names, file_names

import 'package:easy_container/easy_container.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class Netvana extends StatelessWidget {
  const Netvana({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<ProvData>(
      builder: (context, value, child) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              SizedBox(height: 2),
              EasyContainer(
                  elevation: 0,
                  color: Colors.white,
                  padding: 10,
                  margin: 12,
                  borderRadius: 15,
                  child: WifiTile(
                    isConnected: true,
                    ssid: "UTEL_GM",
                  )),
            ]),
          ),
        );
      },
    ));
  }
}

class WifiTile extends StatefulWidget {
  final bool isConnected;
  final String ssid;

  const WifiTile({
    super.key,
    required this.isConnected,
    required this.ssid,
  });

  @override
  State<WifiTile> createState() => _WifiTileState();
}

class _WifiTileState extends State<WifiTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSignalIcon() {
    return Icon(
      Icons.wifi,
      size: 32,
      color: widget.isConnected ? Colors.green : Colors.red,
    );
  }

  Widget _buildConnectionIcon() {
    return ScaleTransition(
      scale: _animation,
      child: Icon(
        widget.isConnected
            ? Icons.check_circle
            : Icons.radio_button_off_rounded,
        size: 28,
        color: widget.isConnected ? Colors.green : Colors.red.shade500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isConnected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isConnected ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // 🔁 Animated icon (right side)
            _buildConnectionIcon(),
            const SizedBox(width: 16),

            // 📄 SSID & info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ssid,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.isConnected
                        ? "متصل شده به این شبکه"
                        : "دستگاه متصل نیست",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // 📶 Signal icon
            const SizedBox(width: 16),
            _buildSignalIcon(),
          ],
        ),
      ),
    );
  }
}
