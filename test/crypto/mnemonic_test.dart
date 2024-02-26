import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:thor_devkit_dart/crypto/mnemonic.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('generate mnemonic words', () {
    List<String> words;
    words = Mnemonic.generate();
    expect(12, words.length);

    words = Mnemonic.generate(entropyLength: 192);
    expect(18, words.length);

    expect(() => Mnemonic.generate(entropyLength: 1), throwsException);
  });

  test('validate pnemonic words', () {
    List<String> words = [
      'ignore',
      'empty',
      'bird',
      'silly',
      'journey',
      'junior',
      'ripple',
      'have',
      'guard',
      'waste',
      'between',
      'tenant'
    ];
    List<String> wrong = [
      'ignore',
      'empty',
      'bird',
      'guard',
      'waste',
      'between',
      'tenant'
    ];

    expect(true, Mnemonic.validate(words));
    expect(true, Mnemonic.validate(Mnemonic.generate(entropyLength: 192)));
    expect(false, Mnemonic.validate(wrong));
  });

  test('test seed', () {
    List<String> words = [
      'ignore',
      'empty',
      'bird',
      'silly',
      'journey',
      'junior',
      'ripple',
      'have',
      'guard',
      'waste',
      'between',
      'tenant'
    ];
    Uint8List seed = Mnemonic.deriveSeed(words);
    String seedExpected =
        "28bc19620b4fbb1f8892b9607f6e406fcd8226a0d6dc167ff677d122a1a64ef936101a644e6b447fd495677f68215d8522c893100d9010668614a68b3c7bb49f";
    expect(seed, hexToBytes(seedExpected));
  });

  test('derive private key test', () {
    List<String> words = [
      'share',
      'adjust',
      'glass',
      'dilemma',
      'adapt',
      'frost',
      'furnace',
      'tip',
      'embrace',
      'fatal',
      'grit',
      'comic',
      'clay',
      'frog',
      'extend',
      'funny',
      'kick',
      'wide',
      'off',
      'cloth',
      'bridge',
      'maid',
      'strong',
      'acquire',
    ];

    expect(
        Mnemonic.derivePrivateKey(words),
        hexToBytes(
            'b724aa16d6face0f461ce2245b60bbfcd8676ec96e8fef615ea626e0aa88cbf0'));
  });

  test('test private key', () {
    List<String> words = [
      'ignore',
      'empty',
      'bird',
      'silly',
      'journey',
      'junior',
      'ripple',
      'have',
      'guard',
      'waste',
      'between',
      'tenant'
    ];

    expect(
        Mnemonic.derivePrivateKey(words),
        hexToBytes(
            "27196338e7d0b5e7bf1be1c0327c53a244a18ef0b102976980e341500f492425"));
  });
}
