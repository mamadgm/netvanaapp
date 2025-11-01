// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:netvana/const/figma.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:netvana/screens/register_device_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late MobileScannerController _controller;
  late Future<void> _permissionFuture;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
    _permissionFuture = _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      // Handle denied state
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _permissionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final String? code = barcodes.first.rawValue;
                    if (code != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegisterDeviceScreen(qrCode: code),
                        ),
                      );
                    }
                  }
                },
              ),
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha(178),
                  BlendMode.srcOut,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 300.w,
                        height: 300.w,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 84.h),
                  child: Text(
                    'بارکد را در تصویر قرار دهید',
                    style: TextStyle(
                        color: FIGMA.Wrn,
                        fontSize: 15.sp,
                        fontFamily: FIGMA.estbo),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.toggleTorch();
                    });
                  },
                  icon: Icon(
                    _controller.torchEnabled ? Icons.flash_off : Icons.flash_on,
                    color: FIGMA.Wrn,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: IconButton(
                  onPressed: () => _controller.switchCamera(),
                  icon: const Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              // Add this inside your Stack in the Scaffold body
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FIGMA.Prn,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.sp),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 12.h),
                    ),
                    onPressed: () {
                      _showManualEntryDialog();
                    },
                    child: Text(
                      "ورود دستی",
                      style: TextStyle(
                        color: FIGMA.Wrn,
                        fontFamily: FIGMA.estbo,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showManualEntryDialog() {
    final TextEditingController _manualController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: FIGMA.Gray,
          title: Center(
            child: Text(
              "ورود دستی",
              style: TextStyle(
                fontFamily: FIGMA.abreb,
                fontSize: 18.sp,
                color: FIGMA.Wrn,
              ),
            ),
          ),
          content: SizedBox(
            width: 320.w,
            child: TextField(
              textAlign: TextAlign.center,
              controller: _manualController,
              decoration: InputDecoration(
                hintText: "کد را وارد کنید",
                hintStyle: TextStyle(color: FIGMA.Wrn.withOpacity(0.5)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: const BorderSide(color: FIGMA.Wrn),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                  borderSide: const BorderSide(color: FIGMA.Prn),
                ),
              ),
              style: const TextStyle(color: FIGMA.Wrn),
            ),
          ),
          actions: [
            SizedBox(
              width: 320.w,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "لغو",
                        style: TextStyle(
                            color: FIGMA.Orn,
                            fontSize: 11.sp,
                            fontFamily: FIGMA.estsb),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final code = _manualController.text.trim();
                        debugPrint(code);
                        if (code.isNotEmpty) {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RegisterDeviceScreen(qrCode: code),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "ثبت دستگاه",
                        style: TextStyle(
                            color: FIGMA.Prn,
                            fontSize: 11.sp,
                            fontFamily: FIGMA.estsb),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
