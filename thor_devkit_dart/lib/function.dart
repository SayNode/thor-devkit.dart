import 'dart:convert';
import 'dart:typed_data';

import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';

class ThorFunction {
  late ContractFunction function;

  ThorFunction(String jsonString) {
    Map tempF = json.decode(jsonString);

    //parse inputs/parameters of function into FunctionParameters
    List<FunctionParameter> inputs = [];
    for (var input in tempF['inputs']) {
      inputs.add(FunctionParameter(input['name'], parseAbiType(input['type'])));
    }

    //parse outputs of function
    List<FunctionParameter> outputs = [];
    for (var output in tempF['inputs']) {
      outputs
          .add(FunctionParameter(output['name'], parseAbiType(output['type'])));
    }

    function = ContractFunction(tempF['name'], inputs,
        outputs: outputs,
        type: parseFunctionType(tempF['type']),
        mutability: parseStateMutability(tempF['stateMutability']));
  }

  ///Get selector as Uint8List
  Uint8List selector() {
    return function.selector;
  }

  ///Encode the parameters to Uint8List
  Uint8List encode(List args) {
    List out = [];
    for (var i = 0; i < args.length; i++) {
      if (args[i] is String) {
        if (Address.isAddress(args[i])) {
          out.add(EthereumAddress.fromHex(args[i]));
        } else {
          out.add(args[i]);
        }
      } else {
        out.add(args[i]);
      }
    }

    //EthereumAddress a = EthereumAddress.fromHex(args[0]);
    //return function.encodeCall([a]);
    return function.encodeCall(out);
  }


  //TODO: maybe change the way the return values are output
  ///Decode the return value of the function
  List decodeReturn(String data) {
    return function.decodeReturnValues(data);
  }

  @override
  String toString() {
    return function.toString();
  }
}

///Returns ContractFunctionType coresponding to [name]
ContractFunctionType parseFunctionType(String name) {
  if (name == 'constructor') {
    return ContractFunctionType.constructor;
  }
  if (name == 'fallback') {
    return ContractFunctionType.fallback;
  }
  if (name == 'function') {
    return ContractFunctionType.function;
  }
  throw FormatException('Type $name doesnt exist.');
}

///Returns StateMutability coresponding to [name]
StateMutability parseStateMutability(String name) {
  if (name == 'nonpayable') {
    return StateMutability.nonPayable;
  }
  if (name == 'payable') {
    return StateMutability.payable;
  }
  if (name == 'pure') {
    return StateMutability.pure;
  }

  if (name == 'view') {
    return StateMutability.view;
  }
  throw FormatException('Type $name doesnt exist.');
}
