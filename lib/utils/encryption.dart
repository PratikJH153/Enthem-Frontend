// String encrypt(String text, String secretKey) {
//   final salt = List<int>.generate(16, (_) => _secureRandom.nextInt(256));
//   final iv = List<int>.generate(16, (_) => _secureRandom.nextInt(256));
//   final key = _deriveKey(secretKey, salt);
//   final cipher = _createCipher(key, iv, true);
//   final encrypted = cipher.process(utf8.encode(text));
//   return '${base64Encode(salt)}:${base64Encode(iv)}:${base64Encode(encrypted)}';
// }

// String decrypt(String data, String secretKey) {
//   List<String> parts = data.split(':');
//   Uint8List salt = Uint8List.fromList(hex.decode(parts[0]));
//   Uint8List iv = Uint8List.fromList(hex.decode(parts[1]));
//   Uint8List encrypted = Uint8List.fromList(hex.decode(parts[2]));
//   var pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
//   pbkdf2.init(Pbkdf2Parameters(salt, 100000, 32));
//   Uint8List key = pbkdf2.process(Uint8List.fromList(utf8.encode(secretKey)));
//   var aes = AESFastEngine();
//   var cbc = CBCBlockCipher(aes);
//   var params = ParametersWithIV(KeyParameter(key), iv);
//   cbc.init(false, params);
//   var decrypted = cbc.process(encrypted);
//   return utf8.decode(decrypted);
// }

// import 'dart:convert';

// import 'package:encrypt/encrypt.dart';

// class EncryptionUtils {
//   static final salt = IV.fromLength(256);
//   static final iv = IV.fromLength(256);

//   static String encrypt(String text, String secretKey) {
//     final key = Key.fromUtf8(secretKey);
//     final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

//     final encrypted = encrypter.encrypt(text, iv: iv);
//     final encoded = base64.encode(salt.bytes + iv.bytes + encrypted.bytes);

//     return encoded;
//   }

//   static String decrypt(String data, String secretKey) {
//     final decoded = base64.decode(data);
//     final key = Key.fromUtf8(secretKey);
//     final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
//     final encryptedBytes = decoded.sublist(256);
//     final decrypted = encrypter.decrypt64(
//       base64.encode(encryptedBytes),
//       iv: iv,
//     );

//     return decrypted;
//   }
// }
