import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/const/figma.dart';

class NetvanaScreen extends StatelessWidget {
  const NetvanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double MaxScreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Center(
        child: EasyContainer(
          height: (MaxScreenWidth * 0.95) * 0.40,
          width: MaxScreenWidth * 0.95,
          color: FIGMA.Prn,
          borderRadius: 20,
          child: const Text(
            '...در حال توسعه',
            style: TextStyle(
                fontFamily: FIGMA.estbo, fontSize: 24, color: FIGMA.Wrn),
          ),
        ),
      ),
    );
  }
}
