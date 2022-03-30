class NumericKind {
  static const int MAX = 256; // MAX bit length is 256-bits.
  static final BigInt ZERO = 0 as BigInt; // Smallest is 0.

  int byteLength = 0;
  BigInt? big;

  /// [input] How mny bytes the number should occupy max.
  NumericKind(int input) {
    if (input <= 0 || input * 8 > MAX) {
      throw Exception("Has to be 32 or less.");
    }
    byteLength = input;

    
  }
}
