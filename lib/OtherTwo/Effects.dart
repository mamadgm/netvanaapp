// ignore_for_file: non_constant_identifier_names, file_names
import 'package:easy_container/easy_container.dart';
import 'package:netvana/const/themes.dart';
import 'package:netvana/customwidgets/ThemeCard.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:netvana/const/figma.dart';

class Effectsscr extends StatelessWidget {
  const Effectsscr({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
      builder: (context, value, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EasyContainer(
                        color: FIGMA.Back,
                        borderWidth: 0,
                        elevation: 0,
                        customMargin: const EdgeInsets.only(right: 36),
                        padding: 0,
                        child: Container(
                          color: FIGMA.Back,
                          child: const Text(
                            "افکت های اختصاصی",
                            style: TextStyle(
                                fontFamily: FIGMA.abrlb, fontSize: 28),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3 / 4, // Adjust based on your card size
                    children: Allthemes.map((theme) {
                      return ThemeCard(
                        id: theme.value,
                        picUrl: theme.path,
                        bigText: theme.name,
                        smallText: theme.property,
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<Widget> buildRows(List<EspTheme> themes) {
  List<Widget> rows = [];

  for (int i = 0; i < themes.length; i += 2) {
    rows.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Expanded(
              child: ThemeCard(
                id: themes[i].value,
                picUrl: themes[i].path,
                bigText: themes[i].name,
                smallText: themes[i].property,
              ),
            ),
            const SizedBox(width: 32),
            if (i + 1 < themes.length)
              Expanded(
                child: ThemeCard(
                  id: themes[i + 1].value,
                  picUrl: themes[i + 1].path,
                  bigText: themes[i + 1].name,
                  smallText: themes[i + 1].property,
                ),
              )
            else
              const Expanded(child: SizedBox()), // Empty space for odd count
          ],
        ),
      ),
    );
  }

  return rows;
}
