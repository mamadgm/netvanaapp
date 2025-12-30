import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/Login/signup.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:netvana/screens/no_devices_screen.dart';
import 'package:provider/provider.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

enum SetupResult { success, noDevices, error, auth }

class _SetupScreenState extends State<SetupScreen> {
  late Future<SetupResult> _setupFuture;

  @override
  void initState() {
    super.initState();
    _setupFuture = _performSetup();
  }

  Future<SetupResult> _performSetup() async {
    final provData = Provider.of<ProvData>(context, listen: false);
    final result = await setup(provData);

    if (provData.firstName.isEmpty || provData.lastName.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Signup()),
        );
      });
    }

    // debugPrint("in screen Top $result");
    return result;
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
                        fontSize: 15.sp,
                      ),
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

        if (snapshot.connectionState == ConnectionState.done) {
          final prov = Provider.of<ProvData>(context, listen: false);
          // If error happened
          if (snapshot.hasError ||
              snapshot.data == SetupResult.error ||
              snapshot.data == SetupResult.auth) {
            return FutureBuilder<bool>(
              future: hasInternet(),
              builder: (context, internetSnap) {
                if (!internetSnap.hasData) {
                  return const SizedBox.shrink(); // loading
                }

                final online = internetSnap.data!;

                if (!online) {
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: FIGMA.Back,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'به اینترنت متصل نیستید',
                              style: TextStyle(fontFamily: FIGMA.estbo),
                            ),
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
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    if (snapshot.data == SetupResult.auth) {
                      await CacheService.instance.saveToken(null);
                      prov.Show_Snackbar(
                        "لطفا دوباره وارد شوید",
                        1500,
                        type: 3,
                      );
                      prov.logoutAndReset();
                    } else {
                      prov.Show_Snackbar(
                        "مشکلی در ورود پیش آمد",
                        1500,
                        type: 3,
                      );
                    }
                  });
                  return const SizedBox.shrink();
                }
              },
            );
          }
        }

        if (snapshot.data == SetupResult.noDevices) {
          return const NoDevicesScreen();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
