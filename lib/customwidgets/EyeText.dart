import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';

class EyeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String hintAuto;
  final bool showEye;
  final bool center;
  final bool transparentBg;
  final TextInputType keyboardType;

  const EyeTextField({
    super.key,
    required this.controller,
    required this.hintAuto,
    this.hintText = "",
    this.showEye = true,
    this.center = false,
    this.transparentBg = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  EyeTextFieldState createState() => EyeTextFieldState();
}

class EyeTextFieldState extends State<EyeTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      autofillHints: [widget.hintAuto],
      style: TextStyle(
        fontSize: 16.sp,
        color: FIGMA.Wrn,
        fontFamily: FIGMA.estre,
      ),
      controller: widget.controller,
      obscureText: widget.showEye ? _obscureText : false,
      textAlign: widget.center ? TextAlign.center : TextAlign.right,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: FIGMA.Gray4, fontSize: 14.sp),
        filled: true,
        fillColor: widget.transparentBg ? FIGMA.Back : FIGMA.Gray2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: FIGMA.Gray2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: FIGMA.Gray2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: FIGMA.Prn),
        ),
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        prefixIcon: widget.showEye
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
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
    );
  }
}
