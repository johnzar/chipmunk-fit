import 'package:chip_component/radio/fit_radio_button.dart';
import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitRadioButton', () {
    testWidgets('calls onChanged with own value when tapped', (tester) async {
      String? selected = 'b';

      await tester.pumpWidget(
        _buildApp(
          FitRadioButton<String>(
            value: 'a',
            groupValue: selected,
            onChanged: (next) => selected = next,
          ),
        ),
      );

      await tester.tap(find.byType(Radio<String>));
      await tester.pumpAndSettle();

      expect(selected, 'a');
    });

    testWidgets('does not call onChanged when disabled', (tester) async {
      String? selected = 'b';

      await tester.pumpWidget(
        _buildApp(
          FitRadioButton<String>(
            value: 'a',
            groupValue: selected,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.byType(Radio<String>));
      await tester.pumpAndSettle();

      expect(selected, 'b');
    });

    testWidgets('tapping label also selects value', (tester) async {
      String? selected = 'b';

      await tester.pumpWidget(
        _buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return FitRadioButton<String>(
                value: 'a',
                groupValue: selected,
                label: '옵션 A',
                onChanged: (next) => setState(() => selected = next),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('옵션 A'));
      await tester.pumpAndSettle();

      expect(selected, 'a');
    });

    testWidgets('uses material style rendering', (tester) async {
      const activeColor = Colors.deepPurple;
      await tester.pumpWidget(
        _buildApp(
          const FitRadioButton<String>(
            value: 'a',
            groupValue: 'b',
            activeColor: activeColor,
            onChanged: _noop,
          ),
        ),
      );

      final radio = tester.widget<Radio<String>>(find.byType(Radio<String>));
      expect(radio.useCupertinoCheckmarkStyle, isFalse);
      expect(radio.side?.width, 2.0);
      expect(
        radio.fillColor?.resolve(<WidgetState>{WidgetState.selected}),
        activeColor,
      );
    });

    testWidgets('reflects custom size', (tester) async {
      const size = 30.0;

      await tester.pumpWidget(
        _buildApp(
          const FitRadioButton<String>(
            value: 'a',
            groupValue: 'b',
            size: size,
            onChanged: _noop,
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(FitRadioButton<String>),
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
  });
}

Widget _buildApp(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      extensions: [lightFitColors],
    ),
    home: Scaffold(body: Center(child: child)),
  );
}

void _noop(String? _) {}
