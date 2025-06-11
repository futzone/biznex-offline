import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import 'package:pub_semver/pub_semver.dart';

const updateDataUrl = "https://raw.githubusercontent.com/futzone/biznex-offline/refs/heads/main/assets/releases/release.json";

Future<void> checkAndUpdate() async {
  log("checking for updates");
  final response = await http.get(Uri.parse(updateDataUrl));

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = jsonDecode(response.body);
    final latest = Version.parse(data['version']);
    final current = Version.parse('1.0.0');

    if (latest > current) {
      log("have new updates. downloading...");
      final url = data['url'];
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/update_installer.exe';

      final file = File(filePath);
      final updateData = await http.get(Uri.parse(url));
      await file.writeAsBytes(updateData.bodyBytes);

      log("downloaded. running...");
      final shell = Shell();
      await shell.run('start "" "$filePath"');
      exit(0);
    }
  }
}
