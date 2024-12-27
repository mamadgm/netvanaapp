import 'package:netvana/const/figma.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';

class Choose_Product extends StatelessWidget {
  String Prefix;
  double myheight;
  double mywidth;
  final Function onTrytoconnect;
  final Function ondelete;
  Choose_Product({
    super.key,
    required this.Prefix,
    required this.myheight,
    required this.mywidth,
    required this.onTrytoconnect,
    required this.ondelete,
  });

  @override
  Widget build(BuildContext context) {
    int selectedWdiget = 0;
    if (Prefix.contains("Nv-")) {
      debugPrint("Selected Product is Nooran");
      selectedWdiget = 1;
    } else if (Prefix.contains("Lp-")) {
      debugPrint("Selected Product is Lamp");
      selectedWdiget = 2;
    } else if (Prefix.contains("neol-gm")) {
      debugPrint("Selected Product is In Development");
      selectedWdiget = 3;
    } else if (Prefix.contains("null")) {
      debugPrint("Selected Product is Null");
      selectedWdiget = 0;
    } else {
      selectedWdiget = 0;
    }
    return selectedWdiget != 0
        ? EasyContainer(
            width: mywidth,
            height: myheight,
            child: Column(
              children: [
                EasyContainer(
                  width: mywidth * 0.90,
                  height: myheight * 0.60,
                  child: Container(
                      child: selectedWdiget == 3
                          ? Image.asset(
                              "ass/icon.png",
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.bluetooth_disabled_rounded,
                              size: mywidth * 0.40,
                            )),
                ),
                Row(
                  children: [
                    EasyContainer(
                      width: (mywidth / 2.2),
                      height: myheight * 0.30,
                      child: Container(
                        child: Text(
                          "اتصال به دستگاه",
                          style:
                              TextStyle(fontFamily: FIGMA.abrlb, fontSize: 12),
                        ),
                      ),
                      onTap: () {
                        onTrytoconnect();
                      },
                    ),
                    EasyContainer(
                      width: (mywidth / 2.2),
                      height: myheight * 0.30,
                      child: Container(
                        child: Text(
                          "حذف دستگاه",
                          style:
                              TextStyle(fontFamily: FIGMA.abrlb, fontSize: 12),
                        ),
                      ),
                      onTap: () {
                        ondelete();
                      },
                    ),
                  ],
                )
              ],
            ))
        : const SizedBox();
  }
}
