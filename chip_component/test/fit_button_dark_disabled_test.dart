import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses accessible dark disabled colors for primary buttons', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => Builder(
          builder: (context) {
            final theme = fitDarkTheme(
              context,
              buttonForegroundColor: darkFitColors.staticWhite,
              buttonDisabledBackgroundColor: darkFitColors.violet50,
            );

            return MaterialApp(
              theme: theme,
              home: Scaffold(
                body: Center(
                  child: FitButton(
                    type: FitButtonType.primary,
                    isEnabled: false,
                    child: const Text('쿠폰 등록'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final background = button.style?.backgroundColor?.resolve(_disabledState);
    final foreground = button.style?.foregroundColor?.resolve(_disabledState);

    expect(background, darkFitColors.violet50);
    expect(foreground, darkFitColors.grey600);
  });
}

const _disabledState = <WidgetState>{WidgetState.disabled};
