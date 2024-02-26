import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('ascii to and from bytes', () {
    String input = 'This is a test!';
    Uint8List code = asciiToBytes(input);
    String output = bytesToAscii(code);
    expect('This is a test!', output);
  });

  test('getRandomByte test', () {
    Uint8List a = getRandomBytes(128);
    expect(128, a.length);
  });
  test('serialize', () {

  });
}
