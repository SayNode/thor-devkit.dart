import 'dart:convert';
import 'dart:typed_data';

import 'package:web3dart/contracts.dart';

class ThorEvent {
  late ContractEvent event;
  ThorEvent(String jsonString) {
    var tempE = json.decode(jsonString);

    //parse components
    List<EventComponent> components = [];
    for (var input in tempE['inputs']) {
      components.add(EventComponent(
          FunctionParameter(input['name'], parseAbiType(input['type'])),
          input['indexed']));
    }

    event = ContractEvent(tempE['anonymous'], tempE['name'], components);
  }

  Uint8List getSignature() {
    return event.signature;
  }

  ///Returns topics and data
  List decodeResults(List<String> topics, String data) {
    return event.decodeResults(topics, data);
  }

  
}

