import 'dart:typed_data';
import 'package:base_x/base_x.dart';
import 'package:bip32/bip32.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/mnemonic.dart';
import 'package:thor_devkit_dart/utils.dart';
import 'package:web3dart/crypto.dart' show compressPublicKey;

const accountDerivationPath = "m/44'/818'/0'/0";

// Hardened bit = the mark ' on the number.
const int HARDENED_BIT = 0x80000000;
// This is a constant for VET path.
// it simply adds 44', 818', 0', 0 to the path.
// m / 44' / 818' / 0' / 0

const List<int> VET_PATH = [
  44 + HARDENED_BIT,
  818 + HARDENED_BIT,
  0 + HARDENED_BIT,
  0
];

class HDNode {
  BIP32 node;
  Uint8List? get privateKey => node.privateKey;
  Uint8List get publicKey => node.publicKey;
  Uint8List get chainCode => node.chainCode;
  Uint8List get address => Adress.publicKeyToAddressBytes(publicKey);

  HDNode(this.node);

  ///This will generate a top-most HDNode for VET wallets.
  factory HDNode.fromSeed(Uint8List seed) {
    BIP32 master = BIP32.fromSeed(seed);
    BIP32 node = master.derivePath(accountDerivationPath);
    return HDNode(node);
  }

  ///This will generate a top-most HDNode for VET wallets.
  factory HDNode.fromMnemonic(List<String> words) {
    if (!Mnemonic.validate(words)) {
      throw Exception("The words not valid!");
    }
    Uint8List seed = Mnemonic.deriveSeed(words);
    BIP32 master = BIP32.fromSeed(seed);
    BIP32 node = master.derivePath(accountDerivationPath);
    return HDNode(node);
  }

  ///Derive child HDNode from an existing HDNode.

  HDNode derive(int childNumber) {
    return HDNode(node.derive(childNumber));
  }

  //create node from xpriv
  static HDNode fromPrivateKey(Uint8List priv, Uint8List chainCode) {
    var base58 = BaseXCodec(
        '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz');

    Uint8List privPrefix = hexToBytes('0488ade4000000000000000000');
    Uint8List key = Uint8List.fromList([
      ...privPrefix,
      ...chainCode,
      ...[0],
      ...priv
    ]);
    Uint8List checksum =
        SHA256Digest().process(SHA256Digest().process(key)).sublist(0, 4);
    var bip32 =
        BIP32.fromBase58(base58.encode(Uint8List.fromList(key + checksum)));
    return HDNode(bip32);
  }

  //create node from xpub
  static HDNode fromPublicKey(Uint8List pub, Uint8List chainCode) {
    var base58 = BaseXCodec(
        '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz');
    var compressed = compressPublicKey(pub);

    Uint8List pubPrefix = hexToBytes('0488b21e000000000000000000');
    Uint8List key =
        Uint8List.fromList([...pubPrefix, ...chainCode, ...compressed]);
    Uint8List checksum =
        SHA256Digest().process(SHA256Digest().process(key)).sublist(0, 4);
    var bip32 =
        BIP32.fromBase58(base58.encode(Uint8List.fromList(key + checksum)));
    return HDNode(bip32);
  }
}
