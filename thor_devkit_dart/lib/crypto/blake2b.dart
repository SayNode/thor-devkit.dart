import 'dart:typed_data';
import 'package:pointycastle/digests/blake2b.dart';

///Use Blake2b algorithm to hash the input.
Uint8List blake2b256(List<Uint8List> inputs) {
  final blake2bDigest = Blake2bDigest(digestSize: 32);

        for (Uint8List input in inputs) {
            blake2bDigest.update(input, 0, input.length);
        }
        Uint8List res = Uint8List(32);
        blake2bDigest.doFinal(res, 0);
        return res;
    }