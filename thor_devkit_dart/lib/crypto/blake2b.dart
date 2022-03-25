import 'dart:typed_data';
import 'package:pointycastle/digests/blake2b.dart';

///Use Blake2b algorithm to hash the input.
Uint8List blake2b256(Uint8List inputSingle) {
  final blake2bDigest = Blake2bDigest(digestSize: 32);

  blake2bDigest.reset();
  return blake2bDigest.process(inputSingle);
}
