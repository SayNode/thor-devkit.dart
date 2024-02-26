import 'dart:typed_data';

import '../utils.dart';

class NullableFixedBlobKind {
  Uint8List? data;
  late int byteLength;

  NullableFixedBlobKind(this.byteLength);

  setValue(String? hexString) {
    if (hexString != null) {
      String realHex = remove0x(hexString);

       if (realHex.length != byteLength * 2) {
        throw Exception("");}

      data = hexToBytes(realHex);
    }
  }

  Uint8List toBytes() {
    if (data == null) {
      return Uint8List.fromList([]);
    } else {
      return data!;
    }
  }

  String? fromBytes(Uint8List data) {
    if (data.isEmpty) {
      this.data = null;
      return null;
    } else {
      if (data.length != byteLength) {
        throw Exception("");
      }
      this.data = data;
      return prepend0x(bytesToHex(data));
    }
  }
}
