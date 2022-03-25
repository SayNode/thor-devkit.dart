import 'dart:typed_data';
import 'package:pointycastle/digests/keccak.dart';

final keccakDigest = KeccakDigest(256);

Uint8List keccak256(Uint8List input) {
  keccakDigest.reset();
  return keccakDigest.process(input);
  
}
