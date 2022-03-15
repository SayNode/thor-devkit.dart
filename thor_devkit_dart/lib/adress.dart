import 'dart:typed_data';

import 'package:pointycastle/digests/keccak.dart';
import 'package:thor_devkit_dart/utils.dart';

/// Convert an uncompressed public key to address bytes. (20 bytes)
Uint8List publicKeyToAdressBytes(Uint8List input) {
  final digest = KeccakDigest(256);
  //remove 0x04(first byte)
  var slice = remove0x04(input);
  //Hash the slice and get 32 bytes of result.
  Uint8List h = digest.process(slice);
  // Get the last 20 bytes from the 32 bytes.
  var result = h.sublist(12, h.length);
  return result;
}

///Convert a public key to address, in string format.
String publicKeyToAdressString(Uint8List input) {
  var p = publicKeyToAdressBytes(input);
  //turn into String adress
  var result = bytesToHex(p);
  return prepend0x(result);
}

String toChecksumAddress(String input) {

  String body = remove0x(input).toLowerCase();
  final digest = KeccakDigest(256);

  var h = digest.process(hexToBytes(body));
  String hash = bytesToHex(h);

  //List<String> parts = <String>[];
  String parts = '0x';

  for (int i = 0; i < body.length; i++) {
    // loop over body.
    if (int.parse(hash.substring(i, i + 1), radix: 16) >= 8) {
      parts = parts + (body.substring(i, i + 1).toUpperCase());
    } else {
      parts = parts + (body.substring(i, i + 1));
    }
  }
  return parts;
}
