import 'dart:convert';

import 'dart:typed_data';

import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/blake2b.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/crypto/thor_signature.dart';
import 'package:thor_devkit_dart/utils.dart';

class Certificate {
  late String purpose;
  late Map payload;
  late String domain;
  late int timestamp;
  late String signer;
  String? signature;

  Certificate(
      this.purpose, this.payload, this.domain,this.timestamp, String signer, 
      {String? signature}) {
    this.signer = signer.toLowerCase();
    if (signature != null) {
      this.signature = signature.toLowerCase();
    }
  }

  Certificate.fromMap(Map map) {
    purpose = map['purpose'];
    payload = map['payload'];
    domain = map['domain'];
    timestamp = map['timestamp'];
    signer = map['signer'];
    signature = map['signature'];
  }

  Certificate.fromJsonString(String input) {
    Map map = jsonDecode(input);
    purpose = map['purpose'];
    payload = map['payload'];
    domain = map['domain'];
    timestamp = map['timestamp'];
    signer = map['signer'];
    signature = map['signature'];
  }

  Map toMap() {
    String sig = '';
    if (signature != null) {
      sig = signature!;
    }
    final map = <String, Object>{
      'purpose': purpose,
      'payload': payload,
      'domain': domain,
      'timestamp': timestamp,
      'signer': signer,
      'signature': sig
    };
    return map;
  }

  /// Encode a certificate into json string.
  String toJsonString() {
    return json.encode(toMap());
  }

  /** Check if signature is in good shape. */
  bool _isSignature(String input) {
    return RegExp(r'^0x[0-9a-f]+$', caseSensitive: false).hasMatch(input);


    // from js regex  if (!/^0x[0-9a-f]+$/i.test(signature) || signature.length % 2 !== 0)
  }

  /// Verify a cert (mainly on signature matching.)
  /// @param c
  /// @return
  verify(Certificate c) {
    if (c.signature == null) {
      throw Exception("Cert needs a signature.");
    }
    if (c.signature!.length % 2 != 0) {
      throw Exception("Signature shall be even length.");
    }
    if (!_isSignature(c.signature!)) {
      throw Exception("Signature cannot pass the style check.");
    }

    // Compares if the signer matches with the signature.
    Map temp = c.toMap();
    temp.remove("signature");
    Certificate newCert = Certificate.fromMap(temp);
    String j = newCert.toJsonString();
    Uint8List signingHash = blake2b256(Uint8List.fromList(utf8.encode(j)));


    // Try to recover the public key.
    Uint8List pubKey = recover(signingHash,
        ThorSignature.fromBytes(hexToBytes(c.signature!.substring(2))));


    Uint8List addrBytes = publicKeyToAddressBytes(pubKey);

    String addr = ("0x" + bytesToHex(addrBytes)).toLowerCase();
    if (addr.compareTo(c.signer.toLowerCase()) != 0) {
      throw Exception("signature does not match with the signer.");
    }
  }
}
