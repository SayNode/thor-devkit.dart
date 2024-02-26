import 'dart:convert';
import 'dart:typed_data';
import 'package:web3dart/crypto.dart';


//Decoding directly taken from https://github.com/ethereumdart/ethereum_util/blob/master/lib/src/rlp.dart
class RlpDecoder {
  static dynamic decode(Uint8List input, [bool stream = false]) {
    if (input.isEmpty) {
      return <Uint8List>[];
    }

    Uint8List inputBuffer = _toBuffer(input);
    Decoded decoded = _decode(inputBuffer);

    if (stream) {
      return decoded;
    }
    if (decoded.remainder.isNotEmpty) {
      throw const FormatException('invalid remainder');
    }

    return decoded.data;
  }
}


class Decoded {
  dynamic data;
  Uint8List remainder;
  Decoded(this.data, this.remainder);
}

Decoded _decode(Uint8List input) {
  int firstByte = input[0];
  if (firstByte <= 0x7f) {
    // a single byte whose value is in the [0x00, 0x7f] range, that byte is its own RLP encoding.
    return Decoded(input.sublist(0, 1), input.sublist(1));
  } else if (firstByte <= 0xb7) {
    // string is 0-55 bytes long. A single byte with value 0x80 plus the length of the string followed by the string
    // The range of the first byte is [0x80, 0xb7]
    int length = firstByte - 0x7f;

    // set 0x80 null to 0
    Uint8List data =
        firstByte == 0x80 ? Uint8List(0) : input.sublist(1, length);

    if (length == 2 && data[0] < 0x80) {
      throw const FormatException(
          'invalid rlp encoding: byte must be less 0x80');
    }

    return Decoded(data, input.sublist(length));
  } else if (firstByte <= 0xbf) {
    int llength = firstByte - 0xb6;
    int length = bytesToInt(input.sublist(1, llength)).toInt();
    //int length = safeParseInt(hex.encode(input.sublist(1, llength)), 16);
    Uint8List data = input.sublist(llength, length + llength);
    if (data.length < length) {
      throw const FormatException('invalid RLP');
    }

    return Decoded(data, input.sublist(length + llength));
  } else if (firstByte <= 0xf7) {
    // a list between  0-55 bytes long
    List<dynamic> decoded = <dynamic>[];
    int length = firstByte - 0xbf;
    Uint8List innerRemainder = input.sublist(1, length);
    while (innerRemainder.isNotEmpty) {
      Decoded d = _decode(innerRemainder);
      decoded.add(d.data);
      innerRemainder = d.remainder;
    }

    return Decoded(decoded, input.sublist(length));
  } else {
    // a list  over 55 bytes long
    List<dynamic> decoded = <dynamic>[];
    int llength = firstByte - 0xf6;
    int length = bytesToInt(input.sublist(1, llength)).toInt();
    //int length = safeParseInt(hex.encode(input.sublist(1, llength)), 16);
    int totalLength = llength + length;
    if (totalLength > input.length) {
      throw const FormatException(
          'invalid rlp: total length is larger than the data');
    }

    Uint8List innerRemainder = input.sublist(llength, totalLength);
    if (innerRemainder.isEmpty) {
      throw const FormatException('invalid rlp, List has a invalid length');
    }

    while (innerRemainder.isNotEmpty) {
      Decoded d = _decode(innerRemainder);
      decoded.add(d.data);
      innerRemainder = d.remainder;
    }
    return Decoded(decoded, input.sublist(totalLength));
  }
}

Uint8List _toBuffer(dynamic data) {
  if (data is Uint8List) return data;

  if (data is String) {
    return Uint8List.fromList(utf8.encode(data));
  } else if (data is int) {
    if (data == 0) return Uint8List(0);

    return Uint8List.fromList(intToBytes(BigInt.from(data)));
  } else if (data is BigInt) {
    if (data == BigInt.zero) return Uint8List(0);

    return Uint8List.fromList(intToBytes(data));
  } else if (data is List<int>) {
    return Uint8List.fromList(data);
  }

  throw TypeError();
}
