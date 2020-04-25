import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:substrate_sign_flutter/substrate_sign_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('substrate_sign_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  test('getPlatformVersion', () async {
//    expect(await SubstrateSignFlutter.platformVersion, '42');
  });

  test('generate random phrase', () {
    String input = "some text";
    String output = randomPhrase(12);
    expect(input, output);
  });
}
