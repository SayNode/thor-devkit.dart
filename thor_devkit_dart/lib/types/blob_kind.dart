import 'dart:typed_data';

import 'package:thor_devkit_dart/utils.dart';

///This is a pre-defined type for "0x...." like hex strings,
/// which shouldn't be interpreted as a number, usually an identifier.
/// like: address, block_ref, data to smart contract.

class BlobKind {
  Uint8List? data; // Internal representation of this kind.

  BlobKind();

  setValue(String hexString) {
    data = hexToBytes(remove0x(hexString));
  }

  Uint8List toBytes() {
    return data!;
  }

  String fromBytes(Uint8List data) {
    this.data = data;
    return prepend0x(bytesToHex(data));
  }
/// @return the hex string without "0x" prefix.
  @override
  String toString() {
    return bytesToHex(data!);
  }
}
