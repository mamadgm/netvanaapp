// ignore_for_file: camel_case_types, must_be_immutanetvana, unused_import, avoid_print, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'package:netvana/const/figma.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/Rawlibs/hsv/hsv_color_pickers.dart';
import 'package:filling_slider/filling_slider.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

class Color_Picker_HSV extends StatefulWidget {
  String color;
  int netvana;
  Function(String) senddata;
  Color_Picker_HSV(
      {Key? key,
      required this.color,
      required this.netvana,
      required this.senddata})
      : super(key: key);

  @override
  State<Color_Picker_HSV> createState() => _Color_Picker_HSVState();
}

class Color_Picker_HSV2 extends StatefulWidget {
  String color;
  int netvana;
  Color_Picker_HSV2({
    Key? key,
    required this.color,
    required this.netvana,
  }) : super(key: key);

  @override
  State<Color_Picker_HSV2> createState() => _Color_Picker_HSVState2();
}

class _Color_Picker_HSVState extends State<Color_Picker_HSV> {
  @override
  Widget build(BuildContext context) {
    widget.color = widget.color.replaceFirst('Color(', '');
    widget.color = widget.color.replaceFirst(')', '');
    widget.color = widget.color.replaceFirst('0x', '');
    int colorInt = int.parse(widget.color, radix: 16); // convert to int
    Color maincolor = Color(colorInt).withOpacity(1.0); //

    return EasyContainer(
      color: FIGMA.Gray,
      borderWidth: 0,
      elevation: 0,
      customMargin:
          const EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
      padding: 6,
      borderRadius: 17,
      child: EasyContainer(
        //color: Color(0xFFF9F9F9),
        color: FIGMA.Wrn,
        margin: 0,
        padding: 0,
        borderRadius: 17,
        child: Container(
          height: 600,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.centerRight,
              begin: Alignment.centerLeft,
              colors: [
                Color.fromARGB(255, 255, 0, 0),
                Color.fromARGB(255, 255, 255, 0),
                Color.fromARGB(255, 0, 255, 0),
                Color.fromARGB(255, 0, 255, 255),
                Color.fromARGB(255, 0, 0, 255),
                Color.fromARGB(255, 255, 0, 255),
                Color.fromARGB(255, 255, 0, 0),
              ],
            ),
          ),
          child: HuePicker(
            thumbShape: const HueSliderThumbShape(
              radius: 20,
              color: Colors.white,
              filled: false,
              showBorder: false,
              strokeWidth: 4,
            ),
            trackHeight: 10,
            initialColor: HSVColor.fromColor(maincolor),
            onChanged: (color) {
              setState(() {
                maincolor = color.toColor();
              });
            },
            onChangeEnd: (color) async {
              color = color.withAlpha(1.0);
              color = color.withSaturation(1.0);
              int red = color.toColor().red;
              int grn = color.toColor().green;
              int blu = color.toColor().blue;

              debugPrint("Color Changed");
              //
              String ColorStr =
                  ((red * 65536) + (grn * 256) + (blu)).toString();
              debugPrint(ColorStr);
              widget.senddata(ColorStr);
            },
          ),
        ),
      ),
    );
  }
}

class _Color_Picker_HSVState2 extends State<Color_Picker_HSV2> {
  @override
  Widget build(BuildContext context) {
    widget.color = widget.color.replaceFirst('Color(', '');
    widget.color = widget.color.replaceFirst(')', '');
    widget.color = widget.color.replaceFirst('0x', '');
    int colorInt = int.parse(widget.color, radix: 16); // convert to int
    Color maincolor = Color(colorInt).withOpacity(1.0); //

    return EasyContainer(
      color: FIGMA.Gray,
      borderWidth: 0,
      elevation: 0,
      customMargin:
          const EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
      padding: 6,
      borderRadius: 17,
      child: EasyContainer(
        //color: Color(0xFFF9F9F9),
        color: FIGMA.Wrn,
        margin: 0,
        padding: 0,
        borderRadius: 17,
        child: Container(
          height: 600,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.centerRight,
              begin: Alignment.centerLeft,
              colors: [
                Color.fromARGB(255, 255, 0, 0),
                Color.fromARGB(255, 255, 255, 0),
                Color.fromARGB(255, 0, 255, 0),
                Color.fromARGB(255, 0, 255, 255),
                Color.fromARGB(255, 0, 0, 255),
                Color.fromARGB(255, 255, 0, 255),
                Color.fromARGB(255, 255, 0, 0),
              ],
            ),
          ),
          child: HuePicker(
            thumbShape: const HueSliderThumbShape(
              radius: 20,
              color: Colors.white,
              filled: false,
              showBorder: false,
              strokeWidth: 4,
            ),
            trackHeight: 10,
            initialColor: HSVColor.fromColor(maincolor),
            onChanged: (color) {
              setState(() {
                maincolor = color.toColor();
              });
            },
            onChangeEnd: (color) async {
              color = color.withAlpha(1.0);
              color = color.withSaturation(1.0);
              int red = color.toColor().red;
              int grn = color.toColor().green;
              int blu = color.toColor().blue;

              debugPrint("Color Changed");
              //
              String ColorStr =
                  ((red * 65536) + (grn * 256) + (blu)).toString();
              debugPrint(ColorStr);
            },
          ),
        ),
      ),
    );
  }
}

//////////////////////////////
class Speed_slider extends StatefulWidget {
  Function(String) senddata;
  Speed_slider({Key? key, required this.senddata}) : super(key: key);

  @override
  _Speed_sliderState createState() => _Speed_sliderState();
}

class Speed_slider2 extends StatefulWidget {
  int speed;
  int netvana;
  Speed_slider2({
    Key? key,
    required this.speed,
    required this.netvana,
  }) : super(key: key);

  @override
  _Speed_sliderState2 createState() => _Speed_sliderState2();
}

class _Speed_sliderState extends State<Speed_slider> {
  double speed = 0.0;

  @override
  void initState() {
    final funcy = context.read<ProvData>();
    debugPrint("orginal");
    super.initState();
    speed = mapIntTodouble(funcy.maincycle_speed, 200, 5000, 1.0, 0.0);
  }

  @override
  void didUpdateWidget(covariant Speed_slider oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double MaxScreenWidth = MediaQuery.of(context).size.width;
    return Consumer<ProvData>(builder: (context, value, child) {
      return EasyContainer(
        color: FIGMA.Gray,
        borderWidth: 0,
        elevation: 0,
        customMargin:
            const EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
        padding: 6,
        borderRadius: 17,
        child: FillingSlider(
          initialValue:
              mapIntTodouble(value.maincycle_speed, 3000, 200, 1.0, 0.0),
          width: MaxScreenWidth * 0.9,
          height: 80,
          direction: FillingSliderDirection.horizontal,
          color: FIGMA.Orn,
          fillColor: FIGMA.Gray,
          onFinish: (value) async {
            int finalspeed = mapdoubleToInt(value, 1.0, 0.0, 3000, 200);
            widget.senddata(finalspeed.toString());
            debugPrint(finalspeed.toString());
          },
        ),
      );
    });
  }
}

class _Speed_sliderState2 extends State<Speed_slider2> {
  double speed = 0.0;

  @override
  void initState() {
    debugPrint("mirror");
    super.initState();
    speed = mapIntTodouble(widget.speed, 200, 5000, 1.0, 0.0);
  }

  @override
  void didUpdateWidget(covariant Speed_slider2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.speed != oldWidget.speed) {
      setState(() {
        speed = mapIntTodouble(widget.speed, 200, 5000, 1.0, 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double MaxScreenWidth = MediaQuery.of(context).size.width;
    return EasyContainer(
      color: FIGMA.Gray,
      borderWidth: 0,
      elevation: 0,
      customMargin:
          const EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
      padding: 6,
      borderRadius: 17,
      child: FillingSlider(
        initialValue: speed,
        width: MaxScreenWidth * 0.9,
        height: 80,
        direction: FillingSliderDirection.horizontal,
        color: FIGMA.Orn,
        fillColor: FIGMA.Gray,
        onChange: (x, y) {},
        onFinish: (value) async {
          int finalspeed = mapdoubleToInt(value, 1.0, 0.0, 200, 5000);

          debugPrint(finalspeed.toString());
        },
      ),
    );
  }
}

/////////////////////
class Bright_slider extends StatefulWidget {
  Bright_slider(
      {Key? key,
      required this.brightness,
      required this.netvana,
      required this.senddata})
      : super(key: key);
  Function(String) senddata;
  final int brightness;
  int netvana;
  double brightd = 0.5;
  @override
  State<Bright_slider> createState() {
    return _Bright_sliderState();
  }
}

class Bright_slider2 extends StatefulWidget {
  Bright_slider2(
      {Key? key,
      required this.netvana,
      required this.brightness,
      required this.senddata})
      : super(key: key);

  final int brightness;
  Function(String) senddata;
  int netvana;
  double brightd = 0.2;
  @override
  State<Bright_slider2> createState() => _Bright_sliderState2();
}

class _Bright_sliderState extends State<Bright_slider> {
  @override
  Widget build(BuildContext context) {
    widget.brightd = mapIntTodouble(widget.brightness, 1, 255, 1.0, 0.0);
    double MaxScreenWidth = MediaQuery.of(context).size.width;
    return EasyContainer(
      color: FIGMA.Gray,
      borderWidth: 0,
      elevation: 0,
      customMargin:
          const EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
      padding: 6,
      borderRadius: 17,
      child: FillingSlider(
        initialValue: widget.brightd,
        width: MaxScreenWidth * 0.9,
        height: MaxScreenWidth,
        direction: FillingSliderDirection.horizontal,
        color: FIGMA.Orn,
        fillColor: FIGMA.Gray,
        onChange: (val1, val2) {},
        onFinish: (value) async {
          int finallight = mapdoubleToInt(value, 1.0, 0.0, 1, 255);
          debugPrint(finallight.toString());
          widget.senddata(finallight.toString());
        },
      ),
    );
  }
}

class _Bright_sliderState2 extends State<Bright_slider2> {
  @override
  Widget build(BuildContext context) {
    double MaxScreenWidth = MediaQuery.of(context).size.width;
    widget.brightd = mapIntTodouble(widget.brightness, 1, 255, 1.0, 0.0);
    return EasyContainer(
      color: FIGMA.Gray,
      borderWidth: 0,
      elevation: 0,
      customMargin:
          const EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
      padding: 6,
      borderRadius: 17,
      child: FillingSlider(
        initialValue: widget.brightd,
        width: MaxScreenWidth * 0.9,
        height: MaxScreenWidth,
        direction: FillingSliderDirection.horizontal,
        color: FIGMA.Orn,
        fillColor: FIGMA.Gray,
        onChange: (val1, val2) {},
        onFinish: (value) async {
          int finallight = mapdoubleToInt(value, 1.0, 0.0, 1, 255);

          debugPrint(value.toString());
        },
      ),
    );
  }
}

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

double mapIntTodouble(int value, int inputStart, int inputEnd,
    double outputStart, double outputEnd) {
  double slope = (outputEnd - outputStart) / (inputEnd - inputStart);
  return outputStart + slope * (value - inputStart);
}

int mapdoubleToInt(double value, double inputStart, double inputEnd,
    double outputStart, double outputEnd) {
  double inputRange = inputEnd - inputStart;
  double outputRange = outputEnd - outputStart;
  return (((value - inputStart) * outputRange) / inputRange + outputStart)
      .round();
}
