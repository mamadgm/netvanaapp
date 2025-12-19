import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/provMain.dart';

void showAboutUs(context, ProvData value) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: FIGMA.Gray,
        title: Center(
          child: Column(
            children: [
              Text(
                "نوروانا چیست؟",
                style: TextStyle(
                  fontFamily: FIGMA.abreb,
                  fontSize: 16.sp,
                  color: FIGMA.Wrn,
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            child: Text(
              "استارتاپی در زمینه طراحی تجربه های گجت های روشنایی است."
              "محصولاتی مثل نوران دارد که تکنولوژی ها و ویژگی های نرم افزاری نوروانا درون خود جا داده است\n"
              "تمرکز اصلی نوروانا روی طراحی ویژگی ها و تبدیل اون به گجت هست که تجربه ای از خلق هنر با نور به وجود بیاره",
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 12.sp,
                color: FIGMA.Wrn2,
                fontFamily: FIGMA.estre,
              ),
            ),
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
                    color: FIGMA.Wrn,
                  ),
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
