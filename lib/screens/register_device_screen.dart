// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_container/easy_container.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:provider/provider.dart';

enum RegisterState {
  start,
  loading,
  error,
  success,
}

class RegisterDeviceScreen extends StatefulWidget {
  const RegisterDeviceScreen({super.key});

  @override
  State<RegisterDeviceScreen> createState() => _RegisterDeviceScreenState();
}

class _RegisterDeviceScreenState extends State<RegisterDeviceScreen> {
  final TextEditingController _codeController = TextEditingController();
  RegisterState _state = RegisterState.start;
  String _errorMessage = '';

  Future<void> _registerDevice() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _state = RegisterState.loading;
      _errorMessage = '';
    });

    try {
      final token = CacheService.instance.token;
      if (token == null) {
        throw Exception("Missing token");
      }

      final result = await NetClass().registerDevice(token, code);

      if (result != null) {
        setState(() => _state = RegisterState.success);
        await Future.delayed(const Duration(seconds: 2));

        final provData = Provider.of<ProvData>(context, listen: false);
        provData.logoutAndReset();
        Navigator.of(context).pop();
        await setup(provData);
      } else {
        throw Exception("No result");
      }
    } catch (e) {
      setState(() {
        _state = RegisterState.error;
        _errorMessage = "کد وارد شده اشتباه است یا ارتباط برقرار نشد";
      });
    }
  }

  Widget _buildStart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "ثبت دستگاه",
          style: TextStyle(
            fontFamily: FIGMA.estbo,
            fontSize: 20.sp,
            color: FIGMA.Wrn,
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: 320.w,
          child: TextField(
            controller: _codeController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "کد دستگاه را وارد کنید",
              hintStyle: TextStyle(
                color: FIGMA.Wrn.withOpacity(0.4),
                fontFamily: FIGMA.estsb,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.sp),
                borderSide: const BorderSide(color: FIGMA.Wrn),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.sp),
                borderSide: const BorderSide(color: FIGMA.Prn),
              ),
            ),
            style: TextStyle(
              color: FIGMA.Wrn,
              fontFamily: FIGMA.estsb,
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(height: 30.h),
        EasyContainer(
          height: 68.h,
          width: 320.w,
          color: FIGMA.Prn,
          borderRadius: 17,
          elevation: 0,
          padding: 0,
          onTap: _registerDevice,
          child: Text(
            'ثبت دستگاه',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: FIGMA.abreb,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '...در حال ثبت دستگاه',
          style: TextStyle(
            fontFamily: FIGMA.estbo,
            color: FIGMA.Wrn,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: 48.sp,
          height: 48.sp,
          child: const CircularProgressIndicator(
            color: FIGMA.Orn,
            strokeWidth: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.packageX, color: FIGMA.Orn, size: 56.sp),
        SizedBox(height: 12.h),
        Text(
          'مشکلی در ثبت پیش آمد',
          style: TextStyle(
            fontFamily: FIGMA.estbo,
            color: FIGMA.Orn,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: 280.w,
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FIGMA.estsb,
              color: FIGMA.Wrn,
              fontSize: 13.sp,
            ),
          ),
        ),
        SizedBox(height: 30.h),
        EasyContainer(
          height: 68.h,
          width: 320.w,
          color: FIGMA.Orn,
          borderWidth: 0,
          elevation: 0,
          borderRadius: 17,
          child: Text(
            'تلاش مجدد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: FIGMA.abreb,
            ),
          ),
          onTap: () {
            setState(() {
              _state = RegisterState.start;
              _errorMessage = '';
            });
          },
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.checkCircle, color: FIGMA.Prn, size: 56.sp),
        SizedBox(height: 12.h),
        Text(
          'دستگاه با موفقیت ثبت شد',
          style: TextStyle(
            fontFamily: FIGMA.estbo,
            color: FIGMA.Wrn,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (_state) {
      case RegisterState.start:
        body = _buildStart();
        break;
      case RegisterState.loading:
        body = _buildLoading();
        break;
      case RegisterState.error:
        body = _buildError();
        break;
      case RegisterState.success:
        body = _buildSuccess();
        break;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: FIGMA.Back,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: body,
          ),
        ),
      ),
    );
  }
}
