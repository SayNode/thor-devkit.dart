import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/keystore.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {

  //TODO: write real test
  test('encrypt() test', () {
    /*
    print(KeyStore().encrypt(
        hexToBytes(
            "27196338e7d0b5e7bf1be1c0327c53a244a18ef0b102976980e341500f492425"),
        'password'));
        */
  });

  test('decrypt() test', () {
    var originalKey =
        "27196338e7d0b5e7bf1be1c0327c53a244a18ef0b102976980e341500f492425";

    var key = bytesToHex(KeyStore.decrypt(
        KeyStore.encrypt(
            hexToBytes(
                "27196338e7d0b5e7bf1be1c0327c53a244a18ef0b102976980e341500f492425"),
            'password'),
        'password'));

    expect(originalKey, key);
  });
}
