import 'dart:developer';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class LicenseServices {
  final String _key =
      "oakqGiacopoTeujlblLHfuH1iCu9BruH5qvmGbvRUYsxfZ88LCBvNSJYJu4hxuHMNs8JkILPgFYtainx7MlwRr5FAQQz7JcLQ3h8SRlxICJzEQJQdPWgAYkqTvqZfr3QWQ";

  Future<String?> getDeviceId() async {
    final box = await Hive.openBox('device_key');
    if (box.get('id') == null) {
      var uuid = Uuid();
      final id = "${uuid.v1()}${uuid.v1()}";
      await box.put('id', id);

      return id;
    }

    return box.get('id');
  }

  Future<String> generateLicenseKey(String deviceId) async {
    final id = await getDeviceId();
    final jwt = JWT({'id': id});

    final token = jwt.sign(SecretKey(_key));
    return token;
  }

  Future<bool> verifyLicense(String inputKey) async {
    try {
      final jwt = JWT.verify(inputKey, SecretKey(_key));
      final id = await getDeviceId();

      log(id.toString());
      log(jwt.payload['id']);
      return jwt.payload['id'] == id;
    } catch (error) {
      log(error.toString());
      return false;
    }
  }
}
