import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bottom_sheet_x/bottom_sheet_x.dart';

void main() {
  const MethodChannel channel = MethodChannel('bottom_sheet_x');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await BottomSheet_x.platformVersion, '42');
  });
}
