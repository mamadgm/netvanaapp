import 'package:easy_container/easy_container.dart';
import 'package:filling_slider/filling_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:provider/provider.dart';

void showSleepSetting(context, ProvData value) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: FIGMA.Gray,
        title: Center(
          child: Column(
            children: [
              Text(
                "حالت خواب",
                style: TextStyle(
                  fontFamily: FIGMA.abreb,
                  fontSize: 16.sp,
                  color: FIGMA.Wrn,
                ),
              ),
              Text(
                "رنگ و نور دلخواه خود را برای حالت خواب تنظیم کنید",
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: FIGMA.estre,
                  fontSize: 12.sp,
                  color: FIGMA.Gray4,
                ),
              ),
              SizedBox(height: 36.h),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            child: SizedBox(
              width: 269.w,
              height: 62.h,
              child: BrightSleep(senddata: (out) {}),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              EasyContainer(
                color: FIGMA.Back,
                width: 130.w,
                height: 60.h,
                elevation: 0,
                showBorder: true,
                borderColor: FIGMA.Gray2,
                borderWidth: 1.5.sp,
                borderRadius: 15,
                child: Text(
                  "برگشت",
                  style: TextStyle(
                    fontFamily: FIGMA.estbo,
                    fontSize: 14.sp,
                    color: FIGMA.Wrn,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              EasyContainer(
                color: FIGMA.Prn,
                width: 130.w,
                height: 60.h,
                elevation: 0,
                borderRadius: 15,
                child: Text(
                  "ذخیره",
                  style: TextStyle(
                    fontFamily: FIGMA.estbo,
                    fontSize: 14.sp,
                    color: FIGMA.Wrn,
                  ),
                ),
                onTap: () {
                  // debugPrint(value.sleepBright.toString());
                  CacheService.instance.saveSleepValue(value.sleepBright);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

class BrightSleep extends StatefulWidget {
  const BrightSleep({Key? key, required this.senddata}) : super(key: key);
  final Function(String) senddata;

  @override
  State<BrightSleep> createState() {
    return BrightSleepState();
  }
}

class BrightSleepState extends State<BrightSleep> {
  double brightd = 0.5;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constsize) {
        return Consumer<ProvData>(
          builder: (context, value, child) {
            brightd = mapIntTodouble(value.sleepBright, 1, 255, 1.0, 0.0);
            return EasyContainer(
              color: FIGMA.Gray2,
              borderWidth: 0,
              elevation: 0,
              margin: 0,
              padding: 8,
              borderRadius: 17,
              child: Stack(
                children: [
                  FillingSlider(
                    initialValue: brightd,
                    width: constsize.maxWidth,
                    height: constsize.maxHeight,
                    direction: FillingSliderDirection.horizontal,
                    color: FIGMA.Orn,
                    fillColor: FIGMA.Gray2,
                    onChange: (val1, val2) {},
                    onFinish: (out) async {
                      int finallight = mapdoubleToInt(out, 1.0, 0.0, 1, 100);
                      widget.senddata(finallight.toString());
                      value.setsleepBright(finallight);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${value.sleepBright}",
                        style: TextStyle(
                          fontFamily: FIGMA.estsb,
                          fontSize: 12.sp,
                          color: FIGMA.Wrn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

double mapIntTodouble(
  int value,
  int inputStart,
  int inputEnd,
  double outputStart,
  double outputEnd,
) {
  double slope = (outputEnd - outputStart) / (inputEnd - inputStart);
  return outputStart + slope * (value - inputStart);
}

int mapdoubleToInt(
  double value,
  double inputStart,
  double inputEnd,
  double outputStart,
  double outputEnd,
) {
  double inputRange = inputEnd - inputStart;
  double outputRange = outputEnd - outputStart;
  return (((value - inputStart) * outputRange) / inputRange + outputStart)
      .round();
}
