import 'dart:core';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:thor_devkit_dart/types/clause.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('test decoding', () {
    Clause clause = Clause("0x7567d83b7b8d80addcb281a71d54fc7b3364ffed",
        "10000", "0x000000606060");
    Uint8List encoded = clause.encode();
    Clause decoded = Clause.decode(encoded);

    expect(decoded.to.toBytes(),
        hexToBytes("7567d83b7b8d80addcb281a71d54fc7b3364ffed"));

    expect(decoded.data.toBytes(), hexToBytes("000000606060"));

    expect(decoded.value.toBytes(), intToBytes(BigInt.from(10000)));
  });

  test('test decoding debug', () {
    // Prepare
    List<Clause> clauses = [];
    for (int a = 0; a < 3; a++) {
      clauses.add(Clause("0x7567d83b7b8d80addcb281a71d54fc7b3364ffed", "10000",
          "0x000000606060"));
    }

    //
    for (Clause c in clauses) {
      // serialize.
      Uint8List encoded = c.encode();

      // deserialize
      Clause decoded = Clause.decode(encoded);

      expect(decoded.to.toBytes(),
          hexToBytes("7567d83b7b8d80addcb281a71d54fc7b3364ffed"));

      expect(decoded.data.toBytes(), hexToBytes("000000606060"));

      expect(decoded.value.toBytes(), intToBytes(BigInt.from(10000)));
    }
  });
}
