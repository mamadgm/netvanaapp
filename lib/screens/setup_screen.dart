import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/screens/no_devices_screen.dart';
import 'package:provider/provider.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

enum SetupResult {
  success,
  noDevices,
  error,
}

class _SetupScreenState extends State<SetupScreen> {
  late Future<SetupResult> _setupFuture;

  @override
  void initState() {
    super.initState();
    _setupFuture = _performSetup();
  }

  Future<SetupResult> _performSetup() async {
    try {
      final provData = Provider.of<ProvData>(context, listen: false);
      final result = await setup(provData);
      return result;
    } catch (e) {
      return SetupResult.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SetupResult>(
      future: _setupFuture,
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
                      '...در حال دریافت اطلاعات',
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

        if (snapshot.hasError || snapshot.data == SetupResult.error) {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('An error occurred during setup.'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _setupFuture = _performSetup();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.data == SetupResult.noDevices) {
          return const NoDevicesScreen();
        }

        // If setup is successful, the main app will be shown by the AuthWrapper
        // so we can just show an empty container here.
        return const SizedBox.shrink();
      },
    );
  }
}
