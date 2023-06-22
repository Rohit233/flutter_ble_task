import 'package:flutter/material.dart';
import 'package:flutter_ble/models/sensor_data.dart';
import 'package:flutter_ble/services/ble_services.dart';
import 'package:flutter_ble/pages/historical_sensor_detail.dart';
import 'package:flutter_ble/widgets/loader_widget.dart';
import 'package:flutter_ble/widgets/sensor_reading_widget.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class RealTimeSensorDetail extends StatefulWidget {
  final BluetoothDevice bluetoothDevice;
  const RealTimeSensorDetail({super.key, required this.bluetoothDevice});

  @override
  State<RealTimeSensorDetail> createState() => _RealTimeSensorDetailState();
}

class _RealTimeSensorDetailState extends State<RealTimeSensorDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bluetoothDevice.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: FutureBuilder(
            future: BleService.connectDevice(widget.bluetoothDevice),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                 return Center(
                   child: LoaderWidget(message: 'Connecting to ${widget.bluetoothDevice.name}...')
                 );
              }
              return FutureBuilder(
                future: BleService.discoverService(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: LoaderWidget(message: 'Discovering services')
                 );
                  }
                  return Column(
                    children: [
                      StreamBuilder<SensorData?>(
                        stream: BleService.readRealTimeSensorValueStream(),
                        builder: (context, AsyncSnapshot<SensorData?> snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: LoaderWidget(message: 'Fetching sensor reading'),
                            );
                          }
                          SensorData? sensorData = snapshot.data;
      
                          return sensorData == null 
                          ? const Text('Error while fetching data') : SensorReadingWidget(sensorData: sensorData);
      
                      },),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () async{
                              await BleService.disconnectDevice();
                              // ignore: use_build_context_synchronously
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return HistoricalSensorDetail(bluetoothDevice: widget.bluetoothDevice);
                              }));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:  [
                                const Text('Historical Sensor Reading'),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return HistoricalSensorDetail(bluetoothDevice: widget.bluetoothDevice);
                                    }));
                                }, icon: const Icon(Icons.arrow_forward_ios))
                              ],
                            ),
                        ),
                      ),
                    ],
                  );
              },);
          },),
        ),
      ),
    );
  }
}