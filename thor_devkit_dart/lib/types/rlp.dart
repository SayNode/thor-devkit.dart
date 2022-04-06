import 'dart:typed_data';

import 'package:web3dart/crypto.dart';

class RlpDecoder {
  late bool isList;
  late int offset;
  late int length;

  RlpDecoder();

  dynamic decode(Uint8List input) {
    _decodeLength(input);
    assert(isList != null);
    if (!isList) {
      return input.sublist(offset, offset + length);
    } else {
      List<dynamic> output = <dynamic>[];
      //output.add(input.sublist(offset, offset + length));

      var reminder = input.sublist(offset);

      while (reminder.isNotEmpty) {
        output.add(decode(reminder));
        reminder = reminder.sublist(offset + length);
      }
      offset = 0;
      return output;
    }
  }

  _decodeLength(Uint8List input) {
    dynamic prefix = input[0];
    int inputLength = input.length;

    if (input.isEmpty) {
      throw Exception('input is null');
    }

    if (prefix <= 0x7f) {
      isList = false;
      offset = 0;
      length = 1;
    }

    //String 0-55 byte
    else if (prefix <= 0xb7 && inputLength > prefix - 0x80) {
      length = prefix - 0x80;
      offset = 1;
      isList = false;
    } else if (prefix <= 0xbf && inputLength > prefix - 0xb7) {
      int lenOfStrLen = prefix - 0xb7;
      length = bytesToInt(input.sublist(1, 1 + lenOfStrLen)).toInt();
      isList = false;
      offset = 1 + lenOfStrLen;
    } else if (prefix <= 0xf7 && inputLength > prefix - 0xc0) {
      length = prefix - 0xc0;
      isList = true;
      offset = 1;
    } else if (prefix <= 0xff && inputLength > prefix - 0xf7) {
      int lenOfStrLen = prefix - 0xf7;
      isList = true;
      length = bytesToInt(input.sublist(1, 1 + lenOfStrLen)).toInt();
      offset = 1 + lenOfStrLen;
    } else {
      throw Exception("input doesn't conform to RLP encoding format");
    }
  }
}
