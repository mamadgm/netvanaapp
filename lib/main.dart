import 'package:flutter/material.dart';
import 'package:netvana/BLE/screens/products/nooran/Nooran.dart';
import 'package:netvana/Login/Login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/OtherTwo/Effects.dart';
import 'package:netvana/OtherTwo/Netvana.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/models/SingleHive.dart';
import 'package:netvana/settingscreen/profile.dart';
import 'package:provider/provider.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:netvana/navbar/TheAppNav.dart';
import 'package:netvana/const/figma.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SdcardService.instance.init();
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
    final value = Provider.of<ProvData>(context, listen: false);
    setup(value);
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
