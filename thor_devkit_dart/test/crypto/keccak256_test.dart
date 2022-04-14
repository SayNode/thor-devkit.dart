import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/keccak.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('Test single input', () {
    String input = "hello world";
    Uint8List inputBytes = Uint8List.fromList(utf8.encode(input));
    
    expect(bytesToHex(keccak256([inputBytes])),
        "47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad");
  });

}
