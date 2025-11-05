import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/Login/Register.dart';
import 'package:netvana/data/ble/provRegister.dart';
import 'package:netvana/data/cache_service.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:netvana/BLE/screens/products/nooran/Nooran.dart';
import 'package:netvana/Login/Login.dart';
import 'package:netvana/screens/Effects.dart';
import 'package:netvana/screens/Netvana.dart';
import 'package:netvana/screens/profile.dart';
import 'package:netvana/data/ble/provMain.dart';
import 'package:netvana/navbar/TheAppNav.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/screens/setup_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  usePathUrlStrategy(); // 🔥 removes # and enables browser back/forward
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.instance.init();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentPath = Uri.base.path;
    return ScreenUtilInit(
      designSize: const Size(360, 667),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          // locale: const Locale("fa", "IR"),
          debugShowCheckedModeBanner: false,
          supportedLocales: const [Locale("fa", "IR"), Locale("en", "US")],
          localizationsDelegates: const [
            PersianMaterialLocalizations.delegate,
            PersianCupertinoLocalizations.delegate,
            // DariMaterialLocalizations.delegate, Dari
            // DariCupertinoLocalizations.delegate,
            // PashtoMaterialLocalizations.delegate, Pashto
            // PashtoCupertinoLocalizations.delegate,
            // SoraniMaterialLocalizations.delegate, Kurdish
            // SoraniCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          scaffoldMessengerKey: scaffoldMessengerKey,
          home: currentPath == '/register'
              ? const Register()
              : const AuthWrapper(),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final provData = Provider.of<ProvData>(context);
    final token = CacheService.instance.token;

    if (token == null || token.isEmpty) {
      return const Login();
    }

    if (provData.isUserLoggedIn) {
      return Scaffold(
        backgroundColor: FIGMA.Back,
        body: IndexedStack(
          index: provData.Current_screen,
          children: const [
            Nooran(),
            Effectsscr(),
            Netvana(),
            ProfileScr(),
          ],
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(8.0),
          child: TheAppNav(),
        ),
      );
    }

    return const SetupScreen();
  }
}
// flutter run -d chrome --web-browser-flag "--disable-web-security" --web-browser-flag "--user-data-dir=/tmp/chrome_dev"
