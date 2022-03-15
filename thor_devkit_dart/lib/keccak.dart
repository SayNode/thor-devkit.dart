import 'dart:typed_data';
import 'package:pointycastle/digests/keccak.dart';

class Keccak {
  /// Use Keccak 256 algorithm to hash the inputs.
  /// Inputs list of Unit8Lists.
  /// returns Unit8List of 32 length.
  Uint8List keccak256(List<Uint8List> input) {
    final digest = KeccakDigest(256);
    for (int i = 0; i < input.length; i++) {
      digest.update(input[i], 0, input[i].length);
    }
    Uint8List res = Uint8List(32);
    digest.doFinal(res, 0);
    return res;
  }

}
