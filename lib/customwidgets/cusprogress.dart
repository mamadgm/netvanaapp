import 'package:flutter/material.dart';
import 'dart:async';
import 'package:netvana/const/figma.dart';

class CusProgressBar extends StatefulWidget {
  final int progress;

  const CusProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  CusProgressBarState createState() => CusProgressBarState();
}

class CusProgressBarState extends State<CusProgressBar> {
  bool _isBlinking = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isBlinking = !_isBlinking;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.progress == -100) {
      return _buildRectangle(Colors.transparent);
    } else if (widget.progress == -69) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(15, (index) => _buildBlinkingRectangle()),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(15, (index) {
        if (index < widget.progress) {
          return _buildRectangle(FIGMA.Prn);
        } else if (index == widget.progress) {
          return _buildBlinkingRectangle();
        } else {
          return _buildRectangle(FIGMA.Gray);
        }
      }),
    );
  }

  Widget _buildRectangle(Color color) {
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildBlinkingRectangle() {
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _isBlinking ? FIGMA.Prn : FIGMA.Gray,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
