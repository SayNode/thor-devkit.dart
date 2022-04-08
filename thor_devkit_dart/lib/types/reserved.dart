import 'dart:core';
import 'dart:typed_data';

import 'package:thor_devkit_dart/types/numeric_kind.dart';

class Reserved {
  static final NumericKind featuresKind = NumericKind(4);
  late int features;
  late List<Uint8List> unused;

  Reserved(this.features, List<Uint8List>? unused) {
    if (unused == null) {
      this.unused = [];
    } else {
      this.unused = unused;
    }
  }

  Reserved.getNullReserved() {
    Reserved(0, null);
  }

  bool isNullReserved() {
    if (unused.isEmpty && features == 0) {
      return true;
    } else {
      return false;
    }
  }

  ///Pack the Reserved into a List<Uint8List>

  List<Uint8List> pack() {
    List<Uint8List> mList = [];
    featuresKind.setValueBigInt(BigInt.from(features));
    mList.add(featuresKind.toBytes());
    mList.addAll(unused); // Concat the list at the tail.

    // While some elements in the m_list is "new Uint8List{}",
    // Then just right strip those from the list.
    // Hence reverse order travesal.
    int rightFirstNotEmptyIdx = -10;
    for (int i = mList.length - 1; i >= 0; i--) {
      final Uint8List x = mList[i];
      if (x == null || x.isEmpty) {
        continue;
      } else {
        rightFirstNotEmptyIdx = i;
        break;
      }
    }

    if (rightFirstNotEmptyIdx == -10) {
      return [];
    } else {
      List<Uint8List> rList = [];
      for (int i = 0; i <= rightFirstNotEmptyIdx; i++) {
        rList.add(mList[i]);
      }
      return rList;
    }
  }

  /// Unpack the Reserved from a group of Uint8List.
  /// @param data
  /// @return Instance of Reserved or null.

  Reserved? unpack(List<Uint8List>? data) {
    List<Uint8List> r = [];
    if (data != null) {
      r = data;
    }
    // empty? return null.
    if (r.isEmpty) {
      return null;
    }
    // not empty? start decoding.
    // Check: Right most isn't something of "new Uint8List{}".
    Uint8List last = r[r.length - 1];
    if (last.isEmpty) {
      throw Exception("Right trim the input please.");
    }
    // Decode the features slot.
    int features = featuresKind.fromBytes(r[0]).toInt();
    // Decode the unused. (simply copy the rest of the items)
    if (r.length > 1) {
      return Reserved(features, r.sublist(1, r.length));
    } else {
      // r.size() == 1, so no unused followed.
      return Reserved(features, null);
    }
  }
}
