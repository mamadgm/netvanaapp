import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/ble/screens/products/nooran/smarttimer/smarttimer.dart';
import 'package:netvana/const/figma.dart';

class NetvanaScreen extends StatelessWidget {
  const NetvanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double MaxScreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Center(
        child: EasyContainer(
          height: 600,
          width: MaxScreenWidth * 0.95,
          color: FIGMA.Prn,
          borderRadius: 20,
          child: Column(
            children: [
              const Text(
                '...در حال توسعه',
                style: TextStyle(
                    fontFamily: FIGMA.estbo, fontSize: 24, color: FIGMA.Wrn),
              ),
              SmartTimer(
                exit: () {},
                start: () {},
                stop: () {},
                resume: () {},
                timepace: (p0) {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
