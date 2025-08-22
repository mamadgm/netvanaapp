import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';

class CustomScreen extends StatelessWidget {
  final String title;
  final Widget body;

  const CustomScreen({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FIGMA.Back,
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Top Row (Not AppBar)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EasyContainer(
                    height: 64.h,
                    width: 64.w,
                    color: FIGMA.Back,
                    showBorder: true,
                    borderWidth: 1.sp,
                    borderColor: FIGMA.Gray2,
                    borderRadius: 20,
                    elevation: 0,
                    margin: 0,
                    padding: 0,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20.sp,
                      color: FIGMA.Gray4,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: FIGMA.abrlb,
                        color: FIGMA.Wrn2),
                  ),
                  EasyContainer(
                    height: 64.h,
                    width: 64.w,
                    color: FIGMA.Back,
                    showBorder: true,
                    borderWidth: 1.sp,
                    borderColor: FIGMA.Gray2,
                    borderRadius: 20,
                    elevation: 0,
                    margin: 0,
                    padding: 0,
                    child: Icon(
                      Icons.edit_rounded,
                      size: 20.sp,
                      color: FIGMA.Gray4,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
