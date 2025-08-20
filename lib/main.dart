import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/screens/products/nooran/Nooran.dart';
import 'package:netvana/Login/Login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/OtherTwo/Effects.dart';
import 'package:netvana/OtherTwo/Netvana.dart';
import 'package:netvana/settingscreen/profile.dart';
import 'package:provider/provider.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:netvana/navbar/TheAppNav.dart';
import 'package:netvana/const/figma.dart';

Future<void> main() async {
  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk(FIGMA.HIVE);
  await Hive.openBox(FIGMA.HIVE);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProvData()),
      ],
      child: const Myapp(),
    ),
  );
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  late List<Widget> mybody;
  @override
  void initState() {
    mybody = [
      const Nooran(), // Main
      const Effectsscr(), // Effects
      const Netvana(), // Timers
      const ProfileScr(),
    ];

    super.initState();
    setup();
  }

  Future<void> setup() async {
    final funcy = context.read<ProvData>();
    var sdcard = Hive.box(FIGMA.HIVE);

    var token = sdcard.get("access_token", defaultValue: "empty");

    if (token != "empty") {
      funcy.setIsUserLoggedIn(true);

      String s1 = sdcard.get("phone", defaultValue: "empty");
      String s2 = sdcard.get("name", defaultValue: "empty");
      String s3 = sdcard.get("last", defaultValue: "empty");
      String s4 = sdcard.get("token", defaultValue: "empty");

      funcy.Set_Userdetails(s1, s2, s3, s4);
      var products = sdcard.get("products", defaultValue: "empty");

      if (products != "empty") {
        funcy.setProducts(products);
      } else {
        debugPrint("no products");
      }

      for (var i = 0; i < 5; i++) {
        funcy.Defalult_colors[i] =
            sdcard.get("COLOR$i", defaultValue: 0xFFFFFF);
      }
      await funcy.getDetailsFromNet();
    } else {
      debugPrint("no token");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 667), // Your Figma design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          home: Consumer<ProvData>(
            builder: (context, value, child) {
              return value.isUserLoggedIn
                  ? Scaffold(
                      backgroundColor: FIGMA.Back,
                      body: IndexedStack(
                        index: value.Current_screen,
                        children: mybody,
                      ),
                      bottomNavigationBar: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TheAppNav(),
                      ),
                    )
                  : const Login();
            },
          ),
        );
      },
    );
  }
}
// flutter build web --web-renderer canvaskit
