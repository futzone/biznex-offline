import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String _generatePassword({
  int length = 8,
  bool hasUpper = true,
  bool hasLower = true,
  bool hasNumbers = true,
  bool hasSpecial = false,
}) {
  const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const lower = 'abcdefghijklmnopqrstuvwxyz';
  const numbers = '0123456789';
  const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  String chars = '';
  if (hasUpper) chars += upper;
  if (hasLower) chars += lower;
  if (hasNumbers) chars += numbers;
  if (hasSpecial) chars += special;

  final rand = Random.secure();
  return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
}

class PasswordDatabase {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final String key = "password_key";

  Future<void> savePassword(String password) async {
    await storage.write(key: key, value: password);
  }

  Future<String?> getPassword() async {
    final password = await storage.read(key: key);

    if (password == null || password.isEmpty) {
      final newPassword = _generatePassword(length: 12);
      await savePassword(newPassword);
      return newPassword;
    }

    return password;
  }

  Future<void> deletePassword() async {
    await storage.delete(key: key);
  }
}
