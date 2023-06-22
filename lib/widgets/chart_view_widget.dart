import 'package:flutter/material.dart';
import 'package:flutter_ble/enums/sensor_reading_parameter.dart';
import 'package:flutter_ble/models/sensor_data.dart';
import 'package:flutter_ble/widgets/line_chart_widget.dart';

class ChartViewWidget extends StatefulWidget {
  final List<SensorData> sensorRedings;
  const ChartViewWidget({super.key, required this.sensorRedings});

  @override
  State<ChartViewWidget> createState() => _ChartViewWidgetState();
}

class _ChartViewWidgetState extends State<ChartViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.thermostat_outlined),
                    Text('Temperature',style: Theme.of(context).textTheme.titleLarge,),
                  ],
                )),
            ),
            LineChartWidget(sensorReadingParameter: SensorReadingParameter.TEMPERATURE, data: widget.sensorRedings),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
          child: Divider(),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Sunlight',style: Theme.of(context).textTheme.titleLarge,),
                    ),
                  ],
                )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: LineChartWidget(sensorReadingParameter: SensorReadingParameter.SUNLIGHT, data: widget.sensorRedings),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
          child: Divider(),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.water_drop_outlined),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Moisture',style: Theme.of(context).textTheme.titleLarge,),
                    ),
                  ],
                )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: LineChartWidget(sensorReadingParameter: SensorReadingParameter.MOISTURE, data: widget.sensorRedings),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
          child: Divider(),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.agriculture_outlined),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Fertility',style: Theme.of(context).textTheme.titleLarge,),
                    ),
                  ],
                )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: LineChartWidget(sensorReadingParameter: SensorReadingParameter.FERTILITY, data: widget.sensorRedings),
            ),
          ],
        ),



      ],
    );
  }
}