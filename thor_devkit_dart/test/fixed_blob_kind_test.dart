import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/types/fixed_blob_kind.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('encode', () {
    FixedBlobKind fbk = new FixedBlobKind(4); // 4 bytes fixed.
    fbk.setValue("0x12345678");
    expect(bytesToHex(fbk.toBytes()), "12345678");
  });

  test('wrong length', () {
    FixedBlobKind fbk = new FixedBlobKind(4);

    expect(() => fbk.setValue("0x1122334455"), throwsException);
  });

  test('decode', () {
    FixedBlobKind fbk = new FixedBlobKind(4); // 4 bytes fixed.
    String result = fbk.fromBytes(Uint8List.fromList([1, 2, 3, 4]));
    expect(result, "0x01020304");
  });

  test('wrong length decode', () {
    FixedBlobKind fbk = new FixedBlobKind(4);
    expect(() => fbk.fromBytes(Uint8List.fromList([1, 2])), throwsException);
    expect(() => fbk.fromBytes(Uint8List.fromList([])), throwsException);
  });

}
