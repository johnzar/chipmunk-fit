import 'package:chip_component/checkbox/fit_checkbox.dart';
import 'package:chip_component/checkbox/fit_checkbox_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitCheckbox', () {
    testWidgets('toggles value on tap', (tester) async {
      var value = false;

      await tester.pumpWidget(
        _buildApp(
          FitCheckbox(
            value: value,
            onChanged: (next) => value = next,
          ),
        ),
      );

      await tester.tap(find.byType(FitCheckbox));
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('toggles with keyboard Space and Enter', (tester) async {
      var value = false;

      await tester.pumpWidget(
        _buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return FitCheckbox(
                value: value,
                onChanged: (next) {
                  setState(() => value = next);
                },
              );
            },
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(value, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(value, isFalse);
    });

    testWidgets('does not toggle when disabled', (tester) async {
      var value = false;

      await tester.pumpWidget(
        _buildApp(
          FitCheckbox(
            value: value,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.byType(FitCheckbox));
      await tester.pumpAndSettle();

      expect(value, isFalse);
    });

    testWidgets('uses error color on border when hasError', (tester) async {
      const errorColor = Colors.red;

      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: false,
            hasError: true,
            errorColor: errorColor,
            activeColor: Colors.green,
            onChanged: _noop,
          ),
        ),
      );

      // Container의 border 색상이 errorColor인지 확인
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FitCheckbox),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      // Color.lerp 결과이므로 ARGB 값으로 비교
      expect(border.top.color.r, closeTo(errorColor.r, 0.01));
      expect(border.top.color.g, closeTo(errorColor.g, 0.01));
      expect(border.top.color.b, closeTo(errorColor.b, 0.01));
    });

    testWidgets('renders all style branches without error', (tester) async {
      for (final style in FitCheckboxStyle.values) {
        await tester.pumpWidget(
          _buildApp(
            FitCheckbox(
              value: true,
              style: style,
              onChanged: _noop,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Container가 렌더링되는지 확인
        expect(
          find.descendant(
            of: find.byType(FitCheckbox),
            matching: find.byType(Container),
          ),
          findsOneWidget,
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(FitCheckbox),
            matching: find.byType(Container),
          ),
        );
        final decoration = container.decoration! as BoxDecoration;

        switch (style) {
          case FitCheckboxStyle.material:
            expect(decoration.borderRadius, BorderRadius.circular(4));
          case FitCheckboxStyle.rounded:
            expect(decoration.shape, BoxShape.circle);
          case FitCheckboxStyle.outlined:
            expect(decoration.borderRadius, BorderRadius.circular(4));
        }
      }
    });

    testWidgets('reflects size to visual container', (tester) async {
      const size = 32.0;

      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: true,
            size: size,
            onChanged: _noop,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FitCheckbox),
          matching: find.byType(Container),
        ),
      );
      final constraints = container.constraints;
      expect(constraints?.maxWidth, size);
      expect(constraints?.maxHeight, size);
    });

    testWidgets('applies custom border width', (tester) async {
      const borderWidth = 3.0;

      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: false,
            borderWidth: borderWidth,
            onChanged: _noop,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FitCheckbox),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.top.width, borderWidth);
    });

    testWidgets('reflects label placement when labelOnLeft is true',
        (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: true,
            onChanged: _noop,
            label: '약관 동의',
            labelOnLeft: true,
          ),
        ),
      );

      final row = tester.widget<Row>(
        find.descendant(
          of: find.byType(FitCheckbox),
          matching: find.byType(Row),
        ),
      );

      // labelOnLeft이면 첫 번째가 Flexible(Text), 마지막이 체크박스 비주얼
      expect(row.children.first, isA<Flexible>());
    });

    testWidgets('exposes checked/enabled semantics', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: true,
            onChanged: _noop,
            label: '약관 동의',
          ),
        ),
      );

      // Semantics 트리에서 label 확인
      final semantics = tester.getSemantics(find.byType(FitCheckbox));
      expect(semantics.label, contains('약관 동의'));
    });

    testWidgets('minimum tap target is 44x44', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: false,
            size: 16,
            onChanged: _noop,
          ),
        ),
      );

      final constrainedBox = tester.widget<ConstrainedBox>(
        find.descendant(
          of: find.byType(FitCheckbox),
          matching: find.byWidgetPredicate(
            (w) =>
                w is ConstrainedBox &&
                w.constraints.minWidth == 44 &&
                w.constraints.minHeight == 44,
          ),
        ),
      );
      expect(constrainedBox.constraints.minWidth, 44);
      expect(constrainedBox.constraints.minHeight, 44);
    });

    testWidgets('accepts animationDuration for backward compatibility',
        (tester) async {
      var value = false;

      await tester.pumpWidget(
        _buildApp(
          FitCheckbox(
            value: value,
            animationDuration: const Duration(milliseconds: 900),
            onChanged: (next) => value = next,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byType(FitCheckbox));
      await tester.pumpAndSettle();
      expect(value, isTrue);
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

void _noop(bool _) {}
