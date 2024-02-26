import 'dart:typed_data';
import 'package:bip39/bip39.dart' as bip39;
import 'package:thor_devkit_dart/crypto/hd_node.dart';
import 'package:thor_devkit_dart/utils.dart';

class Mnemonic {
  static final List<int> L = [128, 160, 192, 224, 256];

  /// Generate mnemonic words accroding to a given entropy length.
  ///
  /// The longer the length more words are created.
  ///
  /// [entropyLength] How many bits the entropy shall be:
  ///                      128, 160, 192, 224, 256.
  /// Default 128

  static List<String> generate({int entropyLength = 128}) {
    if (!L.contains(entropyLength)) {
      throw Exception("entropyLength is wrong.");
    }
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
    return HDNode.fromMnemonic(words).derive(0).privateKey!;
  }
}
