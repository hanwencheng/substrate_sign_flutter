// Import the test package and Counter class
import 'package:test/test.dart';
import 'package:substrate_sign_flutter/substrate_sign_flutter.dart';

void main() {
  test('get random phrase', () {
    String response = randomPhrase(12);

    expect(response.split("").length, 12);
  });
}
