import 'dart:core';
import 'dart:typed_data';
import 'package:thor_devkit_dart/utils.dart';
import 'package:web3dart/crypto.dart' as w3d;

class ThorSignature {
  late w3d.MsgSignature signature;

  ThorSignature(this.signature);

  /// Initiate a signature from 65 bytes.
  ThorSignature.fromBytes(
    Uint8List sigBytes,
  ) {
    if (sigBytes.length != 65) {
      throw Exception("signature bytes shall be 65 length.");
    }

    BigInt r = bytesToBigInt(sigBytes.sublist(0, 32));
    BigInt s = bytesToBigInt(sigBytes.sublist(32, 64));

    //TODO: add 27 or not? Have to look into this
    var v = sigBytes[64] + 27;
    signature = w3d.MsgSignature(r, s, v);
  }

  /// Serialize the signature to Uint8List.
  ///
  /// @return byte[65]
  Uint8List serialize() {
    Uint8List r = bigIntToBytes(signature.r);
    Uint8List s = bigIntToBytes(signature.s);
    var v = signature.v;

    //TODO: remove -27 or not? Have to look into this
    Uint8List byteV = bigIntToBytes(BigInt.from(v - 27));

    return Uint8List.fromList(r + s + byteV);
  }
}
