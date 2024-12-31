import 'package:flutter/material.dart';
import 'dart:async';

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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(15, (index) {
        if (index < widget.progress) {
          return _buildRectangle(Colors.green);
        } else if (index == widget.progress) {
          return _buildBlinkingRectangle();
        } else {
          return _buildRectangle(Colors.grey);
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
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildBlinkingRectangle() {
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _isBlinking ? Colors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
