import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

///Remove the 0x04 bytes at the begin of a Unit8List.
Uint8List remove0x04(Uint8List input) {
  if (input[0] == 4) {
    return input.sublist(1, input.length);
  } else {
    return input;
  }
}

///Append "0x" at the begin of a string.
String prepend0x(String input) {
  if (input.startsWith("0x") || input.startsWith("0X")) {
    return input;
  } else {
    return "0x" + input;
  }
}

///Remove "0x" at the begin of a string.
String remove0x(String input) {
  if (input.startsWith("0x") || input.startsWith("0X")) {
    return input.substring(2);
  } else {
    return input;
  }
}

///Converts Unit8List into Hex
String bytesToHex(Uint8List input) {
  String result = hex.encode(input);
  return result;
}

///Converts a hex String to a Uint8List
Uint8List hexToBytes(String input) {
  var result = hex.decode(remove0x(input)) as Uint8List;
  return result;
}

///Converts a hex String to a BigInt
BigInt hexToBigInt(String input) {
  return BigInt.parse(input, radix: 16);
}

///Converts  BigInt to a Uint8List
Uint8List bigIntToBytes(BigInt number) {
  if (number == BigInt.zero) {
    return Uint8List.fromList([0]);
  }
  var size = number.bitLength + (number.isNegative ? 8 : 7) >> 3;
  var result = Uint8List(size);
  for (var i = 0; i < size; i++) {
    result[size - i - 1] = (number & BigInt.from(0xff)).toInt();
    number = number >> 8;
  }
  return result;
}

///Converts a Uint8List to a BigInt
BigInt bytesToBigInt(Uint8List bytes) {
  BigInt result;
  if (bytes.length == 1) {
    result = BigInt.from(bytes[0]);
  } else {
    result = BigInt.from(0);
    for (var i = 0; i < bytes.length; i++) {
      var item = bytes[bytes.length - i - 1];
      result |= (BigInt.from(item) << (8 * i));
    }
    if (result != BigInt.zero) {
      result = result.toUnsigned(result.bitLength);
    }
  }
  return result;
}

///Converts ascii String to a Uint8List
Uint8List asciiToBytes(String input) {
  AsciiCodec a = const AsciiCodec();
  return a.encode(input);
}
