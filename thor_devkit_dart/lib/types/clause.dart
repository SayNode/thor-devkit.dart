import 'dart:typed_data';
import 'package:rlp/rlp.dart';
import 'package:thor_devkit_dart/types/blob_kind.dart';
import 'package:thor_devkit_dart/types/nullable_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/numeric_kind.dart';
import 'package:thor_devkit_dart/types/rlp.dart';
import 'package:thor_devkit_dart/utils.dart';

class Clause {
  final NullableFixedBlobKind to = NullableFixedBlobKind(20);
  final NumericKind value = NumericKind(32);
  final BlobKind data = BlobKind();

  Clause(String? to, String value, String data) {
    this.to.setValue(to);
    this.value.setValueString(value);
    this.data.setValue(data);
  }

  Clause.fromBytes(Uint8List to, Uint8List value, Uint8List data) {
    this.to.fromBytes(to);
    this.value.fromBytes(value);
    this.data.fromBytes(data);
  }

  ///turns a encoded clause back into a clause object
  static Clause decode(Uint8List dataInput) {
    var decoded = RlpDecoder.decode(dataInput);
    List<int> to = [];
    for (var item in decoded[0]) {
      to.add(bytesToInt(item).toInt());
    }
    List<int> value = [];
    for (var item in decoded[1]) {
      value.add(bytesToInt(item).toInt());
    }
    List<int> data = [];
    for (var item in decoded[2]) {
      data.add(bytesToInt(item).toInt());
    }

    return Clause.fromBytes(Uint8List.fromList(to), Uint8List.fromList(value),
        Uint8List.fromList(data));
  }

  Uint8List encode() {
    return Rlp.encode(pack());
    //return Rlp.encode([to.toBytes(), value.toBytes(), data.toBytes()]);
  }

  /// Pack a Clause into a List of Objects
  List<Uint8List> pack() {
    return [to.toBytes(), value.toBytes(), data.toBytes()];
  }
}
