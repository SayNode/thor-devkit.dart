import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/hd_node.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  String sentence =
      "ignore empty bird silly journey junior ripple have guard waste between tenant";
  List<String> words = sentence.split(" ");
  Uint8List privateKey = hexToBytes(
      "27196338e7d0b5e7bf1be1c0327c53a244a18ef0b102976980e341500f492425");

  // Generate from words.
  HDNode topMostNode = HDNode.fromMnemonic(words);
  test('Test fromMnemonic()', () {
    List<String> words2 = [
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
    var node2 = HDNode.fromMnemonic(words2);

    expect(
        hexToBytes(
            'b724aa16d6face0f461ce2245b60bbfcd8676ec96e8fef615ea626e0aa88cbf0'),
        node2.derive(0).privateKey);
  });

  test('Test fromMnemonic() with data from thor-devkit.java', () {
    expect(privateKey, topMostNode.derive(0).privateKey);
  });

  test('Test fromPrivateKey() with data from thor-devkit.java', () {
    expect(
        topMostNode.privateKey,
        HDNode.fromPrivateKey(topMostNode.privateKey!, topMostNode.chainCode)
            .privateKey);
  });

  test('Test fromPublicKey() with data from thor-devkit.java', () {
    expect(
        topMostNode.publicKey,
        HDNode.fromPublicKey(topMostNode.publicKey, topMostNode.chainCode)
            .publicKey);
  });
}
