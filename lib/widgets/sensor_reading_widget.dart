import 'package:flutter/material.dart';
import 'package:flutter_ble/models/sensor_data.dart';
import 'package:flutter_ble/utils/date_time_util.dart';

class SensorReadingWidget extends StatefulWidget {
  final SensorData sensorData;
  final bool isHistoricalReadings;
  const SensorReadingWidget({
    super.key, 
    required this.sensorData,
    this.isHistoricalReadings = false,
    });

  @override
  State<SensorReadingWidget> createState() => _SensorReadingWidgetState();
}

class _SensorReadingWidgetState extends State<SensorReadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           !widget.isHistoricalReadings ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month_outlined),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(DateTimeUtil.getFormatedDate(widget.sensorData.dateTime)),
                ),
              ],
            ) : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.watch_later_outlined),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(DateTimeUtil.getFormatedTime(context,widget.sensorData.dateTime)),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                   const Icon(Icons.thermostat),
                   Padding(
                     padding: const EdgeInsets.only(left: 8.0),
                     child: Column(
                      children: [
                        Text('${widget.sensorData.temperature} °C' ,),
                        Text('Temp',style: Theme.of(context).textTheme.caption,)
                      ],
                     ),
                   )
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.water_drop),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Text('${widget.sensorData.moisture} %' ,),
                        Text('Moinsture',style: Theme.of(context).textTheme.caption,)
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                   const Icon(Icons.wb_sunny_outlined),
                   Padding(
                     padding: const EdgeInsets.only(left: 8.0),
                     child: Column(
                      children: [
                        Text('${widget.sensorData.sunlight} LUX' ,),
                        Text('Sunlight',style: Theme.of(context).textTheme.caption,)
                      ],
                     ),
                   )
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.agriculture_outlined),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Text('${widget.sensorData.fertility} µS/cm' ,),
                        Text('Fertility',style: Theme.of(context).textTheme.caption,)
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}