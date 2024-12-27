import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:easy_container/easy_container.dart';
import 'package:provider/provider.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';

class SmartTimer extends StatefulWidget {
  const SmartTimer({super.key, required this.start, required this.stop});

  final Function start;
  final Function stop;

  @override
  _SmartTimerState createState() => _SmartTimerState();
}

class _SmartTimerState extends State<SmartTimer> {
  late StopWatchTimer _stopWatchTimer;
  late int totalSeconds;
  bool isStopped = true;
  @override
  void initState() {
    super.initState();
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
    );

    final funcy = context.read<ProvData>();
    totalSeconds = funcy.smartdelaysec * 15;
    _stopWatchTimer.setPresetTime(mSec: totalSeconds * 1000);

    _stopWatchTimer.fetchEnded.listen((value) {
      setState(() {
        isStopped = value;
        debugPrint("isstoped $isStopped");
        _stopWatchTimer.onResetTimer();
        funcy.setSmartTimerPaused(true);
        isStopped = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
      builder: (context, value, child) {
        int newTotalSeconds = value.smartdelaysec * 15;
        if (value.issmarttimerpaused && isStopped) {
          debugPrint("UPDATING");
          totalSeconds = newTotalSeconds;
          _stopWatchTimer.clearPresetTime();
          _stopWatchTimer.onResetTimer();
          _stopWatchTimer.setPresetTime(mSec: totalSeconds * 1000);
        }

        int hours = totalSeconds ~/ 3600;
        int minutes = (totalSeconds % 3600) ~/ 60;
        int seconds = totalSeconds % 60;

        String formattedTime =
            "${hours}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

        return EasyContainer(
          borderWidth: 0,
          elevation: 0,
          margin: 1,
          padding: 0,
          borderRadius: 15,
          color: FIGMA.Back,
          child: Column(
            children: [
              StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
                builder: (context, snapshot) {
                  final value = snapshot.data!;
                  final displayTime = StopWatchTimer.getDisplayTime(value,
                      hours: true,
                      minute: true,
                      second: true,
                      milliSecond: false);
                  return Text(
                    displayTime,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: FIGMA.abreb,
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      _stopWatchTimer.onResetTimer();
                      value.setSmartTimerPaused(true);
                      isStopped = true;
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 36,
                      color: FIGMA.Orn,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (value.issmarttimerpaused) {
                        _stopWatchTimer.onStartTimer();
                        isStopped = false;
                        widget.start();
                      } else {
                        _stopWatchTimer.onStopTimer();
                      }
                      value.setSmartTimerPaused(!value.issmarttimerpaused);
                    },
                    icon: Icon(
                      value.issmarttimerpaused
                          ? Icons.play_circle_rounded
                          : Icons.stop_circle_rounded,
                      size: 36,
                      color: FIGMA.Grn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
