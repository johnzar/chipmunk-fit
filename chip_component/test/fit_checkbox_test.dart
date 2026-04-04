import 'dart:ui' show CheckedState, SemanticsAction, Tristate;

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

    testWidgets('uses error color with higher priority', (tester) async {
      const errorColor = Colors.red;

      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: true,
            hasError: true,
            errorColor: errorColor,
            activeColor: Colors.green,
            onChanged: _noop,
          ),
        ),
      );

      final checkbox = _resolveCheckboxWidget(tester);
      expect(checkbox.side?.color, errorColor);
    });

    testWidgets('renders all style branches', (tester) async {
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

        final checkbox = _resolveCheckboxWidget(tester);
        switch (style) {
          case FitCheckboxStyle.material:
            expect(checkbox.shape, isA<RoundedRectangleBorder>());
            final shape = checkbox.shape! as RoundedRectangleBorder;
            expect(shape.borderRadius, BorderRadius.circular(4));
          case FitCheckboxStyle.rounded:
            expect(checkbox.shape, isA<CircleBorder>());
          case FitCheckboxStyle.outlined:
            expect(
              checkbox.fillColor?.resolve(<WidgetState>{WidgetState.selected}),
              Colors.transparent,
            );
        }
      }
    });

    testWidgets('reflects size to visual box', (tester) async {
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

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(FitCheckbox),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox &&
                widget.width == size &&
                widget.height == size,
          ),
        ),
      );
      expect(sizedBox.width, size);
      expect(sizedBox.height, size);
    });

    testWidgets('applies custom border width', (tester) async {
      const borderWidth = 2.2;

      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: false,
            borderWidth: borderWidth,
            onChanged: _noop,
          ),
        ),
      );

      final checkbox = _resolveCheckboxWidget(tester);
      expect(checkbox.side?.width, borderWidth);
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

      expect(row.children.first, isA<GestureDetector>());
      expect(row.children.last, isA<SizedBox>());
    });

    testWidgets('exposes checked/enabled/label semantics', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitCheckbox(
            value: true,
            onChanged: _noop,
            label: '약관 동의',
          ),
        ),
      );

      final rootSemantics = tester.getSemantics(find.byType(FitCheckbox));
      final checkboxSemantics = tester.getSemantics(find.byType(Checkbox));
      final data = checkboxSemantics.getSemanticsData();
      expect(rootSemantics.label, contains('약관 동의'));
      expect(data.flagsCollection.isChecked, CheckedState.isTrue);
      expect(data.flagsCollection.isEnabled, Tristate.isTrue);
      expect(data.hasAction(SemanticsAction.tap), isTrue);
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

Checkbox _resolveCheckboxWidget(WidgetTester tester) {
  return tester.widget<Checkbox>(
    find.descendant(
      of: find.byType(FitCheckbox),
      matching: find.byType(Checkbox),
    ),
  );
}

void _noop(bool _) {}
