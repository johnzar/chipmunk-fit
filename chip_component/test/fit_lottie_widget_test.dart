import 'package:chip_assets/gen/assets.gen.dart';
import 'package:chip_component/lottie/fit_lottie_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitLottieWidget', () {
    testWidgets('network shows placeholder while loading', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitLottieWidget.network(
            url:
                'https://bitbucket.org/electlink/design-system/raw/main/fit_assets/lottie/loading.lottie',
            placeholder: Text('loading'),
          ),
        ),
      );

      expect(find.text('loading'), findsOneWidget);
    });

    testWidgets('network invalid url shows errorWidget', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitLottieWidget.network(
            url: 'invalid-url',
            errorWidget: Text('network-error'),
          ),
        ),
      );

      expect(find.text('network-error'), findsOneWidget);
    });

    testWidgets('file with missing path shows errorWidget', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitLottieWidget.file(
            filePath: '/tmp/not_exists_fit_lottie_file.lottie',
            errorWidget: Text('missing-file'),
          ),
        ),
      );

      expect(find.text('missing-file'), findsOneWidget);
    });

    testWidgets('asset animate/repeat updates without exceptions',
        (tester) async {
      var animate = true;
      var repeat = true;
      late StateSetter update;

      await tester.pumpWidget(
        _buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return FitLottieWidget.asset(
                assetPath: ChipAssets.lottie.loading.keyName,
                animate: animate,
                repeat: repeat,
              );
            },
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      update(() => animate = false);
      await tester.pump(const Duration(milliseconds: 16));
      update(() => repeat = false);
      await tester.pump(const Duration(milliseconds: 16));

      expect(tester.takeException(), isNull);
    });

    testWidgets('file animate/repeat updates without exceptions',
        (tester) async {
      var animate = true;
      var repeat = true;
      late StateSetter update;

      await tester.pumpWidget(
        _buildApp(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return FitLottieWidget.file(
                filePath:
                    '/tmp/not_exists_fit_lottie_file_for_update_test.lottie',
                animate: animate,
                repeat: repeat,
              );
            },
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      update(() => animate = false);
      await tester.pump(const Duration(milliseconds: 16));
      update(() => repeat = false);
      await tester.pump(const Duration(milliseconds: 16));

      expect(tester.takeException(), isNull);
    });

    testWidgets('external controller is not disposed by widget',
        (tester) async {
      final controller = AnimationController(vsync: tester);

      await tester.pumpWidget(
        _buildApp(
          FitLottieWidget.asset(
            assetPath: ChipAssets.lottie.dotLoading.keyName,
            controller: controller,
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      expect(() => controller.dispose(), returnsNormally);
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
