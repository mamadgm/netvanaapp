import 'package:netvana/BLE/logic/Ble_Scan.dart';
import 'package:netvana/ble/screens/Connecting/widgets/PermissionHandler.dart';
import 'package:netvana/ble/screens/Connecting/widgets/PlatformButton.dart';
import 'package:netvana/ble/screens/products/product_chooser.dart';
import 'package:netvana/const/figma.dart';
import 'package:netvana/data/ble/providerble.dart';
import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universal_ble/universal_ble.dart';

class netvanaHandel extends StatefulWidget {
  const netvanaHandel({super.key});
  @override
  State<netvanaHandel> createState() => _netvanaHandelState();
}

class _netvanaHandelState extends State<netvanaHandel> {
  bool _isScanning = false;
  late My_Ble_Scan mynetvanascan;
  @override
  void initState() {
    super.initState();
    final datky = Provider.of<ProvData>(context, listen: false);
    final funcy = context.read<ProvData>();
    mynetvanascan = My_Ble_Scan(datky, funcy);
  }

  @override
  Widget build(BuildContext context) {
    double MaxScreenWidth = MediaQuery.of(context).size.width;
    double MaxScreenHeight = MediaQuery.of(context).size.height;
    final funcy = context.read<ProvData>();
    final datky = Provider.of<ProvData>(context, listen: false);
    return Consumer<ProvData>(
      builder: (context, value, child) {
        return SafeArea(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              const SizedBox(
                height: 30,
              ),
              Icon(
                Icons.bluetooth,
                size: 200,
                color: FIGMA.Orn.withOpacity(0.2),
              ),
              const SizedBox(
                height: 40,
              ),
              EasyContainer(
                height: 100,
                color: FIGMA.Back,
                borderWidth: 0,
                elevation: 0,
                margin: 1,
                padding: 0,
                borderRadius: 15,
                child: Container(
                  color: FIGMA.Back,
                  child: Text(
                    "هیچ دستگاهی متصل نیست",
                    style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EasyContainer(
                  height: 60,
                  width: 100,
                  color: FIGMA.Prn,
                  borderWidth: 0,
                  elevation: 0,
                  margin: 1,
                  padding: 0,
                  borderRadius: 15,
                  child: Text(
                    "جستجوی دستگاه",
                    style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 18),
                  ),
                  onTap: () async {
                    debugPrint("Search Button Clicked");
                    setState(() {
                      datky.mynetvanaDevices.clear();
                      funcy.update_mynetvanadevice();
                      _isScanning = true;
                    });
                    try {
                      await mynetvanascan.startScan();
                    } catch (e) {
                      setState(() {
                        _isScanning = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EasyContainer(
                  height: 60,
                  width: 100,
                  color: FIGMA.Prn,
                  borderWidth: 0,
                  elevation: 0,
                  margin: 1,
                  padding: 0,
                  borderRadius: 15,
                  child: Text(
                    "متوقف کردن اسکن بلوتوث",
                    style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 18),
                  ),
                  onTap: () async {
                    await UniversalBle.stopScan();
                    setState(() {
                      _isScanning = false;
                    });
                  },
                ),
              ),
              if (BleCapabilities.requiresRuntimePermission)
                PlatformButton(
                  text: 'Check Permissions',
                  onPressed: () async {
                    bool hasPermissions =
                        await PermissionHandler.arePermissionsGranted();
                    if (hasPermissions) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Permissions granted")),
                      );
                    }
                  },
                ),
              EasyContainer(
                  height: _isScanning && datky.mynetvanaDevices.isEmpty
                      ? 100
                      : !_isScanning && datky.mynetvanaDevices.isEmpty
                          ? 10
                          : 600,
                  color: FIGMA.Back,
                  borderWidth: 0,
                  elevation: 0,
                  margin: 6,
                  padding: 0,
                  child: _isScanning && datky.mynetvanaDevices.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : !_isScanning && datky.mynetvanaDevices.isEmpty
                          ? Choose_Product(
                              onTrytoconnect: () {},
                              ondelete: () {},
                              Prefix: "null",
                              myheight: GetGoodW(context, 321, 400).height,
                              mywidth: GetGoodW(context, 321, 400).width,
                            )
                          : Choose_Product(
                              Prefix: datky.mynetvanaDevices[0].name ?? "null",
                              myheight: GetGoodW(context, 321, 400).height,
                              mywidth: GetGoodW(context, 321, 400).width,
                              onTrytoconnect: () async {
                                final funcy = context.read<ProvData>();
                                await UniversalBle.stopScan();
                                _isScanning = false;
                                funcy.SetDevice(
                                    datky.mynetvanaDevices[0].deviceId,
                                    datky.mynetvanaDevices[0].name ?? "null");
                                funcy.ChangeDeviceFound(true);
                              },
                              ondelete: () {
                                setState(() {
                                  datky.mynetvanaDevices.clear();
                                  funcy.update_mynetvanadevice();
                                });
                              },
                            )),
            ],
          ),
        );
      },
    );
  }
}
