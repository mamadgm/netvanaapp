import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netvana/Network/netmain.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/customwidgets/EyeText.dart';
import 'package:netvana/customwidgets/global.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:netvana/models/SingleHive.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController formphone;
  late TextEditingController formpass;
  double _topPadding = 300;

  @override
  void initState() {
    super.initState();
    formphone = TextEditingController();
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
                                      fontSize: 24.sp,
                                      color: FIGMA.Wrn),
                                  textAlign: TextAlign.end,
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  "برای ورود به اپلیکیشن رمز عبور\n و شماره خود را وارد کنید",
                                  style: TextStyle(
                                      fontFamily: FIGMA.estre,
                                      fontSize: 14.sp,
                                      color: FIGMA.Wrn2),
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
                          height: 68.h,
                          width: 320.w,
                          color: Colors.black12.withOpacity(0),
                          borderWidth: 0,
                          elevation: 0,
                          padding: 0,
                          borderRadius: 0,
                          child: EyeTextField(
                            controller: formphone,
                            hintText: "شماره تلفن",
                            showEye: false,
                          ),
                        ),
                        EasyContainer(
                          height: 68.h,
                          width: 320.w,
                          color: Colors.black12.withOpacity(0),
                          borderWidth: 0,
                          elevation: 0,
                          padding: 0,
                          borderRadius: 0,
                          child: EyeTextField(
                            controller: formpass,
                            hintText: "رمز عبور",
                          ),
                        ),
                        EasyContainer(
                            height: 68.h,
                            width: 320.w,
                            color: FIGMA.Prn,
                            borderWidth: 0,
                            elevation: 0,
                            padding: 0,
                            borderRadius: 17,
                            child: Text(
                              'ورود به نت وانا',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontFamily: FIGMA.abreb),
                            ),
                            onTap: () async {
                              try {
                                var loginResponse = await NetClass()
                                    .login(formphone.text, formpass.text)
                                    .timeout(const Duration(seconds: 5));

                                if (loginResponse == null ||
                                    loginResponse['access_token'] == null) {
                                  value.Show_Snackbar("ورود ناموفق", 1000);
                                  return;
                                }

                                final token = loginResponse['access_token'];

                                final service = SdcardService.instance;
                                service.sdcard.token = token;
                                await service.sdcard.save();

                                await service.updateUser(token);

                                debugPrint(
                                    "Got Devices: ${service.products.length}");

                                setup(value);
                              } catch (e) {
                                value.Show_Snackbar("ورود ناموفق", 1000);
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
