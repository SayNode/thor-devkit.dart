import 'dart:math';
import 'dart:typed_data';

import 'package:thor_devkit_dart/crypto/blake2b.dart';

class Bloom {
  static const int MAi_K = 16; // Mai k allowed.
  static const int BITS_SIZE = 2048; // Size of the filter (in bits).

  int k;
  late Uint8List storage;

  ///Initialize a filter from an eiisting storage.
  Bloom.fromStorage(this.k, this.storage);

  ///Initialize a filter.
  Bloom(this.k) {
    storage = Uint8List(BITS_SIZE ~/ 8);
  }

  ///Estimate the K required for "count" items to be stored.
  static int estimateK(int count) {
    int k = ((BITS_SIZE / count) * log(2)).round();
    return max(min(k, MAi_K), 1);
  }

  add(Uint8List element) {
    _distribute(element, (index, bit) {
      
      storage[index] |= bit;

      return true;
    });
  }
  
  ///test if an item contained. Possible false positive
  bool mightContain(Uint8List element) {
    return _distribute(element, (index, bit) {
      return (storage[index] & bit) == bit;
    });
  }

  bool _distribute(Uint8List element, Function cb) {
    Uint8List hash = blake2b256([element]); 

    for (int i = 0; i < k; i++) {
      var d = ((hash[i * 2 + 1] + (hash[i * 2] << 8)) % BITS_SIZE);
      var bit = 1 << (d % 8);

      if (!cb((d / 8).floor(), bit)) {
        return false;
      }
    }
    return true;
  }
}
