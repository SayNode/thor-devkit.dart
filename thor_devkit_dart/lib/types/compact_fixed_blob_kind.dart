import 'dart:typed_data';

import 'package:thor_devkit_dart/types/fixed_blob_kind.dart';

class CompactFixedBlobKind extends FixedBlobKind {
  CompactFixedBlobKind(int byteLength) : super(0) {
    super.byteLength = byteLength;
  }

  @override
  Uint8List toBytes() {
    Uint8List m = super.toBytes();
    int firstNonZeroIndex = -1;
    for (int i = 0; i < m.length; i++) {
      if (m[i] != 0) {
        firstNonZeroIndex = i;
        break;
      }
    }

    Uint8List? n;
    if (firstNonZeroIndex != -1) {
      n = Uint8List.sublistView(m, firstNonZeroIndex, m.length);
    }

    if (n != null) {
      return n;
    } else {
      return Uint8List.fromList([]);
    }
  }

  @override
  String fromBytes(Uint8List data) {
    // check length
    if (data.length > byteLength) {
      throw Exception("Input too long.");
    }
    if (data.isEmpty) {
      throw Exception("Input length 0, forbidden.");
    }
    // check leading zeros
    if (data[0] == 0) {
      throw Exception("Remove leading zeros, please.");
    }

    int missingZeros = byteLength - data.length;
    if (missingZeros > 0) {
      // indeed missing some zeros!
      Uint8List temp = Uint8List(missingZeros);
      Uint8List newData = Uint8List.fromList((temp + data));
      return super.fromBytes(newData);
    } else {
      return super.fromBytes(data);
    }
  }
}
