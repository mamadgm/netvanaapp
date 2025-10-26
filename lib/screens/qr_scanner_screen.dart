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
                    _controller.torchEnabled
                        ? Icons.flash_off
                        : Icons.flash_on,
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
            ],
          );
        },
      ),
    );
  }
}
