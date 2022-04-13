import 'dart:core';
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';
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

    BigInt r = bytesToInt(sigBytes.sublist(0, 32));
    BigInt s = bytesToInt(sigBytes.sublist(32, 64));

    //FIXME: add 27 or not? Have to look into this
    var v = sigBytes[64] + 27;
    signature = w3d.MsgSignature(r, s, v);
  }

  /// Serialize the signature to Uint8List.
  ///
  /// @return byte[65]
  Uint8List serialize() {
    Uint8List r = intToBytes(signature.r);
    Uint8List s = intToBytes(signature.s);
    var v = signature.v;

    //FIXME: remove -27 or not? Have to look into this
    Uint8List byteV = intToBytes(BigInt.from(v - 27));

    return Uint8List.fromList(r + s + byteV);
  }
}
