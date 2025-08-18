import 'package:flutter/material.dart';

class LampWidget extends StatefulWidget {
  final Color lampColor;
  final double width;
  final double height;
  final double glowIntensity;

  const LampWidget({
    super.key,
    required this.lampColor,
    this.width = 100,
    this.height = 200,
    this.glowIntensity = 1.0,
  });

  @override
  State<LampWidget> createState() => LampWidgetState();
}

class LampWidgetState extends State<LampWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shake;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Call this to trigger the shake externally
  void shake() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shake.value, 0),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top (white)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                // Middle (glowing)
                Expanded(
                  flex: 5,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: widget.width * 0.12),
                    decoration: BoxDecoration(
                      color: widget.lampColor,
                      boxShadow: [
                        BoxShadow(
                          color: widget.lampColor.withOpacity(0.8),
                          blurRadius: 100 * widget.glowIntensity,
                          spreadRadius: 20 * widget.glowIntensity,
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom (white)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
