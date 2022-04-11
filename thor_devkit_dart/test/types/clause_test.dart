import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:rlp/rlp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/types/clause.dart';
import 'package:thor_devkit_dart/types/rlp.dart';

void main() {
  //TODO: move to rlp test, write more proper rlp tests
  test('rlp decode test', () {
    var encoded1 = Rlp.encode("dog");
    var encoded2 =
        Rlp.encode("Lorem ipsum dolor sit amet, consectetur adipisicing elit");

    var encoded3 = Rlp.encode(['cat', 'dog']);
    var encoded4 = Rlp.encode([
      'cat',
      'dog',
      'cat',
      'dog',
      'cat',
      'dog',
      'cat',
      'dog',
      'cat',
      'dog',
      'cat',
      'dog',
      'cat',
      'dog',
      'cat',
      'dog',
      'cat',
      'dog',
      'cat',
      'dog'
    ]);

    RlpDecoder decoder = RlpDecoder();
    RlpDecoder decoder2 = RlpDecoder();

    expect(utf8.decode(decoder.decode(encoded1)), "dog");
    expect(utf8.decode(decoder.decode(encoded2)),
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit");
    var a = Uint8List.fromList(decoder2.decode(encoded3)[1]);
    //print(utf8.decode(a));

    //print(decoder.decode(encoded3));
    //print(decoder2.decode(encoded4).length);
  });

  test('encode decode', () {
    List<Clause> clauses = [];

    for (int a = 0; a < 3; a++) {
      clauses.add(Clause("0x7567d83b7b8d80addcb281a71d54fc7b3364ffed", "10000",
          "0x000000606060"));
    }
    for (Clause c in clauses) {
      // serialize.
      Uint8List encoded = c.encode();

      // deserialize
      RlpDecoder decoder = RlpDecoder();
      //print(c.data.toBytes());

      var out = decoder.decode(encoded);
      //print(out);
    }
  });


//TODO: Write test for pack methode
  test('test pack methode', () {
    Clause clause = Clause("0x7567d83b7b8d80addcb281a71d54fc7b3364ffed",
        "10000", "0x000000606060");

        
        expect(false, true);
  });
}

/*
      Clause decoded = c.decode(encoded);

      expect(decoded.to.toBytes(),
          hexToBytes("7567d83b7b8d80addcb281a71d54fc7b3364ffed"));

      expect(decoded.data.toBytes(), hexToBytes("000000606060"));

      expect(decoded.value.toBytes(), intToBytes(BigInt.from(10000)));
*/
