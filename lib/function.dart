import 'dart:convert';
import 'dart:typed_data';

import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/types/v1_param_wrapper.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';

class ThorFunction {
  late ContractFunction function;

  ThorFunction(String jsonString) {
    Map tempF = json.decode(jsonString);

    //parse inputs/parameters of function into FunctionParameters
    List<FunctionParameter> inputs = [];
    for (var input in tempF['inputs']) {
      if (input['type'] == 'tuple') {
        List<AbiType> components = [];
        for (var component in input['components']) {
          components.add(parseAbiType(component['type']));
        }
        inputs.add(FunctionParameter(input['name'], TupleType(components)));
      } else {
        inputs
            .add(FunctionParameter(input['name'], parseAbiType(input['type'])));
      }
    }

    //parse outputs of function
    List<FunctionParameter> outputs = [];
    for (var output in tempF['outputs']) {
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

  List _encode(List args) {
    try {
      List<int> intList = args as List<int>;
      return Uint8List.fromList(intList);
    } catch (_) {
      List out = [];
      for (var i = 0; i < args.length; i++) {
        if (args[i] is String) {
          if (Address.isAddress(args[i])) {
            out.add(EthereumAddress.fromHex(args[i]));
          } else {
            out.add(args[i]);
          }
        } else if (args[i] is List) {
          out.add(_encode(args[i]));
        } else {
          out.add(args[i]);
        }
      }

      return out;
    }
  }

  ///Encode the parameters to Uint8List
  Uint8List encode(List args) {
    List out = _encode(args);
    return function.encodeCall(out);
  }

  //Decode return data into a list of V1ParamWrapper objects.
  List<V1ParamWrapper> decodeReturnV1(String data) {
    List<V1ParamWrapper> decoded = [];

    for (var i = 0; i < function.outputs.length; i++) {
      decoded.add(V1ParamWrapper(i, function.outputs[i].name,
          function.outputs[i].type.name, function.decodeReturnValues(data)[i]));
    }

    return decoded;
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
