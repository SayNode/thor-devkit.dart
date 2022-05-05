import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/keccak.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/crypto/thor_signature.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('signature from bytes', () {

    final sig = ThorSignature.fromBytes(hexToBytes(
            "f8fe82c74f9e1f5bf443f8a7f8eb968140f554968fdcab0a6ffe904e451c8b9244be44bccb1feb34dd20d9d8943f8c131227e55861736907b02d32c06b934d7200"));

            
            expect(sig.signature.r, BigInt.parse('112623268203542962336683443235965960954055727881808573265071148232367478180754')); 
            expect(sig.signature.s, BigInt.parse('31093449054583088445972786457650737184360800860675945013753219307278091636082'));
            expect(sig.signature.v, 27);

            expect(() => ThorSignature.fromBytes(hexToBytes(
            "f8fe82c74f9e1f5bf443f8a7f8eb968140f554968fdcab0a6ffe904e451c8b9244be44bccb1feb34dd20d9d8943f8c131227e55861736907b02d32c06b934d72")), throwsA(isA<Exception>()));


  });


//FIXME: Fix this test, this test could be incorrect
  test('serialize', () {
    Uint8List priv = hexToBytes(
        "7582be841ca040aa940fff6c05773129e135623e41acce3e0b8ba520dc1ae26a");
    final messageHash = keccak256([asciiToBytes('hello world')]);
    Uint8List sigBytes = sign(messageHash, priv).serialize();
    expect(
        sigBytes,
        hexToBytes(
            "f8fe82c74f9e1f5bf443f8a7f8eb968140f554968fdcab0a6ffe904e451c8b9244be44bccb1feb34dd20d9d8943f8c131227e55861736907b02d32c06b934d7200"));
  });
}
