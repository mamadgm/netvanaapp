import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:provider/provider.dart';

class RegisterDeviceScreen extends StatefulWidget {
  final String qrCode;

  const RegisterDeviceScreen({super.key, required this.qrCode});

  @override
  State<RegisterDeviceScreen> createState() => _RegisterDeviceScreenState();
}

enum RegisterResult {
  success,
  error,
}

class _RegisterDeviceScreenState extends State<RegisterDeviceScreen> {
  late Future<RegisterResult> _registerFuture;

  @override
  void initState() {
    super.initState();
    _registerFuture = _performRegistration();
  }

  Future<RegisterResult> _performRegistration() async {
    try {
      final token = CacheService.instance.token;
      if (token == null) {
        return RegisterResult.error;
      }
      final result = await NetClass().registerDevice(token, widget.qrCode);
      if (result != null) {
        return RegisterResult.success;
      } else {
        return RegisterResult.error;
      }
    } catch (e) {
      return RegisterResult.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RegisterResult>(
      future: _registerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: FIGMA.Back,
              body: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '...در حال ثبت دستگاه',
                      style: TextStyle(
                          fontFamily: FIGMA.estbo,
                          color: FIGMA.Wrn,
                          fontSize: 15.sp),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 48.sp,
                      height: 48.sp,
                      child: const CircularProgressIndicator(
                        color: FIGMA.Orn,
                        strokeWidth: 8,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(height: 16 + 68.h + 68.h + 6.h),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == RegisterResult.error) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: FIGMA.Back,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 48.h),
                    Text(
                      'مشکلی در ثبت پیش آمد',
                      style: TextStyle(
                          fontFamily: FIGMA.estbo,
                          color: FIGMA.Orn,
                          fontSize: 18.sp),
                    ),
                    SizedBox(height: 4.h),
                    Center(
                      child: SizedBox(
                        width: 300.w,
                        child: Text(
                          'درخاست های مکرر نا مربوط باعث بلاک شدن اکانت می شود',
                          style: TextStyle(
                              fontFamily: FIGMA.estsb,
                              color: FIGMA.Wrn,
                              fontSize: 14.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      LucideIcons.packageX,
                      color: FIGMA.Orn,
                      size: 48.sp,
                    ),
                    const Spacer(),
                    SizedBox(height: 4.h),
                    const Spacer(),
                    EasyContainer(
                      height: 68.h,
                      width: 320.w,
                      color: FIGMA.Orn,
                      borderWidth: 0,
                      elevation: 0,
                      padding: 0,
                      borderRadius: 17,
                      child: Text(
                        'برگشت',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontFamily: FIGMA.abreb,
                        ),
                      ),
                      onTap: () {
                        final provData =
                            Provider.of<ProvData>(context, listen: false);
                        provData.logoutAndReset();
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final provData = Provider.of<ProvData>(context, listen: false);
          provData.logoutAndReset();
          await Future.delayed(const Duration(seconds: 2));
          Navigator.of(context).pop();
          await setup(provData);
        });

        return SafeArea(
          child: Scaffold(
            backgroundColor: FIGMA.Back,
            body: Center(
              child: Text(
                'دستگاه با موفقیت ثبت شد',
                style: TextStyle(
                  fontFamily: FIGMA.estbo,
                  color: FIGMA.Wrn,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
