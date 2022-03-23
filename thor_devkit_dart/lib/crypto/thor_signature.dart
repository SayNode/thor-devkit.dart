import 'dart:core';
import 'dart:typed_data';

import 'package:pointycastle/pointycastle.dart';
import 'package:thor_devkit_dart/utils.dart';

class ThorSignature {
  late ECSignature signature;
  late int v;

  ThorSignature(this.signature, this.v);

  /// Initiate a signature from 65 bytes.
  ThorSignature.fromBytes(
    Uint8List sigBytes,
  ) {
    if (sigBytes.length != 65) {
      throw Exception("signature bytes shall be 65 length.");
    }

    BigInt r = bytesToInt(sigBytes.sublist(0, 32));
    BigInt s = bytesToInt(sigBytes.sublist(32, 64));

    signature = ECSignature(r, s);
    v = sigBytes[64];


  }

        /// Serialize the signature to Uint8List.
    ///
    /// @return byte[65]
    Uint8List serialize() {
      Uint8List r = intToBytes(signature.r);
      Uint8List s = intToBytes(signature.s);
      Uint8List byteV = intToBytes(BigInt.from(v));
      
      return Uint8List.fromList(r+s+byteV);
    }

}
