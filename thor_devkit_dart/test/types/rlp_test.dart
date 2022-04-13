import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:rlp/rlp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/types/rlp.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('decode short string', () {
    var encoded = Rlp.encode("dog");

    expect(utf8.decode(RlpDecoder.decode(encoded)), "dog");
  });

  test('decode long string', () {
    var encoded =
        Rlp.encode("Lorem ipsum dolor sit amet, consectetur adipisicing elit");

    expect(utf8.decode(RlpDecoder.decode(encoded)),
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit");
  });

  test('decode lshort list', () {
    var encoded = Rlp.encode(['cat', 'dog']);
    var decoded = RlpDecoder.decode(encoded);

    expect([utf8.decode(decoded[0]), utf8.decode(decoded[1])], ['cat', 'dog']);
  });

  test('decode long List', () {
    var encoded = Rlp.encode([
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

    var decoded = [];

    for (var item in RlpDecoder.decode(encoded)) {
      decoded.add(utf8.decode(item));
    }

    expect(decoded, [
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
  });

    test('lists in lists in lists', () {
    var encoded = Rlp.encode([
      [],
      [['aaa']],
      [
        [],
        [[], '10']
      ]
    ]);
    expect(RlpDecoder.decode(encoded), [
      [],
      [[[97, 97, 97]]],
      [
        [],
        [[], [49, 48]]
      ]
    ]);
  });
}
