import 'dart:typed_data';

import 'package:convert/convert.dart';

class SensorValueConversionUtils{

  static Uint8List int32byte(int value) {
    return Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.little);
  }

  //* HISTORICAL READING COUNT CONVERSION 
  static int getHistoricalReadingCount(List hexValue) {
    return int.parse(hexValue[1] + hexValue[0], radix: 16);
  }

  //* DEVICE  EPOCH CONVERSION 
  static int getDeviceEpoch(List<int> readDeviceTimeAddress ) {
    String dateInHex = hex.encoder.convert(readDeviceTimeAddress);
    return int.parse(
              dateInHex[6] +
              dateInHex[7] +
              dateInHex[4] +
              dateInHex[5] +
              dateInHex[2] +
              dateInHex[3] +
              dateInHex[0] +
              dateInHex[1],
        radix: 16);
  }

//* HOISTORICAL READING CONVERTION STARTS HERE: 

  //* EPOCH OF HISTORICAL READING  
  static int getEpochFromHistoricalReadings(List<int> readings) {
     String dateInHex = hex.encoder.convert(readings);
    return int.parse(
        dateInHex.substring(6, 8) +
        dateInHex.substring(4, 6) +
        dateInHex.substring(2, 4) +
        dateInHex.substring(0, 2),
    radix: 16);
  }

  //* HISTORICAL TEMP READING
  static double getTempFromHistoricalReadings(List<int> readings) {
    String dateInHex = hex.encoder.convert(readings);
    return (int.parse(dateInHex.substring(10, 12) + dateInHex.substring(8, 10),radix: 16)/10);
  }

  //* HISTORICAL MOISTURE READING
  static int getMoistureFromHistoricalReadings(List<int> readings) {
    String dateInHex = hex.encoder.convert(readings);
    return int.parse(dateInHex.substring(22, 24),radix: 16);
  }

  //* HISTORICAL SUNLIGHT READING
  static int getSunlightFromHistoricalReadings(List<int> readings) {
    String dateInHex = hex.encoder.convert(readings);
    return int.parse(dateInHex.substring(20, 22) +
              dateInHex.substring(18, 20) +
              dateInHex.substring(16, 18) +
              dateInHex.substring(14, 16),radix: 16);
  }

//* HISTORICAL READING CONVERTION ENDS HERE:  


//* REAL TIME READING CONVERTION STARTS HERE: 

  //* HISTORICAL FERTILITY READING
  static int getFertilityFromHistoricalReadings(List<int> readings) {
    String dateInHex = hex.encoder.convert(readings);
    return int.parse(dateInHex.substring(26, 28) + dateInHex.substring(24, 26),radix: 16);
  }


  //* REALTIME TEMPERATURE READING 
  static double getRealTimeTempReading(List<int> readings) {
    String dateInHex = hex.encoder.convert(readings);
    return (int.parse(dateInHex.substring(2, 4) + dateInHex.substring(0, 2),radix: 16) / 10);
  }

  //* REALTIME MOISTURE READING 
  static int getRealTimeMoistureReading(List<int> readings) {
    String dateInHex = hex.encoder.convert(readings);
    return int.parse(dateInHex.substring(14, 16),radix: 16);
  }

  //* REALTIME SUNLIGHT READING 
  static int getRealTimeSunlightReading(List<int> readings) {
    String dateInHex = hex.encoder.convert(readings);
    return int.parse(dateInHex.substring(12, 14) + dateInHex.substring(10, 12) + dateInHex.substring(8, 10) + dateInHex.substring(6, 8),radix: 16);
  }

  //* REALTIME FERTILITY READING 
  static int getRealTimeFertilityReading(List<int> readings) {
    String dateInHex = hex.encoder.convert(readings);
    return int.parse(dateInHex.substring(18, 20) + dateInHex.substring(16, 18),radix: 16);
  }
//* REAL TIME READING CONVERTION ENDS HERE: 
}