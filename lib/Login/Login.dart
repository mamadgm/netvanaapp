import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

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
              resizeToAvoidBottomInset:
                  false, // Prevent resizing when keyboard appears
              body: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Image.asset(
                      'ass/signin.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Login form
                  SingleChildScrollView(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "خوش آمدید",
                                      style: TextStyle(
                                          fontFamily: FIGMA.abrlb,
                                          fontSize: 24),
                                      textAlign: TextAlign.end,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    Text(
                                      "برای ورود به اپلیکیشن رمز عبور\n و ایمیل خود را وارد کنید",
                                      style: TextStyle(
                                          fontFamily: FIGMA.estre,
                                          fontSize: 14,
                                          color: Colors.grey),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                                const SizedBox(
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
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontFamily: FIGMA.abrlb,
                                      fontSize: 12,
                                      color: Colors.grey),
                                  hintText: "Email",
                                  border: const OutlineInputBorder(),
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
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontFamily: FIGMA.abrlb,
                                      fontSize: 12,
                                      color: Colors.grey),
                                  hintText: "Password",
                                  border: const OutlineInputBorder(),
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
                              child: Text(
                                'ورود به نت وانا',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: FIGMA.abreb),
                              ),
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                value.email = formemail.text.toString();
                                value.pass = formpass.text.toString();
                                var url = Uri.parse(
                                    'https://netvana.ir/neol/handle/app.php?email=${value.email}&&pass=${value.pass}');

                                var response = await http.get(url);

                                if (response.statusCode == 200) {
                                  //debugPrint('Response body: ${response.body}');
                                } else {
                                  // debugPrint(
//                          'Request failed with status: ${response.statusCode}.');
                                  final funcy = context.read<ProvData>();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
