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

typedef RustGreetingFunc = Pointer<Utf8> Function(Pointer<Utf8>);
typedef RustGreetingFuncNative = Pointer<Utf8> Function(Pointer<Utf8>);

typedef FreeStringFunc = void Function(Pointer<Utf8>);
typedef FreeStringFuncNative = Void Function(Pointer<Utf8>);

///////////////////////////////////////////////////////////////////////////////
// Load the library
///////////////////////////////////////////////////////////////////////////////

final DynamicLibrary nativeSubstrateSignLib = Platform.isAndroid
    ? DynamicLibrary.open("libsubstrateSign.so")
    : DynamicLibrary.process();

///////////////////////////////////////////////////////////////////////////////
// Locate the symbols we want to use
///////////////////////////////////////////////////////////////////////////////

final RustGreetingFunc rustGreeting = nativeSubstrateSignLib
    .lookup<NativeFunction<RustGreetingFuncNative>>("rust_greeting")
    .asFunction();

final FreeStringFunc freeCString = nativeSubstrateSignLib
    .lookup<NativeFunction<FreeStringFuncNative>>("rust_cstr_free")
    .asFunction();

///////////////////////////////////////////////////////////////////////////////
// HANDLERS
///////////////////////////////////////////////////////////////////////////////

String nativeGreeting(String name) {
  if (nativeSubstrateSignLib == null)
    return "ERROR: The library is not initialized 🙁";

  print("  ${nativeSubstrateSignLib.toString()}"); // Instance info

  final argName = Utf8.toUtf8(name);
  print("- Calling rust_greeting with argument:  $argName");

  // The actual native call
  final resultPointer = rustGreeting(argName);
  print("- Result pointer:  $resultPointer");

  final greetingStr = Utf8.fromUtf8(resultPointer);
  print("- Response string:  $greetingStr");

  // Free the string pointer, as we already have
  // an owned String to return
  print("- Freing the native char*");
  freeCString(resultPointer);

  return greetingStr;
}

