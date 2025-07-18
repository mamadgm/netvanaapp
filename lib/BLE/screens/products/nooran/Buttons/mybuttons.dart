// ignore_for_file: non_constant_identifier_names, unused_local_varianetvana, camel_case_types, avoid_print, must_be_immutanetvana, deprecated_member_use

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/const/figma.dart';
import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

class Sleep_Button extends StatefulWidget {
  final bool state;
  final Function(String) onDataChange;
  const Sleep_Button({
    Key? key,
    required this.state,
    required this.onDataChange,
  }) : super(key: key);

  @override
  State<Sleep_Button> createState() => _Sleep_ButtonState();
}

class _Sleep_ButtonState extends State<Sleep_Button> {
  @override
  Widget build(BuildContext context) {
    return EasyContainer(
      onTap: () {
        widget.onDataChange("Hello ");
        // debugPrint('Sleep Button Clicked');
      },
      margin: 0,
      padding: 4,
      borderRadius: 17,
      color: widget.state == true ? FIGMA.Grn : FIGMA.Gray,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('ass/sleep.svg',
              width: 32, color: widget.state == true ? FIGMA.Wrn : FIGMA.Grn),
          Text(
            'خواب',
            style: TextStyle(
              fontFamily: FIGMA.estsb,
              fontSize: 16,
              color: widget.state == true ? FIGMA.Wrn : FIGMA.Grn,
            ),
          ),
          Text(
            '10%',
            style: TextStyle(
              fontFamily: FIGMA.estre,
              fontSize: 12,
              color: widget.state == true ? FIGMA.Wrn : FIGMA.Grn,
            ),
          ),
        ],
      ),
    );
  }
}

class Power_Button extends StatefulWidget {
  final Function() onDataChange;
  final bool onof;
  final int netvana;
  const Power_Button({
    required this.onof,
    required this.onDataChange,
    required this.netvana,
    Key? key,
  }) : super(key: key);

  @override
  State<Power_Button> createState() => Power_ButtonState();
}

class Power_ButtonState extends State<Power_Button> {
  @override
  Widget build(BuildContext context) {
    return EasyContainer(
      color: widget.onof == true ? FIGMA.Prn : FIGMA.Gray,
      onTap: () {
        debugPrint("PowerButton Clicked");
        widget.onDataChange();
      },
      margin: 0,
      padding: 4,
      borderRadius: 17,
      child: SvgPicture.asset(
        'ass/power.svg',
        width: 40,
        color: Colors.white,
      ),
    );
  }
}

class NewPopup extends StatefulWidget {
  final List<Widget> innerwidgets;
  final List<Widget> Templete;
  final Color TempleteColor;
  const NewPopup(
      {Key? key,
      required this.TempleteColor,
      required this.innerwidgets,
      required this.Templete})
      : super(key: key);

  @override
  State<NewPopup> createState() => _NewPopupState();
}

class _NewPopupState extends State<NewPopup> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(builder: (context, value, child) {
      return EasyContainer(
        onTap: () {
          // debugPrint('Timer Button Clicked');
          showGeneralDialog(
            context: context,
            pageBuilder: (context, animation1, animation) {
              return AlertDialog(
                scrollable: true,
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                backgroundColor: FIGMA.Back,
                content: EasyContainer(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 1.5,
                  color: FIGMA.Back.withAlpha(128),
                  borderWidth: 0,
                  elevation: 0,
                  margin: 0,
                  padding: 0,
                  borderRadius: 30,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: widget.innerwidgets),
                ),
              );
            },
          );
        },
        margin: 0,
        padding: 0,
        borderRadius: 17,
        color: widget.TempleteColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.Templete),
      );
    });
  }
}

class TimerMinutes extends StatefulWidget {
  final Function(int) onDataChange;
  final String Time;
  final int Time_int;
  const TimerMinutes({
    required this.Time_int,
    required this.Time,
    required this.onDataChange,
    Key? key,
  }) : super(key: key);

  @override
  State<TimerMinutes> createState() => _TimerMinutesState();
}

class _TimerMinutesState extends State<TimerMinutes> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 10,
      child: EasyContainer(
        onTap: () {
          widget.onDataChange(widget.Time_int);
        },
        margin: 8,
        padding: 0,
        borderRadius: 17,
        color: FIGMA.Gray,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.Time == "999" ? "" : "دقیقه",
              textAlign: TextAlign.end,
              style: const TextStyle(fontFamily: FIGMA.estsb, fontSize: 16),
            ),
            const Text(
              " ",
              textAlign: TextAlign.end,
              style: TextStyle(fontFamily: FIGMA.estsb, fontSize: 16),
            ),
            Text(
              widget.Time == "999" ? "غیر فعال سازی" : widget.Time,
              textAlign: TextAlign.end,
              style: const TextStyle(fontFamily: FIGMA.estbo, fontSize: 16),
            ),
            const Text(
              "    ",
              textAlign: TextAlign.end,
              style: TextStyle(fontFamily: FIGMA.estsb, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

void calculateTimeStore(int minutes) {
  var sdcard = Hive.box(FIGMA.HIVE);
  if (minutes == 999) {
    sdcard.put("Timeofdie", "0");
  } else {
    final now = DateTime.now();
    final newTime = now.add(Duration(minutes: minutes));
    final formattedTime =
        "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";
    debugPrint(formattedTime);
    sdcard.put("Timeofdie", formattedTime);
  }
}

class Circlecolor extends StatefulWidget {
  final int color; // Accept color as a simple int number
  final Function(String) onDataChange;

  const Circlecolor({
    required this.color,
    required this.onDataChange,
    Key? key,
  }) : super(key: key);

  @override
  State<Circlecolor> createState() => _CirclecolorState();
}

class _CirclecolorState extends State<Circlecolor> {
  @override
  Widget build(BuildContext context) {
    Color maincolor = Color(widget.color).withOpacity(1.0);

    return EasyContainer(
      height: 80,
      color: maincolor,
      borderWidth: 0,
      elevation: 0,
      borderRadius: 13,
      onTap: () async {
        widget.onDataChange(widget.color.toRadixString(10));
      },
      onLongPress: () {
        _showColorPicker(context);
      },
      child: Icon(Icons.color_lens, color: maincolor),
    );
  }

  void _showColorPicker(BuildContext context) {
    Color pickerColor = Color(widget.color).withAlpha(0xFF);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "رنگ دلخواه",
              style: TextStyle(
                  fontFamily: FIGMA.abreb, fontSize: 19, color: FIGMA.Orn),
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              enableAlpha: false,
              hexInputBar: false,
              showLabel: false,
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                setState(() {
                  pickerColor = color.withAlpha(0xFF);
                });
              },
            ),
          ),
          actions: <Widget>[
            EasyContainer(
              borderRadius: 15,
              color: FIGMA.Prn,
              child: const Text(
                "ذخیره رنگ",
                style: TextStyle(
                    fontFamily: FIGMA.estbo, fontSize: 19, color: FIGMA.Wrn),
              ),
              onTap: () {
                widget.onDataChange(((pickerColor.red * 65536) +
                        (pickerColor.green * 256) +
                        pickerColor.blue)
                    .toString());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
