import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/Login/Register.dart';
import 'package:netvana/data/ble/provRegister.dart';
import 'package:provider/provider.dart';
import 'package:netvana/BLE/screens/products/nooran/Nooran.dart';
import 'package:netvana/Login/Login.dart';
import 'package:netvana/screens/Effects.dart';
import 'package:netvana/screens/Netvana.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/models/SingleHive.dart';
import 'package:netvana/screens/profile.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/navbar/TheAppNav.dart';
import 'package:netvana/const/figma.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SdcardService.instance.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProvData()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Widget> mybody;
  late final String currentPath;

  @override
  void initState() {
    super.initState();
    mybody = [
      const Nooran(),
      const Effectsscr(),
      const Netvana(),
      const ProfileScr(),
    ];

    // read current browser path (e.g. "/", "/register")
    currentPath = Uri.base.path; // works only on web

    final value = Provider.of<ProvData>(context, listen: false);
    setup(value);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // decide based on URL
        if (currentPath == '/register') {
          // show your registration MaterialApp
          return MaterialApp(
              scaffoldMessengerKey: scaffoldMessengerKey,
              debugShowCheckedModeBanner: false,
              home: const Register());
        }

        // default route ("/" or others)
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
// flutter run -d chrome --web-browser-flag "--disable-web-security" --web-browser-flag "--user-data-dir=/tmp/chrome_dev"
