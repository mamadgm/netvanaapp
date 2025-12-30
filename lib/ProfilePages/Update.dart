import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:provider/provider.dart';

void showUpdate(context, ProvData value) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: FIGMA.Gray,
        title: Center(
          child: Column(
            children: [
              Icon(Icons.exit_to_app_rounded, color: FIGMA.Orn, size: 48.sp),
              SizedBox(height: 16.h),
              Text(
                "خروج از اکانت",
                style: TextStyle(
                  fontFamily: FIGMA.abreb,
                  fontSize: 16.sp,
                  color: FIGMA.Wrn,
                ),
              ),
              Text(
                "آیا از خروج از حساب کاربری مطمئن هستید؟ ",
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: FIGMA.estre,
                  fontSize: 12.sp,
                  color: FIGMA.Gray4,
                ),
              ),
              SizedBox(height: 10.h),
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
                borderColor: FIGMA.Orn,
                borderWidth: 1.5.sp,
                borderRadius: 15,
                child: Text(
                  "خروج از حساب",
                  style: TextStyle(
                    fontFamily: FIGMA.estbo,
                    fontSize: 14.sp,
                    color: FIGMA.Orn,
                  ),
                ),
                onTap: () async {
                  final prov = Provider.of<ProvData>(context, listen: false);
                  await CacheService.instance.saveToken(null);
                  prov.logoutAndReset();
                  prov.Show_Snackbar(
                    "خارج شدید , صفحه را مجدد بارگزاری کنید",
                    1000,
                  );
                  Navigator.of(context).pop();
                },
              ),
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
