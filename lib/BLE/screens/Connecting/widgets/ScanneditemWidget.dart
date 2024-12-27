import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';

class ScannedItemWidget extends StatelessWidget {
  final BleDevice netvanaDevice;
  final VoidCallback? onTap;
  const ScannedItemWidget({super.key, required this.netvanaDevice, this.onTap});

  @override
  Widget build(BuildContext context) {
    String? name = netvanaDevice.name;
    Uint8List? rawManufacturerData = netvanaDevice.manufacturerData;
    ManufacturerData? manufacturerData;
    if (rawManufacturerData != null && rawManufacturerData.isNotEmpty) {
      manufacturerData = ManufacturerData.fromData(rawManufacturerData);
    }
    if (name == null || name.isEmpty) name = 'NA';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          title: Text(
            '$name (${netvanaDevice.rssi})',
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(netvanaDevice.deviceId),
              Visibility(
                visible: manufacturerData != null,
                child: Text(
                  'CompanyIdentifier: ${manufacturerData.toString()} (${manufacturerData?.companyIdRadix16})',
                ),
              ),
              netvanaDevice.isPaired == true
                  ? const Text(
                      "Paired",
                      style: TextStyle(color: Colors.green),
                    )
                  : const Text(
                      "Not Paired",
                      style: TextStyle(color: Colors.red),
                    ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}
