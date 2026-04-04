import 'package:chip_foundation/colors.dart';
import 'package:chip_module/fit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitDialog', () {
    testWidgets('confirm only: confirm callback and dialog close',
        (tester) async {
      var confirmed = false;

      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.show(
            context: context,
            title: 'Confirm Only',
            subTitle: 'subtitle',
            confirmText: '확인',
            onConfirm: () => confirmed = true,
          );
        }),
      );

      await _openDialog(tester);
      expect(find.text('Confirm Only'), findsOneWidget);

      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
      expect(find.text('Confirm Only'), findsNothing);
    });

    testWidgets('confirm + cancel: each callback works and closes',
        (tester) async {
      var confirmCount = 0;
      var cancelCount = 0;

      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.show(
            context: context,
            title: 'Confirm Cancel',
            confirmText: '예',
            cancelText: '아니오',
            onConfirm: () => confirmCount++,
            onCancel: () => cancelCount++,
          );
        }),
      );

      await _openDialog(tester);
      await tester.tap(find.text('아니오'));
      await tester.pumpAndSettle();

      expect(cancelCount, 1);
      expect(confirmCount, 0);
      expect(find.text('Confirm Cancel'), findsNothing);

      await _openDialog(tester);
      await tester.tap(find.text('예'));
      await tester.pumpAndSettle();

      expect(cancelCount, 1);
      expect(confirmCount, 1);
      expect(find.text('Confirm Cancel'), findsNothing);
    });

    testWidgets('dismissOnTouchOutside true closes and false keeps open',
        (tester) async {
      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.show(
            context: context,
            title: 'Dismiss True',
            dismissOnTouchOutside: true,
          );
        }),
      );

      await _openDialog(tester);
      expect(find.text('Dismiss True'), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();
      expect(find.text('Dismiss True'), findsNothing);

      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.show(
            context: context,
            title: 'Dismiss False',
            dismissOnTouchOutside: false,
          );
        }),
      );

      await _openDialog(tester);
      expect(find.text('Dismiss False'), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();
      expect(find.text('Dismiss False'), findsOneWidget);
    });

    testWidgets(
        'outside dismiss can stay enabled while back dismiss is blocked',
        (tester) async {
      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.show(
            context: context,
            title: 'Outside Only',
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: false,
          );
        }),
      );

      await _openDialog(tester);
      expect(find.text('Outside Only'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Outside Only'), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();
      expect(find.text('Outside Only'), findsNothing);
    });

    testWidgets('showFitDialog wrapper maps to show behavior', (tester) async {
      var confirmCount = 0;
      var cancelCount = 0;

      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.showFitDialog(
            context: context,
            title: 'Wrapper Dialog',
            subTitle: 'wrapper subtitle',
            btnOkText: '확인',
            btnCancelText: '취소',
            btnOkPressed: () => confirmCount++,
            btnCancelPressed: () => cancelCount++,
          );
        }),
      );

      await _openDialog(tester);
      expect(find.text('Wrapper Dialog'), findsOneWidget);

      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();
      expect(cancelCount, 1);

      await _openDialog(tester);
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();
      expect(confirmCount, 1);
    });

    testWidgets('showErrorDialog wrapper shows message and confirm callback',
        (tester) async {
      var confirmCount = 0;

      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.showErrorDialog(
            context: context,
            message: 'error message',
            description: 'error description',
            btnOkText: '닫기',
            onPress: () => confirmCount++,
          );
        }),
      );

      await _openDialog(tester);
      expect(find.text('error description'), findsOneWidget);

      await tester.tap(find.text('닫기'));
      await tester.pumpAndSettle();

      expect(confirmCount, 1);
      expect(find.text('error description'), findsNothing);
    });

    testWidgets('onDismiss is called once per route close', (tester) async {
      var dismissCount = 0;

      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.show(
            context: context,
            title: 'Dismiss Count',
            confirmText: '확인',
            onDismiss: () => dismissCount++,
          );
        }),
      );

      await _openDialog(tester);
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      expect(dismissCount, 1);
      expect(find.text('Dismiss Count'), findsNothing);
    });

    testWidgets('long content is constrained and scrollable', (tester) async {
      final longText = List.generate(120, (i) => 'line $i').join(' ');

      await tester.pumpWidget(
        _buildHarness((context) {
          FitDialog.show(
            context: context,
            title: 'Long Content',
            subTitle: longText,
            bottomContent: Text(longText),
          );
        }),
      );

      await _openDialog(tester);

      final scaffoldContext = tester.element(find.byType(Scaffold).first);
      final screenHeight = MediaQuery.of(scaffoldContext).size.height;
      final cappedRect =
          tester.getRect(find.byKey(const ValueKey('fit_dialog_height_cap')));

      expect(cappedRect.height, lessThanOrEqualTo(screenHeight * 0.82 + 1));
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

const _openDialogKey = Key('open_dialog_button');

Future<void> _openDialog(WidgetTester tester) async {
  await tester.tap(find.byKey(_openDialogKey));
  await tester.pumpAndSettle();
}

Widget _buildHarness(void Function(BuildContext context) onOpen) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, __) => MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        extensions: [lightFitColors],
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                key: _openDialogKey,
                onPressed: () => onOpen(context),
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    ),
  );
}
