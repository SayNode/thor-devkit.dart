import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/types/blob_kind.dart';
import 'package:thor_devkit_dart/utils.dart';
void main() {


  test('set Value', () {
            BlobKind bk = BlobKind();
        bk.setValue("0x1234567890");
    expect(bytesToHex(bk.toBytes()), "1234567890");

  });

    test('exception not even encoded', () {
            BlobKind bk = BlobKind();
        
        expect(() => bk.setValue("0x1"), throwsException);
    

  });
    test('exception wrong data encode', () {
            BlobKind bk = BlobKind();
    expect(() => bk.setValue("0xxy"), throwsException);

  });
    test('decode', () {
            BlobKind bk = BlobKind();
            List<int> bytes = [1,2,3,4,5];
        String result = bk.fromBytes(Uint8List.fromList(bytes));
    expect(result, "0x0102030405");

  });


}