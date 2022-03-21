import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';
import 'utils.dart';

/// MAX is the maximum number used as private key.
final Uint8List _maxForPrivateKeyByte = hexToBytes(
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141");
final BigInt _maxForPrivateKeyInt = hexToInt(
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141");

/// Test if the private key is valid.
///
/// @param privateKey byte[] of a private key.
/// @return true/false
bool isValidPrivateKey(Uint8List privateKey) {
  var hexKey = bytesToHex(privateKey);
  if (hexToInt(hexKey) == 0) {
    return false;
  }

  if (hexToInt(hexKey) >= _maxForPrivateKeyInt) {
    return false;
  }

  if (privateKey.length != 32) {
    return false;
  }
  return true;
}

/// If the message hash is of valid length or format.
///
/// @param messageHash byte[] of message hash.
/// @return true/false
bool isValidMessageHash(Uint8List messageHash) {
  return messageHash.length == 32;
}

/// Generates a new private key
BigInt generatePrivateKey() {
  final generator = ECKeyGenerator();
  final random = FortunaRandom();
  final keyParams = ECKeyGeneratorParameters(ECCurve_secp256k1());

  generator.init(ParametersWithRandom(keyParams, random));

  final key = generator.generateKeyPair();
  final privateKey = key.privateKey as ECPrivateKey;
  return privateKey.d!;
}

/// Generates a public key for the given private key.
/// @param privateKey is a BigInt
/// @param compressed The output public key is compressed or not.
Uint8List derivePublicKey(BigInt privateKey, bool compressed) {
  final p = (ECCurve_secp256k1().G * privateKey)!;

  return Uint8List.view(p.getEncoded(compressed).buffer, 1);
}

/// Generates a public key for the given private key.
/// @param privateKey is a Uint8List
/// @param compressed The output public key is compressed or not.
Uint8List derivePublicKeyFromBytes(Uint8List privateKey, bool compressed) {
  return derivePublicKey(bytesToInt(privateKey), compressed);
}

//ECSignature  a = ECSignature(r, s);











/*
  Uint8List sign(Uint8List message, Uint8List keyBytes) {
    ECPrivateKey key = ECPrivateKey(hexToInt(bytesToHex(keyBytes)), ECCurve_secp256k1())

  final verifier = ECDSASigner(SHA256Digest())

    ..init(
      true, // verify vs sign
      PrivateKeyParameter(key), // key is an ECPrivateKey
    );
    ECSignature a = verifier.generateSignature(message) as ECSignature;
 return  a.normalize(curveParams);
}
*/

