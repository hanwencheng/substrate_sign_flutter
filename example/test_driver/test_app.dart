import 'package:flutter/material.dart';
import 'package:substrate_sign_flutter/substrate_sign_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      home: MyHomePage(title: 'Test App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool _result = false;
  bool _started = false;
  void _setTestFailed (){
    setState(() {
      _result = false;
      _started = true;
    });
  }

  void _setTestSuccess(){
    setState(() {
      _result = true;
      _started = true;
    });
  }

  void _resetTest(){
    setState(() {
      _result = false;
      _started = false;
    });
  }

  void _startTest(){
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
    if(address!= "" && address == addressWithRef ){
      _setTestSuccess();
    } else{
      _setTestFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E2E test App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Start by tap the button',
            ),
            Text(
              _result ? "Success" : "Failed",
              // Provide a Key to this specific Text widget. This allows
              // identifing the widget from inside the test suite,
              // and reading the text.
              key: Key('testResult'),
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              _started ? "Finished" : "Ready",
              // Provide a Key to this specific Text widget. This allows
              // identifing the widget from inside the test suite,
              // and reading the text.
              key: Key('testFinished'),
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Provide a Key to this button. This allows finding this
        // specific button inside the test suite, and tapping it.
        key: Key('startTest'),
        onPressed: _startTest,
        tooltip: 'Start Test',
        child: Icon(Icons.autorenew),
      ),
    );
  }
}
