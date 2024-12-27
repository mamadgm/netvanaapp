import 'package:flutter/material.dart';

class NetvanaScreen extends StatelessWidget {
  const NetvanaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double MaxScreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: (MaxScreenWidth * 0.95) * 0.40,
                width: MaxScreenWidth * 0.95,
                color: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
