import 'dart:typed_data';

import 'package:rlp/rlp.dart';
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/blake2b.dart';
import 'package:thor_devkit_dart/types/clause.dart';
import 'package:thor_devkit_dart/types/compact_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/nullable_fixed_blob_kind.dart';
import 'package:thor_devkit_dart/types/numeric_kind.dart';
import 'package:thor_devkit_dart/types/reserved.dart';
import 'package:thor_devkit_dart/utils.dart';

class Transaction {
  static const int DELEGATED_MASK = 1;
  NumericKind chainTag = NumericKind(1);
  CompactFixedBlobKind blockRef = CompactFixedBlobKind(8);
  NumericKind expiration = NumericKind(4);
  late List<Clause> clauses;
  NumericKind gasPriceCoef = NumericKind(1);
  NumericKind gas = NumericKind(8);
  NullableFixedBlobKind dependsOn = NullableFixedBlobKind(32);
  NumericKind nonce = NumericKind(8);
  Reserved? reserved;

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
      String chainTag,
      String blockRef,
      String expiration,
      this.clauses,
      String gasPriceCoef,
      String gas,
      String? dependsOn, // can be null
      String nonce,
      Reserved? reserved // can be null
      ) {
    this.chainTag.setValueString(chainTag);
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

  /// Calculate the gas used by the data section.
  ///
  /// @param data Thre pure bytes of the data.

  static int calcDataGas(Uint8List data) {
    const int Z_GAS = 4;
    const int NZ_GAS = 68;

    int sum = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i] == 0) {
        sum += Z_GAS;
      } else {
        sum += NZ_GAS;
      }
    }
    return sum;
  }

  /// Calculate roughly the gas from a list of clauses.
  ///
  /// @param clauses A list of clauses.
  /// @return

  static int calcIntrinsicGas(List<Clause> clauses) {
    const int TX_GAS = 5000;
    const int CLAUSE_GAS = 16000;
    const int CLAUSE_CONTRACT_CREATION = 48000;

    // Must pay a static fee even empty!
    if (clauses.isEmpty) {
      return TX_GAS + CLAUSE_GAS;
    }

    int sum = 0;
    sum += TX_GAS;

    for (Clause c in clauses) {
      int clauseSum = 0;

      if (c.to.toBytes().isEmpty) {
        // contract creation
        clauseSum += CLAUSE_CONTRACT_CREATION;
      } else {
        // or a normal clause
        clauseSum += CLAUSE_GAS;
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

  /// Check if is a delegated transaction (vip-191)

  bool isDelegated() {}

  ///Compute the hash result to be signed.
  /// @param delegateFor "0x..." the address to delegate for him or null.

  Uint8List getSigningHash(String? delegateFor) {
    // Get a unsigned Tx body as an array.
    List<dynamic> unsignedTxBody = this.packUnsignedTxBody().toArray();
    // RLP encode them to bytes.

    Uint8List buff = Rlp.encode(unsignedTxBody);

    // Hash it.
    Uint8List h = blake2b256([buff]);

    if (delegateFor != null) {
      if (!isAddress(delegateFor)) {
        throw Exception("delegateFor should be address type.");
      }
      return blake2b256([h, hexToBytes(delegateFor.substring(2))]);
    } else {
      return h;
    }
  }

    /// Pack the objects bytes in a fixed order.
    
    List packUnsignedTxBody() {

}
