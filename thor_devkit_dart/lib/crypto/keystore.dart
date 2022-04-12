import 'dart:math';
import 'dart:typed_data';
import 'package:web3dart/credentials.dart';

class KeyStore {
  ///Encrypt a private key with a password, generate a JSON string.
  static String encrypt(Uint8List priv, String password) {
    var ethKey = EthPrivateKey(priv);
    Random random = Random.secure();

    Wallet wallet = Wallet.createNew(ethKey, password, random);

    return wallet.toJson();
  }

  ///Decrypt a JSON-style keystore back into a private key.
  static Uint8List decrypt(String jsonString, String password) {
    Wallet wallet = Wallet.fromJson(jsonString, password);
    var ethKey = wallet.privateKey;

    return ethKey.privateKey;
  }
}
