import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/digests/keccak.dart';
import 'package:thor_devkit_dart/utils.dart';

class Adress {

  ///Check if the public key is 65 bytes, and starts with 4.
  static bool isUncompressedPublicKey(Uint8List input) {
    if (input.length != 65) {
      throw Exception("Requires 65 bytes!");
    }

    if (input[0] != 4) {
      throw Exception("First byte should be 4.");
    }

    return true;
  }

  ///Check if input is an address
  static bool isAddress(String input) {
    final addressFormt = RegExp(r'^0x[0-9a-f]{40}$', caseSensitive: false);
    if (addressFormt.hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  /// Convert an uncompressed public key to address bytes. (20 bytes)
  static Uint8List publicKeyToAddressBytes(Uint8List input) {
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
  static String publicKeyToAddressString(Uint8List input) {
    var p = publicKeyToAddressBytes(input);
    //turn into String address
    var result = bytesToHex(p);
    return prepend0x(result);
  }

  /// encode the address to checksumed address that is compatible with eip-55
  static String toChecksumAddress(String input) {
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
}
