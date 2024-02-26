import 'package:test/test.dart';
import 'package:thor_devkit_dart/function.dart';
import 'package:thor_devkit_dart/types/v1_param_wrapper.dart';
import 'package:thor_devkit_dart/utils.dart';
import 'package:web3dart/web3dart.dart';

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

  String f2 = "{" +
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
  String f3 = "{" +
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
  String f4 = "{" +
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
  String f5 = "{" +
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
    expect(bytesToHex(f.selector()), "27fcbb2f");
  });

  test('decode return', () {
    const data =
        "000000000000000000000000abc000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000003666f6f0000000000000000000000000000000000000000000000000000000000";
    ThorFunction f = ThorFunction(f1);
    List result = f.decodeReturnV1(data);

    expect(result.length, 2);
    expect(result[0].name, "r1");
    expect(result[0].canonicalType, "address");
    expect(result[0].value,
        EthereumAddress.fromHex("0xabc0000000000000000000000000000000000001"));
    expect(result[1].name, "r2");
    expect(result[1].canonicalType, "bytes");
    expect(result[1].value, hexToBytes("0x666f6f"));
  });

  test('decode return String', () {
    String data =
        "0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000c48656c6c6f20576f726c64210000000000000000000000000000000000000000";
    ThorFunction f = ThorFunction(f3);

    List<V1ParamWrapper> result = f.decodeReturnV1(data);
    expect(result[0].name, "");
    expect(result[0].value, "Hello World!");
  });

  test('decode return bool', () {
    String data =
        "0000000000000000000000000000000000000000000000000000000000000001";
    ThorFunction f = ThorFunction(f4);
    List<V1ParamWrapper> result = f.decodeReturnV1(data);
    expect(result[0].value, true);
  });

  test('decode return bigInt', () {
    String data =
        "000000000000000000000000000000000000000000000000000000000001e240fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1dc0";
    ThorFunction f = ThorFunction(f5);

    List<V1ParamWrapper> result = f.decodeReturnV1(data);
    expect(result[0].value, BigInt.from(123456));
    expect(result[1].value, BigInt.from(-123456));
  });

  test('decode return bigInt', () {
    String data =
        "000000000000000000000000000000000000000000000000000000000001e240fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1dc0";
    ThorFunction f = ThorFunction(f5);

    List<V1ParamWrapper> result = f.decodeReturnV1(data);
    expect(result[0].value, BigInt.from(123456));
    expect(result[1].value, BigInt.from(-123456));
  });
}
