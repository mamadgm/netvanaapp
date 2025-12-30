// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui' as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/data/ble/provRegister.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:netvana/data/errors/error_login.dart';
import 'package:netvana/main.dart';
import 'package:provider/provider.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  final TextEditingController formFirst = TextEditingController();
  final TextEditingController formLast = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  double _topPadding = 300;

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisinetvana = MediaQuery.of(context).viewInsets.bottom != 0;

    if (isKeyboardVisinetvana) {
      _topPadding = 100.h;
    } else {
      _topPadding = 169.h;
    }

    // ignore: non_constant_identifier_names
    double HEIGHTTEXT = 60;
    // Check if the keyboard is visinetvana

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
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                  ), // Blur effect
                  child: Opacity(
                    opacity: 0.1, // Adjust opacity for subtlety
                    child: Transform.scale(
                      scale: 1,
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
                                  "مشخصات فردی",
                                  style: TextStyle(
                                    fontFamily: FIGMA.abrlb,
                                    fontSize: 20.sp,
                                    color: FIGMA.Wrn,
                                  ),
                                  textAlign: TextAlign.end,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  "نام و تاریخ تولد خود را برای تکمیل پروفایل وارد کنید",
                                  style: TextStyle(
                                    fontFamily: FIGMA.estre,
                                    fontSize: 14.sp,
                                    color: FIGMA.Gray4,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 13.h),
                      EyeTextField(
                        height: HEIGHTTEXT.h,
                        width: 302.w,
                        controller: formFirst,
                        hintText: "نام",
                        showEye: false,
                        hintAuto: AutofillHints.name,
                      ),
                      SizedBox(height: 7.h),
                      EyeTextField(
                        height: HEIGHTTEXT.h,
                        width: 302.w,
                        controller: formLast,
                        hintText: "نام خانوادگی",
                        showEye: false,
                        hintAuto: AutofillHints.familyName,
                      ),

                      // SizedBox(height: 7.h),
                      // EyeTextField(
                      //   height: HEIGHTTEXT.h,
                      //   width: 302.w,
                      //   controller: formUsername,
                      //   hintText: "(Amin123 مثلا) نام کاربری",
                      //   showEye: false,
                      //   hintAuto: AutofillHints.newUsername,
                      // ),
                      SizedBox(
                        height: 60.h,
                        width: 302.w,
                        child: Row(
                          children: [
                            Expanded(
                              child: EyeTextField(
                                controller: _yearController,
                                hintText: "سال تولد",
                                showEye: false,
                                center: true,
                                keyboardType: TextInputType.number,
                                hintAuto: AutofillHints.birthdayYear,
                              ),
                            ),
                            SizedBox(width: 4.sp),
                            Expanded(
                              child: EyeTextField(
                                controller: _monthController,
                                hintText: "ماه تولد",
                                showEye: false,
                                center: true,
                                keyboardType: TextInputType.number,
                                hintAuto: AutofillHints.birthdayMonth,
                              ),
                            ),
                            SizedBox(width: 4.sp),
                            Expanded(
                              child: EyeTextField(
                                controller: _dayController,
                                hintText: "روز تولد",
                                showEye: false,
                                center: true,
                                keyboardType: TextInputType.number,
                                hintAuto: AutofillHints.birthdayDay,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                        width: 302.w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Text(
                                "1390 مثلا",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FIGMA.estre,
                                  color: FIGMA.Gray3,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.sp),
                            const Expanded(
                              child: Text(
                                "5 مثلا",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FIGMA.estre,
                                  color: FIGMA.Gray3,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.sp),
                            const Expanded(
                              child: Text(
                                "29 مثلا",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FIGMA.estre,
                                  color: FIGMA.Gray3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 61.h),
                      EasyContainer(
                        height: 72.h,
                        width: 302.w,
                        color: FIGMA.Prn,
                        borderWidth: 0,
                        elevation: 0,
                        borderRadius: 17.sp,
                        padding: 0,
                        margin: 0,
                        child: Text(
                          'تکمیل ثبت نام',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: FIGMA.estsb,
                          ),
                        ),
                        onTap: () async {
                          if (!checkAll(value)) {
                            return;
                          }
                          try {
                            await NetClass()
                                .signUp(
                                  CacheService.instance.token!,
                                  formFirst.text,
                                  formLast.text,
                                  _pickedDateToIso(),
                                  "",
                                )
                                .timeout(const Duration(seconds: 45));
                            value.Show_Snackbar(
                              "حساب شما تکمیل شد",
                              1000,
                              type: 2,
                            );

                            Future.delayed(
                              const Duration(milliseconds: 1000),
                              () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const AuthWrapper(),
                                  ), // your initial screen
                                  (route) => false,
                                );
                                final provData = Provider.of<ProvData>(context);
                                provData.logoutAndReset();
                              },
                            );
                          } catch (e) {
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

  String _pickedDateToIso() {
    if (_yearController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _dayController.text.isEmpty) {
      return "";
    }
    try {
      final year = int.parse(_yearController.text);
      final month = int.parse(_monthController.text);
      final day = int.parse(_dayController.text);

      final jalaliDate = Jalali(year, month, day);
      final g = jalaliDate.toGregorian();
      final dateTime = DateTime(g.year, g.month, g.day).toUtc();
      return dateTime.toIso8601String();
    } catch (e) {
      // Return empty string if parsing fails, validation will catch it
      return "";
    }
  }

  bool checkAll(RegisterProvider value) {
    if (formFirst.text.isEmpty || formLast.text.isEmpty) {
      value.Show_Snackbar("نام و نام خانوادگی خود را وارد کنید", 1000, type: 3);
      return false;
    }

    if (_yearController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _dayController.text.isEmpty) {
      value.Show_Snackbar("تاریخ تولد خود را وارد کنید", 1000, type: 3);
      return false;
    }

    try {
      final year = int.parse(_yearController.text);
      final month = int.parse(_monthController.text);
      final day = int.parse(_dayController.text);
      final pickedDate = Jalali(year, month, day);
      final g = pickedDate.toGregorian();
      final birthDate = DateTime(g.year, g.month, g.day);
      final now = DateTime.now();
      final age =
          now.year -
          birthDate.year -
          ((now.month < birthDate.month ||
                  (now.month == birthDate.month && now.day < birthDate.day))
              ? 1
              : 0);
      if (age < 7) {
        value.Show_Snackbar("سن شما باید بیشتر از 3 سال باشد", 1000, type: 3);
        return false;
      }
    } catch (e) {
      value.Show_Snackbar("تاریخ تولد وارد شده معتبر نیست", 1000, type: 3);
      return false;
    }

    return true;
  }
}
