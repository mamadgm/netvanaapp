// ignore_for_file: file_names

import 'dart:ui' as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netvana/Login/otp_check.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/data/errors/error_login.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
      _topPadding = 100.h;
    } else {
      _topPadding = 281.h;
    }

    return Consumer<ProvData>(
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
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                    tileMode: TileMode.clamp,
                  ), // Blur effect
                  child: Opacity(
                    opacity: 0.18, // Adjust opacity for subtlety
                    child: Transform.scale(
                      scale: 1.2,
                      child: RotatedBox(
                        quarterTurns: 90,
                        child: SvgPicture.asset(
                          'assets/pattern.svg', // Replace with your SVG file path
                          width: MediaQuery.of(
                            context,
                          ).size.width, // Full width
                          fit: BoxFit.cover, // Maintain aspect ratio
                          colorFilter: const ColorFilter.mode(
                            Colors.white70,
                            BlendMode.srcIn,
                          ), // Lighten the pattern
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Existing content in a SingleChildScrollView
            SingleChildScrollView(
              child: AutofillGroup(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: _topPadding),
                      // RTL text
                      SizedBox(
                        width: 302.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "خوش آمدید",
                                  style: TextStyle(
                                    fontFamily: FIGMA.abrlb,
                                    fontSize: 20.sp,
                                    color: FIGMA.Wrn,
                                  ),
                                  textAlign: TextAlign.end,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  "لطفا شماره موبایل همراه خود را وارد کنید ",
                                  style: TextStyle(
                                    fontFamily: FIGMA.estre,
                                    fontSize: 14.sp,
                                    color: FIGMA.Gray4,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 27.h),
                      EyeTextField(
                        maxChars: 11,
                        width: 302.w,
                        height: 68.h,
                        controller: formphone,
                        hintText: "شماره تلفن",
                        showEye: false,
                        hintAuto: AutofillHints.telephoneNumber,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 80.h),
                      EasyContainer(
                        height: 74.h,
                        width: 302.w,
                        color: FIGMA.Prn,
                        borderWidth: 0,
                        elevation: 0,
                        padding: 0,
                        borderRadius: 17.sp,
                        child: Text(
                          'دریافت کد تایید',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: FIGMA.estbo,
                          ),
                        ),
                        onTap: () async {
                          try {
                            showLoading(context);
                            await NetClass()
                                .sendOtp(formphone.text)
                                .timeout(const Duration(seconds: 30));
                            hideLoading(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    OtpCheck(phoneNumber: formphone.text),
                              ),
                            );
                          } catch (e) {
                            hideLoading(context);
                            final detail = extractDetailFromException(e);
                            value.Show_Snackbar(detail!, 1000, type: 3);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // SVG pattern layer
            ),
          ],
        ),
      ),
    );
  }
}
