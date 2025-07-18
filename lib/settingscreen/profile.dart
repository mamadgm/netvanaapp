import 'package:flutter/material.dart';
import 'package:easy_container/easy_container.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:netvana/BLE/screens/Setting/espsettings.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:provider/provider.dart';

class ProfileScr extends StatelessWidget {
  const ProfileScr({super.key});

  @override
  Widget build(BuildContext context) {
    double maxScreenWidth = MediaQuery.of(context).size.width;
    return Consumer<ProvData>(builder: (context, value, child) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.90,
            child: Column(
              children: [
                // Picture
                SizedBox(
                  height: 250,
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      CircleAvatar(
                        radius: maxScreenWidth * 0.10,
                        backgroundColor: Colors.grey[300],
                        child: Image.asset(
                          "ass/icon.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Name + Family
                      Text(
                        value.name_last,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Email
                      Text(
                        value.phone_number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemCount: value.Products.length,
                    itemBuilder: (context, index) {
                      return EasyContainer(
                        color: FIGMA.Prn,
                        height: 7,
                        width: 10,
                        borderRadius: 15,
                        child: Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          "${value.Products[index]["category_name"] + "-" + value.Products[index]["part_number"].toString()}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: FIGMA.abreb),
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                EasyContainer(
                  height: GetGoodW(context, 320, 68).height,
                  width: GetGoodW(context, 320, 68).width,
                  color: FIGMA.Grn,
                  borderWidth: 0,
                  elevation: 0,
                  padding: 8,
                  borderRadius: 17,
                  onTap: () {
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Espsettings()),
                    );

                    //
                  },
                  margin: 8,
                  child: const Text(
                    "تنظیمات دستگاه (بلوتوث)",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: FIGMA.abreb),
                  ),
                ),
                EasyContainer(
                  height: GetGoodW(context, 320, 68).height,
                  width: GetGoodW(context, 320, 68).width,
                  color: FIGMA.Orn,
                  borderWidth: 0,
                  elevation: 0,
                  padding: 8,
                  borderRadius: 17,
                  onTap: () {
                    var sdcard = Hive.box(FIGMA.HIVE);
                    sdcard.clear();
                  },
                  margin: 8,
                  child: const Text(
                    "خروج از نت وانا",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: FIGMA.abreb),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
