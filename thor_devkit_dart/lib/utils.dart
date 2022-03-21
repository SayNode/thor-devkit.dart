import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:pointycastle/src/utils.dart';

// Remove the 0x04 bytes at the begin of a Unit8List.
///
/// @param input the byte sequence.
/// @return the byte sequence.
Uint8List remove0x04(Uint8List input) {
  if (input[0] == 4) {
    return input.sublist(1, input.length);
  } else {
    return input;
  }
}

///Append "0x" at the begin of a string.
///
/// @param input The input string.
/// @return The prepended string.
String prepend0x(String input) {
  if (input.startsWith("0x") || input.startsWith("0X")) {
    return input;
  } else {
    return "0x" + input;
  }
}

///Remove "0x" at the begin of a string.
///
/// @param input The input string.
/// @return The  string without 0x.
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

Uint8List hexToBytes(String input) {
  var result = hex.decode(remove0x(input)) as Uint8List;
  return result;
}

BigInt hexToInt(String input){
  return BigInt.parse(input, radix: 16);
}

String intToHex(BigInt? input){
  return input!.toRadixString(16);
}

Uint8List intToBytes(BigInt number) {
  assert(!number.isNegative);
  return encodeBigIntAsUnsigned(number);
}

BigInt bytesToInt(Uint8List bytes) {
  return decodeBigIntWithSign(1, bytes);
}

