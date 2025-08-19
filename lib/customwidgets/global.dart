import 'dart:convert';

import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/const/figma.dart';

void showWiFiDialog(BuildContext context) {
  bool connected = false;
  final ssidController = TextEditingController();
  final passController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "popup",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return Center(
        child: AlertDialog(
          scrollable: true,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          backgroundColor: FIGMA.Gray,
          content: StatefulBuilder(builder: (context, setState) {
            return EasyContainer(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height * 0.5,
              color: FIGMA.Gray,
              borderWidth: 0,
              elevation: 0,
              margin: 0,
              padding: 6,
              borderRadius: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: connected
                    ? [
                        const Icon(Icons.check_circle,
                            size: 80, color: Colors.green),
                        const Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            "مراحل اتصال تکمیل شد!",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: FIGMA.abrlb,
                                color: FIGMA.Wrn),
                          ),
                        ),
                        EasyContainer(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 95,
                          borderRadius: 15,
                          color: FIGMA.Orn,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text("خروج",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: FIGMA.abreb,
                                  color: FIGMA.Wrn)),
                        ),
                      ]
                    : [
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "اتصال به شبکه نوروانا",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: FIGMA.abrlb,
                                color: FIGMA.Wrn),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "لطفا کادر های زیر را برای اتصال کامل کنید",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: FIGMA.abrlb,
                                color: FIGMA.Wrn),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: ssidController,
                            obscureText: true,

                            textAlign: TextAlign.right, // For RTL alignment
                            decoration: InputDecoration(
                              hintText: " WiFi نام", // Or "Password"
                              hintStyle: const TextStyle(color: FIGMA.Wrn2),

                              filled: true,
                              fillColor: FIGMA.Gray2,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 22,
                              ), // Big height/width

                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // Curved border
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey.shade700), // Darker on focus
                              ),

                              // Remove all effects (e.g., shadows, glow)
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                            ),
                            cursorColor: Colors.grey.shade700,
                            style:
                                const TextStyle(fontSize: 16, color: FIGMA.Wrn),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passController,
                            obscureText: true,
                            textAlign: TextAlign.right, // For RTL alignment
                            decoration: InputDecoration(
                              hintText: "رمز عبور", // Or "Password"
                              hintStyle: const TextStyle(color: FIGMA.Wrn2),

                              filled: true,
                              fillColor: FIGMA.Gray2,

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 22,
                              ), // Big height/width

                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // Curved border
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors
                                        .grey.shade700), // Darker on focus
                              ),

                              // Remove all effects (e.g., shadows, glow)
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                            ),
                            cursorColor: Colors.grey.shade700,
                            style:
                                const TextStyle(fontSize: 16, color: FIGMA.Wrn),
                          ),
                        ),
                        Column(
                          children: [
                            EasyContainer(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 95,
                              borderRadius: 15,
                              color: FIGMA.Prn,
                              onTap: () {
                                if (ssidController.text.isNotEmpty &&
                                    passController.text.isNotEmpty) {
                                  setState(() {
                                    String jsonPayload = jsonEncode({
                                      "Np": passController.text,
                                      "Ns": ssidController.text,
                                    });
                                    SingleBle().sendMain(jsonPayload);
                                    connected = true;
                                  });
                                }
                              },
                              child: const Text("ارسال اطلاعات",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: FIGMA.abreb,
                                      color: FIGMA.Wrn)),
                            ),
                            const SizedBox(height: 1),
                            EasyContainer(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 95,
                              borderRadius: 15,
                              color: FIGMA.Orn,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text("خروج",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: FIGMA.abreb,
                                      color: FIGMA.Wrn)),
                            ),
                          ],
                        ),
                      ],
              ),
            );
          }),
        ),
      );
    },
  );
}
