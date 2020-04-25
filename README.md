# substrate_sign_flutter

Flutter plugin for using Substrate signing functions offline.

This plugin use Dart `ffi` module to bind Rust function. 

Now works on Android, check this [thread](https://github.com/flutter/flutter/issues/33227#issuecomment-611838825) to get update for ios

More details about using rust in flutter please check this great [article](https://medium.com/flutter-community/using-ffi-on-flutter-plugins-to-run-native-rust-code-d64c0f14f9c2)

## Usage

SURI: Secret URI is with format of `"$seedPhrase//$derivationPath///derivationPassword"`, for example `SURI bottom drive obey lake curtain smoke basket hold race lonely fit walk//kusama/1///000000`.

`randomPhrase`: Generate random seed phrase

```dart
String randomPhrase(int digits)
```

`substrateAddress`: Generate substrate address with provided suri(Secret URI). 
```dart
String substrateAddress (String seed, int prefix) 
```

`substrateSign`: Sign hex string with the provided seed
```dart
String substrateSign(String suri, String message)
```

`encryptData`: encrypt data with [ethsign](https://github.com/tomusdrw/ethsign)
```dart
String encryptData(String data, String password) 
```

`decryptData`: decrypt data with [ethsign](https://github.com/tomusdrw/ethsign)
```dart
String decryptData(String data, String password)
```

#### Functions with seed pointer

By using seed phrase, we could keep seed phrase in the protected Rust runtime and avoid it to be exposed to the dart Runtime and avoid it to keep in the app state. To interact with seed reference functions user need give the seed pointer as an argument.

```dart
//get address with seed pointer
String substrateAddressWithRef(int seedRef, String suriSuffix, int prefix)

//sign hex data with seed pointer
String substrateSignWithRef(int seedRef, String suriSuffix, String message)

//decrypt the cipher text and return the seed pointer
int decryptDataWithRef(String data, String password)

//destroy the pointer, deallocate the memory assigned to the seed
void destroyDataRef(int ref)
```

NOTICE: here `suriSuffix` refer to the combination of derivation path and derivation password like `//some_path/1///123456` or only path but without password like `//another_path`

## Develop
To customize the library or add more functions. First run
```shell script
./script/init.sh
```
to setup required toolchains

After building, run 
```shell script
./script/build.sh
```
to generate the clue code and binaries for Rust, Flutter, iOS and Android.

## Test

Now use integration test for testing the native binding functions.
```shell script
cd example && flutter drive --target=test_driver/app.dart
```

## License 
GNU 3.0
