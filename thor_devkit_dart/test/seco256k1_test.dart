import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:thor_devkit_dart/adress.dart';
import 'package:thor_devkit_dart/secp256k1.dart';
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

    //Uint8List priv = generatePrivateKey();
    //expect(true, isValidPrivateKey(priv));
  });
  test('finds public key for private key', () {
    expect(
        bytesToHex(derivePublicKeyFromBytes(hexToBytes( 'a392604efc2fad9c0b3da43b5f698a2e3f270f170d859912be0d54742275c5f6'), false)),
        '506bc1dc099358e5137292f4efdd57e400f29ba5132aa5d12b18dac1c1f6aaba645c0b7b58158babbfa6c6cd5a48aa7340a8749176b120e8516216787a13dc76');
  });

    print(publicKeyToAdressString(derivePublicKey(hexToInt('67805e58a1c3925caf8837bf5c062014c3380e8e2c8c7f159bc6d795131ad747'), false)));

}
