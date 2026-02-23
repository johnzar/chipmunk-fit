import 'package:chip_component/chip/fit_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitChip', () {
    testWidgets('applies pressed transform on tap down and restores on tap up',
        (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        _buildApp(
          FitChip(
            onTap: () => tapCount++,
            child: const Text('chip'),
          ),
        ),
      );

      final gesture =
          await tester.startGesture(tester.getCenter(find.text('chip')));
      await tester.pumpAndSettle();

      expect(
        _currentScale(tester),
        closeTo(FitChip.defaultPressedScale, 0.0001),
      );

      await gesture.up();
      await tester.pumpAndSettle();

      expect(_currentScale(tester), closeTo(1.0, 0.0001));
      expect(tapCount, 1);
    });

    testWidgets('restores transform on tap cancel', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          FitChip(
            onTap: () {},
            child: const Text('chip'),
          ),
        ),
      );

      final gesture =
          await tester.startGesture(tester.getCenter(find.text('chip')));
      await tester.pumpAndSettle();
      expect(
        _currentScale(tester),
        closeTo(FitChip.defaultPressedScale, 0.0001),
      );

      await gesture.cancel();
      await tester.pumpAndSettle();

      expect(_currentScale(tester), closeTo(1.0, 0.0001));
    });

    testWidgets('toggles onSelected with next value', (tester) async {
      bool? toggled;

      await tester.pumpWidget(
        _buildApp(
          FitChip(
            isSelected: false,
            onSelected: (next) => toggled = next,
            child: const Text('selectable'),
          ),
        ),
      );

      await tester.tap(find.text('selectable'));
      await tester.pumpAndSettle();

      expect(toggled, isTrue);
    });

    testWidgets('calls onTap when onSelected is null', (tester) async {
      var tapCount = 0;

      await tester.pumpWidget(
        _buildApp(
          FitChip(
            onTap: () => tapCount++,
            child: const Text('action'),
          ),
        ),
      );

      await tester.tap(find.text('action'));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
    });

    testWidgets('does not react when disabled', (tester) async {
      var tapCount = 0;
      bool? toggled;

      await tester.pumpWidget(
        _buildApp(
          FitChip(
            isEnabled: false,
            isSelected: false,
            onTap: () => tapCount++,
            onSelected: (next) => toggled = next,
            child: const Text('disabled'),
          ),
        ),
      );

      final gesture =
          await tester.startGesture(tester.getCenter(find.text('disabled')));
      await tester.pumpAndSettle();
      expect(_currentScale(tester), closeTo(1.0, 0.0001));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(tapCount, 0);
      expect(toggled, isNull);
    });

    testWidgets('applies pressedScale override', (tester) async {
      const customScale = 0.9;

      await tester.pumpWidget(
        _buildApp(
          FitChip(
            pressedScale: customScale,
            onTap: () {},
            child: const Text('custom-scale'),
          ),
        ),
      );

      final gesture = await tester
          .startGesture(tester.getCenter(find.text('custom-scale')));
      await tester.pumpAndSettle();

      expect(_currentScale(tester), closeTo(customScale, 0.0001));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('uses animationDuration override', (tester) async {
      const customDuration = Duration(milliseconds: 120);

      await tester.pumpWidget(
        _buildApp(
          FitChip(
            animationDuration: customDuration,
            onTap: () {},
            child: const Text('duration'),
          ),
        ),
      );

      final animated =
          tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(animated.duration, customDuration);
    });

    testWidgets('uses FitButton-aligned default motion values', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          FitChip(
            onTap: () {},
            child: const Text('defaults'),
          ),
        ),
      );

      final animated =
          tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
      expect(animated.duration, FitChip.defaultAnimationDuration);
    });
  });
}

Widget _buildApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

double _currentScale(WidgetTester tester) {
  final animated =
      tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
  final matrix = animated.transform;
  if (matrix == null) return 1.0;
  return matrix.storage[0];
}
