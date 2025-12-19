// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui' as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/data/ble/provRegister.dart';
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
  final TextEditingController formUsername = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double HEIGHTTEXT = 44;
    double HEIGHTTEXTPADDING = 4;
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
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    // RTL text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "ثبت نام",
                              style: TextStyle(
                                fontFamily: FIGMA.abrlb,
                                fontSize: 16.sp,
                                color: FIGMA.Wrn,
                              ),
                              textAlign: TextAlign.end,
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              "کد پیامک شده را وارد کنید",
                              style: TextStyle(
                                fontFamily: FIGMA.estre,
                                fontSize: 14.sp,
                                color: FIGMA.Wrn2,
                              ),
                              textAlign: TextAlign.end,
                            ),

                            Text(
                              "شما کی هستید",
                              style: TextStyle(
                                fontFamily: FIGMA.estre,
                                fontSize: 14.sp,
                                color: FIGMA.Wrn2,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            EyeTextField(
                              height: HEIGHTTEXT.h,
                              width: 320.w,
                              controller: formFirst,
                              hintText: "نام",
                              showEye: false,
                              hintAuto: AutofillHints.name,
                            ),
                            EyeTextField(
                              height: HEIGHTTEXT.h,
                              width: 320.w,
                              controller: formLast,
                              hintText: "نام خانوادگی",
                              showEye: false,
                              hintAuto: AutofillHints.familyName,
                            ),
                            SizedBox(
                              height: 60.h,
                              width: 320.w,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: EyeTextField(
                                      controller: _dayController,
                                      hintText: "روز",
                                      showEye: false,
                                      center: true,
                                      keyboardType: TextInputType.number,
                                      hintAuto: AutofillHints.birthdayDay,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: EyeTextField(
                                      controller: _monthController,
                                      hintText: "ماه",
                                      showEye: false,
                                      center: true,
                                      keyboardType: TextInputType.number,
                                      hintAuto: AutofillHints.birthdayMonth,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: EyeTextField(
                                      controller: _yearController,
                                      hintText: "سال",
                                      showEye: false,
                                      center: true,
                                      keyboardType: TextInputType.number,
                                      hintAuto: AutofillHints.birthdayYear,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              "این اطلاعات یادتون نره",
                              style: TextStyle(
                                fontFamily: FIGMA.estre,
                                fontSize: 14.sp,
                                color: FIGMA.Wrn2,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            EyeTextField(
                              height: HEIGHTTEXT.h,
                              width: 320.w,
                              controller: formUsername,
                              hintText: "نام کاربری",
                              showEye: false,
                              center: true,
                              hintAuto: AutofillHints.newUsername,
                            ),
                          ],
                        ),
                        SizedBox(width: 24.w),
                      ],
                    ),
                    EasyContainer(
                      height: HEIGHTTEXT.h,
                      width: 320.w,
                      color: FIGMA.Prn,
                      borderWidth: 0,
                      elevation: 0,
                      padding: HEIGHTTEXTPADDING,
                      borderRadius: 11,
                      child: Text(
                        'ثبت نام',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
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
                                value.token,
                                formFirst.text,
                                formLast.text,
                                _pickedDateToIso()!,
                                formUsername.text,
                              )
                              .timeout(const Duration(seconds: 45));
                          value.Show_Snackbar(
                            "اکانت شما ثبت شد , با رمز عبور وارد شوید",
                            2000,
                            type: 2,
                          );
                          // Wait until snackbar disappears
                          Future.delayed(
                            const Duration(milliseconds: 2000),
                            () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const AuthWrapper(),
                                ), // your initial screen
                                (route) => false,
                              );
                            },
                          );
                        } catch (e) {
                          final detail = extractDetailFromException(e);
                          value.Show_Snackbar(detail!, 1000, type: 3);
                        }
                      },
                    ),
                    SizedBox(height: 350.h),
                  ],
                ),
              ),
              // SVG pattern layer
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _pickedDateToIso() {
    if (_yearController.text.isEmpty ||
        _monthController.text.isEmpty ||
        _dayController.text.isEmpty) {
      return null;
    }
    try {
      final year = int.parse(_yearController.text);
      final month = int.parse(_monthController.text);
      final day = int.parse(_dayController.text);

      final jalaliDate = Jalali(year, month, day);
      final g = jalaliDate.toGregorian();
      final dateTime = DateTime(g.year, g.month, g.day).toUtc();
      return dateTime;
    } catch (e) {
      // Return empty string if parsing fails, validation will catch it
      return null;
    }
  }

  bool checkAll(RegisterProvider value) {
    final usernameRegex = RegExp(r'^[A-Za-z][A-Za-z0-9]{4,}$');

    if (formFirst.text.isEmpty || formLast.text.isEmpty) {
      value.Show_Snackbar("نام و نام خانوادگی خود را وار کنید", 1000, type: 3);
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

    if (!usernameRegex.hasMatch(formUsername.text)) {
      value.Show_Snackbar(
        "نام کاربری باید با حروف انگلیسی شروع شود و حداقل 3 کاراکتر باشد",
        1500,
        type: 3,
      );
      return false;
    }

    return true;
  }
}
