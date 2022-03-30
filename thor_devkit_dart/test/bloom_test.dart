import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/bloom.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('Test estimateK()', () {
    expect(Bloom.estimateK(1), 16);
    expect(Bloom.estimateK(100), 14);
    expect(Bloom.estimateK(200), 7);
    expect(Bloom.estimateK(300), 5);
    expect(Bloom.estimateK(400), 4);
    expect(Bloom.estimateK(500), 3);
  });

  test('Test add()', () {
    Bloom b = Bloom(14);
    b.add(Uint8List.fromList(utf8.encode("hello world")));
    expect(bytesToHex(b.storage),
        "00000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000004000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000001000000000000020000000000000000000000000008000000000000000000000000000000080000000100000000000000000000040020000000000080000000000000000000080000000000000000000000000");
  });

    test('Test mightContain()', () {
        Bloom b = Bloom(14);
        var input = Uint8List.fromList(utf8.encode("hello world"));

        expect(b.mightContain(input), false);
        b.add(input);
        expect(b.mightContain(input), true);
 
  });

    test('Test estimateK()', () {
    expect(Bloom.estimateK(1), 16);
    expect(Bloom.estimateK(100), 14);
    expect(Bloom.estimateK(200), 7);
    expect(Bloom.estimateK(300), 5);
    expect(Bloom.estimateK(400), 4);
    expect(Bloom.estimateK(500), 3);
  });


}
