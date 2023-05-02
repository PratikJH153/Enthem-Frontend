import 'dart:convert';

import 'package:encrypt/encrypt.dart';

String encrypt(String data, String key) {
  final plainText = utf8.encode(data);
  final iv = IV.fromLength(16);
  final encrypter =
      Encrypter(AES(Key.fromUtf8(key), mode: AESMode.ctr, padding: null));
  final encrypted = encrypter.encryptBytes(plainText, iv: iv);
  final cipherText = base64Url.encode(encrypted.bytes);
  final ivString = base64Url.encode(iv.bytes);
  return '$cipherText|$ivString';
}

// Decryption
String decrypt(String data, String key) {
  final parts = data.split('|');
  final encrypted = Encrypted(base64Url.decode(parts[0]));
  final iv = IV(base64Url.decode(parts[1]));
  final encrypter =
      Encrypter(AES(Key.fromUtf8(key), mode: AESMode.ctr, padding: null));
  final decrypted = encrypter.decrypt(encrypted, iv: iv);
  return decrypted;
}
