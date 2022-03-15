import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';

import 'utils.dart';

/// MAX is the maximum number used as private key.
final Uint8List _maxForPrivateKeyByte = hexToBytes(
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141");
final BigInt _maxForPrivateKeyInt = hexToInt(
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141");

/// Test if the private key is valid.
///
/// @param privateKey byte[] of a private key.
/// @return true/false
bool isValidPrivateKey(Uint8List privateKey) {
  var hexKey = bytesToHex(privateKey);
  if (hexToInt(hexKey) == 0) {
    return false;
  }

  if (hexToInt(hexKey) >= _maxForPrivateKeyInt) {
    return false;
  }

  if (privateKey.length != 32) {
    return false;
  }
  return true;
}

///Generate a PrivateKey
Uint8List generatePrivateKey() {
  final Random _random = Random.secure();
  late Uint8List values;
  bool validKey = false;
  while (validKey == false) {
    values = Uint8List.fromList(List<int>.generate(32, (i) => _random.nextInt(256)));

    if (isValidPrivateKey(values as Uint8List)) {
      validKey = true;
    }
  }
  return values;
}


