import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/blake2b.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/transaction.dart';
import 'package:thor_devkit_dart/types/clause.dart';
import 'package:thor_devkit_dart/types/reserved.dart';
import 'package:thor_devkit_dart/utils.dart';

void main() {
  late Transaction tx;
  List<Clause> clauses = [
    Clause("0x7567d83b7b8d80addcb281a71d54fc7b3364ffed", "10000",
        "0x000000606060"),
    Clause(
        "0x7567d83b7b8d80addcb281a71d54fc7b3364ffed", "20000", "0x000000606060")
  ];

  setUp(() {
    tx = Transaction("1", "0x00000000aabbccdd", "32", clauses, "128", "21000",
        null, "12345678", null);
  });



  test('test encoding unsigned Transaction', () {


    expect(tx.getId(), null);
    expect(tx.getIntrinsicGas(), 37432);
    expect(tx.signature, null);
    expect(tx.getOriginAsPublicKey(), null);
    expect(tx.getOriginAsAddressBytes(), null);
    expect(tx.getOriginAsAddressString(), null);

            expect(
        tx.encode(),
        hexToBytes(
            "f8540184aabbccdd20f840df947567d83b7b8d80addcb281a71d54fc7b3364ffed82271086000000606060df947567d83b7b8d80addcb281a71d54fc7b3364ffed824e208600000060606081808252088083bc614ec0"));



    expect(
        tx.getSigningHash(null),
        hexToBytes(
            "2a1c25ce0d66f45276a5f308b99bf410e2fc7d5b6ea37a49f2ab9f1da9446478"));
  });


    test('signed transaction', () {


        Uint8List privateKey = hexToBytes("7582be841ca040aa940fff6c05773129e135623e41acce3e0b8ba520dc1ae26a");
        Uint8List h = blake2b256([tx.encode()]);
        Uint8List sig = sign(h, privateKey).serialize();
        tx.signature = sig;

        Uint8List publicKeyUncompressed = derivePublicKeyFromBytes(privateKey, false);
        Uint8List addressBytes = publicKeyToAddressBytes(publicKeyUncompressed);

        expect(
            tx.signature,
            hexToBytes("f76f3c91a834165872aa9464fc55b03a13f46ea8d3b858e528fcceaf371ad6884193c3f313ff8effbb57fe4d1adc13dceb933bedbf9dbb528d2936203d5511df00")
        );

        expect(
            tx.getOriginAsAddressBytes(),
            addressBytes
        );

        expect(
            tx.getIdAsString(),
            "0xda90eaea52980bc4bb8d40cb2ff84d78433b3b4a6e7d50b75736c5e3e77b71ec"
        );

        expect(
            tx.getSigningHash("0x" + bytesToHex(addressBytes)),
            hexToBytes("da90eaea52980bc4bb8d40cb2ff84d78433b3b4a6e7d50b75736c5e3e77b71ec")
        );

        expect(
            tx.encode(),
            hexToBytes("f8970184aabbccdd20f840df947567d83b7b8d80addcb281a71d54fc7b3364ffed82271086000000606060df947567d83b7b8d80addcb281a71d54fc7b3364ffed824e208600000060606081808252088083bc614ec0b841f76f3c91a834165872aa9464fc55b03a13f46ea8d3b858e528fcceaf371ad6884193c3f313ff8effbb57fe4d1adc13dceb933bedbf9dbb528d2936203d5511df00")
        );

        //Uint8List encodedTx = hexToBytes("f8970184aabbccdd20f840df947567d83b7b8d80addcb281a71d54fc7b3364ffed82271086000000606060df947567d83b7b8d80addcb281a71d54fc7b3364ffed824e208600000060606081808252088083bc614ec0b841f76f3c91a834165872aa9464fc55b03a13f46ea8d3b858e528fcceaf371ad6884193c3f313ff8effbb57fe4d1adc13dceb933bedbf9dbb528d2936203d5511df00");
        //Transaction tx1 = Transaction.decode(encodedTx, false);

        // See: tx1.equals(tx);
       // expect(tx1, tx);
    });



  test('empty clauses', () {
    // empty clauses!
    tx.clauses = [];

    expect(tx.getIntrinsicGas(), 21000);
  });

  test('clause with empty text', () {
    List<Clause> clauses = [
      Clause(null, "0", "0x" // data = 0x
          )
    ];

    tx.clauses = clauses;

    expect(tx.getIntrinsicGas(), 53000);
  });


    test('features', () {
        Reserved reserved = Reserved(1, [
            hexToBytes("1234")
        ]);
        tx.reserved = reserved;

        expect(tx.isDelegated(), true);

        // Sender
        Uint8List priv_1 = hexToBytes("58e444d4fe08b0f4d9d86ec42f26cf15072af3ddc29a78e33b0ceaaa292bcf6b");
        Uint8List addr_1 = publicKeyToAddressBytes(derivePublicKeyFromBytes(priv_1, false));

        // Gas Payer
        Uint8List priv_2 = hexToBytes("0bfd6a863f347f4ef2cf2d09c3db7b343d84bb3e6fc8c201afee62de6381dc65");
        Uint8List addr_2 = publicKeyToAddressBytes(derivePublicKeyFromBytes(priv_2, false));

        // Sender sign the message himself.
        Uint8List h = tx.getSigningHash(null);
        Uint8List senderHash = sign(h, priv_1).serialize();

        // Gas payer sign the hash for the sender.
        Uint8List dh = tx.getSigningHash("0x" + bytesToHex(addr_1));
        Uint8List payerHash = sign(dh, priv_2).serialize();

        // Assemble signature
        Uint8List sig = Uint8List.fromList(senderHash + payerHash);
        expect(sig.length, 65 * 2);

        // Set the signature onto the tx.
        tx.signature = sig;

        expect(
            tx.getOriginAsAddressBytes(),
            addr_1
        );

        expect(
            tx.getDeleagtorAsAddressBytes(),
            addr_2
        );
    });

  


}
