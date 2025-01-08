import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/screens/Connecting/Ble_manager.dart';
import 'package:netvana/NetvanaScreen/NetvanaScreen.dart';
import 'package:provider/provider.dart';
import 'package:netvana/Login/Login.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/ble/screens/products/nooran/Nooran.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:netvana/navbar/TheAppNav.dart';
import 'package:netvana/settingscreen/profile.dart';
import 'package:netvana/const/figma.dart';

Future<void> main() async {
  await Hive.initFlutter();
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
      const ProfileScr(),
      const NetvanaScreen(),
      const BLEHandel(),
      Consumer<ProvData>(
        builder: (context, value, child) {
          return value.Isdevicefound ? const Nooran() : Container();
        },
      ),
    ];
    // Signing The User
    final funcy = context.read<ProvData>();
    var box = Hive.box(FIGMA.HIVE);
    bool temp = box.get("IS_SIGNED", defaultValue: false);
    funcy.setIssigned(temp, box.get("token", defaultValue: "NULL"));
    if (temp) {
      funcy.Set_Userdetails(box.get("email"), box.get("name"),
          box.get("login_counter", defaultValue: 0), false);

      // Fetch products
      fetchProducts(funcy.Token);
    }
    super.initState();
  }

  Future<void> fetchProducts(String? token) async {
    final funcy = context.read<ProvData>();
    try {
      if (token != null && token != "NULL") {
        var response = await NetClass().getProducts(token);
        if (response != null && response['products'] != null) {
          debugPrint('Products: ${response['products']}');
          List<String> productNames = response['products']
              .map<String>((product) => product['name'].toString())
              .toList();
          funcy.setProducts(productNames);
        } else {
          debugPrint("No products found.");
        }
      }
    } catch (e) {
      funcy.setIssigned(false, "");
      debugPrint('Failed to fetch products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: Consumer<ProvData>(
        builder: (context, value, child) {
          return value.Issigned == true
              ? Scaffold(
                  backgroundColor: FIGMA.Back,
                  body: IndexedStack(
                    index: value.Current_screen,
                    children: mybody,
                  ),
                  bottomNavigationBar: const TheAppNav(),
                )
              : const Login();
        },
      ),
    );
  }
}
