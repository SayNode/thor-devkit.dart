import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/certificate.dart';
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  Uint8List priv = hexToBytes(
      "7582be841ca040aa940fff6c05773129e135623e41acce3e0b8ba520dc1ae26a");
  Uint8List addr =
      publicKeyToAddressBytes(derivePublicKey(bytesToInt(priv), false));
  String sig =
      "0x390870e4a99a6a80c3903e0bc13fdcaf15ae46d27b6365e3e07275990e3e74955ad43dba79682b9d0de3a47e96149539b07dde6b51c49a1c7eb6254036b913b000";


      //TODO: Figure out why this doesnt work
  test('verify correct', () {

            Map<String, String> m = <String, String>{};
            m['type'] = 'text';
            m['content'] = 'fyi';

        Certificate c = Certificate(
            "identification",
            m,
            "localhost",
            1545035330,
            "0x" + bytesToHex(addr),
            signature: sig
        );


        c.verify(c);



  });
}
