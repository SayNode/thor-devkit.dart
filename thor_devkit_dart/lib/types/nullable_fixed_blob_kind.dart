import 'package:thor_devkit_dart/types/fixed_blob_kind.dart';

class NullableFixedBlobKind extends FixedBlobKind{

  NullableFixedBlobKind(int input) : super(0) {
    super.byteLength = input;
  }
}
