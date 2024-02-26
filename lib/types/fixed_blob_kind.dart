import 'dart:typed_data';

import 'package:thor_devkit_dart/types/blob_kind.dart';
import 'package:thor_devkit_dart/utils.dart';

class FixedBlobKind extends BlobKind {
  late int byteLength;

  FixedBlobKind(this.byteLength);

  @override
  void setValue(String hexString) {
    // Strip the "0x".
    String realHex = remove0x(hexString);

    // Length check.
    if (realHex.length != byteLength * 2) {
      // 1 byte = 2 hex chars.
      throw Exception("");
    }
    // Set it.
    super.setValue(hexString);
  }

  @override
  String fromBytes(Uint8List data) {
    // Validation.
    if (data.length != byteLength) {
      throw Exception("");
    }

    return super.fromBytes(data);
  }
}
