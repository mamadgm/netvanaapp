// ignore_for_file: camel_case_types, must_be_immutanetvana, unused_import, avoid_print, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'package:netvana/const/figma.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/Rawlibs/hsv/hsv_color_pickers.dart';
import 'package:filling_slider/filling_slider.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

class Color_Picker_HSV extends StatefulWidget {
  int netvana;
  Function(String) senddata;
  Color_Picker_HSV({Key? key, required this.netvana, required this.senddata})
      : super(key: key);

  @override
  State<Color_Picker_HSV> createState() => _Color_Picker_HSVState();
}

class _Color_Picker_HSVState extends State<Color_Picker_HSV> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(builder: (context, value, _) {
      String colorStr = value.maincycle_color;
      int colorInt;

      colorStr = colorStr.replaceFirst('Color(', '').replaceFirst(')', '');

      if (colorStr.startsWith('0x')) {
        colorStr = colorStr.replaceFirst('0x', '');
        colorInt = int.parse(colorStr, radix: 16);
      } else {
        colorInt = int.parse(colorStr);
      }

      // Ensure the color has full opacity
      Color maincolor = Color(colorInt).withOpacity(1.0);
      return LayoutBuilder(builder: (context, constsize) {
        return EasyContainer(
          color: FIGMA.Gray2,
          borderWidth: 0,
          elevation: 0,
          padding: 8,
          margin: 0,
          borderRadius: 20,
          child: Container(
            height: constsize.maxHeight,
            width: constsize.maxWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                end: Alignment.centerRight,
                begin: Alignment.centerLeft,
                colors: (!value.nextmoveisconnect | value.isConnectedWifi)
                    ? [
                        const Color.fromARGB(255, 255, 0, 0),
                        const Color.fromARGB(255, 255, 255, 0),
                        const Color.fromARGB(255, 0, 255, 0),
                        const Color.fromARGB(255, 0, 255, 255),
                        const Color.fromARGB(255, 0, 0, 255),
                        const Color.fromARGB(255, 255, 0, 255),
                        const Color.fromARGB(255, 255, 0, 0),
                      ]
                    : [
                        const Color.fromARGB(255, 255, 0, 0),
                        const Color.fromARGB(255, 255, 255, 0),
                        const Color.fromARGB(255, 0, 255, 0),
                        const Color.fromARGB(255, 0, 255, 255),
                        const Color.fromARGB(255, 0, 0, 255),
                        const Color.fromARGB(255, 255, 0, 255),
                        const Color.fromARGB(255, 255, 0, 0),
                      ],
              ),
            ),
            child: HuePicker(
              thumbShape: const HueSliderThumbShape(
                  radius: 28, color: FIGMA.Wrn, borderColor: FIGMA.Wrn),
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
                // Convert RGB to decimal string
                String colorStr =
                    ((red * 65536) + (grn * 256) + blu).toString();
                debugPrint(colorStr);
                widget.senddata(colorStr);
              },
            ),
          ),
        );
      });
    });
  }
}

//////////////////////////////
class HueSliderThumbShape extends RoundSliderThumbShape {
  final double radius;
  final bool filled;
  final Color color;
  final double strokeWidth;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  const HueSliderThumbShape({
    this.radius = 10,
    this.filled = false,
    this.color = Colors.white,
    this.strokeWidth = 3,
    this.showBorder = false,
    this.borderColor = Colors.black,
    this.borderWidth = 1,
  }) : super(enabledThumbRadius: radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: disabledThumbRadius ?? enabledThumbRadius,
      end: enabledThumbRadius,
    );
    final double currentRadius = radiusTween.evaluate(enableAnimation);

    // 🌟 Glow Effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, currentRadius + 8, glowPaint);

    // 🎨 Main thumb circle
    final circlePaint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;
    if (!filled) circlePaint.strokeWidth = strokeWidth;

    canvas.drawCircle(
      center,
      showBorder ? currentRadius - borderWidth : currentRadius,
      circlePaint,
    );

    if (showBorder) {
      double borderRadius = currentRadius - borderWidth;
      if (!filled) borderRadius += strokeWidth / 2;

      canvas.drawCircle(
        center,
        borderRadius,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }
  }
}

//////////////////////////////
class Speed_slider extends StatefulWidget {
  final Function(String) senddata;
  const Speed_slider({Key? key, required this.senddata}) : super(key: key);

  @override
  Speed_sliderState createState() => Speed_sliderState();
}

class Speed_sliderState extends State<Speed_slider> {
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
    return LayoutBuilder(builder: (context, constsize) {
      return Consumer<ProvData>(builder: (context, value, child) {
        return EasyContainer(
          color: FIGMA.Gray2,
          borderWidth: 0,
          elevation: 0,
          margin: 0,
          padding: 8,
          borderRadius: 17,
          child: FillingSlider(
            initialValue:
                mapIntTodouble(value.maincycle_speed, 2500, 100, 1.0, 0.0),
            width: constsize.maxWidth,
            height: constsize.maxHeight,
            direction: FillingSliderDirection.horizontal,
            color: (!value.nextmoveisconnect | value.isConnectedWifi)
                ? FIGMA.Orn
                : Colors.grey,
            fillColor: FIGMA.Gray2,
            onFinish: (value) async {
              int finalspeed = mapdoubleToInt(value, 1.0, 0.0, 2500, 100);
              widget.senddata(finalspeed.toString());
              debugPrint(finalspeed.toString());
            },
          ),
        );
      });
    });
  }
}

/////////////////////
class Bright_slider extends StatefulWidget {
  const Bright_slider(
      {Key? key,
      required this.brightness,
      required this.netvana,
      required this.senddata})
      : super(key: key);
  final Function(String) senddata;
  final int brightness;
  final int netvana;

  @override
  State<Bright_slider> createState() {
    return _Bright_sliderState();
  }
}

class _Bright_sliderState extends State<Bright_slider> {
  double brightd = 0.5;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constsize) {
      return Consumer<ProvData>(builder: (context, value, child) {
        brightd = mapIntTodouble(value.Brightness, 1, 255, 1.0, 0.0);
        return EasyContainer(
          color: FIGMA.Gray2,
          borderWidth: 0,
          elevation: 0,
          margin: 0,
          padding: 8,
          borderRadius: 17,
          child: FillingSlider(
            initialValue: brightd,
            width: constsize.maxWidth,
            height: constsize.maxHeight,
            direction: FillingSliderDirection.horizontal,
            color: (!value.nextmoveisconnect | value.isConnectedWifi)
                ? FIGMA.Orn
                : Colors.grey,
            fillColor: FIGMA.Gray2,
            onChange: (val1, val2) {},
            onFinish: (value) async {
              int finallight = mapdoubleToInt(value, 1.0, 0.0, 1, 255);
              debugPrint(finallight.toString());
              widget.senddata(finallight.toString());
            },
          ),
        );
      });
    });
  }
}

// void rebuildAllChildren(BuildContext context) {
//   void rebuild(Element el) {
//     el.markNeedsBuild();
//     el.visitChildren(rebuild);
//   }

//   (context as Element).visitChildren(rebuild);
// }

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
