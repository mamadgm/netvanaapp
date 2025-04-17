import 'package:easy_container/easy_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:netvana/BLE/screens/products/nooran/Buttons/mybuttons.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/newtab.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SmrtSetting extends StatelessWidget {
  final TextStyle mystyle = const TextStyle(
    fontSize: 48,
  );

  final Function(int) time;
  final Function(String) color;

  const SmrtSetting({super.key, required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
      builder: (context, value, child) => NewTab(
        appbartext: "تنظیمات تایمر هوشمند",
        childrens: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 400,
                child: CupertinoPicker(
                  useMagnifier: true,
                  itemExtent: 75,
                  onSelectedItemChanged: (temp) {
                    value.set_SmartTimerMinSec(temp, value.SmartTimerSec);
                  },
                  selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                    background: FIGMA.Prn.withOpacity(0.3),
                  ),
                  children: List.generate(
                      90,
                      (index) => Text(
                            "$index",
                            style: mystyle,
                          )),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                height: 400,
                child: CupertinoPicker(
                  useMagnifier: true,
                  itemExtent: 75,
                  onSelectedItemChanged: (temp) {
                    value.set_SmartTimerMinSec(value.SmartTimerMin, temp);
                  },
                  selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                    background: FIGMA.Orn.withOpacity(0.3),
                  ),
                  children: List.generate(
                      60,
                      (index) => Text(
                            "$index",
                            style: mystyle,
                          )),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 220,
                width: 100,
                child: Column(
                  children: [
                    Circlecolor(
                      color: value.smarttimercolor,
                      onDataChange: (temp) {
                        value.setSmartTimerColor(int.parse(temp));
                        color(temp);
                      },
                    ),
                    const Text(
                      "رنگ تایمر",
                      style: TextStyle(
                          fontFamily: FIGMA.abreb,
                          color: Colors.black,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
            ],
          ),
          EasyContainer(
            height: 100,
            width: double.infinity,
            padding: 4,
            color: FIGMA.Prn,
            borderRadius: 17,
            elevation: 0,
            margin: 16,
            child: const Text(
              "تایید",
              style: TextStyle(
                  fontFamily: FIGMA.abreb, color: Colors.white, fontSize: 24),
            ),
            onTap: () {
              value.set_SmartTimerMinSec(
                  value.SmartTimerMin, value.SmartTimerSec,
                  update: true);

              int sum = ((value.SmartTimerMin) * 60) + value.SmartTimerSec;
              // debugPrint(sum.toString());
              int delaysec = sum ~/ 15;
              debugPrint(delaysec.toString());
              time(sum);
            },
          ),
          const Center(
            child: Text(
              "زمان ها ممکن است ممکنی تفاوت داشته باشد\nمقدار اصلی در صفحه اصلی است",
              style: TextStyle(
                fontFamily: FIGMA.estbo,
                color: FIGMA.Grn,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
