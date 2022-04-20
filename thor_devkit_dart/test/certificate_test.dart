import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/certificate.dart';
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/blake2b.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  Uint8List priv = hexToBytes(
      "7582be841ca040aa940fff6c05773129e135623e41acce3e0b8ba520dc1ae26a");
  String addr = Address.publicKeyToAddressString(derivePublicKeyFromBytes(priv, false));
  String sig =
      "0x390870e4a99a6a80c3903e0bc13fdcaf15ae46d27b6365e3e07275990e3e74955ad43dba79682b9d0de3a47e96149539b07dde6b51c49a1c7eb6254036b913b000";


  test('verify correct', () {
    Map<String, String> m = <String, String>{};
    m['type'] = 'text';
    m['content'] = 'fyi';

    Certificate c = Certificate(
        "identification", m, "localhost", 1545035330, addr, 
        signature: sig);
 
      c.verify();
  });

    test('verify correct dart signed', () {
    Map<String, String> m = <String, String>{};
    m['type'] = 'text';
    m['content'] = 'fyi';

    Certificate c = Certificate(
        "identification", m, "localhost", 1545035330, addr);

        c.signature = sig;
 
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

/*
    test('verify', () {

      var PRIV_KEY = hexToBytes(
    '7582be841ca040aa940fff6c05773129e135623e41acce3e0b8ba520dc1ae26a');

var SIGNER = '0x' + Adress.publicKeyToAddressString(derivePublicKeyFromBytes(PRIV_KEY, false));

var cert_dict = {
    'purpose': 'identification',
    'payload': {
        'type': 'text',
        'content': 'fyi'
    },
    'domain': 'localhost',
    'timestamp': 1545035330,
    'signer': SIGNER
};
Certificate cert = Certificate.fromMap(cert_dict);


cert2_dict = {
    'domain': 'localhost',
    'timestamp': 1545035330,
    'purpose': 'identification',
    'signer': SIGNER,
    'payload': {
        'content': 'fyi',
        'type': 'text'
    }
}
cert2 = certificate.Certificate(**cert2_dict)

    var to_be_signed, _ = blake2b256([
        certificate.encode(cert).encode('utf-8')
    ]);


  });



*/

}


