import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:substrate_sign_flutter/substrate_sign_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _testSeed = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String testSeed;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      testSeed = randomPhrase(12);
    } on PlatformException {
      testSeed = 'Failed to get seed.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _testSeed = testSeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Genrated Seed: $_testSeed\n'),
              FlatButton(
                child: const Text('Press'),
                onPressed: () {
//                  String seed = "${randomPhrase(12)}//kusama///";
                  String seed = "daring phrase labor alien treat divert trick analyst shrug idle run program//kusama///";
                  String suriSuffix = "//kusama";
                  String seedPhrase = "daring phrase labor alien treat divert trick analyst shrug idle run program";
                  print("response is $seed");
                  String message = "49800000100005301025a4a03f84a19cf8ebda40e62358c592870691a9cf456138bb4829969d10fe9699c0400ff3c36776005aec2f32a34c109dc791a82edef980eec3be80da938ac9bcc68217202286bee7503000015040000b0a8d493285c2df73290dfb7e61f870f17b41801197a149ca93654499ea3dafe19d84dae3af90c5c78ff8eaed58b0db1ff8600c4426d4e0969a905ab5fe2d2e50";
                  String signedResult = substrateSign(seed, message);
                  print("signed result is $signedResult");
                  String address = substrateAddress(seed, 2);
                  print("substrate address is $address");
                  String encrypted = encryptData(seed, "000000");
                  print("encrypted data is $encrypted");
                  String decrypted = decryptData(encrypted, "000000");
                  print("decrypted seed is $decrypted");

                  String encryptedSeedPhrase = encryptData(seedPhrase, "000000");
                  int seedRef = decryptDataWithRef(encryptedSeedPhrase, "000000");
                  print("decrypted seed ref is $seedRef");
                  String signedWithRefResult = substrateSignWithRef(seedRef, suriSuffix, message);
                  print("signed with ref result is $signedWithRefResult");
                  String addressWithRef = substrateAddressWithRef(seedRef, suriSuffix, 2);
                  print("generate address with ref is $addressWithRef");
                  rustDestroyDataRef(seedRef);
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}
