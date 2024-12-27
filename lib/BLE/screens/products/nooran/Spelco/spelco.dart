import 'package:netvana/const/figma.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Spelco extends StatefulWidget {
  final int which;
  Function(int) handlechange;
  Spelco({super.key, required this.which, required this.handlechange});

  @override
  State<Spelco> createState() => _SpelcoState();
}

class _SpelcoState extends State<Spelco> {
  @override
  Widget build(BuildContext context) {
    double iconSize = 28;
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: EasyContainer(
        color: FIGMA.Gray,
        borderWidth: 0,
        elevation: 0,
        margin: 0,
        padding: 0,
        borderRadius: 15,
        child: GNav(
          selectedIndex: widget.which,
          tabActiveBorder: Border.all(color: FIGMA.Gray, width: 3),
          tabMargin: const EdgeInsets.only(right: 2, left: 2),
          tabBorderRadius: 20,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          color: Colors.grey,
          activeColor: FIGMA.Orn,
          tabBackgroundColor: FIGMA.Wrn,
          backgroundColor: FIGMA.Gray,
          tabs: [
            GButton(
              iconSize: iconSize,
              icon: Icons.speed,
              text: "سرعت",
              textStyle: TextStyle(
                  fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Grn),
            ),
            GButton(
              iconSize: iconSize,
              icon: Icons.sunny,
              text: "روشنایی",
              textStyle: TextStyle(
                  fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Grn),
            ),
            GButton(
              iconSize: iconSize,
              icon: Icons.color_lens,
              text: "رنگ",
              textStyle: TextStyle(
                  fontFamily: FIGMA.estbo, fontSize: 16, color: FIGMA.Grn),
            ),
          ],
          onTabChange: (index) {
            widget.handlechange(index);
          },
        ),
      ),
    );
  }
}
