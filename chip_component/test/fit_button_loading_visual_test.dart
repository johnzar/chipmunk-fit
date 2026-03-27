import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitButton loading visuals', () {
    testWidgets(
      'primary loading keeps the default tone in catalog-like light theme',
      (tester) async {
        await _pumpButton(
          tester,
          type: FitButtonType.primary,
          brightness: Brightness.light,
          isLoading: true,
        );

        final style = _resolveFilledButtonStyle(tester);
        final background = style.backgroundColor?.resolve(_disabledState);
        final foreground = style.foregroundColor?.resolve(_disabledState);

        expect(background, lightFitColors.main);
        expect(background, isNot(lightFitColors.violet50));
        expect(foreground, lightFitColors.staticWhite);
      },
    );

    testWidgets(
      'primary loading keeps the default tone in catalog-like dark theme',
      (tester) async {
        await _pumpButton(
          tester,
          type: FitButtonType.primary,
          brightness: Brightness.dark,
          isLoading: true,
        );

        final style = _resolveFilledButtonStyle(tester);
        final background = style.backgroundColor?.resolve(_disabledState);
        final foreground = style.foregroundColor?.resolve(_disabledState);

        expect(background, darkFitColors.main);
        expect(background, isNot(darkFitColors.violet50));
        expect(foreground, darkFitColors.staticWhite);
      },
    );

    testWidgets(
      'loading visuals match default foreground and differ from disabled for every type',
      (tester) async {
        for (final type in FitButtonType.values) {
          await _pumpButton(tester, type: type, brightness: Brightness.light);
          final defaultStyle = _resolveFilledButtonStyle(tester);

          await _pumpButton(
            tester,
            type: type,
            brightness: Brightness.light,
            isEnabled: false,
          );
          final disabledStyle = _resolveFilledButtonStyle(tester);

          await _pumpButton(
            tester,
            type: type,
            brightness: Brightness.light,
            isLoading: true,
          );
          final loadingStyle = _resolveFilledButtonStyle(tester);

          final defaultForeground = defaultStyle.foregroundColor?.resolve({});
          final disabledForeground = disabledStyle.foregroundColor?.resolve(
            _disabledState,
          );
          final loadingForeground = loadingStyle.foregroundColor?.resolve(
            _disabledState,
          );
          final defaultBackground = defaultStyle.backgroundColor?.resolve({});
          final loadingBackground = loadingStyle.backgroundColor?.resolve(
            _disabledState,
          );

          expect(
            loadingForeground,
            defaultForeground,
            reason: '$type foreground',
          );
          expect(
            loadingForeground,
            isNot(disabledForeground),
            reason: '$type should not reuse disabled foreground while loading',
          );
          expect(
            loadingBackground,
            defaultBackground,
            reason: '$type background',
          );
        }
      },
    );

    testWidgets('loading ignores taps and does not call onDisabledPressed', (
      tester,
    ) async {
      var pressedCount = 0;
      var disabledPressedCount = 0;

      await _pumpButton(
        tester,
        type: FitButtonType.primary,
        brightness: Brightness.light,
        isLoading: true,
        onPressed: () => pressedCount++,
        onDisabledPressed: () => disabledPressedCount++,
      );

      await tester.tap(find.byType(FitButton));
      await tester.pump(const Duration(milliseconds: 16));

      expect(pressedCount, 0);
      expect(disabledPressedCount, 0);
    });
  });
}

const _disabledState = <WidgetState>{WidgetState.disabled};

Future<void> _pumpButton(
  WidgetTester tester, {
  required FitButtonType type,
  required Brightness brightness,
  bool isEnabled = true,
  bool isLoading = false,
  VoidCallback? onPressed,
  VoidCallback? onDisabledPressed,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => Builder(
        builder: (context) {
          final theme = brightness == Brightness.dark
              ? fitDarkTheme(
                  context,
                  buttonForegroundColor: darkFitColors.staticWhite,
                  buttonDisabledBackgroundColor: darkFitColors.violet50,
                )
              : fitLightTheme(
                  context,
                  buttonForegroundColor: lightFitColors.staticWhite,
                  buttonDisabledBackgroundColor: lightFitColors.violet50,
                );

          return MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Center(
                child: FitButton(
                  type: type,
                  isEnabled: isEnabled,
                  isLoading: isLoading,
                  onPressed: onPressed ?? () {},
                  onDisabledPressed: onDisabledPressed,
                  child: const Text('쿠폰 등록'),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
  await tester.pump();
}

ButtonStyle _resolveFilledButtonStyle(WidgetTester tester) {
  final button = tester.widget<FilledButton>(find.byType(FilledButton));
  return button.style!;
}
