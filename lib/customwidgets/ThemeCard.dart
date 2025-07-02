import 'dart:convert';

import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

class ThemeCard extends StatelessWidget {
  final int id;
  final String picUrl;
  final String bigText;
  final String smallText;

  const ThemeCard({
    Key? key,
    required this.id,
    required this.picUrl,
    required this.bigText,
    required this.smallText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
        builder: (context, value, child) => EasyContainer(
              onTap: () {
                String jsonPayload = jsonEncode({"Lm": id.toString()});
                SingleBle().sendMain(jsonPayload);
                value.triggerDelayedAction();
              },
              hoverColor: FIGMA.Back,
              padding: 8,
              margin: 0,
              borderRadius: 15,
              elevation: value.maincycle_mode == id ? 5 : 0,
              splashColor: FIGMA.Back,
              color: FIGMA.Back,
              child: Column(
                children: [
                  EasyContainer(
                    padding: 0,
                    margin: 0,
                    color: FIGMA.Back,
                    borderRadius: 16,
                    elevation: value.maincycle_mode == id ? 5 : 0,
                    child: Image.asset(
                      picUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                bigText,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FIGMA.estsb),
                              ),
                              Text(
                                smallText,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontFamily: FIGMA.estre),
                              ),
                            ],
                          ),
                          const SizedBox(width: 32),
                          IconButton(
                            icon: Icon(
                              value.Favorites.contains(id)
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              color: FIGMA.Orn,
                              size: 36,
                            ),
                            onPressed: () {
                              if (value.Favorites.contains(id)) {
                                value.Favorites.remove(id);
                                value.hand_update();
                              } else {
                                value.Favorites.add(id);
                                value.hand_update();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
