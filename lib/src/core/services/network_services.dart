import 'package:biznex/biznex.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkServices {
  static final _info = NetworkInfo();

  static Future<String?> getNetworkAddress() async {
    final address = await _info.getWifiIP();
    return address;
  }
}

final ipProvider = FutureProvider((ref) async {
  return await NetworkServices.getNetworkAddress();
});
