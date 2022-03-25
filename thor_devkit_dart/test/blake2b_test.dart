import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/blake2b.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('Test single input', () {
    String input = "hello world";
    Uint8List inputBytes = Uint8List.fromList(utf8.encode(input));

    expect(bytesToHex(blake2b256(inputBytes)),
        "256c83b297114d201b30179f3f0ef0cace9783622da5974326b436178aeef610");
  });
}
