import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/types/compact_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('encode', () {
    CompactFixedBlobKind kind = CompactFixedBlobKind(4);
    kind.setValue("0x00112233");
    expect(kind.toBytes(), hexToBytes("112233"));

    kind.setValue("0x11002233");
    expect(kind.toBytes(), hexToBytes("11002233"));
  });

  test('decode', () {
    CompactFixedBlobKind kind = CompactFixedBlobKind(4);
    Uint8List byte = Uint8List.fromList([1]);

    expect(kind.fromBytes(byte), "0x00000001");
  });

  test('All Zero', () {
    CompactFixedBlobKind kind = CompactFixedBlobKind(4);
    kind.setValue("0x00000000");
    Uint8List byte = Uint8List.fromList([]);
    expect(kind.toBytes(), byte);
  });
}
