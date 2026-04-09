import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FitButton uses dialog-aligned default radius', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          theme: ThemeData(useMaterial3: true, extensions: [lightFitColors]),
          home: Scaffold(
            body: Center(
              child: FitButton(
                onPressed: () {},
                child: const Text('확인'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final shape = button.style?.shape?.resolve(<WidgetState>{});
    expect(shape, isA<RoundedRectangleBorder>());

    final border = shape! as RoundedRectangleBorder;
    final radius = border.borderRadius.resolve(TextDirection.ltr);

    expect(
      radius.topLeft.x,
      closeTo(FitButtonStyle.defaultBorderRadius.r, 0.01),
    );
    expect(
      radius.topRight.x,
      closeTo(FitButtonStyle.defaultBorderRadius.r, 0.01),
    );
  });
}
