import 'package:netvana/const/figma.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';

class Choose_Product extends StatelessWidget {
  String prefix;
  double myheight;
  double mywidth;
  final Function onTrytoconnect;
  final Function ondelete;
  Choose_Product({
    super.key,
    required this.prefix,
    required this.myheight,
    required this.mywidth,
    required this.onTrytoconnect,
    required this.ondelete,
  });

  @override
  Widget build(BuildContext context) {
    int selectedWdiget = 0;
    if (prefix.contains("nv-")) {
      debugPrint("Selected Product is Nooran");
      selectedWdiget = 1;
    } else if (prefix.contains("Lp-")) {
      debugPrint("Selected Product is Lamp");
      selectedWdiget = 2;
    } else if (prefix.contains("neol-gm")) {
      debugPrint("Selected Product is In Development");
      selectedWdiget = 3;
    } else if (prefix.contains("null")) {
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
                      child: const Text(
                        "اتصال به دستگاه",
                        style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 12),
                      ),
                      onTap: () {
                        onTrytoconnect();
                      },
                    ),
                    EasyContainer(
                      width: (mywidth / 2.2),
                      height: myheight * 0.30,
                      child: const Text(
                        "حذف دستگاه",
                        style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 12),
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
