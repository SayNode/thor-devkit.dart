import 'dart:typed_data';
import 'package:pointycastle/digests/keccak.dart';

Uint8List keccak256(List<Uint8List> inputs) {
  final keccak = KeccakDigest(256);
  keccak.reset();
  for (Uint8List input in inputs) {
    keccak.update(input, 0, input.length);
  }
  Uint8List res = Uint8List(32);
  keccak.doFinal(res, 0);
  return res;
}
