import 'package:flutter/material.dart';
import 'package:flutter_ble/services/ble_services.dart';
import 'package:flutter_ble/widgets/device_search_result_widget.dart';
import 'package:flutter_ble/widgets/loader_widget.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BleService.startScanDevices();
        },
        child: const Icon(Icons.bluetooth_searching_outlined),
      ),
      appBar: AppBar(
        title: const Text('Flutter BLE'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: StreamBuilder<BluetoothState>(
          stream: BleService.flutterBlue.state,
          builder: (context, AsyncSnapshot<BluetoothState> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
               return const Center(
                child: LoaderWidget(message: 'Checking bluetooth state')
               );
            }
            BluetoothState bluetoothState = snapshot.data!;
            return bluetoothState == BluetoothState.on 
            ? StreamBuilder<List<ScanResult>>(
                  stream: BleService.scanResultStream(),
                  builder: (context, AsyncSnapshot<List<ScanResult>> searchResultSnapshot) {
                    if(searchResultSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                         child: LoaderWidget(message: 'Scanning....')
                      );
                    }
                    return StreamBuilder(
                      stream: BleService.flutterBlue.isScanning,
                      builder: (context,AsyncSnapshot<bool> connectionStatusSnapshot) {
                        if(connectionStatusSnapshot.connectionState == ConnectionState.waiting || connectionStatusSnapshot.data!) {
                            return const Center(
                                child: LoaderWidget(message: 'Scanning...'),
                            );
                        }
                        List<ScanResult> searchResults = searchResultSnapshot.data ?? [];
                    return searchResults.isEmpty 
                    ? const Center(
                       child: Text('No BLE device found'),
                    ) : Column(
                      children: [
                        Text('BLE devices',style: Theme.of(context).textTheme.titleLarge,),
                        Expanded(
                          child: ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return DeviceSearchResultWidget(bluetoothDevice:searchResults[index].device);
                          },),
                        ),
                      ],
                    );
                    });
                },)
            : const Center(
              child: Text('Turn on bluetooth'),
            );
          },
        ),
      ),
    );
  }
}