// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui' as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netvana/Login/otp_check.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/data/ble/provRegister.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  late TextEditingController formphone;
  double _topPadding = 300;

  @override
  void initState() {
    super.initState();
    formphone = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is visinetvana
    bool isKeyboardVisinetvana = MediaQuery.of(context).viewInsets.bottom != 0;

    if (isKeyboardVisinetvana) {
      _topPadding = 100;
    } else {
      _topPadding = 300;
    }

    return Consumer<RegisterProvider>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: FIGMA.Back, // Background color from FIGMA
        resizeToAvoidBottomInset:
            false, // Prevent resizing when keyboard appears
        body: Stack(
          children: [
            Positioned(
              left: -100,
              top: -100,
              child: ClipRect(
                clipBehavior: Clip.antiAlias,
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                      sigmaX: 20.0, sigmaY: 20.0), // Blur effect
                  child: Opacity(
                    opacity: 0.1, // Adjust opacity for subtlety
                    child: Transform.scale(
                      scale: 1,
                      child: RotatedBox(
                        quarterTurns: 90,
                        child: SvgPicture.asset(
                          'assets/pattern.svg', // Replace with your SVG file path
                          width:
                              MediaQuery.of(context).size.width, // Full width
                          fit: BoxFit.cover, // Maintain aspect ratio
                          colorFilter: const ColorFilter.mode(Colors.white70,
                              BlendMode.srcIn), // Lighten the pattern
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Existing content in a SingleChildScrollView
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: _topPadding),
                  // RTL text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "ثبت نام در نوروانا",
                            style: TextStyle(
                              fontFamily: FIGMA.abrlb,
                              fontSize: 24.sp,
                              color: FIGMA.Wrn,
                            ),
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            "شماره تلفن همراه خود را وارد کنید",
                            style: TextStyle(
                              fontFamily: FIGMA.estre,
                              fontSize: 14.sp,
                              color: FIGMA.Wrn2,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  EasyContainer(
                    height: 68.h,
                    width: 320.w,
                    color: Colors.black12.withOpacity(0),
                    borderWidth: 0,
                    elevation: 0,
                    padding: 0,
                    margin: 0,
                    borderRadius: 0,
                    child: EyeTextField(
                      controller: formphone,
                      hintText: "شماره تلفن",
                      showEye: false,
                    ),
                  ),
                  EasyContainer(
                    height: 68.h,
                    width: 320.w,
                    color: FIGMA.Prn,
                    borderWidth: 0,
                    elevation: 0,
                    padding: 0,
                    borderRadius: 17,
                    child: Text(
                      'ارسال کد تایید',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: FIGMA.abreb,
                      ),
                    ),
                    onTap: () async {
                      debugPrint("Sending...");
                      try {
                        await NetClass()
                            .sendOtp(formphone.text)
                            .timeout(const Duration(seconds: 45));

                        value.setPhoneNumber(formphone.text);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const OtpCheck(),
                          ),
                        );
                      } catch (e) {
                        debugPrint("error otp send $e");
                        value.Show_Snackbar("کد ارسال نشد", 1000, type: 3);
                      }
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    height: 68.h,
                  ),
                ],
              ),
            ),
            // SVG pattern layer
          ],
        ),
      ),
    );
  }
}
