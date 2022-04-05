import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:typed_data';
import 'package:rlp/rlp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/types/rlp.dart' as Rlp2;

import 'package:convert/convert.dart';

void main() {
  test('encode test', () {
    var encoded1 = Rlp.encode("dog");
    var encoded2 =
        Rlp.encode("Lorem ipsum dolor sit amet, consectetur adipisicing elit");

    var encoded3 = Rlp.encode(['cat', 'dog']);

    Rlp2.RlpDecoder decoder = Rlp2.RlpDecoder();
    Rlp2.RlpDecoder decoder2 = Rlp2.RlpDecoder();

    expect(utf8.decode(decoder.decode(encoded1)), "dog");
    expect(utf8.decode(decoder.decode(encoded2)),
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit");
        var a = Uint8List.fromList(decoder2.decode(encoded3)[1]);
    print(utf8.decode(a));
    print(decoder.decode(encoded3));
  });
}
