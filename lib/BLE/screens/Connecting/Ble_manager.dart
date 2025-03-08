// import 'package:flutter/material.dart';
// import 'package:netvana/BLE/logic/SingleBle.dart';
// import 'package:netvana/const/figma.dart';
// import 'package:easy_container/easy_container.dart';
// import 'package:netvana/ble/screens/products/product_chooser.dart';

// class BLEHandel extends StatefulWidget {
//   const BLEHandel({super.key});
//   @override
//   State<BLEHandel> createState() => _BLEHandelState();
// }

// class _BLEHandelState extends State<BLEHandel> {
//   bool _isScanning = false;
//   bool _isConnected = false;
//   String? _deviceDetails = '';
//   late SingleBle singleBle;

//   @override
//   void initState() {
//     super.initState();
//     singleBle = SingleBle();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ListView(
//         scrollDirection: Axis.vertical,
//         children: [
//           const SizedBox(
//             height: 30,
//           ),
//           Icon(
//             Icons.bluetooth,
//             size: 200,
//             color: FIGMA.Orn.withOpacity(0.2),
//           ),
//           const SizedBox(
//             height: 40,
//           ),
//           EasyContainer(
//             height: 100,
//             color: FIGMA.Back,
//             borderWidth: 0,
//             elevation: 0,
//             margin: 1,
//             padding: 0,
//             borderRadius: 15,
//             child: Container(
//               color: FIGMA.Back,
//               child: Text(
//                 _isConnected
//                     ? "Connected to: $_deviceDetails"
//                     : "هیچ دستگاهی متصل نیست",
//                 style: const TextStyle(fontFamily: FIGMA.abrlb, fontSize: 18),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: EasyContainer(
//               height: 60,
//               width: 100,
//               color: FIGMA.Prn,
//               borderWidth: 0,
//               elevation: 0,
//               margin: 1,
//               padding: 0,
//               borderRadius: 15,
//               child: const Text(
//                 "جستجوی دستگاه",
//                 style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 18),
//               ),
//               onTap: () async {
//                 setState(() {
//                   _isScanning = true;
//                 });

//                 // Start scanning with SingleBle
//                 try {
//                   await singleBle.startScan();
//                   setState(() {});
//                 } catch (e) {
//                   setState(() {
//                     _isScanning = false;
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(e.toString())),
//                   );
//                 }
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: EasyContainer(
//               height: 60,
//               width: 100,
//               color: FIGMA.Prn,
//               borderWidth: 0,
//               elevation: 0,
//               margin: 1,
//               padding: 0,
//               borderRadius: 15,
//               child: const Text(
//                 "متوقف کردن اسکن بلوتوث",
//                 style: TextStyle(fontFamily: FIGMA.abrlb, fontSize: 18),
//               ),
//               onTap: () async {
//                 await singleBle.stopScan(); // Stop scanning
//                 setState(() {
//                   _isScanning = false;
//                 });
//               },
//             ),
//           ),
//           EasyContainer(
//             height: _isScanning && singleBle.discoveredDevices.isEmpty
//                 ? 100
//                 : !_isScanning && singleBle.discoveredDevices.isEmpty
//                     ? 10
//                     : 600,
//             color: FIGMA.Back,
//             borderWidth: 0,
//             elevation: 0,
//             margin: 6,
//             padding: 0,
//             child: _isScanning && singleBle.discoveredDevices.isEmpty
//                 ? const Center(child: CircularProgressIndicator.adaptive())
//                 : !_isScanning && singleBle.discoveredDevices.isEmpty
//                     ? Choose_Product(
//                         onTrytoconnect: () {},
//                         ondelete: () {},
//                         prefix: "null",
//                         myheight: GetGoodW(context, 321, 400).height,
//                         mywidth: GetGoodW(context, 321, 400).width,
//                       )
//                     : ListView.builder(
//                         itemCount: singleBle.discoveredDevices.length,
//                         itemBuilder: (context, index) {
//                           var device = singleBle.discoveredDevices[index];
//                           return ListTile(
//                             title: Text(device.name ?? "Unnamed Device"),
//                             subtitle: Text(device.deviceId),
//                             onTap: () async {
//                               await singleBle.connectToDevice(device.deviceId);
//                               setState(() {
//                                 _isConnected = true;
//                                 _deviceDetails =
//                                     "Name: ${device.name}, ID: ${device.deviceId}";
//                               });
//                             },
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }
