
import 'package:thor_devkit_dart/types/compact_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/nullable_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/numeric_kind.dart';

class Transaction {
  static const int DELEGATED_MASK = 1;
    NumericKind chainTag =  NumericKind(1);
    CompactFixedBlobKind blockRef =  CompactFixedBlobKind(8);
    NumericKind expiration =  NumericKind(4);
    Clause[] clauses;
    NumericKind gasPriceCoef =  NumericKind(1);
    NumericKind gas =  NumericKind(8);
    NullableFixedBlobKind dependsOn =  NullableFixedBlobKind(32);
    NumericKind nonce =  NumericKind(8);
    Reserved reserved;
  
}