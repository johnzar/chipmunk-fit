import 'package:chip_component/indicator/fit_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitPageIndicator', () {
    testWidgets('renders correct number of dots', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitPageIndicator(count: 5, currentIndex: 0),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 5);
    });

    testWidgets('returns SizedBox.shrink when count is 0', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitPageIndicator(count: 0, currentIndex: 0),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('expanded style: active dot is wider', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitPageIndicator(
            count: 3,
            currentIndex: 1,
            style: FitPageIndicatorStyle.expanded,
            dotSize: 6,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      expect(containers.length, 3);
    });

    testWidgets('circle style: all dots are same size', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitPageIndicator(
            count: 3,
            currentIndex: 0,
            style: FitPageIndicatorStyle.circle,
            dotSize: 8,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();
      expect(containers.length, 3);
    });

    testWidgets('applies custom active and inactive colors', (tester) async {
      const activeColor = Colors.red;
      const inactiveColor = Colors.blue;

      await tester.pumpWidget(
        _buildApp(
          const FitPageIndicator(
            count: 2,
            currentIndex: 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();

      final activeDeco =
          containers[0].decoration! as BoxDecoration;
      final inactiveDeco =
          containers[1].decoration! as BoxDecoration;

      expect(activeDeco.color, activeColor);
      expect(inactiveDeco.color, inactiveColor);
    });
  });
}

Widget _buildApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}
