import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:netvana/screens/setup_screen.dart';
import 'package:url_launcher/url_launcher.dart';

void showWiFiDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "popup",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return Center(
        child: AlertDialog(
          scrollable: true,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          backgroundColor: FIGMA.Gray,
          content: StatefulBuilder(
            builder: (context, setState) {
              return EasyContainer(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height * 0.70,
                color: FIGMA.Gray,
                borderWidth: 0,
                elevation: 0,
                margin: 0,
                padding: 6,
                borderRadius: 30,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        "تنظیم مجدد دستگاه",
                        style: TextStyle(
                          color: FIGMA.Wrn2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: FIGMA.abrlb,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "این مرحله فقط زمانی لازم است که:",
                        style: TextStyle(
                          color: FIGMA.Wrn2,
                          fontSize: 14,
                          fontFamily: FIGMA.estsb,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• مودم جدید گرفته‌اید",
                            style: TextStyle(
                              color: FIGMA.Orn,
                              fontSize: 12,
                              fontFamily: FIGMA.estsb,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            "• رمز وای‌فای عوض شده است",
                            style: TextStyle(
                              color: FIGMA.Orn,
                              fontSize: 12,
                              fontFamily: FIGMA.estsb,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            "• با دستگاه نیاز به اتصال دوباره دارد",
                            style: TextStyle(
                              color: FIGMA.Orn,
                              fontSize: 12,
                              fontFamily: FIGMA.estsb,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "نگران نباشید! دستگاه به‌صورت خودکار تلاش می‌کند به مودم قبلی وصل شود. حتی اگر دستگاه ریست شود، دوباره قابل تنظیم خواهد بود.",
                        style: TextStyle(
                          color: FIGMA.Gray4,
                          fontSize: 12,
                          height: 1.6,
                          fontFamily: FIGMA.estbo,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "لطفاً مراحل زیر را انجام دهید:",
                        style: TextStyle(
                          color: FIGMA.Wrn2,
                          fontSize: 14,
                          fontFamily: FIGMA.estsb,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1. دوربین گوشی را باز کنید و QR کدی که روی کارت شناسنامه دستگاه هست را اسکن کنید تا به دستگاه وصل شوید.",
                            style: TextStyle(
                              color: FIGMA.Gray4,
                              fontSize: 12,
                              height: 1.5,
                              fontFamily: FIGMA.estsb,
                            ),
                          ),
                          Text(
                            "2. مطمئن شوید که به دستگاه متصل شدید.",
                            style: TextStyle(
                              color: FIGMA.Gray4,
                              fontSize: 12,
                              height: 1.5,
                              fontFamily: FIGMA.estsb,
                            ),
                          ),
                          Text(
                            "3. به این صفحه برگردید (این پاپ‌آپ را نبندید).",
                            style: TextStyle(
                              color: FIGMA.Gray4,
                              fontSize: 12,
                              height: 1.5,
                              fontFamily: FIGMA.estsb,
                            ),
                          ),
                          Text(
                            "4. روی کلید پایین بزنید تا وارد تنظیمات شوید.",
                            style: TextStyle(
                              color: FIGMA.Gray4,
                              fontSize: 12,
                              height: 1.5,
                              fontFamily: FIGMA.estsb,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      EasyContainer(
                        height: 60.h,
                        width: 320.w,
                        color: FIGMA.Prn,
                        borderWidth: 0,
                        elevation: 0,
                        padding: 0,
                        borderRadius: 17,
                        child: const Text(
                          "باز کردن صفحه تنظیمات دستگاه",
                          style: TextStyle(
                            color: FIGMA.Wrn,
                            fontSize: 14,
                            fontFamily: FIGMA.estsb,
                          ),
                        ),
                        onTap: () async {
                          final url = Uri.parse('http://192.168.4.1');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

Future<SetupResult> setup(ProvData funcy) async {
  final service = CacheService.instance;

  if (service.token == null || service.token!.isEmpty) {
    funcy.setIsUserLoggedIn(false);
    return SetupResult.error; // Or a new result type like notLoggedIn
  }

  try {
    final userData = await NetClass().getUser(service.token!);
    if (userData == null) {
      return SetupResult.error;
    }

    funcy.setFirstName(userData['first_name']?.toString() ?? '');
    funcy.setLastName(userData['last_name']?.toString() ?? '');
    funcy.setPhone(userData['phone']?.toString() ?? '');
    funcy.setUsername(userData['username']?.toString() ?? '');

    final devices = (userData['devices'] as List)
        .map(
          (d) => Device(
            id: d['id'],
            macAddress: d['mac_address'],
            partNumber: d['part_number'],
            isOnline: d['is_online'],
            assembledAt: DateTime.parse(d['assembled_at']),
            categoryName: d['category_name'],
            categoryId: d['category_name'] == "nt" ? 1 : 2,
            versionName: d['version_name'],
          ),
        )
        .toList();

    if (devices.isEmpty) {
      return SetupResult.noDevices;
    }

    funcy.devices = devices;
    funcy.selectedDevice = devices.first;
    funcy.setIsUserLoggedIn(true);

    // Load other data
    var sdcardBox = Hive.box(FIGMA.HIVE2);
    for (var i = 0; i < 5; i++) {
      funcy.Defalult_colors[i] = sdcardBox.get(
        "COLOR$i",
        defaultValue: 0xFFFFFF,
      );
    }
    await funcy.getDetailsFromNet();

    return SetupResult.success;
  } catch (e) {
    debugPrint("Error during setup: $e");
    return SetupResult.error;
  }
}

void showCannotSend(ProvData value) {
  value.Show_Snackbar("هیچ اتصالی وجود ندارد", 1000);
}

Future<bool> hasInternet() async {
  final result = await Connectivity().checkConnectivity();
  return result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet;
}
