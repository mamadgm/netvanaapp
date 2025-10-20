import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/provMain.dart';

void showUpdate(context, ProvData value) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: FIGMA.Gray,
        title: Center(
          child: Column(
            children: [
              Image.asset("assets/Tick.png", width: 90.w, height: 90.h),
              SizedBox(height: 16.h),
              Text(
                "شما به روز هستید",
                style: TextStyle(
                    fontFamily: FIGMA.abreb, fontSize: 16.sp, color: FIGMA.Wrn),
              ),
              Text(
                "در حال حاضر از آخرین نسخه نوروانا استفاده می‌کنید",
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontFamily: FIGMA.estre,
                    fontSize: 12.sp,
                    color: FIGMA.Gray4),
              ),
              SizedBox(height: 36.h)
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EasyContainer(
                color: FIGMA.Back,
                width: 130.w,
                height: 60.h,
                elevation: 0,
                showBorder: true,
                borderColor: FIGMA.Gray2,
                borderWidth: 1.5.sp,
                borderRadius: 15,
                child: Text(
                  "برگشت",
                  style: TextStyle(
                      fontFamily: FIGMA.estbo,
                      fontSize: 14.sp,
                      color: FIGMA.Wrn),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
