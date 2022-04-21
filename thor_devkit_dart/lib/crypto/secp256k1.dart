import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:thor_devkit_dart/crypto/thor_signature.dart';
import 'package:web3dart/crypto.dart' as web3dart;
import '../utils.dart';

/// MAX is the maximum number used as private key.
final BigInt _maxForPrivateKeyInt = hexToInt(
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141");

/// Test if the private key is valid.
///
/// @param privateKey Uint8List of a private key.
/// @return true/false
bool isValidPrivateKey(Uint8List privateKey) {
  var hexKey = bytesToInt(privateKey);
  if (hexKey.toInt() == 0) {
    return false;
  }

  if (hexKey >= _maxForPrivateKeyInt) {
    return false;
  }

  if (privateKey.length != 32) {
    return false;
  }
  return true;
}

/// If the message hash is of valid length or format.
///
/// @param messageHash Uint8List of message hash.
/// @return true/false
bool isValidMessageHash(Uint8List messageHash) {
  return messageHash.length == 32;
}

/// Generates a new private key
BigInt generatePrivateKey() {
  final random = Random();
  return web3dart.generateNewPrivateKey(random);
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

/// Signs the hashed data in [messageHash] using the given private key and returns a ThorSignature.
ThorSignature sign(Uint8List messageHash, Uint8List privateKey) {
  final msgSig = web3dart.sign(messageHash, privateKey);

  return ThorSignature(msgSig);
}

Uint8List recover(Uint8List messageHash, ThorSignature signature) {
  return web3dart.ecRecover(
      messageHash, 
      signature.signature);
}
