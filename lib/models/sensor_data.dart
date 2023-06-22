class SensorData{
  late DateTime dateTime;
  late String temperature;
  late String moisture;
  late String sunlight;
  late String fertility;
  late String deviceId;
 
 SensorData({
  required this.deviceId,
  required this.dateTime, 
  required this.temperature,
  required this.moisture,
  required this.sunlight,
  required this.fertility
  });

}