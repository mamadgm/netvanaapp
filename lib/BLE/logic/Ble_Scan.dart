// import 'package:netvana/BLE/screens/Connecting/widgets/MockUniversalBle.dart';
// import 'package:netvana/const/figma.dart';
// import 'package:netvana/data/ble/providerble.dart';
// import 'package:flutter/material.dart';
// import 'package:universal_ble/universal_ble.dart';

// class My_Ble_Scan with ChangeNotifier {
//   bool personselecteddevice = false;
//   final QueueType _queueType = QueueType.global;
//   TextEditingController servicesFilterController = TextEditingController();
//   TextEditingController namePrefixController = TextEditingController();
//   TextEditingController manufacturerDataController = TextEditingController();

//   AvailabilityState? netvanaAvailabilityState;
//   final ScanFilter scanFilter = ScanFilter(
//     withServices: [FIGMA.ESP32_SERVICE_ID],
//   );

//   My_Ble_Scan(ProvData datky, dynamic funcy) {
//     if (const bool.fromEnvironment('MOCK')) {
//       UniversalBle.setInstance(MockUniversalBle());
//     }

//     UniversalBle.queueType = _queueType;
//     UniversalBle.timeout = const Duration(seconds: 10);

//     UniversalBle.onAvailabilityChange = (state) {
//       netvanaAvailabilityState = state;
//       debugPrint("GM : Availablity Changed $state");
//     };

//     UniversalBle.onScanResult = (result) {
//       int index = datky.mynetvanaDevices
//           .indexWhere((e) => e.deviceId == result.deviceId);
//       if (index == -1) {
//         datky.mynetvanaDevices.add(result);
//         funcy.update_mynetvanadevice();
//       } else {
//         if (result.name == null && datky.mynetvanaDevices[index].name != null) {
//           result.name = datky.mynetvanaDevices[index].name;
//           funcy.update_mynetvanadevice();
//         }
//         datky.mynetvanaDevices[index] = result;
//         funcy.update_mynetvanadevice();
//       }
//     };
//   }

//   Future<void> startScan() async {
//     await UniversalBle.startScan(
//       scanFilter: scanFilter,
//     );
//   }
// }
