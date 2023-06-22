import 'package:flutter_ble/models/sensor_data.dart';
import 'dart:async';

import 'package:flutter_ble/utils/constant.dart';
import 'package:flutter_ble/utils/sensor_value_converstion.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  static final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  static BluetoothDevice? connectedDevice;
  static BluetoothCharacteristic? deviceModeWriteCharacteristic;
  static BluetoothCharacteristic? realTimeSensorValueReadCharacteristic;
  static BluetoothCharacteristic? firmwareReadCharacteristic;
  static BluetoothCharacteristic? historicalSensorValueReadCharacteristic;
  static BluetoothCharacteristic? readDeviceTimeCharacteristic;
  static BluetoothService? dataService;
  static BluetoothCharacteristic? historicalModeWriteCharacteristic;
  static int devicepochTime = 0;

  //* START SCANING
  static Future startScanDevices() async {
    if(!flutterBlue.isScanningNow) {
      await flutterBlue.startScan(timeout: const Duration(seconds: 120))
      .timeout(const Duration(seconds: 120),onTimeout: (() {
         stopScanDevices();
      }))
      .catchError((e) {
        stopScanDevices();
      });
    }
    
  }

  //* STOP SCANING 
  static stopScanDevices() {
    flutterBlue.stopScan();
  }

  //* SCAN RESULT STREAM 
  static Stream<List<ScanResult>> scanResultStream() {
    startScanDevices();
    StreamController<List<ScanResult>> deviceListStreamController = StreamController();
    flutterBlue.scanResults.listen((devices) {
      if(devices.isNotEmpty) {
        flutterBlue.stopScan();
      }
      
      deviceListStreamController.add(devices);
    });
    return deviceListStreamController.stream;
  }

  //* CONNECTED DEVICE
  static connectDevice(BluetoothDevice device) async {
    await device.connect();
    connectedDevice = device;
    return;
  }

  //* DISCONNECT DEVICE 
  static Future disconnectDevice() async {
    if(connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
    }  
  }

  //* DISCOVER SERVICES AND CHARACTERISTICS
  static Future discoverService() async {
    if(connectedDevice != null) {
      List<BluetoothService> services = await connectedDevice!.discoverServices();
      for (BluetoothService service in services) {
          if(service.uuid.toString() == Constants.DATA_SERVICE) {
              dataService = service;
              if(dataService != null) {
                for (BluetoothCharacteristic characteristic in dataService!.characteristics) {
                   if(characteristic.uuid.toString() == Constants.DEVICE_MODE_CHANGE_CHARACTERISTIC) {
                    deviceModeWriteCharacteristic = characteristic;
                   }
                   else if (characteristic.uuid.toString() == Constants.REAL_TIME_SENSOR_VALUE_CHARACTERISTIC) {
                    realTimeSensorValueReadCharacteristic = characteristic;
                   }
                   else if (characteristic.uuid.toString() == Constants.FIRMWARE_VERSION_BATTERY_LEVEL_CHARACTERISTIC) {
                    firmwareReadCharacteristic = characteristic;
                   }
                }
              }
          }
          else if (service.uuid.toString() == Constants.HISTORICAL_DATA_SERVICE) {
            for (BluetoothCharacteristic characteristic in service.characteristics) {
              if (characteristic.uuid.toString() == Constants.HISTORICAL_SENSOR_VALUE_CHARACTERISTIC) {
                 historicalSensorValueReadCharacteristic = characteristic; 
              }
              else if (characteristic.uuid.toString() == Constants.HISTORICAL_MODE_WRITE_CHARACTERISTIC) {
                  historicalModeWriteCharacteristic = characteristic;
              }
              else if (characteristic.uuid.toString() == Constants.READ_DEVICE_TIME_CHARACTERISTIC) {
                readDeviceTimeCharacteristic = characteristic;
              }
            }
            
          }
      }
    }
      
  }

  //* GET SENSOR HISTORY DATA COUNT  
  static Future<List<List<int>>> _getHistoryDataCount() async {
   List<List<int>> listCountAddress = [];
   if(historicalModeWriteCharacteristic != null
    && historicalSensorValueReadCharacteristic != null 
    && readDeviceTimeCharacteristic != null){
      await historicalModeWriteCharacteristic!.write(Constants.HISTORICAL_MODE_COMMAND);
      List<int> sensorValue = await historicalSensorValueReadCharacteristic!.read();
      List hexValue = [];
        for (int element in sensorValue) {
          hexValue.add(element.toRadixString(16));
        }
        int count = SensorValueConversionUtils.getHistoricalReadingCount(hexValue);
        List<int> address = [];
        List<int> readDeviceTimeAddress = await readDeviceTimeCharacteristic!.read();
        int deviceDateInEpoch = SensorValueConversionUtils.getDeviceEpoch(readDeviceTimeAddress);
        int currentDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        devicepochTime = (currentDate) - deviceDateInEpoch;
        for (int i = 0; i < count; i++) {
          address = [];
          address.add(0xa1);
          address.add(SensorValueConversionUtils.int32byte(i)[0]);
          address.add(SensorValueConversionUtils.int32byte(i)[1]);
          listCountAddress.add(address);
        }
   }
  return listCountAddress;
  }

  //* READ HISTORY DATA FROM BLE DEVICE
  static Future<List<SensorData>> readHistoryData() async {
    List<SensorData> historySensorValues = [];
    if(historicalModeWriteCharacteristic != null 
    && historicalSensorValueReadCharacteristic != null 
    && readDeviceTimeCharacteristic != null) {
      List<List<int>> historyValuesCountAddress = await _getHistoryDataCount();
      for (List<int> address in historyValuesCountAddress) {
          await historicalModeWriteCharacteristic!
          .write(address)
          .whenComplete(() async {
        await historicalSensorValueReadCharacteristic!.read().then((readings) {
          int dateInEpoch = SensorValueConversionUtils.getEpochFromHistoricalReadings(readings);
          String temperature = SensorValueConversionUtils.getTempFromHistoricalReadings(readings) .toString();
          String sunlight = SensorValueConversionUtils.getSunlightFromHistoricalReadings(readings).toString();
          String moisture = SensorValueConversionUtils.getMoistureFromHistoricalReadings(readings).toString();
          String fertility = SensorValueConversionUtils.getFertilityFromHistoricalReadings(readings).toString();
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
              (devicepochTime + dateInEpoch) * 1000);
          historySensorValues.add(
            SensorData(
             deviceId: connectedDevice!.id.id, 
             dateTime: dateTime,
             temperature: temperature, 
             moisture: moisture, 
             sunlight: sunlight, 
             fertility: fertility));
        });
      });
      }
    }
    return historySensorValues;
  } 

  //* READ REAL TIME SENSOR VALUES
  static Stream<SensorData?> readRealTimeSensorValueStream() {
    StreamController<SensorData?> sensorValueStreamController = StreamController();
    if(deviceModeWriteCharacteristic != null && realTimeSensorValueReadCharacteristic != null) {
      deviceModeWriteCharacteristic!.write(Constants.REAL_TIME_MODE_COMMAND).whenComplete(() async {
      await realTimeSensorValueReadCharacteristic!.setNotifyValue(true);
      realTimeSensorValueReadCharacteristic!.value.listen((readings) {
        SensorData? sensorData;
        if(readings.isNotEmpty) {
          connectedDevice!.state.listen((event) {
            if (event == BluetoothDeviceState.disconnected) {
              disconnectDevice();
            }
          });
          String temperature = SensorValueConversionUtils.getRealTimeTempReading(readings).toString();
          String sunlight = SensorValueConversionUtils.getRealTimeSunlightReading(readings).toString();
          String moisture = SensorValueConversionUtils.getRealTimeMoistureReading(readings).toString();
          String fertility = SensorValueConversionUtils.getRealTimeFertilityReading(readings).toString();
          sensorData = SensorData(deviceId: connectedDevice!.id.toString(), dateTime: DateTime.now(), temperature: temperature, moisture: moisture, sunlight: sunlight, fertility: fertility);
          sensorValueStreamController.sink.add(sensorData);
        }
        
      });
    });
    }
    
    return sensorValueStreamController.stream;  
  }

}