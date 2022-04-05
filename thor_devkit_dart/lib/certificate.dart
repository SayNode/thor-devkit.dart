import 'dart:convert';

class Certificate {
  late String purpose;
  late Map payload;
  late String domain;
  late int timestamp;
  late String signer;
  String? signature;

  Certificate(
      this.purpose, this.payload, this.domain, String signer, this.timestamp,
      {String? signature}) {
    this.signer = signer.toLowerCase();
    if (signature != null) {
      this.signature = signature.toLowerCase();
    }
  }

  Certificate.fromMap(Map map) {
    purpose = map['purpose'];
    payload = map['payload'];
    domain = map['domain'];
    timestamp = map['timestamp'];
    signer = map['signer'];
    signature = map['signature'];
  }

  Certificate.fromJsonString(String input) {
    Map map = jsonDecode(input);
    purpose = map['purpose'];
    payload = map['payload'];
    domain = map['domain'];
    timestamp = map['timestamp'];
    signer = map['signer'];
    signature = map['signature'];
  }

  Map toMap() {
    String sig = '';
    if (signature != null) {
      sig = signature!;
    }
    final map = <String, Object>{
      'purpose': purpose,
      'payload': payload,
      'domain': domain,
      'timestamp': timestamp,
      'signer': signer,
      'signature': sig
    };
    return map;
  }
}
