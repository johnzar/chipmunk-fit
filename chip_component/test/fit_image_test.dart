import 'package:chip_component/image/fit_cached_network_Image.dart';
import 'package:chip_component/image/fit_image.dart';
import 'package:chip_component/image/fit_image_shape.dart';
import 'package:chip_component/image/fit_local_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitImage compatibility', () {
    testWidgets('FitCachedNetworkImage delegates to FitImage.network',
        (tester) async {
      const placeholderKey = Key('placeholder');
      const errorKey = Key('error');

      await tester.pumpWidget(
        _buildApp(
          const FitCachedNetworkImage(
            imageUrl: 'https://example.com/image.png',
            width: 120,
            height: 80,
            fit: BoxFit.contain,
            imageShape: FitImageShape.CIRCLE,
            borderWidth: 3,
            borderColor: Colors.blue,
            fadeInDuration: Duration(milliseconds: 500),
            placeholder: SizedBox(key: placeholderKey),
            errorWidget: SizedBox(key: errorKey),
            memCacheWidth: 100,
            memCacheHeight: 90,
          ),
        ),
      );

      final fitImage = tester.widget<FitImage>(find.byType(FitImage));
      expect(fitImage.width, 120);
      expect(fitImage.height, 80);
      expect(fitImage.fit, BoxFit.contain);
      expect(fitImage.imageShape, FitImageShape.CIRCLE);
      expect(fitImage.borderWidth, 3);
      expect(fitImage.borderColor, Colors.blue);
      expect(fitImage.fadeInDuration, const Duration(milliseconds: 500));
      expect(fitImage.placeholder, isA<SizedBox>());
      expect(fitImage.errorWidget, isA<SizedBox>());
      expect(fitImage.memCacheWidth, 100);
      expect(fitImage.memCacheHeight, 90);
    });

    testWidgets('FitLocalImage delegates to FitImage.file with NONE shape',
        (tester) async {
      const errorKey = Key('local-error');

      await tester.pumpWidget(
        _buildApp(
          const FitLocalImage(
            filePath: '/tmp/does-not-exist.png',
            width: 100,
            height: 70,
            fit: BoxFit.fitWidth,
            errorWidget: SizedBox(key: errorKey),
          ),
        ),
      );

      final fitImage = tester.widget<FitImage>(find.byType(FitImage));
      expect(fitImage.width, 100);
      expect(fitImage.height, 70);
      expect(fitImage.fit, BoxFit.fitWidth);
      expect(fitImage.imageShape, FitImageShape.NONE);
    });
  });

  group('FitImage behavior', () {
    testWidgets('network returns provided error widget when URL is empty',
        (tester) async {
      const errorKey = Key('network-error');

      await tester.pumpWidget(
        _buildApp(
          const FitImage.network(
            imageUrl: '',
            errorWidget: SizedBox(key: errorKey),
          ),
        ),
      );

      expect(find.byKey(errorKey), findsOneWidget);
    });

    testWidgets('asset returns provided error widget when asset path is empty',
        (tester) async {
      const errorKey = Key('asset-error');

      await tester.pumpWidget(
        _buildApp(
          const FitImage.asset(
            assetPath: '',
            errorWidget: SizedBox(key: errorKey),
          ),
        ),
      );

      expect(find.byKey(errorKey), findsOneWidget);
    });

    testWidgets('file returns provided error widget when file path is empty',
        (tester) async {
      const errorKey = Key('file-error');

      await tester.pumpWidget(
        _buildApp(
          const FitImage.file(
            filePath: '',
            errorWidget: SizedBox(key: errorKey),
          ),
        ),
      );

      expect(find.byKey(errorKey), findsOneWidget);
    });

    testWidgets('circle shape wraps child with ClipOval', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitImage.file(
            filePath: '/tmp/not-found.png',
            imageShape: FitImageShape.CIRCLE,
          ),
        ),
      );

      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('squircle shape wraps child with ClipPath', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          const FitImage.file(
            filePath: '/tmp/not-found.png',
            imageShape: FitImageShape.SQUIRCLE,
          ),
        ),
      );

      expect(find.byType(ClipPath), findsOneWidget);
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
