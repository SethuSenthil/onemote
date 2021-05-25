import 'package:onemote/deviceTypes/roku.dart';

stringToInstance(String device) {
  if (device.toUpperCase() == 'ROKU') return Roku(ip: '192');
}
