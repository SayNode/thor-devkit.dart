# VeChain Thor Devkit (SDK) in Dart

Dart package to assist smooth development on VeChain for developers and hobbyists.

|                          Content                          |
| --------------------------------------------------------- |
| Public key, private key, address conversion.              |
| Mnemonic Wallets.                                         |
| HD Wallet.                                                |
| Keystore.                                                 |
| Various Hashing functions.                                |
| Signing messages.                                         |
| Verify signature of messages.                             |
| Bloom filter.                                             |
| Transaction Assembling (**Multi-task Transaction, MTT**). |
| Fee Delegation Transaction (**VIP-191**).                 |
| Self-signed Certificate (**VIP-192**).                    |
| ABI decoding of "functions" and "events" in logs.         |

... and will always be updated with the **newest** features on VeChain.



# Usage

### Private/Public Keys
```dart
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/utils.dart';

//generate a new private key
BigInt priv = generatePrivateKey();
//derive public key from given private key
Uint8List pub = derivePublicKey(priv, false); // byte[65].
//derive address from given public key
Uint8List addr = Address.publicKeyToAddressBytes(pub);
//turn address into a hex string and prepend 0x to get a valid address String
String address = "0x" + bytesToHex(addr);
print(address);
// address should look like this: 0x63ad8a6d015ae579ad128e0c63040bb860cc5d34

String checksumAddress = Address.toChecksumAddress(address);
print(checksumAddress);
// checksumAddress should look like this: 0x63ad8A6D015aE579ad128e0c63040bB860Cc5D34
```

### Sign & Verify Signatures

```dart
import 'package:thor_devkit_dart/crypto/keccak.dart';
import 'package:thor_devkit_dart/crypto/secp256k1.dart';
import 'package:thor_devkit_dart/crypto/thor_signature.dart';
import 'package:thor_devkit_dart/utils.dart';
Uint8List priv = hexToBytes(
    "7582be841ca040aa940fff6c05773129e135623e41acce3e0b8ba520dc1ae26a"
); // byte[32].

Uint8List msgHash = keccak256(
    [asciiToBytes("hello world")]
); // byte[32].

// Sign the message hash.
ThorSignature sig = sign(msgHash, priv);

//you can turn a ThorSignature object into bytes
Uint8List sigBytes = sig.serialize();
print(bytesToHex(sigBytes));
//f8fe82c74f9e1f5bf443f8a7f8eb968140f554968fdcab0a6ffe904e451c8b9244be44bccb1feb34dd20d9d8943f8c131227e55861736907b02d32c06b934d7200

// Recover public key from given message hash and signature.
Uint8List pub = recover( msgHash, sig); // byte[65].


// Verify if the public key matches.
expect(pub, derivePublicKey(bytesToInt(priv), false));// true.

```

### Mnemonic Wallet

```dart
import 'package:thor_devkit_dart/crypto/mnemonic.dart';

    List<String> words = Mnemonic.generate(entropyLength: 128);
    print(words);
// [carry, slow, attack, december, number, film, scale, faith, can, old, cage, expose]

    bool flag = Mnemonic.validate(words);
    print(flag); // true.

// Quickly get a Bip32 master seed for HD wallets.
// How to use the seed? See "HD wallet" below.
    Uint8List seed = Mnemonic.deriveSeed(words);

// Quickly get a private key at index 0.
// Need to generate more? See "HD wallet" below.
    Uint8List priv = Mnemonic.derivePrivateKey(words);
```

### HD Wallet

Hierarchical Deterministic Wallets. 
See [bip-32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) 
and [bip-44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki).

```dart
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:thor_devkit_dart/crypto/hd_node.dart';
import 'package:thor_devkit_dart/utils.dart';

    List<String> words = [
      "ignore",
      "empty",
      "bird",
      "silly",
      "journey",
      "junior",
      "ripple",
      "have",
      "guard",
      "waste",
      "between",
      "tenant"
    ];

// Construct an HD node from words. (Recommended)
    HDNode topMostNode = HDNode.fromMnemonic(words);

// Or, construct from seed. (Advanced)
    String seed_hex =
        "28bc19620b4fbb1f8892b9607f6e406fcd8226a0d6dc167ff677d122a1a64ef936101a644e6b447fd495677f68215d8522c893100d9010668614a68b3c7bb49f";

    HDNode topMostNode2 = HDNode.fromSeed(hexToBytes(seed_hex));

// Access the HD node's properties.
    Uint8List priv = topMostNode.privateKey!; //private key can be null
    Uint8List pub = topMostNode.publicKey;
    Uint8List cc = topMostNode.chainCode;

// Or, construct from a private key. (Advanced)
    HDNode topMostNode3 = HDNode.fromPrivateKey(priv, cc);

// Or, construct from a public key. (Advanced)
// Notice: This HD node CANNOT derive child HD node contains "private key".
    HDNode topMostNode4 = HDNode.fromPublicKey(pub, cc);

// Let it derive further child HD nodes.
    for (int i = 0; i < 3; i++) {
      HDNode child = topMostNode.derive(i);
      print("addr: " + Address.publicKeyToAddressString(child.publicKey));
      print("priv: " + bytesToHex(child.privateKey!));
    }
// addr: 0x339fb3c438606519e2c75bbf531fb43a0f449a70
// priv: 27196338e7d0b5e7bf1be1c0327c53a244a18ef0b102976980e341500f492425
// addr: 0x5677099d06bc72f9da1113afa5e022feec424c8e
// priv: cf44074ec3bf912d2a46b7c84fa6eb745652c9c74e674c3760dc7af07fc98b62
// addr: 0x86231b5cdcbfe751b9ddcd4bd981fc0a48afe921
// priv: 2ca054a50b53299ea3949f5362ee1d1cfe6252fbe30bea3651774790983e9348

```
### Keystore

```dart
import 'package:thor_devkit_dart/crypto/keystore.dart';

    String ks = """
{
    "version": 3,
    "id": "f437ebb1-5b0d-4780-ae9e-8640178ffd77",
    "address": "dc6fa3ec1f3fde763f4d59230ed303f854968d26",
    "crypto":
    {
        "kdf": "scrypt",
        "kdfparams": {
            "dklen": 32,
            "salt": "b57682e5468934be81217ad5b14ca74dab2b42c2476864592c9f3b370c09460a",
            "n": 262144,
            "r": 8,
            "p": 1
        },
        "cipher": "aes-128-ctr",
        "ciphertext": "88cb876f9c0355a89cad88ee7a17a2179700bc4306eaf78fa67320efbb4c7e31",
        "cipherparams": {
            "iv": "de5c0c09c882b3f679876b22b6c5af21"
        },
        "mac": "8426e8a1e151b28f694849cb31f64cbc9ae3e278d02716cf5b61d7ddd3f6e728"
    }
}
""";

// Must be UTF_8 string.
    String password = "123456";
// Decrypt from keystore to a private key.
    Uint8List priv = Keystore.decrypt(ks, password);
// Encrypt from a private key to a keystore.
    String ks2 = Keystore.encrypt(priv, password);
    print(ks2);
```

### Hash
```dart
import 'package:thor_devkit_dart/utils.dart';
import 'package:thor_devkit_dart/crypto/keccak.dart';

    String input = "hello world";
    List<String> inputs = ["hello", " ", "world"];

    Uint8List output1 = keccak256([asciiToBytes(input)]);
    Uint8List output2 = keccak256([
      asciiToBytes(inputs[0]),
      asciiToBytes(inputs[1]),
      asciiToBytes(inputs[2])
    ]); // output1 == outpu2
    print(bytesToHex(output1));
    print(bytesToHex(output2));
    //47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad

    Uint8List output3 = blake2b256([asciiToBytes(input)]);
    Uint8List output4 = blake2b256([
      asciiToBytes(inputs[0]),
      asciiToBytes(inputs[1]),
      asciiToBytes(inputs[2])
    ]); // output3 == outpu4
    print(bytesToHex(output3));
    print(bytesToHex(output4));
    //256c83b297114d201b30179f3f0ef0cace9783622da5974326b436178aeef610
  });
```