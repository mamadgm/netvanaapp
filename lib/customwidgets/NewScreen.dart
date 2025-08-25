import 'package:flutter/material.dart';
import 'package:netvana/const/figma.dart';

class CustomScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget header;

  const CustomScreen(
      {super.key,
      required this.title,
      required this.body,
      required this.header});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FIGMA.Back,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: header),
            Expanded(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
