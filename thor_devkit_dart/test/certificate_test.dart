import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/certificate.dart';
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  Uint8List priv = hexToBytes(
      "7582be841ca040aa940fff6c05773129e135623e41acce3e0b8ba520dc1ae26a");
  String addr = Adress.publicKeyToAddressString(derivePublicKeyFromBytes(priv, false));
  String sig =
      "0x390870e4a99a6a80c3903e0bc13fdcaf15ae46d27b6365e3e07275990e3e74955ad43dba79682b9d0de3a47e96149539b07dde6b51c49a1c7eb6254036b913b000";

  //TODO: Figure out why this doesnt work(signature last byte 0 or 27?)
  test('verify correct', () {
    Map<String, String> m = <String, String>{};
    m['type'] = 'text';
    m['content'] = 'fyi';

    Certificate c = Certificate(
        "identification", m, "localhost", 1545035330, addr,
        signature: sig);

// print(bytesToHex(derivePublicKeyFromBytes(priv, false)));
    c.verify();
  });

  test('not a valid sig', () {
    Map<String, String> m = <String, String>{};
    m['type'] = 'text';
    m['content'] = 'fyi';

    Certificate c = Certificate(
        "identification", m, "localhost", 1545035330, addr,
        signature:
            '1x390870e4a99a6a80c3903e0bc13fdcaf15ae46d27b6365e3e07275990e3e74955ad43dba79682b9d0de3a47e96149539b07dde6b51c49a1c7eb6254036b913b000' // invalid sig
        );

    expect(() => c.verify(), throwsException);
  });

  test('not  match', () {
    Map<String, String> m = <String, String>{};
    m['type'] = 'text';
    m['content'] = 'fyi';

    Certificate c = Certificate(
        "identification", m, "localhost", 1545035330, addr,
        signature:
            '0x390870e4a99a6a80c3903e0bc13fdcaf15ae46d27b6365e3e07275990e3e74955ad43dba796aaaad0de3a47e96149539b07dde6b51c49a1c7eb6254036b913b000' // wrong sig.
        );

    expect(() => c.verify(), throwsException);
  });
}


//699612bb2d72d1052bc89f6bdcda8385c6a7f21f2f9cf81d6793150cc17b8f0e
//d96176be62ff9460fa4dd9edee1aada23ae2a93c93d28f8a3eacba99806fa06f