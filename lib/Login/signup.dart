// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/data/ble/provRegister.dart';
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
  final TextEditingController formPass1 = TextEditingController();
  final TextEditingController formPass2 = TextEditingController();
  Jalali? pickedDate;
  String? birthLabel;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getDate() async {
    pickedDate = await showModalBottomSheet<Jalali>(
        backgroundColor: FIGMA.Gray4, // Background color from FIGMA
        context: context,
        builder: (context) {
          Jalali? tempPickedDate;
          return SizedBox(
            height: 250,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text(
                        'لغو',
                        style: TextStyle(
                            fontFamily: FIGMA.estbo,
                            color: FIGMA.Wrn,
                            fontSize: 9.sp),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: Text('تایید',
                          style: TextStyle(
                              fontFamily: FIGMA.estbo,
                              color: FIGMA.Wrn,
                              fontSize: 9.sp)),
                      onPressed: () {
                        debugPrint("date is ${tempPickedDate ?? Jalali.now()}");
                        Navigator.of(context)
                            .pop(tempPickedDate ?? Jalali.now());
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: PersianCupertinoDatePicker(
                    backgroundColor: FIGMA.Gray4, // Background color from FIGMA
                    initialDateTime: Jalali.now(),
                    mode: PersianCupertinoDatePickerMode.date,
                    onDateTimeChanged: (Jalali dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ],
            ),
          );
        });

    setState(() {
      if (pickedDate != null) {
        birthLabel = pickedDate!.formatCompactDate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 32.h),
                  // RTL text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "تکمیل اطلاعات",
                            style: TextStyle(
                              fontFamily: FIGMA.abrlb,
                              fontSize: 24.sp,
                              color: FIGMA.Wrn,
                            ),
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "شما کی هستید",
                            style: TextStyle(
                              fontFamily: FIGMA.estre,
                              fontSize: 14.sp,
                              color: FIGMA.Wrn2,
                            ),
                            textAlign: TextAlign.end,
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
                              controller: formFirst,
                              hintText: "نام",
                              showEye: false,
                            ),
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
                              controller: formLast,
                              hintText: "نام خانوادگی",
                              showEye: false,
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                            width: 320.w,
                            child: EasyContainer(
                                height: 50.h,
                                width: 320.w,
                                color: FIGMA.Prn,
                                borderWidth: 0,
                                elevation: 0,
                                padding: 0,
                                borderRadius: 17,
                                child: Text(
                                  birthLabel ?? "ورود تاریخ تولد",
                                  style: TextStyle(
                                      fontFamily: FIGMA.estbo,
                                      fontSize: 13.sp,
                                      color: FIGMA.Wrn),
                                ),
                                onTap: () async {
                                  await getDate();
                                }),
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
                              controller: formUsername,
                              hintText: "نام کاربری",
                              showEye: false,
                              center: true,
                            ),
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
                              controller: formPass1,
                              hintText: "رمز عبور",
                              showEye: true,
                              center: true,
                            ),
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
                              controller: formPass2,
                              hintText: "رمز عبور دوباره",
                              showEye: true,
                              center: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 24.w,
                      ),
                    ],
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
                      'ثبت نام',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: FIGMA.abreb,
                      ),
                    ),
                    onTap: () async {
                      if (formFirst.text.isEmpty || formLast.text.isEmpty) {
                        value.Show_Snackbar("کمترین اطلاعات نام شماست", 1000,
                            type: 2);
                      }
                      try {
                        await NetClass()
                            .signUp(
                                value.token,
                                formFirst.text,
                                formLast.text,
                                _pickedDateToIso(),
                                formUsername.text,
                                formPass1.text,
                                formPass2.text)
                            .timeout(const Duration(seconds: 10));
                        value.Show_Snackbar(
                            "اکانت شما ثبت شد , با رمز عبور وارد شوید", 2000,
                            type: 2);
                        // Wait until snackbar disappears
                        Future.delayed(const Duration(milliseconds: 2000), () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) =>
                                    const AuthWrapper()), // your initial screen
                            (route) => false,
                          );
                        });
                      } catch (e) {
                        value.Show_Snackbar("ثبت ناموفق", 1000, type: 3);
                        debugPrint(e.toString());
                      }
                    },
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

  String _pickedDateToIso() {
    if (pickedDate == null) {
      return DateTime.now().toUtc().toIso8601String();
    }
    // Convert Jalali to Gregorian
    final g = pickedDate!.toGregorian();
    final dateTime = DateTime(
      g.year,
      g.month,
      g.day,
      0,
      0,
      0,
      0,
      0,
    ).toUtc();
    return dateTime.toIso8601String(); // e.g. 2025-10-20T00:00:00.000Z
  }
}
