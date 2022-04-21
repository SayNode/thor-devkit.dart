import 'dart:convert';
import 'dart:typed_data';
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/blake2b.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/crypto/thor_signature.dart';
import 'package:thor_devkit_dart/types/clause.dart';
import 'package:thor_devkit_dart/types/compact_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/nullable_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/numeric_kind.dart';
import 'package:thor_devkit_dart/types/reserved.dart';
import 'package:thor_devkit_dart/types/rlp.dart';
import 'package:thor_devkit_dart/utils.dart';
import 'package:web3dart/src/utils/rlp.dart' as rlp2;

class Transaction {
  static const int delegatedMask = 1;
  NumericKind chainTag = NumericKind(1);
  CompactFixedBlobKind blockRef = CompactFixedBlobKind(8);
  NumericKind expiration = NumericKind(4);
  late List<Clause> clauses;
  NumericKind gasPriceCoef = NumericKind(1);
  NumericKind gas = NumericKind(8);
  NullableFixedBlobKind dependsOn = NullableFixedBlobKind(32);
  NumericKind nonce = NumericKind(8);
  Reserved? reserved;

  Uint8List? signature;

  /// Construct a Transaction.
  /// @param chainTag eg. "1"
  /// @param blockRef eg. "0x00000000aabbccdd"
  /// @param expiration eg. "32"
  /// @param clauses See Clause.java
  /// @param gasPriceCoef eg. "128"
  /// @param gas eg. "21000"
  /// @param dependsOn eg. "0x..." as block ID, or null if not wish to depends on.
  /// @param nonce eg. "12345678", as a random positive number max width is 8 bytes.
  /// @param reserved See Reserved.java

  Transaction(
      int chainTag,
      String blockRef,
      String expiration,
      this.clauses,
      String gasPriceCoef,
      String gas,
      String? dependsOn, // can be null
      String nonce,
      Reserved? reserved // can be null
      ) {
    this.chainTag.setValueBigInt(BigInt.from(chainTag));
    this.blockRef.setValue(blockRef);
    this.expiration.setValueString(expiration);

    this.gasPriceCoef.setValueString(gasPriceCoef);
    this.gas.setValueString(gas);
    this.dependsOn.setValue(dependsOn);
    this.nonce.setValueString(nonce);
    if (reserved == null) {
      this.reserved = Reserved.getNullReserved();
    } else {
      this.reserved = reserved;
    }
  }

  Transaction.fromBytes(
      Uint8List chainTag,
      Uint8List blockRef,
      Uint8List expiration,
      List clauses,
      Uint8List gasPriceCoef,
      Uint8List gas,
      Uint8List dependsOn,
      Uint8List nonce,
      List<Uint8List>? reserved) {
    this.chainTag.fromBytes(chainTag);
    this.blockRef.fromBytes(blockRef);
    this.expiration.fromBytes(expiration);

    List<Clause> _clauses = [];
    for (List c in clauses) {
      var to = Uint8List.fromList(c[0].cast<int>());
      var value = Uint8List.fromList(c[1].cast<int>());
      var data = Uint8List.fromList(c[2].cast<int>());

      _clauses.add(Clause.fromBytes(to, value, data));
    }

    this.clauses = _clauses;

    this.gasPriceCoef.fromBytes(gasPriceCoef);
    this.gas.fromBytes(gas);
    this.dependsOn.fromBytes(dependsOn);
    this.nonce.fromBytes(nonce);
    if (reserved != null) {
      if (reserved.isNotEmpty) {
        this.reserved = Reserved.unpack(reserved);
      } else {
        this.reserved = Reserved.getNullReserved();
      }
    } else {
      this.reserved = Reserved.getNullReserved();
    }
  }

  static fromJsonString(String txBody) {
    Map txMap = json.decode(txBody);
    List<Clause> clauses = [];
    for (var clause in txMap['clauses']) {
      if (clause is String) {
        var c = json.decode(clause);
        clauses.add(Clause(c['to'], c['value'].toString(), c['data']));
      } else {
        clauses.add(
            Clause(clause['to'], clause['value'].toString(), clause['data']));
      }
    }

    var reserved = Reserved(1, []);

    var tx = Transaction(
        txMap['chainTag'],
        txMap['blockRef'],
        txMap['expiration'].toString(),
        clauses,
        txMap['gasPriceCoef'].toString(),
        txMap['gas'].toString(),
        txMap['dependsOn'],
        txMap['nonce'].toString(),
        reserved);
    return tx;
  }

  String toJsonString() {
/*
        this.chainTag.setValueBigInt(BigInt.from(chainTag));
    this.blockRef.setValue(blockRef);
    this.expiration.setValueString(expiration);

    this.gasPriceCoef.setValueString(gasPriceCoef);
    this.gas.setValueString(gas);
    this.dependsOn.setValue(dependsOn);
    this.nonce.setValueString(nonce);
    */
    List<Map> c = [];
    for (var clause in clauses) {
      var _to;
      var _value;
      var _data = '';
      if (clause.to.data != null) {
        _to = '0x' + bytesToHex(clause.to.data!);
      }
            if (clause.value.big != null) {
        _value = clause.value.big!.toInt();
      }
                  if (clause.data.data != null) {
        _data = bytesToHex(clause.data.data!);
      }
      c.add({"to":_to, "value":_value, "data": '0x' + _data});
    }
    var dep;
    if (dependsOn.data != null) {
      dep = bytesToHex(dependsOn.data!);
    }
    Map txMap = {
      "chainTag": chainTag.big!.toInt(),
      "blockRef": '0x' + bytesToHex(blockRef.data!),
      "expiration": expiration.big!.toInt(),
      "clauses": c,
      "gasPriceCoef": gasPriceCoef.big!.toInt(),
      "gas": gas.big!.toInt(),
      "dependsOn": dep,
      "nonce": nonce.big!.toInt()
    };

    return json.encode(txMap);
  }

  /// Calculate the gas used by the data section.
  ///
  /// @param data Thre pure bytes of the data.

  static int calcDataGas(Uint8List data) {
    const int zGas = 4;
    const int nzGas = 68;

    int sum = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 0) {
        sum += zGas;
      } else {
        sum += nzGas;
      }
    }
    return sum;
  }

  /// Calculate roughly the gas from a list of clauses.
  ///
  /// @param clauses A list of clauses.
  /// @return

  static int calcIntrinsicGas(List<Clause> clauses) {
    const int transactionGas = 5000;
    const int clauseGas = 16000;
    const int clauseContrctCreation = 48000;

    // Must pay a static fee even empty!
    if (clauses.isEmpty) {
      return transactionGas + clauseGas;
    }

    int sum = 0;
    sum += transactionGas;

    for (Clause c in clauses) {
      int clauseSum = 0;

      if (c.to.toBytes().isEmpty) {
        // contract creation
        clauseSum += clauseContrctCreation;
      } else {
        // or a normal clause
        clauseSum += clauseGas;
      }

      clauseSum += calcDataGas(c.data.toBytes());
      sum += clauseSum;
    }

    return sum;
  }

  /// Get the rough gas this tx will consume.
  /// @return

  int getIntrinsicGas() {
    return calcIntrinsicGas(clauses);
  }

  ///Determine if this is a delegated transaction (vip-191)

  bool isDelegated() {
    if (reserved == null) {
      return false;
    }
    if (reserved!.features == 0) {
      return false;
    }

    //TODO: make sure this is correct
    return reserved!.features == delegatedMask;
  }

  ///Check if the signature is valid.

  bool _isSignatureValid() {
    int expectedSignatureLength;
    if (isDelegated()) {
      expectedSignatureLength = 65 * 2;
    } else {
      expectedSignatureLength = 65;
    }

    if (signature == null) {
      return false;
    } else {
      return (signature!.length == expectedSignatureLength);
    }
  }

  ///Compute the hash result to be signed.
  /// @param delegateFor "0x..." the address to delegate for him or null.

  Uint8List getSigningHash(String? delegateFor) {
    // Get a unsigned Tx body as List
    List<dynamic> unsignedTxBody = packUnsignedTxBody();
    // RLP encode them to bytes.
    Uint8List buff = Uint8List.fromList(rlp2.encode(unsignedTxBody));
    // Hash it.
    Uint8List h = blake2b256([buff]);

    if (delegateFor != null) {
      if (!Address.isAddress(delegateFor)) {
        throw Exception("delegateFor should be address type.");
      }
      return blake2b256([h, hexToBytes(delegateFor.substring(2))]);
    } else {
      return h;
    }
  }

  ///Pack the objects bytes in a fixed order.
  List packUnsignedTxBody() {
    // Prepare reserved.

    //FIXME: check if reserved can be null
    List<Uint8List> _reserved = reserved!.pack();
    // Prepare clauses.
    List<List<Uint8List>> _clauses = [];
    for (Clause c in clauses) {
      _clauses.add(c.pack());
    }
    // Prepare unsigned tx.
    List unsignedBody = [
      chainTag.toBytes(),
      blockRef.toBytes(),
      expiration.toBytes(),
      _clauses,
      gasPriceCoef.toBytes(),
      gas.toBytes(),
      dependsOn.toBytes(),
      nonce.toBytes(),
      _reserved
    ];

    return unsignedBody;
  }

  ///Get "origin" of the tx by public key bytes style.
  ///@return If can't decode just return null.

  Uint8List? getOriginAsPublicKey() {
    if (!_isSignatureValid()) {
      return null;
    }

    try {
      Uint8List h = getSigningHash(null);
      ThorSignature sig = ThorSignature.fromBytes(
          Uint8List.fromList(signature!.sublist(0, 65)));
      Uint8List pubKey = recover(h, sig);
      return pubKey;
    } catch (e) {
      return null;
    }
  }

  ///Get "origin" of the tx by string Address style.
  /// Notice: Address != public key.
  String? getOriginAsAddressString() {
    Uint8List? pubKey = getOriginAsPublicKey();

    if (pubKey != null) {
      return Address.publicKeyToAddressString(pubKey);
    }

    return null;
  }

  /// Get "origin" of the tx by bytes Address style.
  /// Notice: Address != public key.

  Uint8List? getOriginAsAddressBytes() {
    Uint8List? pubKey = getOriginAsPublicKey();
    return pubKey == null ? null : Address.publicKeyToAddressBytes(pubKey);
  }

  ///Get the delegator public key as bytes.

  Uint8List? getDelegator() {
    if (!isDelegated()) {
      return null;
    }

    if (!_isSignatureValid()) {
      return null;
    }

    String? origin = getOriginAsAddressString();
    if (origin == null) {
      return null;
    }

    try {
      Uint8List h = getSigningHash(origin);
      ThorSignature sig = ThorSignature.fromBytes(
          Uint8List.fromList(signature!.sublist(65, signature!.length)));
      return recover(h, sig);
    } catch (e) {
      return null;
    }
  }

  /// Get the delegator as Address type, in bytes.
  /// @return or null.

  Uint8List? getDeleagtorAsAddressBytes() {
    Uint8List? pubKey = getDelegator();
    return pubKey == null ? null : Address.publicKeyToAddressBytes(pubKey);
  }

  /// Get the delegator as Address type, in string.
  /// @return or null.
  String? getDelegatorAsAddressString() {
    Uint8List? pubKey = getDelegator();
    return pubKey == null ? null : Address.publicKeyToAddressString(pubKey);
  }

  ///Calculate Tx id (32 bytes).
  /// @return or null.

  Uint8List? getId() {
    if (!_isSignatureValid()) {
      return null;
    }
    try {
      Uint8List h = getSigningHash(null);
      ThorSignature sig = ThorSignature.fromBytes(
          Uint8List.fromList(signature!.sublist(0, 65)));
      Uint8List pubKey = recover(h, sig);
      Uint8List addressBytes = Address.publicKeyToAddressBytes(pubKey);
      return blake2b256([h, addressBytes]);
    } catch (e) {
      return null;
    }
  }

  ///Get TX id as "0x..." = 2 chars 0x + 64 chars hex
  ///@return or null.

  String? getIdAsString() {
    Uint8List? b = getId();
    return b == null ? null : "0x" + bytesToHex(b);
  }

  ///Encode a tx into bytes.

  Uint8List encode() {
    List unsignedTxBody = packUnsignedTxBody();

    // Pack more: append the sig bytes at the end.
    if (signature != null) {
      unsignedTxBody.add(signature!);
    }

    // RLP encode the packed body.

    return Uint8List.fromList(rlp2.encode(unsignedTxBody));
  }

  ///Decode a tx from Uint8List [data].
  ///
  static Transaction decode(Uint8List data, bool unsigned) {
    var decoded = RlpDecoder.decode(data);

    var chainTag = Uint8List.fromList(decoded[0].cast<int>());
    var blockRef = Uint8List.fromList(decoded[1].cast<int>());
    var expiration = Uint8List.fromList(decoded[2].cast<int>());

    List clauses = [];

    for (var item in decoded[3]) {
      clauses.add(item);
    }

    var gasPriceCoef = Uint8List.fromList(decoded[4].cast<int>());
    var gas = Uint8List.fromList(decoded[5].cast<int>());
    var dependsOn = Uint8List.fromList(decoded[6].cast<int>());
    var nonce = Uint8List.fromList(decoded[7].cast<int>());
    List<Uint8List> reserved = [];
    for (var item in decoded[8]) {
      clauses.add(item);
    }

    var output = Transaction.fromBytes(chainTag, blockRef, expiration, clauses,
        gasPriceCoef, gas, dependsOn, nonce, reserved);

    if (!unsigned) {
      Uint8List sig = Uint8List.fromList(decoded[9].cast<int>());
      output.signature = sig;
    }

    return output;
  }

  ///Clone current tx into a standalone object.

  Transaction clone() {
    bool unsigned = signature == null;
    return Transaction.decode(encode(), unsigned);
  }
}
