import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_experiment/main.dart';
import 'package:flutter_experiment/screenshotable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/integration_test_driver.dart';
import 'package:screenshot/screenshot.dart';
import '../test_driver/main_test.dart' as app;
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_driver/driver_extension.dart';

// void main() {
//   late FlutterDriver driver;

//   setUpAll(() async {
//     driver = await FlutterDriver.connect();
//     final driverHealth = await driver.checkHealth();
//     switch (driverHealth.status) {
//       case HealthStatus.ok:
//         debugPrint('Driver Health OK');
//         break;
//       case HealthStatus.bad:
//         fail('Driver Health Bad');
//     }
//   });

//   tearDownAll(() => driver.close());

//   testWidgets('test example', (tester) async {
//     await tester.pumpWidget(const MyApp());

//     await takeScreenShot(driver, '', 'test');

//     sleep(const Duration(seconds: 3));
//   });
// }

// Future<void> takeScreenShot(
//   FlutterDriver driver,
//   String path,
//   String fileName,
// ) async {
//   await driver.waitUntilNoTransientCallbacks();
//   final screenshot = await driver.screenshot();
//   final file = File('$path/$fileName.png');
//   await file.writeAsBytes(screenshot);
// }

Future<void> main() async {
  // ScreenshotController screenshotController = ScreenshotController();
  // late FlutterDriver driver;

  // setUpAll(() async {
  //   driver = await FlutterDriver.connect();
  //   final driverHealth = await driver.checkHealth();
  //   switch (driverHealth.status) {
  //     case HealthStatus.ok:
  //       debugPrint('Driver Health OK');
  //       break;
  //     case HealthStatus.bad:
  //       fail('Driver Health Bad');
  //   }
  //   sleep(const Duration(seconds: 3));
  // });

  /// 実機テストをサポート
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  testWidgets('screenshot', (tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(2 + 2, equals(4));

    // pattern default android
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('test123');

// pattern 1
    // await takeScreenShot(screenshotController, 'screenshot/', 'test.png');

//pattern2
    // await capture(path: 'test.png');
    // sleep(const Duration(seconds: 3));
  });
}

Future<void> takeScreenShot(
  ScreenshotController controller,
  String path,
  String fileName,
) async {
  final screenshot = await controller.captureAndSave(fileName);
}
