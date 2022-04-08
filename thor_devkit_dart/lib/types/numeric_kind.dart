import 'dart:typed_data';

import 'package:thor_devkit_dart/utils.dart';

class NumericKind {
  static const int MAX = 256; // MAX bit length is 256-bits.
  static final BigInt ZERO = BigInt.from(0); // Smallest is 0.

  int byteLength = 0;
  BigInt? big;

  /// [input] How mny bytes the number should occupy max.
  NumericKind(int input) {
    if (input <= 0 || input * 8 > MAX) {
      throw Exception("Has to be 32 or less.");
    }
    byteLength = input;
  }

  _setBig(BigInt big) {
    this.big = big;
  }

  static _check(BigInt big, int byteLength) {


    // Less than 0.
    if (ZERO.compareTo(big) > 0) {
      throw Exception("Has to be be bigger than 0");
    }

    // Breach the ceiling.
    if (big.bitLength > MAX) {
      throw Exception("Hs to be 256-bit/32-byte or less.");
    }

    // Breach the limit.
    if (big.bitLength > byteLength * 8) {
      throw Exception("Longer than expected");
    }
  }

  setValueString(String number) {
    BigInt b;
    if (number.startsWith("0x")) {
      b = hexToInt(number.substring(2));
    } else {
      b = BigInt.parse(number);
    }
    _check(b, byteLength);
    _setBig(b);
  }

  setValueBigInt(BigInt x) {
    _check(x, byteLength);
    _setBig(x);
  }

  Uint8List toBytes() {
    if (big == null) {
      throw Exception("Call setValue() before use.");
    }
    if (big!.toInt() == 0) {
      return Uint8List.fromList([]);
    }

    Uint8List m = intToBytes(big!);

    int firstNonZeroIndex = -1;
    for (int i = 0; i < m.length; i++) {
      if (m[i] != 0) {
        firstNonZeroIndex = i;
        break;
      }
    }

    Uint8List? n;
    if (firstNonZeroIndex != -1) {
      n = Uint8List.sublistView(m, firstNonZeroIndex, m.length);
    }

    if (n != null) {
      return n;
    } else {
      return Uint8List.fromList([]);
    }
  }

  BigInt fromBytes(Uint8List data) {
    // Validation.
    if (data.isNotEmpty && data[0] == 0) {
      throw Exception("Trim the leading zeros, please.");
    }
    BigInt b = bytesToInt(data);
    _check(b, byteLength);
    // Set the internal value.
    big = b;
    return b;
  }

  @override
  String toString() {
    return big.toString();
  }
}
