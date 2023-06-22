import 'package:flutter/material.dart';
import 'package:flutter_ble/enums/reading_view_type.dart';
import 'package:flutter_ble/models/sensor_data.dart';
import 'package:flutter_ble/services/ble_services.dart';
import 'package:flutter_ble/utils/date_time_util.dart';
import 'package:flutter_ble/widgets/chart_view_widget.dart';
import 'package:flutter_ble/widgets/loader_widget.dart';
import 'package:flutter_ble/widgets/sensor_reading_widget.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HistoricalSensorDetail extends StatefulWidget {
  final BluetoothDevice bluetoothDevice;
  const HistoricalSensorDetail({super.key, required this.bluetoothDevice});

  @override
  State<HistoricalSensorDetail> createState() => _SensorDetailState();
}

class _SensorDetailState extends State<HistoricalSensorDetail> {
  DateTime currentDate = DateTime.now();
  late DateTime startFrom;
  late DateTime endAt;
  ReadingViewType selectedViewType = ReadingViewType.LIST_VIEW;
  
  @override
  void initState() {
    startFrom = DateTime(currentDate.year,currentDate.month,currentDate.day,);
    endAt = DateTime(currentDate.year,currentDate.month,currentDate.day,23,59);

    super.initState();
  }

  @override
  void dispose() {
    BleService.disconnectDevice();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Sensor Readings'),
      ),
      body: FutureBuilder(
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
                    child: LoaderWidget(message: 'Discovering services'),
               );
              }
              return FutureBuilder<List<SensorData>>(
                future: BleService.readHistoryData(),
                builder: (context, AsyncSnapshot<List<SensorData>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: LoaderWidget(message: 'Fetching sensor readings',));
                  }
                  List<SensorData> historicalSensorValues = snapshot.data ?? [];

                  return StatefulBuilder(
                    builder: ((context, setState) {
                    List<SensorData> filteredValues = List<SensorData>.of(historicalSensorValues.where((sensorReading) {
                      return sensorReading.dateTime.millisecondsSinceEpoch >= startFrom.millisecondsSinceEpoch 
                      && sensorReading.dateTime.millisecondsSinceEpoch <= endAt.millisecondsSinceEpoch; 
                    }));
                      return Column(
                        children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: (){
                                    startFrom = startFrom.subtract(const Duration(days: 1));
                                    endAt = endAt.subtract(const Duration(days: 1));
                                    setState((){});
                                  }, 
                                  icon: const Icon(Icons.arrow_back_ios)),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined),
                                    Text(DateTimeUtil.getFormatedDate(startFrom),style: Theme.of(context).textTheme.titleLarge),
                                  ],
                                ),
                                IconButton(
                                  onPressed: startFrom.add(const Duration(days: 1)).millisecondsSinceEpoch > currentDate.millisecondsSinceEpoch 
                                  ? null :(){
                                    startFrom = startFrom.add(const Duration(days: 1));
                                    endAt = endAt.add(const Duration(days: 1));
                                     setState((){});
                                  }, 
                                  icon: const Icon(Icons.arrow_forward_ios))  
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: selectedViewType == ReadingViewType.LIST_VIEW ? (){
                                  setState(() {
                                    selectedViewType = ReadingViewType.CHART_VIEW;
                                  });  
                              } : () {
                                  setState(() {
                                    selectedViewType = ReadingViewType.LIST_VIEW;
                                  });
                              }, icon: selectedViewType == ReadingViewType.LIST_VIEW 
                              ? const Icon(Icons.bar_chart_rounded)
                              : const Icon(Icons.list_alt_outlined)),
                            ),
                            filteredValues.isEmpty ? const Expanded(
                              child: Center(
                                 child: Text('Historical sensor reading not found'),
                              ),
                            ) : Expanded(
                              child: selectedViewType == ReadingViewType.LIST_VIEW
                               ? ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredValues.length,
                                itemBuilder: ((context, index) {
                                    return SensorReadingWidget(
                                      isHistoricalReadings: true,
                                      sensorData: filteredValues[index]);
                              }), separatorBuilder: (BuildContext context, int index) { 
                                  if(index != filteredValues.length - 1) {
                                     return const Padding(
                                       padding: EdgeInsets.all(8.0),
                                       child: Divider(),
                                     );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(),
                                  );
                               },) : ChartViewWidget(sensorRedings: filteredValues),
                            )
                        ],
                      );
                  }));

              },);
          },);
      },),
    );
  }
}