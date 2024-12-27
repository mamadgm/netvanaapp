// ignore_for_file: non_constant_identifier_names, unused_local_varianetvana, camel_case_types, avoid_print, must_be_immutanetvana

import 'package:netvana/const/figma.dart';
import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Sleep_Button extends StatefulWidget {
  bool state;
  final Function(String) onDataChange;
  Sleep_Button({
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
        debugPrint('Sleep Button Clicked');
      },
      margin: 0,
      padding: 4,
      borderRadius: 17,
      color: widget.state == true ? FIGMA.Grn : FIGMA.Wrn,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'ass/sleep.svg',
            width: 32,
          ),
          Text(
            'خواب',
            style: TextStyle(
              fontFamily: FIGMA.estsb,
              fontSize: 16,
              color: widget.state == true ? FIGMA.Wrn : Colors.black,
            ),
          ),
          Text(
            '10%',
            style: TextStyle(
              fontFamily: FIGMA.estre,
              fontSize: 12,
              color: widget.state == true ? FIGMA.Wrn : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class Power_Button extends StatefulWidget {
  final Function() onDataChange;
  bool onof;
  int netvana;
  Power_Button({
    required this.onof,
    required this.onDataChange,
    required this.netvana,
    Key? key,
  }) : super(key: key);

  @override
  State<Power_Button> createState() => _Power_ButtonState();
}

class _Power_ButtonState extends State<Power_Button> {
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

class Timer_Button extends StatefulWidget {
  int time;
  bool state;
  final Function() onDataChange;
  Timer_Button(
      {Key? key,
      required this.time,
      required this.state,
      required this.onDataChange})
      : super(key: key);

  @override
  State<Timer_Button> createState() => _Timer_ButtonState();
}

class _Timer_ButtonState extends State<Timer_Button> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return EasyContainer(
      onTap: () {
        widget.onDataChange();
        debugPrint('Timer Button Clicked');
        showGeneralDialog(
          context: context,
          pageBuilder: (context, animation1, animation) {
            return AlertDialog(
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
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        "تایمر خاموش کننده",
                        style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 19),
                      ),
                    ),
                    FASELE(value: 2),
                    TimerMinutes(
                      Time: "15",
                      onDataChange: (s) {},
                      Time_int: 15,
                    ),
                    TimerMinutes(
                      Time: "30",
                      onDataChange: (s) {},
                      Time_int: 30,
                    ),
                    TimerMinutes(
                      Time: "60",
                      onDataChange: (s) {},
                      Time_int: 90,
                    ),
                    TimerMinutes(
                      Time: "90",
                      onDataChange: (s) {},
                      Time_int: 90,
                    ),
                    TimerMinutes(
                      Time: "999",
                      onDataChange: (s) {},
                      Time_int: 999,
                    ),
                    Expanded(
                        flex: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: EasyContainer(
                                margin: 4,
                                padding: 0,
                                borderRadius: 17,
                                color: FIGMA.Orn,
                                child: Text(
                                  "خروج",
                                  style: TextStyle(
                                      fontFamily: FIGMA.estsb,
                                      fontSize: 16,
                                      color: FIGMA.Wrn),
                                ),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            );
          },
        );
      },
      margin: 0,
      padding: 0,
      borderRadius: 17,
      color: widget.state == true ? FIGMA.Grn : FIGMA.Wrn,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'ass/timer.svg',
            width: 32,
            color: widget.state == true ? FIGMA.Wrn : FIGMA.Grn,
          ),
          Text(
            'تایمر',
            style: TextStyle(
              fontFamily: FIGMA.estsb,
              fontSize: 16,
              color: widget.state == true ? FIGMA.Wrn : Colors.black,
            ),
          ),
          Text(
            "غیرفعال",
            style: TextStyle(
              fontFamily: FIGMA.estre,
              fontSize: 14,
              color: widget.state == true ? FIGMA.Wrn : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// class spelco extends StatefulWidget {
//   int whichoneison;
//   final Function(String) onDataChange;
//   spelco({Key? key, required this.whichoneison, required this.onDataChange})
//       : super(key: key);

//   @override
//   State<spelco> createState() => _spelcoState();
// }

// class _spelcoState extends State<spelco> {
//   @override
//   Widget build(BuildContext context) {
//     final MyscreenHeight = MediaQuery.of(context).size.height;
//     final MyscreenWidth = MediaQuery.of(context).size.width;

//     return EasyContainer(
//       borderColor: FIGMA.Gray,
//       shadowColor: FIGMA.Gray,
//       margin: 4,
//       padding: 0,
//       borderRadius: 17,
//       color: FIGMA.Gray,
//       borderWidth: 0,
//       elevation: 0,
//       borderOnForeground: false,
//       child: Row(
//         children: [
//           Expanded(
//             child: EasyContainer(
//               onTap: () {
//                 debugPrint("SPEED_SPELCO");
//                 setState(() {
//                   widget.onDataChange('New data from child');
//                 });
//               },
//               borderWidth: 0,
//               elevation: 0,
//               margin: 6,
//               padding: 0,
//               borderRadius: 15,

//               color: widget.whichoneison == 1
//                   ? FIGMA.Wrn
//                   : FIGMA.Gray, // Change color based on `which`
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   widget.whichoneison == 1
//                       ? Text(
//                           'سرعت',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: FIGMA.estsb,
//                               fontSize: 16),
//                         )
//                       : Container(), // Empty Container widget will effectively "hide" the text
//                   SvgPicture.asset(
//                     'ass/Bolt.svg',
//                     color: widget.whichoneison == 1
//                         ? FIGMA.Orn
//                         : Colors.grey, // Change color based on `which`
//                     width: MyscreenWidth / 12,
//                     height: MyscreenWidth / 12,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: EasyContainer(
//               onTap: () {
//                 debugPrint("Bright_SPELCO");
//                 setState(() {
//                   sdcard.put("spelcowhich", 2);
//                   widget.onDataChange('New data from child');
//                 });
//               },
//               margin: 6,
//               padding: 0,
//               borderRadius: 15,
//               borderWidth: 0,
//               elevation: 0,
//               color: widget.whichoneison == 2
//                   ? FIGMA.Wrn
//                   : FIGMA.Gray, // Change color based on `which`
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   widget.whichoneison == 2
//                       ? Text(
//                           'روشنایی',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: FIGMA.estsb,
//                               fontSize: 16),
//                         )
//                       : Container(),
//                   SvgPicture.asset(
//                     'ass/sun.svg',
//                     color: widget.whichoneison == 2
//                         ? FIGMA.Orn
//                         : Colors.grey, // Change color based on `which`
//                     width: MyscreenWidth / 12,
//                     height: MyscreenWidth / 12,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: EasyContainer(
//               onTap: () {
//                 debugPrint("Color_SPELCO");
//                 setState(() {
//                   sdcard.put("spelcowhich", 3);
//                   widget.onDataChange('New data from child');
//                 });
//               },
//               margin: 6,
//               padding: 0,
//               borderRadius: 15,
//               borderWidth: 0,
//               elevation: 0,
//               color: widget.whichoneison == 3
//                   ? FIGMA.Wrn
//                   : FIGMA.Gray, // Change color based on `which`
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   widget.whichoneison == 3
//                       ? Text(
//                           'رنگ',
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: FIGMA.estsb,
//                               fontSize: 16),
//                         )
//                       : Container(),
//                   SvgPicture.asset(
//                     'ass/colorp.svg',
//                     color: widget.whichoneison == 3
//                         ? FIGMA.Orn
//                         : Colors.grey, // Change color based on `which`
//                     width: MyscreenWidth / 12,
//                     height: MyscreenWidth / 12,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class TimerMinutes extends StatefulWidget {
  final Function(String) onDataChange;
  String Time;
  int Time_int;
  TimerMinutes({
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
          debugPrint("Timer Clicked");
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
              style: TextStyle(fontFamily: FIGMA.estsb, fontSize: 16),
            ),
            Text(
              " ",
              textAlign: TextAlign.end,
              style: TextStyle(fontFamily: FIGMA.estsb, fontSize: 16),
            ),
            Text(
              widget.Time == "999" ? "غیر فعال سازی" : widget.Time,
              textAlign: TextAlign.end,
              style: TextStyle(fontFamily: FIGMA.estbo, fontSize: 16),
            ),
            Text(
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

void calcualtetimestore(int minutes) {
  // var sdcard = Hive.box('neol');
  if (minutes == 999) {
    // sdcard.put("Timeofdie", "0");
  } else {
    final now = DateTime.now();
    final newTime = now.add(Duration(minutes: minutes));
    debugPrint(newTime.toString());
    String hour = newTime.hour.toString();
    String min = newTime.minute.toString();
    // sdcard.put("Timeofdie", "$hour:$min");
  }
}

class Circlecolor extends StatefulWidget {
  String color;
  final Function(String) onDataChange;
  Circlecolor({
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
    widget.color = widget.color.replaceFirst('0x', '');
    int colorInt = int.parse(widget.color, radix: 16); // convert to int
    Color maincolor = Color(colorInt).withOpacity(1.0); //
    return Expanded(
      flex: 10,
      child: EasyContainer(
        height: 80,
        color: maincolor,
        borderWidth: 0,
        elevation: 0,
        // customMargin: EdgeInsets.only(right: 16, left: 16, top: 6, bottom: 6),
        padding: 0,
        borderRadius: 13,
        onTap: () async {
          int red = maincolor.red;
          int grn = maincolor.green;
          int blu = maincolor.blue;

          //debugPrint("Color Changed");
          //
          String ColorStr = ((red * 65536) + (grn * 256) + (blu)).toString();
          //debugPrint(ColorStr);

          widget.onDataChange("hello");
        },
        child: Icon(Icons.color_lens, color: maincolor),
      ),
    );
  }
}
