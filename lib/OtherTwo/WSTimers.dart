// ignore_for_file: non_constant_identifier_names, file_names
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
        return Stack(
          children: [
            const SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '...در حال توسعه',
                    style: TextStyle(
                        fontFamily: FIGMA.estbo,
                        fontSize: 24,
                        color: FIGMA.Wrn),
                  ),
                  Text(
                    '...تایمرها ',
                    style: TextStyle(
                        fontFamily: FIGMA.estbo,
                        fontSize: 24,
                        color: FIGMA.Wrn),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ));
  }
}
