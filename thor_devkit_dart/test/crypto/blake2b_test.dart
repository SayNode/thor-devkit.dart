import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/blake2b.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('Test single input', () {
    String input = "hello world";
    Uint8List inputBytes = Uint8List.fromList(utf8.encode(input));

    expect(bytesToHex(blake2b256([inputBytes])),
        "256c83b297114d201b30179f3f0ef0cace9783622da5974326b436178aeef610");
  });

    test('Test single input 2', () {
    String input = "{hello: world}";
    Uint8List inputBytes = Uint8List.fromList(utf8.encode(input));

    expect(bytesToHex(blake2b256([inputBytes])),
        "b84c6e2bc47a39a05c42b1447526243783312edc14058dc1718256e743a8291d");
  });

  test('Test multiple inputs', () {
    Uint8List inputBytes1 = Uint8List.fromList(utf8.encode("hello"));
    Uint8List inputBytes2 = Uint8List.fromList(utf8.encode(" "));
    Uint8List inputBytes3 = Uint8List.fromList(utf8.encode("world"));
    Uint8List output = blake2b256([inputBytes1, inputBytes2, inputBytes3]);
    expect(bytesToHex(output),
        "256c83b297114d201b30179f3f0ef0cace9783622da5974326b436178aeef610");
  });
}


