import 'package:chip_component/button/fit_switch_button.dart';
import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitSwitchButton', () {
    testWidgets('emits nextValue true when toggled from false', (tester) async {
      bool? received;

      await tester.pumpWidget(
        _buildApp(
          FitSwitchButton(
            isOn: false,
            debounceDuration: Duration.zero,
            onToggle: (next) => received = next,
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(received, isTrue);
    });

    testWidgets('emits nextValue false when toggled from true', (tester) async {
      bool? received;

      await tester.pumpWidget(
        _buildApp(
          FitSwitchButton(
            isOn: true,
            debounceDuration: Duration.zero,
            onToggle: (next) => received = next,
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(received, isFalse);
    });

    testWidgets('blocks repeated toggle calls within debounce duration',
        (tester) async {
      var value = false;
      var calls = 0;

      await tester.pumpWidget(
        _buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              return FitSwitchButton(
                isOn: value,
                debounceDuration: const Duration(milliseconds: 300),
                onToggle: (next) {
                  calls += 1;
                  setState(() => value = next);
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(value, isTrue);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(value, isTrue);

      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 320)),
      );
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(value, isFalse);
    });

    testWidgets('binds switch value from isOn', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitSwitchButton(
            isOn: true,
            onToggle: _noop,
          ),
        ),
      );

      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

      await tester.pumpWidget(
        _buildApp(
          const FitSwitchButton(
            isOn: false,
            onToggle: _noop,
          ),
        ),
      );

      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    });

    testWidgets('maps active and inactive track colors', (tester) async {
      const active = Colors.green;
      const inactive = Colors.orange;

      await tester.pumpWidget(
        _buildApp(
          const FitSwitchButton(
            isOn: true,
            onToggle: _noop,
            activeColor: active,
            inactiveColor: inactive,
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.activeTrackColor, active);
      expect(switchWidget.inactiveTrackColor, inactive);
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

void _noop(bool _) {}
