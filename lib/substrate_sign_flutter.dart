//import 'dart:async';
//
//import 'package:flutter/services.dart';
//
//class SubstrateSignFlutter {
//  static const MethodChannel _channel =
//      const MethodChannel('substrate_sign_flutter');
//
//  static Future<String> get platformVersion async {
//    final String version = await _channel.invokeMethod('getPlatformVersion');
//    return version;
//  }
//}

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

///////////////////////////////////////////////////////////////////////////////
// C bindings
///////////////////////////////////////////////////////////////////////////////

// void rust_cstr_free(char *s);
// char *rust_greeting(const char *to);

///////////////////////////////////////////////////////////////////////////////
// Typedef's
///////////////////////////////////////////////////////////////////////////////

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);

typedef RustRandomPhrase = Pointer<Utf8> Function(int);
typedef RustRandomPhraseNative = Pointer<Utf8> Function(Uint32);

typedef RustSign = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef RustSignNative = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

typedef RustSubstrateAddress = Pointer<Utf8> Function(Pointer<Utf8>, int);
typedef RustSubstrateAddressNative = Pointer<Utf8> Function(Pointer<Utf8>, Uint32);

typedef RustEncrypt = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef RustEncryptNative = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

typedef RustDecrypt = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);
typedef RustDecryptNative = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>);

typedef RustDecryptWithRef = int Function(Pointer<Utf8>, Pointer<Utf8>);
typedef RustDecryptWithRefNative = Int64 Function(Pointer<Utf8>, Pointer<Utf8>);

typedef RustDestroyDataRef = void Function(int);
typedef RustDestroyDataRefNative = Void Function(Int64);

typedef RustSignWithRef = Pointer<Utf8> Function(int, Pointer<Utf8>, Pointer<Utf8>);
typedef RustSignWithRefNative = Pointer<Utf8> Function(Int64, Pointer<Utf8>, Pointer<Utf8>);

typedef RustSubstrateAddressWithRef = Pointer<Utf8> Function(int, Pointer<Utf8>, int);
typedef RustSubstrateAddressWithRefNative = Pointer<Utf8> Function(Int64, Pointer<Utf8>, Uint32);

///////////////////////////////////////////////////////////////////////////////
// Load the library
///////////////////////////////////////////////////////////////////////////////

final DynamicLibrary nativeSubstrateSignLib = Platform.isAndroid
    ? DynamicLibrary.open("libsubstrateSign.so")
    : DynamicLibrary.process();

///////////////////////////////////////////////////////////////////////////////
// Locate the symbols we want to use
///////////////////////////////////////////////////////////////////////////////

final FreeStringFunc freeCString = nativeSubstrateSignLib
    .lookup<NativeFunction<FreeStringFuncNative>>("rust_cstr_free")
    .asFunction();

final RustRandomPhrase rustRandomPhrase = nativeSubstrateSignLib
    .lookup<NativeFunction<RustRandomPhraseNative>>("random_phrase")
    .asFunction();

final RustSign rustSign = nativeSubstrateSignLib
    .lookup<NativeFunction<RustSignNative>>("substrate_sign")
    .asFunction();

final RustSubstrateAddress rustSubstrateAddress = nativeSubstrateSignLib
    .lookup<NativeFunction<RustSubstrateAddressNative>>("substrate_address")
    .asFunction();

final RustEncrypt rustEncrypt = nativeSubstrateSignLib
    .lookup<NativeFunction<RustEncryptNative>>("encrypt_data")
    .asFunction();

final RustDecrypt rustDecrypt = nativeSubstrateSignLib
    .lookup<NativeFunction<RustDecryptNative>>("decrypt_data")
    .asFunction();

final RustDecryptWithRef rustDecryptWithRef = nativeSubstrateSignLib
    .lookup<NativeFunction<RustDecryptWithRefNative>>("decrypt_data_with_ref")
    .asFunction();

final RustDestroyDataRef rustDestroyDataRef = nativeSubstrateSignLib
    .lookup<NativeFunction<RustDestroyDataRefNative>>("destroy_data_ref")
    .asFunction();

final RustSignWithRef rustSignWithRef = nativeSubstrateSignLib
    .lookup<NativeFunction<RustSignWithRefNative>>("substrate_sign_with_ref")
    .asFunction();

final RustSubstrateAddressWithRef rustSubstrateAddressWithRef = nativeSubstrateSignLib
    .lookup<NativeFunction<RustSubstrateAddressWithRefNative>>("substrate_address_with_ref")
    .asFunction();

///////////////////////////////////////////////////////////////////////////////
// HANDLERS
///////////////////////////////////////////////////////////////////////////////

String randomPhrase(int digits){
  if (nativeSubstrateSignLib == null)
    return "ERROR: The library is not initialized 🙁";

  print("  ${nativeSubstrateSignLib.toString()}"); // Instance info
  final phrasePointer = rustRandomPhrase(digits);
  return Utf8.fromUtf8(phrasePointer);
}

String substrateSign(String suri, String message) {
  final utf8Suri =  Utf8.toUtf8("$suri//path///");
  final utf8Message = Utf8.toUtf8(message);
  final utf8SignedMessage = rustSign(utf8Suri, utf8Message);
  final signedMessage = Utf8.fromUtf8(utf8SignedMessage);
  freeCString(utf8SignedMessage);
  return signedMessage;
}

String substrateAddress (String seed, int prefix) {
  final utf8Seed = Utf8.toUtf8(seed);
  final utf8Address = rustSubstrateAddress(utf8Seed, prefix);
  final address = Utf8.fromUtf8(utf8Address);
  freeCString(utf8Address);
  return address;
}

String encryptData(String data, String password) {
  final utf8Data = Utf8.toUtf8(data);
  final utf8Password = Utf8.toUtf8(password);
  final utf8Encrypted = rustEncrypt(utf8Data, utf8Password);
  final encrypted = Utf8.fromUtf8(utf8Encrypted);
  freeCString(utf8Encrypted);
  return encrypted;
}

String decryptData(String data, String password) {
  final utf8Data = Utf8.toUtf8(data);
  final utf8Password = Utf8.toUtf8(password);
  final utf8Decrypted = rustDecrypt(utf8Data, utf8Password);
  final decrypted = Utf8.fromUtf8(utf8Decrypted);
  freeCString(utf8Decrypted);
  return decrypted;
}

int decryptDataWithRef(String data, String password) {
  final utf8Data = Utf8.toUtf8(data);
  final utf8Password = Utf8.toUtf8(password);
  final ref = rustDecryptWithRef(utf8Data, utf8Password);
  return ref;
}

void destroyDataRef(int ref){
  rustDestroyDataRef(ref);
}

String substrateSignWithRef(int seedRef, String suriSuffix, String message) {
  if(seedRef == 0) return "seed ref not valid";
  final utf8SuriSuffix =  Utf8.toUtf8("$suriSuffix//path///");
  final utf8Message = Utf8.toUtf8(message);
  final utf8SignedMessage = rustSignWithRef(seedRef, utf8SuriSuffix, utf8Message);
  final signedMessage = Utf8.fromUtf8(utf8SignedMessage);
  freeCString(utf8SignedMessage);
  return signedMessage;
}

String substrateAddressWithRef(int seedRef, String suriSuffix, int prefix) {
  if(seedRef == 0) return "seed ref not valid";
  final utf8SuriSuffix = Utf8.toUtf8(suriSuffix);
  final utf8Address = rustSubstrateAddressWithRef(seedRef, utf8SuriSuffix, prefix);
  final address = Utf8.fromUtf8(utf8Address);
  freeCString(utf8Address);
  return address;
}


