import 'dart:core';
import 'dart:typed_data';
import 'package:thor_devkit_dart/utils.dart';
import 'package:thor_devkit_dart/crypto/address.dart';
import 'package:test/test.dart';

void main() {
  test('is adress test', () {
    String adress = '0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb';

    expect(true, Address.isAddress(adress));
    adress = '0XD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb';
    expect(true, Address.isAddress(adress));
    adress = '0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aD';
    expect(false, Address.isAddress(adress));
    adress = '0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDba';
    expect(false, Address.isAddress(adress));
    adress = '0xD1220A0cf47c7B9Be7A2E6Bx89F429762e7b9aDb';
    expect(false, Address.isAddress(adress));
  });
  test('Test key to adress', () {
    Uint8List pub = hexToBytes(
        "04b90e9bb2617387eba4502c730de65a33878ef384a46f1096d86f2da19043304afa67d0ad09cf2bea0c6f2d1767a9e62a7a7ecc41facf18f2fa505d92243a658f");

    Uint8List address = Address.publicKeyToAddressBytes(pub);
    expect(address, hexToBytes("d989829d88b0ed1b06edf5c50174ecfa64f14a64"));

    String address2 = Address.publicKeyToAddressString(pub);
    expect(address2, "0xd989829d88b0ed1b06edf5c50174ecfa64f14a64");
  });

  test('Test checksum adress', () {
    Set<String> addresses = {
      "0x5aAeb6053F3E94C9b9A09f33669435E7Ef1BeAed",
      "0xfB6916095ca1df60bB79Ce92cE3Ea74c37c5d359",
      "0xdbF03B407c01E7cD3CBea99509d93f8DDDC8C6FB",
      "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb",
    };

    for (String item in addresses) {
      expect(item, Address.toChecksumAddress(item));
    }
    expect('0xf7172f3dC885b68931C7259Aea44c83B31c447E8',
        Address.toChecksumAddress("0xf7172f3dc885b68931c7259aea44c83b31c447e8"));
  });
}
