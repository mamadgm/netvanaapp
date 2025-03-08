import 'package:netvana/BLE/logic/SingleBle.dart';
import 'package:netvana/cuswidgets/newtab.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:netvana/ble/logic/esp_ble.dart';
import 'package:netvana/const/figma.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modern_textfield/modern_textfield.dart';

class Espsettings extends StatefulWidget {
  const Espsettings({super.key});

  @override
  State<Espsettings> createState() => _EspsettingsState();
}

class _EspsettingsState extends State<Espsettings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProvData>(
      builder: (context, value, child) => NewTab(
        appbartext: "تنظیمات دستگاه",
        childrens: [
          const Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "تنظیمات بلوتوثی",
                style: TextStyle(
                    fontFamily: FIGMA.abrlb, fontSize: 18, color: FIGMA.Prn),
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: EasyContainer(
              color: FIGMA.Gray,
              padding: 0,
              margin: 16,
              borderWidth: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: CheckboxListTile(
                      title: const Text(
                        "فعال سازی نتوانا در\n ریستارت بعدی",
                        style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 13),
                      ),
                      value: value.isnooranNet,
                      onChanged: (p0) {
                        final funcy = context.read<ProvData>();
                        funcy.update_netvana(p0 ?? false);
                        p0 == true
                            ? SingleBle().sendMain("Ne-")
                            : SingleBle().sendMain("Nd-");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ModernTextField(
              textEditingController: value.r_ssid_netvana,
              backgroundColor: FIGMA.Gray,
              iconBackgroundColor: FIGMA.Prn,
              borderRadius: 15,
              customTextFieldIcon: const Icon(
                Icons.wifi_password,
                color: Colors.white,
              ),
              hintText: "نام روتر",
              hintStyling: TextStyle(
                fontFamily: FIGMA.abrlb,
                fontSize: 13,
                color: FIGMA.Orn.withOpacity(0.3),
              ),
              trailingWidget: IconButton(
                onPressed: () {
                  debugPrint(value.r_ssid_netvana.text);
                  SingleBle().sendBigString(value.r_ssid_netvana.text);
                  SingleBle().sendMain("Ns-");
                },
                icon: const Icon(
                  Icons.send_rounded,
                  color: FIGMA.Prn,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ModernTextField(
              textEditingController: value.r_pass_netvana,
              backgroundColor: FIGMA.Gray,
              iconBackgroundColor: FIGMA.Prn,
              borderRadius: 15,
              customTextFieldIcon: const Icon(
                Icons.key_rounded,
                color: Colors.white,
              ),
              hintText: "پسورد",
              hintStyling: TextStyle(
                fontFamily: FIGMA.abrlb,
                fontSize: 13,
                color: FIGMA.Orn.withOpacity(0.3),
              ),
              trailingWidget: IconButton(
                onPressed: () {
                  debugPrint(value.r_pass_netvana.text);
                  SingleBle().sendBigString(value.r_pass_netvana.text);
                  SingleBle().sendMain("Np-");
                },
                icon: const Icon(
                  Icons.send_rounded,
                  color: FIGMA.Prn,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: EasyContainer(
              color: FIGMA.Gray,
              padding: 0,
              margin: 16,
              borderWidth: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: CheckboxListTile(
                      title: const Text(
                        "فعال سازی آپدیت سیستم",
                        style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 13),
                      ),
                      value: value.NetvanaUpdateFlag,
                      onChanged: (p0) {
                        final funcy = context.read<ProvData>();
                        funcy.update_NetvanaUpdateFlag(p0 ?? false);
                        p0 == true
                            ? SingleBle().sendMain("Ue-")
                            : SingleBle().sendMain("Ud-");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: EasyContainer(
              color: FIGMA.Gray,
              padding: 8,
              margin: 16,
              borderWidth: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "ورژن",
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 14),
                  ),
                  TextField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      fillColor: FIGMA.Orn,
                      hintStyle: const TextStyle(
                          fontFamily: FIGMA.abrlb,
                          fontSize: 12,
                          color: Colors.grey),
                      hintText: "V.${value.ESPVersion}",
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "تنظیمات بلوتوثی",
                      style: TextStyle(
                          fontFamily: FIGMA.abrlb,
                          fontSize: 18,
                          color: FIGMA.Prn),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: EasyContainer(
                    color: FIGMA.Gray,
                    padding: 0,
                    margin: 16,
                    borderWidth: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 15,
                          child: CheckboxListTile(
                            title: Text(
                              "فعال سازی نتوانا در\n ریستارت بعدی",
                              style: TextStyle(
                                  fontFamily: FIGMA.abrlb, fontSize: 13),
                            ),
                            value: value.NetvanaFlag,
                            onChanged: (p0) {
                              final funcy = context.read<ProvData>();
                              funcy.update_netvana(p0 ?? false);
                              p0 == true
                                  ? SingleBle().sendMain("Ne-")
                                  : SingleBle().sendMain("Nd-");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ModernTextField(
                    textEditingController: value.r_ssid_netvana,
                    backgroundColor: FIGMA.Gray,
                    iconBackgroundColor: FIGMA.Prn,
                    borderRadius: 15,
                    customTextFieldIcon: const Icon(
                      Icons.wifi_password,
                      color: Colors.white,
                    ),
                    hintText: "نام روتر",
                    hintStyling: TextStyle(
                      fontFamily: FIGMA.abrlb,
                      fontSize: 13,
                      color: FIGMA.Orn.withOpacity(0.3),
                    ),
                    trailingWidget: IconButton(
                      onPressed: () {
                        debugPrint(value.r_ssid_netvana.text);
                        NooranBle.send_big_string(value.r_ssid_netvana.text);
                        SingleBle().sendMain("Ns-");
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: FIGMA.Prn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ModernTextField(
                    textEditingController: value.r_pass_netvana,
                    backgroundColor: FIGMA.Gray,
                    iconBackgroundColor: FIGMA.Prn,
                    borderRadius: 15,
                    customTextFieldIcon: const Icon(
                      Icons.key_rounded,
                      color: Colors.white,
                    ),
                    hintText: "پسورد",
                    hintStyling: TextStyle(
                      fontFamily: FIGMA.abrlb,
                      fontSize: 13,
                      color: FIGMA.Orn.withOpacity(0.3),
                    ),
                    trailingWidget: IconButton(
                      onPressed: () {
                        debugPrint(value.r_pass_netvana.text);
                        NooranBle.send_big_string(value.r_pass_netvana.text);
                        SingleBle().sendMain("Np-");
                      },
                      icon: Icon(
                        Icons.send_rounded,
                        color: FIGMA.Prn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: EasyContainer(
                    color: FIGMA.Gray,
                    padding: 0,
                    margin: 16,
                    borderWidth: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 15,
                          child: CheckboxListTile(
                            title: Text(
                              "فعال سازی آپدیت سیستم",
                              style: TextStyle(
                                  fontFamily: FIGMA.abrlb, fontSize: 13),
                            ),
                            value: value.NetvanaFlag,
                            onChanged: (p0) {
                              final funcy = context.read<ProvData>();
                              funcy.update_netvana(p0 ?? false);
                              p0 == true
                                  ? SingleBle().sendMain("Ue-")
                                  : SingleBle().sendMain("Ud-");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: EasyContainer(
                    color: FIGMA.Gray,
                    padding: 8,
                    margin: 16,
                    borderWidth: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "دریافت ورژن",
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.rtl,
                          style:
                              TextStyle(fontFamily: FIGMA.abrlb, fontSize: 13),
                        ),
                        TextField(
                          readOnly: true,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            fillColor: FIGMA.Orn,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.download,
                                color: FIGMA.Prn,
                              ),
                              onPressed: () {},
                            ),
                            hintStyle: TextStyle(
                                fontFamily: FIGMA.abrlb,
                                fontSize: 12,
                                color: Colors.grey),
                            hintText: "exp : NV-V1.0",
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
*/
