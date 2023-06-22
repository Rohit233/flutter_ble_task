import 'package:flutter/material.dart';
import 'package:flutter_ble/pages/real_time_sensor_detail.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceSearchResultWidget extends StatefulWidget {
  final BluetoothDevice bluetoothDevice;
  const DeviceSearchResultWidget({super.key, required this.bluetoothDevice});

  @override
  State<DeviceSearchResultWidget> createState() => _DeviceSearchResultWidgetState();
}

class _DeviceSearchResultWidgetState extends State<DeviceSearchResultWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.bluetooth),
      title: Text(widget.bluetoothDevice.name),
      trailing: ElevatedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return  RealTimeSensorDetail(bluetoothDevice: widget.bluetoothDevice,);
          }));
        },
        child: const Text('Connect'),
      ),
    );
  }
}