import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/BLE/screens/products/nooran/sliders/sliders.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

class CircleTimerWidget extends StatefulWidget {
  const CircleTimerWidget({super.key});

  @override
  State<CircleTimerWidget> createState() => _CircleTimerWidgetState();
}

class _CircleTimerWidgetState extends State<CircleTimerWidget> {
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    final value = Provider.of<ProvData>(context, listen: false);
    super.initState();
    value.Remaining = value.SmartTimerTime;
  }

  bool _wasPaused = false;

  void _startPause() {
    final value = Provider.of<ProvData>(context, listen: false);

    if (_isRunning) {
      // Pause
      _timer?.cancel();
      setState(() {
        _isRunning = false;
        _wasPaused = true;
      });
      debugPrint("Paused");
      String jsonPayload = jsonEncode({"Cs": 2});
      SingleBle().sendMain(jsonPayload);
    } else {
      // Resume or Start
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          if (value.Remaining > Duration.zero) {
            value.Remaining -= const Duration(seconds: 1);
          } else {
            _timer?.cancel();
            _isRunning = false;
          }
        });
      });

      setState(() {
        _isRunning = true;

        if (_wasPaused) {
          debugPrint("Resumed");
          String jsonPayload = jsonEncode({"Cs": 3});
          SingleBle().sendMain(jsonPayload);
        } else {
          String jsonPayload = jsonEncode({
            "Cs": 4,
            "Ss": value.SmartTimerTime.inSeconds,
            "Sc": value.SmartTimerColor
          });
          SingleBle().sendMain(jsonPayload);
          debugPrint("Started");
        }

        _wasPaused = false; // Reset the flag after resuming
      });
    }
  }

  void _reset() {
    final value = Provider.of<ProvData>(context, listen: false);
    _timer?.cancel();
    setState(() {
      value.Remaining = value.SmartTimerTime;
      _isRunning = false;
      _wasPaused = false; // Clear the resume state
    });
    debugPrint("Reset");
    String jsonPayload = jsonEncode({"Cs": 1});
    SingleBle().sendMain(jsonPayload);
  }

  void _openSettings() async {
    final value = Provider.of<ProvData>(context, listen: false);
    final newDuration = await showDialog<Duration>(
      context: context,
      builder: (_) => _SettingsDialog(current: value.SmartTimerTime),
    );
    if (newDuration != null) {
      setState(() {
        value.SmartTimerTime = newDuration;
        value.Remaining = newDuration;
        _isRunning = false;
      });
      debugPrint("Settings Updated");
    }
  }

  String _formatTime(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(builder: (context, value, child) {
      double progress =
          (value.Remaining.inSeconds / value.SmartTimerTime.inSeconds)
              .clamp(0.0, 1.0);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("زمان تمرکز",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: FIGMA.estre,
                          color: Colors.black38)),
                  const SizedBox(height: 10),
                  Text(_formatTime(value.Remaining),
                      style: const TextStyle(
                          fontSize: 48, fontFamily: FIGMA.abreb)),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EasyContainer(
                          width: 80,
                          height: 80,
                          padding: 0,
                          elevation: 0,
                          margin: 3,
                          color: Colors.white,
                          borderWidth: 1,
                          borderColor: Colors.black12,
                          showBorder: true,
                          borderRadius: 15,
                          onTap: _reset,
                          child: const Icon(
                            Icons.refresh,
                            size: 36,
                          )),
                      EasyContainer(
                          width: 80,
                          height: 80,
                          padding: 0,
                          elevation: 0,
                          margin: 3,
                          color: Colors.white,
                          borderWidth: 1,
                          borderColor: Colors.black12,
                          showBorder: true,
                          borderRadius: 15,
                          onTap: _openSettings,
                          child: const Icon(
                            Icons.settings,
                            size: 36,
                          )),
                    ],
                  ),
                ],
              ),
              EasyContainer(
                padding: 8,
                margin: 0,
                elevation: 0,
                color: Colors.blue[50],
                width: 210,
                height: 210,
                borderRadius: 15,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(210, 210),
                      painter: CirclePainter(progress),
                    ),
                    EasyContainer(
                      width: 75,
                      height: 75,
                      padding: 0,
                      elevation: 0,
                      margin: 0,
                      color: Colors.white,
                      borderRadius: 100,
                      onTap: _startPause,
                      child: Center(
                          child: Icon(
                        _isRunning ? Icons.pause : Icons.play_arrow,
                        size: 48,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 15.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Base arc with rounded caps
    final basePaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - 0.8;
    // Progress arc (grey)
    final progressPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final startAngle = -pi / 2;

    // Draw base arc (almost full circle to show caps)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * pi - 0.01, // just under full circle
      false,
      basePaint,
    );

    // Draw progress arc on top
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _SettingsDialog extends StatefulWidget {
  final Duration current;

  const _SettingsDialog({required this.current});

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog> {
  late int hours;
  late int minutes;
  String selectedColor = "0xFFFFFFFF";

  @override
  void initState() {
    final value = Provider.of<ProvData>(context, listen: false);

    super.initState();
    hours = value.SmartTimerTime.inHours;
    minutes = value.SmartTimerTime.inMinutes % 60;

    if (hours == 0 && minutes < 2) minutes = 2;
  }

  bool get isValidDuration {
    final totalSeconds = (hours * 60 + minutes) * 60;
    return totalSeconds >= 120;
  }

  TextStyle myStyle = const TextStyle(fontFamily: FIGMA.abreb, fontSize: 48);
  @override
  Widget build(BuildContext context) {
    final value = Provider.of<ProvData>(context, listen: false);
    return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.80,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EasyContainer(
                  color: Colors.white,
                  showBorder: true,
                  elevation: 0,
                  padding: 18,
                  margin: 0,
                  borderRadius: 15,
                  borderColor: Colors.black12,
                  child: const Center(
                      child: Icon(
                    Icons.close_rounded,
                    size: 48,
                    color: Colors.black38,
                  )),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Text(
                  "تایمر",
                  style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 32),
                ),
                EasyContainer(
                  color: Colors.white,
                  showBorder: true,
                  elevation: 0,
                  padding: 18,
                  margin: 0,
                  borderRadius: 15,
                  borderColor: Colors.black12,
                  child: const Center(
                      child: Icon(
                    Icons.check_rounded,
                    size: 48,
                    color: FIGMA.Prn,
                  )),
                  onTap: () {
                    value.set_SmartTimerMinSec(hours, minutes, update: true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.60, // enough for smooth scroll
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour picker
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent:
                          100, // increase this to match total height (text + spacing)
                      scrollController:
                          FixedExtentScrollController(initialItem: hours),

                      onSelectedItemChanged: (value) {
                        setState(() => hours = value);
                      },
                      children: List.generate(
                          3,
                          (i) => Center(
                                  child: Text(
                                '$i',
                                style: myStyle,
                              ))),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Minute picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController:
                          FixedExtentScrollController(initialItem: minutes),
                      itemExtent: 100,
                      onSelectedItemChanged: (value) {
                        setState(() => minutes = value);
                      },
                      children: List.generate(
                          60,
                          (i) => Center(
                                  child: Text(
                                '$i',
                                style: myStyle,
                              ))),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: GetGoodW(context, 329, 70).height,
              child: Color_Picker_HSV(
                senddata: (p0) {
                  selectedColor = p0;
                  value.set_SmartTimerColor(p0);
                },
                color: selectedColor,
                netvana: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
