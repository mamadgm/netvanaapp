// ignore_for_file: non_constant_identifier_names, file_names

import 'package:easy_container/easy_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/ButtonIcon.dart';
import 'package:netvana/customwidgets/cylander.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

class Netvana extends StatelessWidget {
  const Netvana({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<ProvData>(
      builder: (context, value, child) {
        return Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      height: 300.h,
                      width: 140.w,
                      child: LampWidget(
                        glowIntensity: 1,
                        lampColor:
                            (!value.nextmoveisconnect | value.isConnectedWifi)
                                ? colorFromString(value.maincycle_color)
                                : colorFromString("0xFF555555"),
                        height: 150.h,
                        width: 80.w,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: EasyContainer(
                  borderRadius: 40,
                  elevation: 0,
                  margin: 0,
                  padding: 15,
                  color: FIGMA.Back,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      WiFiItem(
                        leadingIcon: Icons.arrow_back_ios_new_rounded,
                        title: "وای فای جدید",
                        trailingIcon: LucideIcons.plus,
                        onTap: () {
                          showWiFiDialog(context);
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EasyContainer(
                  height: 60.h,
                  showBorder: true,
                  borderColor: FIGMA.Gray2,
                  color: FIGMA.Gray,
                  customPadding: const EdgeInsets.symmetric(horizontal: 8),
                  elevation: 0,
                  shadowColor: FIGMA.Gray2,
                  borderWidth: 3,
                  borderRadius: 30,
                  child: Row(
                    children: [
                      Text(
                        "Wifi:",
                        style: TextStyle(
                            color: FIGMA.Gray4,
                            fontFamily: FIGMA.estre,
                            fontSize: 13.sp),
                      ),
                      Text(
                        value.Device_SSID,
                        style: TextStyle(
                            color: FIGMA.Wrn,
                            fontFamily: FIGMA.estsb,
                            fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
                EasyContainer(
                  height: 60.h,
                  width: 148.w,
                  showBorder: true,
                  borderColor: FIGMA.Gray2,
                  color: FIGMA.Gray,
                  padding: 16,
                  elevation: 5,
                  shadowColor: FIGMA.Gray2,
                  borderWidth: 3,
                  borderRadius: 30,
                  child: Row(
                    children: [
                      Text(
                        "عالی",
                        style: TextStyle(
                            color: FIGMA.Prn2,
                            fontFamily: FIGMA.estsb,
                            fontSize: 13.sp),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ":وضعیت اتصال",
                        style: TextStyle(
                            color: FIGMA.Gray4,
                            fontFamily: FIGMA.estre,
                            fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]);
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
                    style: TextStyle(
                      fontSize: 18.sp,
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
                      fontSize: 14.sp,
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
