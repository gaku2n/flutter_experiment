import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_experiment/main.dart';
import 'package:flutter_experiment/screenshotable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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
    @override
    Future<Uint8List?> takeScreenshot() async {
      Uint8List? image;

      try {
        if (!kIsWeb && Platform.isIOS) {
          try {
            var ss =
                find.byType(Screenshotable).evaluate().first as StatefulElement;

            await tester.pump();
            image = await (ss.state as ScreenshotableState).captureImage();

            debugPrint('screenshot success');
          } catch (e) {
            debugPrint('Screenshot failed $e');
          }
        } else {
          try {
            if (!kIsWeb && Platform.isAndroid) {
              await binding.convertFlutterSurfaceToImage();
            }
          } catch (e) {
            // no-op
          }

          await tester.pump();
          image =
              Uint8List.fromList(await binding.takeScreenshot('screenshot'));
        }
      } catch (e) {
        debugPrint('Screenshot failed $e');
      }

      return image;
    }

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    expect(2 + 2, equals(4));

    // pattern default android
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    // await binding.takeScreenshot('test1234');

    final image = await takeScreenshot();
    binding.reportData ??= <String, dynamic>{};
    binding.reportData!['screenshots'] ??= <dynamic>[];
    final Map<String, dynamic> data = {
      'screenshotName': 'testtest123',
      'bytes': image
    };
    (binding.reportData!['screenshots']!).add(data);

// pattern 1
    // await takeScreenShot(screenshotController, 'screenshot/', 'test.png');

//pattern2
    // await capture(path: 'test.png');
    // sleep(const Duration(seconds: 3));
  });
}
