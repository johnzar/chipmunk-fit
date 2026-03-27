import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitButton accessibility', () {
    testWidgets('respects system text scaling for button label', (
      tester,
    ) async {
      await _pumpButton(
        tester,
        width: 220,
        text: '버튼',
        textScaler: const TextScaler.linear(1.5),
      );

      final label = _findButtonLabel(tester);
      expect(label.textScaler, isNotNull);
      expect(label.textScaler!.scale(10), closeTo(15, 0.01));
    });

    testWidgets('keeps accessibility scaling even when auto-size applies', (
      tester,
    ) async {
      await _pumpButton(
        tester,
        width: 88,
        text: '접근성 버튼 텍스트',
        textScaler: const TextScaler.linear(2.0),
      );

      final label = _findButtonLabel(tester);
      expect(label.textScaler, isNotNull);
      expect(label.textScaler!.scale(10), greaterThan(10));
    });
  });
}

Future<void> _pumpButton(
  WidgetTester tester, {
  required double width,
  required String text,
  required TextScaler textScaler,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        theme: ThemeData(useMaterial3: true, extensions: [lightFitColors]),
        home: MediaQuery(
          data: MediaQueryData(textScaler: textScaler),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: width,
                child: FitButton(
                  maxLines: 1,
                  onPressed: () {},
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Text _findButtonLabel(WidgetTester tester) {
  final finder = find.descendant(
    of: find.byType(FitButton),
    matching: find.byType(Text),
  );
  return tester.widget<Text>(finder.first);
}
