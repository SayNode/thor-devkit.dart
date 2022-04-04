import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/types/blob_kind.dart';
import 'package:thor_devkit_dart/types/numeric_kind.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('encode', () {
    NumericKind kind = NumericKind(8); // Max 8 bytes.
    kind.setValueString("0x0");
    expect(bytesToHex(kind.toBytes()), "");
    kind.setValueString("0x123");
    expect(bytesToHex(kind.toBytes()), "0123");
    kind.setValueString("0");
    expect(bytesToHex(kind.toBytes()), "");
    kind.setValueBigInt(BigInt.from(0));
    expect(bytesToHex(kind.toBytes()), "");
    kind.setValueString("100");
    expect(bytesToHex(kind.toBytes()), "64");
  });

  test('null test', () {
    NumericKind kind = NumericKind(8);

    expect(() => kind.toBytes(), throwsException);
  });

  test('belwo zero', () {
    NumericKind kind = NumericKind(8);

    expect(() => kind.setValueBigInt(BigInt.from(-1)), throwsException);
  });

  test('not hex', () {
    NumericKind kind = NumericKind(8);

    expect(() => kind.setValueString("0x"), throwsException);
  });

  test('too long', () {
    NumericKind kind = NumericKind(8);
    expect(() => kind.setValueString("0x12345678123456780"), throwsException);
    expect(() => kind.toBytes(), throwsException);
  });

  test('wrong hex', () {
    NumericKind kind = NumericKind(8);

    expect(() => kind.setValueString("0x123z"), throwsException);
  });

  test('decode', () {
    NumericKind kind = new NumericKind(8);
    BigInt b = kind.fromBytes(Uint8List.fromList([]));
    expect(b.compareTo(BigInt.from(0)), 0);
    BigInt b2 = kind.fromBytes(Uint8List.fromList([1, 2, 3]));
    expect(b2.compareTo(hexToInt("010203")), 0);
    BigInt b3 = kind.fromBytes(Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]));
    expect(b3.compareTo(hexToInt("0102030405060708")), 0);
  });

  test('too long decode', () {
    NumericKind kind = NumericKind(8);
    expect(
        () => kind.fromBytes(Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9])),
        throwsException);
  });

  test('leading zeros', () {
    NumericKind kind = NumericKind(8);
    expect(
        () => kind.fromBytes(Uint8List.fromList([0, 1, 2])), throwsException);
  });
}
