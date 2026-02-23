import 'package:chip_component/button/fit_animated_bottom_button.dart';
import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitAnimatedBottomButton', () {
    testWidgets('does not apply safe-area bottom padding when disabled',
        (tester) async {
      tester.view.padding = const FakeViewPadding(bottom: 34);
      addTearDown(tester.view.resetPadding);

      await _pumpButton(
        tester,
        useSafeArea: false,
      );

      final padding = _resolveOuterPadding(tester);
      expect(padding.bottom, 0);
    });

    testWidgets('applies safe-area + policy padding when enabled',
        (tester) async {
      tester.view.padding = const FakeViewPadding(bottom: 34);
      addTearDown(tester.view.resetPadding);

      await _pumpButton(
        tester,
        useSafeArea: true,
      );

      final padding = _resolveOuterPadding(tester);
      final context = tester.element(find.byType(FitAnimatedBottomButton));
      final mediaQuery = MediaQuery.of(context);
      expect(padding.bottom, mediaQuery.padding.bottom + 8);
      expect(padding.top, closeTo(12.h, 0.6));
    });

    testWidgets('always applies keyboard tween animation', (tester) async {
      await _pumpButton(
        tester,
        useSafeArea: false,
      );

      expect(
        find.byWidgetPredicate((widget) => widget is TweenAnimationBuilder),
        findsOneWidget,
      );
    });

    testWidgets('collapses padding and radius when keyboard is visible',
        (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);

      await _pumpButton(
        tester,
        useSafeArea: false,
      );

      final padding = _resolveOuterPadding(tester);
      expect(padding.left, 0);
      expect(padding.right, 0);
      expect(padding.bottom, 0);
      expect(padding.top, closeTo(0, 0.6));

      final fitButton = tester.widget<FitButton>(find.byType(FitButton));
      final shape = fitButton.style?.shape?.resolve(<WidgetState>{});
      expect(shape, isA<RoundedRectangleBorder>());
      final border = shape! as RoundedRectangleBorder;
      final radius = border.borderRadius.resolve(TextDirection.ltr);
      expect(radius.topLeft.x, 0);
      expect(radius.topRight.x, 0);
      expect(radius.bottomLeft.x, 0);
      expect(radius.bottomRight.x, 0);
    });

    testWidgets('collapses radius after keyboard appears post-build',
        (tester) async {
      addTearDown(tester.view.resetViewInsets);

      await _pumpButton(
        tester,
        useSafeArea: false,
      );

      final initialRadius = _resolveButtonRadius(tester);
      expect(initialRadius.topLeft.x, greaterThan(0));

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();

      final collapsedRadius = _resolveButtonRadius(tester);
      expect(collapsedRadius.topLeft.x, 0);
      expect(collapsedRadius.topRight.x, 0);
      expect(collapsedRadius.bottomLeft.x, 0);
      expect(collapsedRadius.bottomRight.x, 0);
    });
  });
}

Future<void> _pumpButton(
  WidgetTester tester, {
  required bool useSafeArea,
}) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          extensions: [lightFitColors],
        ),
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: FitAnimatedBottomButton(
              useSafeArea: useSafeArea,
              onPressed: () {},
              child: const Text('확인'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

EdgeInsets _resolveOuterPadding(WidgetTester tester) {
  final containerFinder = find
      .descendant(
        of: find.byType(FitAnimatedBottomButton),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.padding != null,
        ),
      )
      .first;

  final container = tester.widget<Container>(containerFinder);
  return container.padding! as EdgeInsets;
}

BorderRadius _resolveButtonRadius(WidgetTester tester) {
  final fitButton = tester.widget<FitButton>(find.byType(FitButton));
  final shape = fitButton.style?.shape?.resolve(<WidgetState>{});
  expect(shape, isA<RoundedRectangleBorder>());
  final border = shape! as RoundedRectangleBorder;
  return border.borderRadius.resolve(TextDirection.ltr);
}
