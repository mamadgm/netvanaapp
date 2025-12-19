// ignore_for_file: non_constant_identifier_names
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';
import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  String phoneNumber = "";
  void setPhoneNumber(String PhoneNumber) {
    phoneNumber = PhoneNumber;
    notifyListeners();
  }

  String token = "";
  void setToken(String Token) {
    token = Token;
    notifyListeners();
  }

  void Show_Snackbar(String value, int dur, {int type = 1}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: _getSnackBarColor(type),
        duration: Duration(milliseconds: dur),
        content: _buildSnackBarContent(type, value),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Color _getSnackBarColor(int type) {
    if (type == 1) {
      return FIGMA.Grn; // Info Notification
    } else if (type == 2) {
      return FIGMA.Prn2; // Success Notification
    } else if (type == 3) {
      return FIGMA.Orn; // Error Notification
    }
    return FIGMA.Back; // Default
  }

  Widget _buildSnackBarContent(int value, String mes) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            _getSnackBarIcon(value), // Add icons for different types
            color: Colors.white,
            size: 24.sp,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mes,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: FIGMA.estre,
                fontSize: 13.sp,
                color: FIGMA.Wrn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSnackBarIcon(int message) {
    if (message == 2) {
      return Icons.check_box_rounded; // Success icon
    } else if (message == 3) {
      return Icons.warning_amber_rounded; // Error icon
    }
    return Icons.info; // Default info icon
  }
}
