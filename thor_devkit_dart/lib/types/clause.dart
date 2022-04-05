import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:rlp/rlp.dart';
import 'package:thor_devkit_dart/types/blob_kind.dart';
import 'package:thor_devkit_dart/types/nullable_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/numeric_kind.dart';

class Clause {
  final NullableFixedBlobKind to = NullableFixedBlobKind(20);
  final NumericKind value = NumericKind(32);
  final BlobKind data = BlobKind();

  Clause(String to, String value, String data) {
    this.to.setValue(to);
    this.value.setValueString(value);
    this.data.setValue(data);
  }

  Clause.fromUint8List(Uint8List to, Uint8List value, Uint8List data) {
    this.to.fromBytes(to);
    this.value.fromBytes(value);
    this.data.fromBytes(data);
  }

  Uint8List encode() {
    return Rlp.encode([to.toBytes(), value.toBytes(), data.toBytes()]);
  }

  dynamic decode(Uint8List data) {


    return null;
  }
}

