import 'package:flutter/material.dart';
import 'package:netvana/BLE/logic/esp_ble.dart';
import 'package:netvana/BLE/screens/Setting/SmartTimerSet.dart';
import 'package:netvana/customwidgets/cusprogress.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:easy_container/easy_container.dart';
import 'package:provider/provider.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';

class SmartTimer extends StatefulWidget {
  const SmartTimer(
      {super.key,
      required this.start,
      required this.stop,
      required this.exit,
      required this.resume,
      required this.timepace,
      required this.timeset,
      required this.colorset});
  final Function(bool) timepace;
  final Function(int) timeset;
  final Function(String) colorset;
  final Function start;
  final Function stop;
  final Function exit;
  final Function resume;

  @override
  SmartTimerState createState() => SmartTimerState();
}

class SmartTimerState extends State<SmartTimer> {
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
        widget.timepace(false);
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
          // debugPrint("UPDATING");
          totalSeconds = newTotalSeconds;
          _stopWatchTimer.clearPresetTime();
          _stopWatchTimer.onResetTimer();
          _stopWatchTimer.setPresetTime(mSec: totalSeconds * 1000);
        }
        return EasyContainer(
          borderWidth: 0,
          elevation: 0,
          margin: 0,
          padding: 10,
          borderRadius: 15,
          color: FIGMA.Back,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
                builder: (context, snapshot) {
                  final value = snapshot.data!;
                  final displayTime = StopWatchTimer.getDisplayTime(value,
                      hours: false,
                      minute: true,
                      second: true,
                      milliSecond: false);
                  return SizedBox(
                    height: 90,
                    child: Text(
                      displayTime,
                      style: const TextStyle(
                        fontSize: 60,
                        fontFamily: FIGMA.abreb,
                      ),
                    ),
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EasyContainer(
                    color: FIGMA.Back,
                    borderRadius: 17,
                    onTap: () {
                      _stopWatchTimer.onResetTimer();
                      isStopped = true;
                      widget.exit();
                      value.setSmartTimerPaused(true);
                      widget.timepace(false);
                    },
                    child: const Icon(
                      Icons.refresh_rounded,
                      size: 40,
                      color: FIGMA.Orn,
                    ),
                  ),
                  EasyContainer(
                    color: FIGMA.Back,
                    borderRadius: 17,
                    onTap: () {
                      if (value.issmarttimerpaused) {
                        _stopWatchTimer.onStartTimer();
                        widget.timepace(true);
                        if (isStopped == true) {
                          widget.start();
                        } else {
                          widget.resume();
                        }
                        isStopped = false;
                      } else {
                        widget.timepace(false);
                        widget.stop();
                        _stopWatchTimer.onStopTimer();
                      }
                      value.setSmartTimerPaused(!value.issmarttimerpaused);
                    },
                    child: Icon(
                      value.issmarttimerpaused
                          ? Icons.play_circle_rounded
                          : Icons.stop_circle_rounded,
                      size: 40,
                      color: FIGMA.Grn,
                    ),
                  ),
                  EasyContainer(
                    color: FIGMA.Back,
                    borderRadius: 17,
                    child: const Icon(
                      Icons.settings_rounded,
                      size: 40,
                      color: FIGMA.Grn,
                    ),
                    onTap: () {
                      value.isConnected == true
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SmrtSetting(
                                  time: (val) {
                                    widget.timeset(val);
                                  },
                                  color: (val) {
                                    widget.colorset(val);
                                  },
                                ),
                              ),
                            )
                          : value.Show_Snackbar(
                              "ابتدا به نوران متصل شوید", 1000);
                    },
                  ),
                ],
              ),
              CusProgressBar(
                progress: value.whereami == 2
                    ? (value.smarttimerpos - 1)
                    : value.whereami == 3
                        ? -69
                        : -100,
              ),
            ],
          ),
        );
      },
    );
  }
}
