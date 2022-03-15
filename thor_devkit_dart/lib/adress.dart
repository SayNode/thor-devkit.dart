import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/digests/keccak.dart';
import 'package:thor_devkit_dart/utils.dart';

///Check if input is an adress
bool isAdress(String input){
  final adressFormt = RegExp(r'^0x[0-9a-f]{40}$', caseSensitive: false);
if (adressFormt.hasMatch(input)) {
  return true;
} else {
  return false;
}
}


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

    /// encode the address to checksumed address that is compatible with eip-55
    /// @param address input address
String toChecksumAddress(String input) {
  String body = remove0x(input).toLowerCase();
  final digest = KeccakDigest(256);
  var x = utf8.encode(body) as Uint8List;
  var h = digest.process(x);

  String hash = bytesToHex(h);
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
