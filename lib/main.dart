import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/screens/products/nooran/Nooran.dart';
import 'package:netvana/Login/Login.dart';
import 'package:netvana/OtherTwo/Effects.dart';
import 'package:netvana/OtherTwo/WSTimers.dart';
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
  bool isUserLoggedIn = false;
  @override
  void initState() {
    mybody = [
      const Timersscr(), // Timers
      const Effectsscr(), // Effects
      const Nooran(), // Main
    ];
    // Signing The User
    final funcy = context.read<ProvData>();
    var sdcard = Hive.box(FIGMA.HIVE);

    var token = sdcard.get("access_token", defaultValue: "empty");

    if (token != "empty") {
      isUserLoggedIn = true;

      String s1 = sdcard.get("phone", defaultValue: "empty");
      String s2 = sdcard.get("name", defaultValue: "empty");
      String s3 = sdcard.get("last", defaultValue: "empty");

      funcy.Set_Userdetails(s1, s2, s3);

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
    } else {
      debugPrint("no token");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: Consumer<ProvData>(
        builder: (context, value, child) {
          return isUserLoggedIn
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
  }
}
// flutter build web --web-renderer canvaskit
