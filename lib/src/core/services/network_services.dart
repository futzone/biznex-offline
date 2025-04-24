import 'package:biznex/biznex.dart';
import 'dart:io';

class NetworkServices {
  static Future<String?> getDeviceIP() async {
    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );

    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        return addr.address;
      }
    }

    return null;
  }
}

final ipProvider = FutureProvider((ref) async {
  return await NetworkServices.getDeviceIP();
});
