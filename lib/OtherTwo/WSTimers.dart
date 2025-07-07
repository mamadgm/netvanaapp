// ignore_for_file: non_constant_identifier_names, file_names
import 'dart:convert';

import 'package:easy_container/easy_container.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/BLE/screens/products/nooran/smarttimer/smarttimer.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:netvana/const/figma.dart';

class Timersscr extends StatelessWidget {
  const Timersscr({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer<ProvData>(
      builder: (context, value, child) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              SizedBox(height: 2),
              EasyContainer(
                  elevation: 0,
                  color: Colors.white,
                  padding: 10,
                  margin: 12,
                  borderRadius: 15,
                  child: CircleTimerWidget(
                    index: 0,
                  )),
              SizedBox(height: 2),
              EasyContainer(
                  elevation: 0,
                  color: Colors.white,
                  padding: 10,
                  margin: 12,
                  borderRadius: 15,
                  child: CircleTimerWidget(
                    index: 1,
                  )),
              SizedBox(height: 2),
              EasyContainer(
                  elevation: 0,
                  color: Colors.white,
                  padding: 10,
                  margin: 12,
                  borderRadius: 15,
                  child: CircleTimerWidget(
                    index: 2,
                  )),
            ]),
          ),
        );
      },
    ));
  }
}
