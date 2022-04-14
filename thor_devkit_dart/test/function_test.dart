import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/function.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  const String f1 = "{" +
      "    \"constant\": false," +
      "    \"inputs\": [" +
      "        {" +
      "            \"name\": \"a1\"," +
      "            \"type\": \"uint256\"" +
      "        }," +
      "        {" +
      "            \"name\": \"a2\"," +
      "            \"type\": \"string\"" +
      "        }" +
      "    ]," +
      "    \"name\": \"f1\"," +
      "    \"outputs\": [" +
      "        {" +
      "            \"name\": \"r1\"," +
      "            \"type\": \"address\"" +
      "        }," +
      "        {" +
      "            \"name\": \"r2\"," +
      "            \"type\": \"bytes\"" +
      "        }" +
      "    ]," +
      "    \"payable\": false," +
      "    \"stateMutability\": \"nonpayable\"," +
      "    \"type\": \"function\"" +
      "}";

  const String f2 = "{" +
      "    \"inputs\": []," +
      "    \"name\": \"nodes\"," +
      "    \"payable\": false," +
      "    \"outputs\": [" +
      "        {" +
      "            \"components\": [" +
      "                {" +
      "                    \"internalType\": \"address\"," +
      "                    \"name\": \"master\"," +
      "                    \"type\": \"address\"" +
      "                }," +
      "                {" +
      "                    \"internalType\": \"address\"," +
      "                    \"name\": \"endorsor\"," +
      "                    \"type\": \"address\"" +
      "                }," +
      "                {" +
      "                    \"internalType\": \"bytes32\"," +
      "                    \"name\": \"identity\"," +
      "                    \"type\": \"bytes32\"" +
      "                }," +
      "                {" +
      "                    \"internalType\": \"bool\"," +
      "                    \"name\": \"active\"," +
      "                    \"type\": \"bool\"" +
      "                }" +
      "            ]," +
      "            \"internalType\": \"struct AuthorityUtils.Candidate[]\"," +
      "            \"name\": \"list\"," +
      "            \"type\": \"tuple[]\"" +
      "        }" +
      "    ]," +
      "    \"stateMutability\": \"nonpayable\"," +
      "    \"type\": \"function\"" +
      "}";

  // Solidity
  // function getStr() public pure returns (string memory) {
  //    return "Hello World!";
  // }
  const String f3 = "{" +
      "    \"inputs\": []," +
      "    \"name\": \"getStr\"," +
      "    \"outputs\": [" +
      "        {" +
      "            \"internalType\": \"string\"," +
      "            \"name\": \"\"," +
      "            \"type\": \"string\"" +
      "        }" +
      "    ]," +
      "    \"stateMutability\": \"pure\"," +
      "    \"type\": \"function\"" +
      "}";

  // Solidity
  // function getBool() public pure returns (bool) {
  //     return true;
  // }
  const String f4 = "{" +
      "    \"inputs\": []," +
      "    \"name\": \"getBool\"," +
      "    \"outputs\": [" +
      "        {" +
      "            \"internalType\": \"bool\"," +
      "            \"name\": \"\"," +
      "            \"type\": \"bool\"" +
      "        }" +
      "    ]," +
      "    \"stateMutability\": \"pure\"," +
      "    \"type\": \"function\"" +
      "}";

  // Solidity
  // function getBigNumbers() public pure returns (uint256 a, int256 b) {
  //     return (123456, -123456);
  // }
  const String f5 = "{" +
      "    \"inputs\": []," +
      "    \"name\": \"getBigNumbers\"," +
      "    \"outputs\": [" +
      "        {" +
      "            \"internalType\": \"uint256\"," +
      "            \"name\": \"a\"," +
      "            \"type\": \"uint256\"" +
      "        }," +
      "        {" +
      "            \"internalType\": \"int256\"," +
      "            \"name\": \"b\"," +
      "            \"type\": \"int256\"" +
      "        }" +
      "    ]," +
      "    \"stateMutability\": \"pure\"," +
      "    \"type\": \"function\"" +
      "}";

  test('encode', () {
    ThorFunction f = ThorFunction(f1);
    expect(
        f.encode([BigInt.from(1), "foo"]),
        hexToBytes(
            '0x27fcbb2f000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000003666f6f0000000000000000000000000000000000000000000000000000000000'));
  });


  test('selector', () {
        ThorFunction f = ThorFunction(f1);
        expect(
             bytesToHex(f.selector()),
             "27fcbb2f"
        );
    });

      test('decode return values', () {
        String data = "000000000000000000000000abc000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000003666f6f0000000000000000000000000000000000000000000000000000000000";
        ThorFunction f2 = ThorFunction(f1);


        List result = f2.decodeReturn(data);
        print(result);
        expect(result.length, 2);
        expect(result[0], hexToInt("abc0000000000000000000000000000000000001"));
        expect(result[1], utf8.decode(hexToBytes("0x666f6f")));
    });

}
