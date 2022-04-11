import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/types/reserved.dart';
void main() {


  test('unpack null', () {

      
      expect(Reserved.unpack(null), null, reason: 'unpack null');

});

  test('getNullReserved', () {

    Reserved r = Reserved.getNullReserved();

    expect(r.features, 0);
    expect(r.unused, []);


});


}
