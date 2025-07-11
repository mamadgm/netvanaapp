import 'package:netvana/Rawlibs/hsv/hsv_color_pickers.dart';
import 'package:netvana/Rawlibs/hsv/src/common.dart';
import 'package:flutter/material.dart';

/// This class defines a slider for picking the hue of a [HSVColor].
class HuePicker extends StatefulWidget {
  /// The initial [HSVColor] which should be set on the color slider. Either this
  /// color should be set at the beginning, or [initialColor].
  final HSVColor? initialColor;

  /// Controller to control (get/set) the value of the [HuePicker] from outside
  /// of the widget.
  final HueController? controller;

  /// The height of the slider's track.
  ///
  /// Defaults to 15px.
  final double trackHeight;

  /// Callback which is triggered on every change of the color slider's value.
  /// Check [Slider.onChanged].
  final HSVColorChange? onChanged;

  /// Callback which is triggered when the user starts dragging.
  /// Check [Slider.onChangeStart].
  final HSVColorChange? onChangeStart;

  /// Callback which is triggered when the user finishes dragging.
  /// Check [Slider.onChangeEnd].
  final HSVColorChange? onChangeEnd;

  /// The [RoundSliderThumbShape] that should be used for the slider.
  /// It is recommended to use [HueSliderThumbShape] and parametrise it
  /// accordingly.
  ///
  /// Defaults to `HueSliderThumbShape()`.
  final RoundSliderThumbShape thumbShape;

  /// The color shown around the thumb when it is being dragged.
  final Color? thumbOverlayColor;

  /// Creates an instance of [HuePicker].
  const HuePicker({
    Key? key,
    this.initialColor,
    this.controller,
    this.trackHeight = 15,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.thumbShape = const HueSliderThumbShape(),
    this.thumbOverlayColor,
  })  : assert((initialColor != null) ^ (controller != null),
            "Either initialColor or controller must be set, but not both."),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HuePickerState();
  }
}

class _HuePickerState extends State<HuePicker> {
  late HueController _controller;

  final List<Color> hueColors = [
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 255, 0, 255),
    const Color.fromARGB(255, 255, 0, 0),
  ];

  @override
  void initState() {
    super.initState();
    // We know that either `widget.initialColor` or `widget.controller` must be
    // defined.
    // Thus, if controller not defined, initialise it with initialColor.
    _controller = widget.controller ?? HueController(widget.initialColor!);

    _controller.addListener(() {
      widget.onChanged?.call(_controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.trackHeight,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: hueColors),
          borderRadius: BorderRadius.circular(80)),
      child: SliderTheme(
        data: SliderThemeData(
          trackShape: HueTrackShape(),
          thumbColor: Colors.white,
          activeTrackColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          thumbShape: widget.thumbShape,
          overlayColor: widget.thumbOverlayColor,
        ),
        child: Slider(
          min: 0.0,
          max: 360.0,
          value: _controller.value.hue,
          onChanged: (hue) {
            _controller.value = _controller.value.withHue(hue);
            widget.onChanged?.call(_controller.value);
          },
          onChangeStart: (_) => widget.onChangeStart?.call(_controller.value),
          onChangeEnd: (_) => widget.onChangeEnd?.call(_controller.value),
        ),
      ),
    );
  }
}

/// Defines a custom track shape for the hue-[Slider].
/// Lets the slider thumb slide until the exact end of the slider.
class HueTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx +
        sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width /
            2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width -
        sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

/// Defines a custom thumb shape for a [Slider].
class HueSliderThumbShape extends RoundSliderThumbShape {
  /// The radius of the slider thumb.
  ///
  /// Defaults to 10.
  final double radius;

  /// Whether the thumb should be filled or not on the inside.
  ///
  /// Defaults to `true`.
  final bool filled;

  /// Main color of the thumb (either fill color or stroke color if filled: `false`).
  ///
  /// Defaults to [Colors.white].
  final Color color;

  /// Width of the stroke, if filled is set to `false`.
  ///
  /// Defaults to 3.
  final double strokeWidth;

  /// Whether an additional border should be shown around the thumb.
  ///
  /// Defaults to `false`.
  final bool showBorder;

  /// The [Color] of the additional border around the thumb.
  ///
  /// Defaults to [Colors.black].
  final Color borderColor;

  /// The width of the border.
  ///
  /// Defaults to 1.
  final double borderWidth;

  /// Creates an instance of [HueSliderThumbShape].
  const HueSliderThumbShape({
    this.radius = 10,
    this.filled = true,
    this.color = Colors.white,
    this.strokeWidth = 3,
    this.showBorder = false,
    this.borderColor = Colors.black,
    this.borderWidth = 1,
  }) : super(enabledThumbRadius: radius);

  /// Copied from [RoundSliderThumbShape.paint] and modified.
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: disabledThumbRadius ?? enabledThumbRadius,
      end: enabledThumbRadius,
    );

    final double radius = radiusTween.evaluate(enableAnimation);

    var circlePaint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;

    if (!filled) {
      circlePaint.strokeWidth = strokeWidth;
    }

    // draw main thumb circle
    canvas.drawCircle(
        center, showBorder ? radius - borderWidth : radius, circlePaint);

    if (showBorder) {
      // if border should be shown, draw it around existing circle
      var borderRadius = radius - borderWidth;
      if (!filled) {
        borderRadius = borderRadius + strokeWidth / 2;
      }
      canvas.drawCircle(
        center,
        borderRadius,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }
  }
}
