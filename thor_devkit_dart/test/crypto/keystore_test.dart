import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/keystore.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {

  test('encrypt() test', () {
        String privateKeyHex = "1599403f7b6c17bb09f16e7f8ebe697af3626db5b41e0f9427a49151c6216920";
        String password = "123456";

        // Convert private key to keystore.
        String ks = Keystore.encrypt(hexToBytes(privateKeyHex), password);
        // Convert keystore to private key.
        print(ks);
        Uint8List priv = Keystore.decrypt(ks, password);
        // Private key shall remain the same.
        expect(privateKeyHex, bytesToHex(priv));
    });

  test('decrypt() test', () {
    var originalKey =
        "27196338e7d0b5e7bf1be1c0327c53a244a18ef0b102976980e341500f492425";

    var key = bytesToHex(Keystore.decrypt(
        Keystore.encrypt(
            hexToBytes(
                "27196338e7d0b5e7bf1be1c0327c53a244a18ef0b102976980e341500f492425"),
            'password'),
        'password'));

    expect(originalKey, key);
  });
}
