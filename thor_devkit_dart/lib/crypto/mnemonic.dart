import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:thor_devkit_dart/utils.dart';

class Mnemonic {
  static final List<int> L = [128, 160, 192, 224, 256];

  /// Generate mnemonic words accroding to a given entropy length.
  ///
  /// The longer the length more words are created.
  ///
  /// @param entropyLength How many bits the entropy shall be:
  ///                      128, 160, 192, 224, 256.
  /// @return A list of strings.

  static List<String> generate(int entropyLength) {
    if (!L.contains(entropyLength)) {
      throw Exception("entropyLength is wrong.");
    }
    Uint8List entropy = getRandomBytes(entropyLength ~/ 8);
    String mnemonic = bip39.generateMnemonic(strength: entropyLength);

    return mnemonic.split(" ");
  }

  ///Validate mnemonic words.
  static bool validate(List<String> words) {
    return bip39.validateMnemonic(words.join(' '));
  }

  ///Derive a seed from words. Normally you won't use this function alone.
  static Uint8List deriveSeed(List<String> words) {
    return hexToBytes(bip39.mnemonicToSeedHex(words.join(' ')));
  }

  ///derive private key at index 0 from mnemonic words according to BIP32.
  static Uint8List derivePrivateKey(List<String> words) {
    final seed = deriveSeed(words);
    var node = bip32.BIP32.fromSeed(seed).derive(0);
    

    //Uint8List i = hmacSha512(Uint8List.fromList(utf8.encode("Bitcoin seed")), seed);

    return node.privateKey!;
  }
}
