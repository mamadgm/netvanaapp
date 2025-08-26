import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:netvana/customwidgets/NewScreen.dart';
import 'package:netvana/customwidgets/cylander.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:netvana/models/SingleHive.dart';

void showAccount(context, ProvData value) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CustomScreen(
        header: Row(
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
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.sp,
                color: FIGMA.Gray4,
              ),
            ),
            Text(
              "حساب کاربری",
              style: TextStyle(
                  fontSize: 16.sp, fontFamily: FIGMA.abrlb, color: FIGMA.Wrn2),
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
              onTap: () async {
                try {
                  await NetClass().editUserName(SdcardService.instance.token!,
                      value.UserNameController.text);
                  value.Show_Snackbar("اطلاعات ویرایش شد", 1000, type: 2);
                } catch (e) {
                  value.Show_Snackbar("مشکلی پیش آمد", 1000, type: 3);
                }
              },
            ),
          ],
        ),
        title: "حساب کاربری",
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8.h),
            SizedBox(
              width: 329.w,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "نام کاربری",
                  style: TextStyle(
                      fontFamily: FIGMA.estsb,
                      fontSize: 12.sp,
                      color: FIGMA.Gray4),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            SizedBox(
              height: 68.h,
              width: 329.w,
              child: EyeTextField(
                controller: value.UserNameController,
                showEye: false,
                hintText: "username",
              ),
            ),
            EasyContainer(
                height: 68.h,
                width: 329.w,
                color: FIGMA.Gray2,
                borderRadius: 20,
                elevation: 0,
                margin: 0,
                padding: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${SdcardService.instance.user!.phone}",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: FIGMA.Wrn,
                          fontFamily: FIGMA.estsb),
                    ),
                    Text(
                      ":شماره تلفن",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: FIGMA.Gray4,
                          fontFamily: FIGMA.estre),
                    ),
                  ],
                )),
            SizedBox(height: 12.h),
            EasyContainer(
                height: 190.h,
                width: 329.w,
                color: FIGMA.Gray2,
                borderRadius: 20,
                elevation: 0,
                margin: 0,
                padding: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 34.h,
                      width: 293.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "لیست دستگاه های خریداری شده",
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: FIGMA.Gray4,
                              fontFamily: FIGMA.estre),
                        ),
                      ),
                    ),
                    EasyContainer(
                        height: 130.h,
                        width: 293.w,
                        color: FIGMA.Back,
                        borderRadius: 20,
                        elevation: 0,
                        margin: 0,
                        padding: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(height: 16.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text('نوران',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: FIGMA.Wrn,
                                            fontFamily: FIGMA.estsb)),
                                  ),
                                  Text(
                                      "${SdcardService.instance.firstDevice!.categoryName}-${SdcardService.instance.firstDevice!.partNumber} :نام دستگاه",
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: FIGMA.Gray4,
                                          fontFamily: FIGMA.estre)),
                                  const Spacer(),
                                  Text(
                                      "${SdcardService.instance.firstDevice!.macAddress} :سریال نامبر",
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: FIGMA.Gray4,
                                          fontFamily: FIGMA.estre)),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            ),
                            EasyContainer(
                                height: 110.h,
                                width: 100.w,
                                color: FIGMA.Gray2,
                                borderRadius: 20,
                                elevation: 0,
                                margin: 0,
                                padding: 4,
                                child: SizedBox(
                                    height: 70.h,
                                    width: 40.w,
                                    child: LampWidget(lampColor: FIGMA.Prn))),
                            SizedBox(width: 6.w),
                          ],
                        ))
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}
