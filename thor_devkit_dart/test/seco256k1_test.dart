import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/Secp256k1.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('isValidPrivateKey test', () {
    Uint8List tooBig = hexToBytes(
        "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364142");
    expect(false, isValidPrivateKey(tooBig));

    Uint8List lessbits = hexToBytes(
        "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd03641");
    expect(false, isValidPrivateKey(lessbits));

    Uint8List zero = hexToBytes("00");
    expect(false, isValidPrivateKey(zero));

    Uint8List priv = generatePrivateKey();
    expect(true, isValidPrivateKey(priv));
  });
}
