import 'dart:typed_data';
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/mnemonic.dart';
import 'package:thor_devkit_dart/utils.dart';
import 'package:hex/hex.dart';

void main() {
  test('generate mnemonic words', () {
    List<String> words;
    words = Mnemonic.generate(128);
    print(words);
    expect(12, words.length);

    words = Mnemonic.generate(192);
    print(words);
    expect(18, words.length);

    expect(() => Mnemonic.generate(1), throwsException);
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
    expect(true, Mnemonic.validate(Mnemonic.generate(192)));
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
      'Share',
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

    print(bytesToHex(Mnemonic.derivePrivateKey(words)));



    expect(Mnemonic.derivePrivateKey(words), hexToBytes('d59b1adddfbc86caed02dc15eecc7761f5f8464e03a8e86e641181fcdb3362ff'));   

  });
}
