import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/keccak.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  test('isValidPrivateKey test', () {
    Uint8List tooBig = hexToBytes(
        "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364142");
    expect(false, isValidPrivateKey(tooBig));

    Uint8List lessbits = hexToBytes(
        "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd03641");
    expect(false, isValidPrivateKey(lessbits));

    Uint8List zero = hexToBytes("00");
    expect(false, isValidPrivateKey(zero));

    //Uint8List priv = generatePrivateKey();
    //expect(true, isValidPrivateKey(priv));
  });
  test('finds public key for private key', () {
    expect(
        bytesToHex(derivePublicKeyFromBytes(
            hexToBytes(
                'a392604efc2fad9c0b3da43b5f698a2e3f270f170d859912be0d54742275c5f6'),
            false)),
        '506bc1dc099358e5137292f4efdd57e400f29ba5132aa5d12b18dac1c1f6aaba645c0b7b58158babbfa6c6cd5a48aa7340a8749176b120e8516216787a13dc76');
  });

  test('produces a valid signature', () {
    final hashedPayload = hexToBytes(
        '82ff40c0a986c6a5cfad4ddf4c3aa6996f1a7837f9c398e17e5de5cbd5a12b28');
    final privKey = hexToBytes(
        '3c9229289a6125f7fdf1885a77bb12c37a8d3b4962d936f7e3084dece32a3ca1');
    final sig = sign(hashedPayload, privKey);

    expect(
        sig.signature.r,
        hexToBigInt(
            '99e71a99cb2270b8cac5254f9e99b6210c6c10224a1579cf389ef88b20a1abe9'));
    expect(
        sig.signature.s,
        hexToBigInt(
            '129ff05af364204442bdb53ab6f18a99ab48acc9326fa689f228040429e3ca66'));
    expect(sig.signature.v, 27);
  });

  test('generate privte key', () {
    var priv = generatePrivateKey();
    expect(isValidPrivateKey(bigIntToBytes(priv)), true);
  });
  test('signatures recover the public key of the signer', () {
    final privateKey = hexToBytes(
        'a392604efc2fad9c0b3da43b5f698a2e3f270f170d859912be0d54742275c5f6');
    final messageHash =
        keccak256([Uint8List.fromList(utf8.encode('this is a test!'))]);
    final publicKey = derivePublicKeyFromBytes(privateKey, false);
    final signature = sign(messageHash, privateKey);
    final recoveredPublicKey = recover(messageHash, signature);
    expect(bytesToHex(publicKey), bytesToHex(recoveredPublicKey));
  });

  test('msghash is valid or not', () {
    final messageHash =
        keccak256([Uint8List.fromList(utf8.encode('this is a test!'))]);

    expect(isValidMessageHash(messageHash), true);
    expect(isValidMessageHash(messageHash.sublist(4)), false);
  });
}
