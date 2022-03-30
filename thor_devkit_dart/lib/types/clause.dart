
import 'dart:typed_data';

import 'package:thor_devkit_dart/types/blob_kind.dart';
import 'package:thor_devkit_dart/types/nullable_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/numeric_kind.dart';

class Clause {
     final NullableFixedBlobKind to =  NullableFixedBlobKind(20);
     final NumericKind value =  NumericKind(32);
     final BlobKind data =  BlobKind();

     Clause(Uint8List to, Uint8List value, Uint8List data) {
        this.to.fromBytes(to);
        this.value.fromBytes(value);
        this.data.fromBytes(data);
    }

}