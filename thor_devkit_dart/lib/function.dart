import 'dart:convert';
import 'dart:typed_data';

import 'package:web3dart/contracts.dart';

class ThorFunction {
  late ContractFunction function;

  ThorFunction(String jsonString) {
    Map tempF = json.decode(jsonString);

    //parse inputs/parameters of function into FunctionParameters
    List<FunctionParameter> inputs = [];
    for (var input in tempF['inputs']) {
      FunctionParameter(input['name'], parseAbiType(input['type']));
    }

    //parse outputs of function
    List<FunctionParameter> outputs = [];
    for (var output in tempF['inputs']) {
      FunctionParameter(output['name'], parseAbiType(output['type']));
    }

    function = ContractFunction(tempF['name'], inputs,
        outputs: outputs,
        type: parseFunctionType(tempF['type']),
        mutability: parseStateMutability(tempF['mutability']));
  }

  ///Get selector as Uint8List
  Uint8List selector() {
    return function.selector;
  }

  ///Encode the parameters to Uint8List
  Uint8List encode(List args) {
    return function.encodeCall(args);
  }


  ///Decode the return value of the function
  List decodeReturn(String data) {
    return function.decodeReturnValues(data);
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
  if (name == 'nonPayable') {
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



/*
      {
        "constant": true,
        "inputs": [
          {
            "internalType": "address",
            "name": "",
            "type": "address"
          }
        ],
        "name": "balanceOf",
        "outputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "payable": false,
        "stateMutability": "view",
        "type": "function"
      },
      */