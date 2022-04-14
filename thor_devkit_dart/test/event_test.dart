import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/event.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  const String e1 = "{" +
      "    \"anonymous\": false," +
      "    \"inputs\": [" +
      "        {" +
      "            \"indexed\": true," +
      "            \"name\": \"a1\"," +
      "            \"type\": \"uint256\"" +
      "        }," +
      "        {" +
      "            \"indexed\": false," +
      "            \"name\": \"a2\"," +
      "            \"type\": \"string\"" +
      "        }" +
      "    ]," +
      "    \"name\": \"E1\"," +
      "    \"type\": \"event\"" +
      "}";

  test('e1 test', () {
    ThorEvent e = ThorEvent(e1);

    // Signature test
    Uint8List expected = hexToBytes(
        "47b78f0ec63d97830ace2babb45e6271b15a678528e901a9651e45b65105e6c2");
    expect(e.getSignature(), expected);

    // Topics decode test
    List<String> topics = [];
    topics.add(
        "47b78f0ec63d97830ace2babb45e6271b15a678528e901a9651e45b65105e6c2");
    topics.add(
        "0000000000000000000000000000000000000000000000000000000000000001");

    // Data decode test
    String data =
        "00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000003666f6f0000000000000000000000000000000000000000000000000000000000";

    List decoded = e.decodeResults(topics, data);

    
    expect(decoded.length, 2);
    expect(decoded[0], BigInt.from(1));
    expect(decoded[1], "foo");
  });
}
