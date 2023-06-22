import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble/enums/sensor_reading_parameter.dart';
import 'package:flutter_ble/models/sensor_data.dart';

class ChartUtils {
  
  //* GET TEMPERATURE CHART READINGS  
  static String _getTempLeftSideText(double value) {
    switch (value.toInt()) {
      case 1:
        return '10°C';
      case 2:
        return '20°C';
      case 3:
        return '30°C';
      case 4:
        return '40°C';
      case 5:
        return '50°C';  
      case 6:
        return '60°C' ; 
      default:
        return '';
    }
  }

  //* GET MOISTURE CHART READINGS 
  static String _getMoistureLeftSideText(double value) {
    switch (value.toInt()) {
      case 1:
        return '10%';
      case 5:
        return '50%';  
      case 6:
        return '100%';           
      default:
        return '';
    }
  }
  
  //* GET SUNLIGHT CHART READINGS 
  static String _getSunlightLeftSideText(double value) {
    switch (value.toInt()) {
      case 1:
        return '100 lux';
      case 3:
        return '500 lux';
      case 6:
        return '1000 lux';          
      default:
        return '';
    }
  }

  //* GET FERTILITY CHART READINGS
  static String _getFertilityLeftSideText(double value) {
    switch (value.toInt()) {
      case 1:
        return '100 µS/cm';
      case 3:
        return '300 µS/cm';
      case 6:
        return '500 µS/cm';         
      default:
        return '';
    }
  }

  //* GET Y AXIS TITLE 
  static Widget leftTitleWidgets(double value, TitleMeta meta,SensorReadingParameter sensorReadingParameter) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = sensorReadingParameter == SensorReadingParameter.TEMPERATURE 
    ? _getTempLeftSideText(value) 
    : sensorReadingParameter == SensorReadingParameter.MOISTURE 
    ? _getMoistureLeftSideText(value) 
    : sensorReadingParameter == SensorReadingParameter.SUNLIGHT 
    ? _getSunlightLeftSideText(value) 
    :  _getFertilityLeftSideText(value);
    if(text.isEmpty) {
       return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  //* GET X AXIS TITLE 
  static Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if(value == 0) {
      return text = const Text('1', style: style);
    }
    else if (value == 2.5) {
      text = const Text('6', style: style);
    }
    else if (value == 5) {
      text = const Text('12', style: style);
    }
    else if (value == 7.5) {
      text = const Text('18', style: style);
    }
    else if (value == 10) {
      text = const Text('24', style: style);
    }
    else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  //* GET TEMPERATURE CHART SPOT 
  static List<FlSpot> _getTempChartSpot(List<SensorData> data) {
      List<FlSpot> spots = [];
      for (SensorData sensorData in data) {
        double x = (sensorData.dateTime.hour * 10) / 24 ;
        double y = (double.parse(sensorData.temperature) * 5) /50;
        spots.add(FlSpot(x, y));
      }
      return spots;
  }

  static List<FlSpot> _getMoistureChartSpot(List<SensorData> data) {
      List<FlSpot> spots = [];
      for (SensorData sensorData in data) {
        double x = (sensorData.dateTime.hour * 10) / 24 ;
        double y = (double.parse(sensorData.moisture) * 6) /100;
        spots.add(FlSpot(x, y));
      }
      return spots;
  }

  //* GET SUNLIGHT CHART SPOT 
  static List<FlSpot> _getSunlightChartSpot(List<SensorData> data) {
      List<FlSpot> spots = [];
      for (SensorData sensorData in data) {
        double x = (sensorData.dateTime.hour * 10) / 24 ;
        double y = (double.parse(sensorData.sunlight) * 6) /1000;
        spots.add(FlSpot(x, y));
      }
      return spots;
  }

  //* GET FERTILITY CHART SPOT 
  static List<FlSpot> _getFertilityChartSpot(List<SensorData> data) {
      List<FlSpot> spots = [];
      for (SensorData sensorData in data) {
        double x = (sensorData.dateTime.hour * 10) / 24 ;
        double y = (double.parse(sensorData.fertility) * 6) /1000;
        spots.add(FlSpot(x, y));
      }
      return spots;
  }

  //* GET CHART SPORT  
  static List<FlSpot> getChartSpot(List<SensorData> data,SensorReadingParameter sensorReadingParameter) {
     switch (sensorReadingParameter) {
       case SensorReadingParameter.TEMPERATURE:
          return _getTempChartSpot(data);
       case SensorReadingParameter.MOISTURE:
          return _getMoistureChartSpot(data);
       case SensorReadingParameter.FERTILITY:
          return _getFertilityChartSpot(data);
       case SensorReadingParameter.SUNLIGHT: 
          return _getSunlightChartSpot(data);      
       default: return [];
     }
  }



}