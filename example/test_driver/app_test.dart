// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Test Rust Bindings', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final resultTextFinder = find.byValueKey('testResult');
    final finishedTextFinder = find.byValueKey('testFinished');
    final buttonFinder = find.byValueKey('startTest');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('starts', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(finishedTextFinder), "Ready");
      expect(await driver.getText(resultTextFinder), "Failed");
    });

    test('increments the counter', () async {
      // First, tap the button.
      await driver.tap(buttonFinder);

      // Then, verify the counter text is incremented by 1.
      expect(await driver.getText(finishedTextFinder), "Finished");
      expect(await driver.getText(resultTextFinder), "Success");
    });
  });
}
