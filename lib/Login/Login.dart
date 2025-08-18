import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController formemail;
  late TextEditingController formpass;
  double _topPadding = 300;

  @override
  void initState() {
    super.initState();
    formemail = TextEditingController();
    formpass = TextEditingController();
  }

  void setup() {
    final funcy = context.read<ProvData>();
    var sdcard = Hive.box(FIGMA.HIVE);

    var token = sdcard.get("access_token", defaultValue: "empty");

    if (token != "empty") {
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
      funcy.setIsUserLoggedIn(true);
      funcy.hand_update();
    } else {
      debugPrint("no token");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is visinetvana
    bool isKeyboardVisinetvana = MediaQuery.of(context).viewInsets.bottom != 0;

    if (isKeyboardVisinetvana) {
      _topPadding = 100;
    } else {
      _topPadding = 300;
    }

    return Consumer<ProvData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: FIGMA.Back,
              resizeToAvoidBottomInset:
                  false, // Prevent resizing when keyboard appears
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: _topPadding,
                        ),
                        // RTL text
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "خوش آمدید",
                                  style: TextStyle(
                                      fontFamily: FIGMA.abrlb,
                                      fontSize: 24,
                                      color: FIGMA.Wrn),
                                  textAlign: TextAlign.end,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  "برای ورود به اپلیکیشن رمز عبور\n و شماره خود را وارد کنید",
                                  style: TextStyle(
                                      fontFamily: FIGMA.estre,
                                      fontSize: 14,
                                      color: FIGMA.Wrn2),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        EasyContainer(
                          height: GetGoodW(context, 320, 68).height,
                          width: GetGoodW(context, 320, 68).width,
                          color: Colors.black12.withOpacity(0),
                          borderWidth: 0,
                          elevation: 0,
                          padding: 0,
                          borderRadius: 0,
                          child: TextField(
                            style: const TextStyle(
                                fontFamily: FIGMA.estre,
                                fontSize: 16,
                                color: FIGMA.Wrn),
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: FIGMA.abrlb,
                                  fontSize: 12,
                                  color: FIGMA.Wrn2),
                              hintText: "Mobile",
                              border: OutlineInputBorder(),
                            ),
                            controller: formemail,
                          ),
                        ),
                        EasyContainer(
                          height: GetGoodW(context, 320, 68).height,
                          width: GetGoodW(context, 320, 68).width,
                          color: Colors.black12.withOpacity(0),
                          borderWidth: 0,
                          elevation: 0,
                          padding: 0,
                          borderRadius: 0,
                          child: TextField(
                            style: const TextStyle(
                                fontFamily: FIGMA.estre,
                                fontSize: 16,
                                color: FIGMA.Wrn),
                            obscureText: true,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: FIGMA.abrlb,
                                  fontSize: 12,
                                  color: FIGMA.Wrn2),
                              hintText: "Password",
                              border: OutlineInputBorder(),
                            ),
                            controller: formpass,
                          ),
                        ),
                        EasyContainer(
                          height: GetGoodW(context, 320, 68).height,
                          width: GetGoodW(context, 320, 68).width,
                          color: FIGMA.Prn,
                          borderWidth: 0,
                          elevation: 0,
                          padding: 0,
                          borderRadius: 17,
                          child: const Text(
                            'ورود به نت وانا',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: FIGMA.abreb),
                          ),
                          onTap: () async {
                            var box = Hive.box(FIGMA.HIVE);
                            try {
                              var loginResponse = await NetClass()
                                  .login(formemail.text, formpass.text)
                                  .timeout(const Duration(seconds: 5));

                              if (loginResponse != null) {
                                debugPrint(loginResponse.toString());

                                box.put("access_token",
                                    loginResponse["access_token"]);

                                var meResponse = await NetClass()
                                    .getProducts(loginResponse['access_token'])
                                    .timeout(const Duration(seconds: 5));

                                if (meResponse != null) {
                                  value.setProducts(meResponse["devices"]);
                                  box.put("products", meResponse["devices"]);
                                  box.put("name", meResponse["first_name"]);
                                  box.put("last", meResponse["last_name"]);
                                  box.put("phone", meResponse["phone"]);
                                  box.put(
                                      "token", loginResponse['access_token']);

                                  debugPrint("Got Devices");

                                  // TODO: add setup
                                  setup();
                                } else {
                                  value.Show_Snackbar("ورود نا موفق", 1000);
                                  debugPrint("getProducts returned null");
                                }
                              } else {
                                value.Show_Snackbar("ورود نا موفق", 1000);
                                debugPrint(
                                    "Login response is null or missing token");
                              }
                            } catch (e) {
                              value.Show_Snackbar("ورود نا موفق", 1000);
                              debugPrint('Error: $e');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
