import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';

class EyeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String hintAuto;
  final bool showEye;
  final bool center;
  final TextInputType keyboardType;
  final double? width;
  final double? height;
  final TextDirection defaultTextDirection;
  final TextAlign defaultTextAlign;
  final int? maxChars;
  final bool price;

  const EyeTextField({
    super.key,
    required this.controller,
    required this.hintAuto,
    this.hintText = "",
    this.showEye = true,
    this.center = false,
    this.price = false,
    this.keyboardType = TextInputType.text,
    this.width,
    this.height,
    this.defaultTextDirection = TextDirection.rtl,
    this.defaultTextAlign = TextAlign.end,
    this.maxChars,
  });

  @override
  EyeTextFieldState createState() => EyeTextFieldState();
}

class EyeTextFieldState extends State<EyeTextField> {
  bool _obscureText = true;
  TextDirection _currentDirection = TextDirection.rtl;
  TextAlign _currentAlign = TextAlign.end;

  @override
  void initState() {
    super.initState();
    _currentDirection = _calculateDirection();
    _currentAlign = _calculateAlign();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final newDirection = _calculateDirection();
    final newAlign = _calculateAlign();
    _applyPrice();
    if (newDirection != _currentDirection) {
      setState(() {
        _currentDirection = newDirection;
      });
    }
    if (newAlign != _currentAlign) {
      setState(() {
        _currentAlign = newAlign;
      });
    }
  }

  TextDirection _calculateDirection() {
    if (widget.controller.text.isEmpty) {
      return widget.defaultTextDirection;
    } else {
      final firstChar = widget.controller.text.characters.first;
      final isRtl = RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
      ).hasMatch(firstChar);
      return isRtl ? TextDirection.rtl : TextDirection.ltr;
    }
  }

  TextAlign _calculateAlign() {
    if (widget.controller.text.isNotEmpty) return TextAlign.start;
    if (widget.defaultTextDirection == TextDirection.rtl) {
      return TextAlign.end;
    } else {
      return TextAlign.start;
    }
  }

  void _applyPrice() {
    if (!widget.price) return;

    final oldText = widget.controller.text;
    final newText = prettyPrice(oldText);

    // اگر تغییر نکرده، دوباره ست نکن
    if (newText == oldText) return;

    final oldSelection = widget.controller.selection;

    // اختلاف طول متن قبل و بعد از فرمت
    final diff = newText.length - oldText.length;

    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: oldSelection.baseOffset + diff,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = widget.height != null
        ? (widget.height! - 20.h) / 2
        : 15.h;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextField(
        maxLength: widget.maxChars,
        showCursor: widget.controller.text.isNotEmpty,
        cursorOpacityAnimates: true,
        cursorColor: FIGMA.Prn,
        keyboardType: widget.keyboardType,
        autofillHints: [widget.hintAuto],
        style: TextStyle(
          fontSize: widget.price ? 18.sp : 16.sp,
          color: widget.price ? FIGMA.Wrn : FIGMA.Wrn,
          fontFamily: FIGMA.estsb,
        ),
        controller: widget.controller,
        obscureText: widget.showEye ? _obscureText : false,
        textAlign: widget.center ? TextAlign.center : _currentAlign,
        textDirection: _currentDirection,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: verticalPadding,
          ),
          isDense: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: FIGMA.Gray3,
            fontSize: 14.sp,
            fontFamily: FIGMA.estsb,
          ),
          filled: true,
          fillColor: FIGMA.Back,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            borderSide: BorderSide(color: FIGMA.Gray3, width: 1.sp),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            borderSide: BorderSide(color: FIGMA.Gray3, width: 1.sp),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            borderSide: BorderSide(color: FIGMA.Gray4, width: 1.1.sp),
          ),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          prefixIcon: widget.showEye
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

String prettyPrice(String input) {
  // Remove any existing commas first (just in case)
  String clean = input.replaceAll(',', '');

  // Parse to int and format with commas
  int number = int.parse(clean);
  return number.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match.group(1)},',
  );
}

String prettyKilogram(double? grams, {bool withUnit = true}) {
  if (grams == null) {
    return "نامشخص";
  }
  if (grams == 0) {
    return withUnit ? "0 کیلوگرم" : "0";
  }
  double kilograms = grams / 1000;
  // Use toStringAsFixed to control the number of decimal places
  // If the number is an integer, show 0 decimal places, otherwise show 2
  String result = kilograms.toStringAsFixed(
    kilograms.truncateToDouble() == kilograms ? 0 : 2,
  );
  if (withUnit) {
    return "$result کیلوگرم";
  }
  return result;
}
