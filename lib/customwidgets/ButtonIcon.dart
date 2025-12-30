import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';

class WiFiItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final IconData? trailingIcon;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;

  const WiFiItem({
    Key? key,
    required this.leadingIcon,
    required this.title,
    this.trailingIcon,
    required this.onTap,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyContainer(
      elevation: 0,
      height: 68.h,
      width: 329.w,
      borderRadius: 15,
      padding: 20,
      showBorder: true,
      borderColor: borderColor ?? FIGMA.Gray2,
      color: backgroundColor ?? FIGMA.Back,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(leadingIcon, color: FIGMA.Gray2, size: 18.sp),
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor ?? FIGMA.Wrn,
                  fontFamily: FIGMA.estsb,
                  fontSize: 14.sp,
                ),
              ),
              if (trailingIcon != null) ...[
                SizedBox(width: 8.w),
                Icon(trailingIcon, color: textColor ?? FIGMA.Wrn, size: 24.sp),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final IconData? trailingIcon;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;

  const SettingItem({
    Key? key,
    required this.leadingIcon,
    required this.title,
    this.trailingIcon,
    required this.onTap,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyContainer(
      elevation: 0,
      height: 55.h,
      width: 329.w,
      borderRadius: 15,
      padding: 20,
      borderColor: borderColor ?? FIGMA.Gray2,
      color: backgroundColor ?? FIGMA.Back,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(leadingIcon, color: FIGMA.Gray2, size: 18.sp),
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor ?? FIGMA.Wrn,
                      fontFamily: FIGMA.estsb,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    SizedBox(width: 8.w),
                    Icon(
                      trailingIcon,
                      color: textColor ?? FIGMA.Wrn,
                      size: 24.sp,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
