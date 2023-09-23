import 'dart:convert';

import 'package:crypto/crypto.dart';

class EnCryptor {
  static String encryptPin(String pin) {
    final bytes = utf8.encode(pin); // Encode the pin as UTF-8
    final sha256Password = sha256.convert(bytes); // Perform SHA-256 hashing
    final encryptedPassword = sha256Password.toString();
    return encryptedPassword;
  }

  static bool comparePin(String pin1, String pin2) {
    final encryptedPin1 = encryptPin(pin1);
    final encryptedPin2 = encryptPin(pin2);
    return encryptedPin1 == encryptedPin2;
  }
}
