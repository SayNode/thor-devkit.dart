import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/keccak.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('signature from bytes', () {});


//FIXME: Fix this test, the matcher is prbably wrong
  test('serialize', () {
    Uint8List priv = hexToBytes(
        "7582be841ca040aa940fff6c05773129e135623e41acce3e0b8ba520dc1ae26a");
    final messageHash = keccak256(asciiToBytes('hello world'));
    Uint8List sigBytes = sign(messageHash, priv).serialize();
    print(sign(messageHash, priv).v);
    print(hexToBytes('21fbf0696d5e0aa2ef41a2b4ffb623bcaf070461d61cf7251c74161f82fec3a4370854bc0a34b3ab487c1bc021cd318c734c51ae29374f2beb0e6f2dd49b4bf41c')[64]);
    expect(
        sigBytes,
        hexToBytes(
            "f8fe82c74f9e1f5bf443f8a7f8eb968140f554968fdcab0a6ffe904e451c8b9244be44bccb1feb34dd20d9d8943f8c131227e55861736907b02d32c06b934d7200"));
  });
}
