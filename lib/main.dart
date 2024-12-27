import 'package:netvana/Login/Login.dart';
import 'package:netvana/NetvanaScreen/NetvanaScreen.dart';
import 'package:netvana/ble/screens/Connecting/ble_manager.dart';
import 'package:netvana/ble/screens/products/nooran/Nooran.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:netvana/navbar/TheAppNav.dart';
import 'package:netvana/settingscreen/settingscreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'const/figma.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.deleteBoxFromDisk('neol');
  await Hive.openBox('neol');
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
    super.initState();

    mybody = [
      const SettingScreen(),
      const NetvanaScreen(),
      const netvanaHandel(),
      Consumer<ProvData>(
        builder: (context, value, child) {
          return value.Isdevicefound ? const Nooran() : Container();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: Consumer<ProvData>(
        builder: (context, value, child) {
          return value.Issigned == false
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

//Commands
//flutter build web --web-renderer canvaskit
