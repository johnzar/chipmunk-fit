import 'dart:math' as math;

import 'package:chip_component/button/fit_animated_bottom_button.dart';
import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_module/bottomsheet/fit_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitBottomSheet', () {
    testWidgets('closes sheet on dim tap when dismissOnBarrierTap is true',
        (tester) async {
      await tester.pumpWidget(
        _buildHarness(
          config: const FitBottomSheetConfig(
            isDismissible: false,
            dismissOnBarrierTap: true,
            enableSnap: true,
          ),
        ),
      );

      await _openSheet(tester);
      expect(find.text('Test Sheet'), findsOneWidget);

      final surfaceRect = tester.getRect(_sheetSurfaceFinder());
      final hasDismissArea = surfaceRect.top > 1;
      final tapOffset =
          Offset(surfaceRect.left + 2, math.max(1.0, surfaceRect.top - 16));
      await tester.tapAt(tapOffset);
      await tester.pumpAndSettle();
      expect(
        find.text('Test Sheet'),
        hasDismissArea ? findsNothing : findsOneWidget,
      );
    });

    testWidgets('keeps sheet open on dim tap when dismissOnBarrierTap is false',
        (tester) async {
      await tester.pumpWidget(
        _buildHarness(
          config: const FitBottomSheetConfig(
            isDismissible: true,
            dismissOnBarrierTap: false,
            enableSnap: true,
          ),
        ),
      );

      await _openSheet(tester);
      expect(find.text('Test Sheet'), findsOneWidget);

      final surfaceRect = tester.getRect(_sheetSurfaceFinder());
      final tapOffset =
          Offset(surfaceRect.left + 2, math.max(1.0, surfaceRect.top - 16));
      await tester.tapAt(tapOffset);
      await tester.pumpAndSettle();
      expect(find.text('Test Sheet'), findsOneWidget);
    });

    testWidgets('uses single spacing before FitAnimatedBottomButton',
        (tester) async {
      await tester.pumpWidget(
        _buildHarness(
          config: const FitBottomSheetConfig(),
          contentBuilder: (sheetContext) => _KeyboardLikeContent(
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        ),
      );

      await _openSheet(tester);

      final textFieldRect = tester.getRect(find.byKey(_textFieldKey));
      final buttonRect = tester.getRect(find.widgetWithText(FitButton, '닫기'));
      final verticalGap = buttonRect.top - textFieldRect.bottom;

      expect(verticalGap, closeTo(12.h, 0.6));
    });

    testWidgets('keeps TextField state when keyboard inset changes',
        (tester) async {
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(
        _buildHarness(
          config: const FitBottomSheetConfig(enableSnap: true),
          contentBuilder: (sheetContext) => _KeyboardLikeContent(
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        ),
      );

      await _openSheet(tester);
      await tester.enterText(find.byKey(_textFieldKey), 'abc');
      expect(find.text('abc'), findsOneWidget);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();

      expect(find.text('abc'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('restores bottom safe-area after keyboard hides',
        (tester) async {
      tester.view.padding = const FakeViewPadding(bottom: 34);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(
        _buildHarness(
          config: const FitBottomSheetConfig(enableSnap: true),
          contentBuilder: (sheetContext) => _KeyboardLikeContent(
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        ),
      );

      await _openSheet(tester);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();

      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.pumpAndSettle();

      final sheetRect = tester.getRect(_sheetSurfaceFinder());
      final buttonRect = tester.getRect(find.widgetWithText(FitButton, '닫기'));
      final gap = sheetRect.bottom - buttonRect.bottom;
      final sheetContext = tester.element(find.byType(BottomSheet));
      final expectedSafeBottom = MediaQuery.of(sheetContext).padding.bottom;

      expect(gap, closeTo(expectedSafeBottom, 0.6));
    });

    testWidgets('dim tap hides keyboard first when keyboard is visible',
        (tester) async {
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(
        _buildHarness(
          config: const FitBottomSheetConfig(
            dismissOnBarrierTap: true,
            enableSnap: true,
          ),
          contentBuilder: (sheetContext) => _KeyboardLikeContent(
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        ),
      );

      await _openSheet(tester);
      await tester.tap(find.byKey(_textFieldKey));
      await tester.pump();

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();

      final surfaceRect = tester.getRect(_sheetSurfaceFinder());
      final tapOffset =
          Offset(surfaceRect.left + 2, math.max(1.0, surfaceRect.top - 16));
      await tester.tapAt(tapOffset);
      await tester.pumpAndSettle();

      expect(find.text('Test Sheet'), findsOneWidget);
    });

    testWidgets('drags down from body to close when body is not scrollable',
        (tester) async {
      await tester.pumpWidget(
        _buildHarness(
          config: const FitBottomSheetConfig(
            isDismissible: true,
            enableSnap: true,
          ),
        ),
      );

      await _openSheet(tester);
      expect(find.text('Test Sheet'), findsOneWidget);

      await tester.drag(find.text('Barrier tap scenario'), const Offset(0, 80));
      await tester.pumpAndSettle();

      expect(find.text('Test Sheet'), findsNothing);
    });

    testWidgets('collapses animated button radius with multiple text fields',
        (tester) async {
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(
        _buildHarness(
          config: const FitBottomSheetConfig(enableSnap: true),
          contentBuilder: (sheetContext) => _MultipleFieldSheetContent(
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        ),
      );

      await _openSheet(tester);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();

      final fitButton = tester.widget<FitButton>(find.byType(FitButton).last);
      final shape = fitButton.style?.shape?.resolve(<WidgetState>{});
      expect(shape, isA<RoundedRectangleBorder>());
      final border = shape! as RoundedRectangleBorder;
      final radius = border.borderRadius.resolve(TextDirection.ltr);
      expect(radius.topLeft.x, 0);
      expect(radius.topRight.x, 0);
      expect(radius.bottomLeft.x, 0);
      expect(radius.bottomRight.x, 0);
    });
  });
}

const _openButtonKey = Key('open_bottom_sheet');
const _textFieldKey = Key('sheet_text_field');

Future<void> _openSheet(WidgetTester tester) async {
  await tester.tap(find.byKey(_openButtonKey));
  await tester.pumpAndSettle();
}

Finder _sheetSurfaceFinder() {
  return find.byWidgetPredicate((widget) {
    if (widget is! Container || widget.decoration is! BoxDecoration) {
      return false;
    }

    final decoration = widget.decoration! as BoxDecoration;
    final borderRadius = decoration.borderRadius;
    if (borderRadius is! BorderRadius) return false;

    return borderRadius.topLeft.x > 0 &&
        borderRadius.topRight.x > 0 &&
        borderRadius.bottomLeft == Radius.zero &&
        borderRadius.bottomRight == Radius.zero;
  });
}

Widget _buildHarness({
  required FitBottomSheetConfig config,
  Widget Function(BuildContext sheetContext)? contentBuilder,
}) {
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
                key: _openButtonKey,
                onPressed: () {
                  FitBottomSheet.show(
                    context,
                    config: config,
                    content: contentBuilder ??
                        (sheetContext) => _BasicSheetContent(
                              onClose: () => Navigator.of(sheetContext).pop(),
                            ),
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _BasicSheetContent extends StatelessWidget {
  const _BasicSheetContent({
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Test Sheet'),
              const SizedBox(height: 8),
              const Text('Barrier tap scenario'),
            ],
          ),
        ),
        FitAnimatedBottomButton(
          useSafeArea: false,
          onPressed: onClose,
          child: const Text('닫기'),
        ),
      ],
    );
  }
}

class _KeyboardLikeContent extends StatefulWidget {
  const _KeyboardLikeContent({
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  State<_KeyboardLikeContent> createState() => _KeyboardLikeContentState();
}

class _KeyboardLikeContentState extends State<_KeyboardLikeContent> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Test Sheet'),
              const SizedBox(height: 12),
              TextField(
                key: _textFieldKey,
                controller: _controller,
              ),
            ],
          ),
        ),
        FitAnimatedBottomButton(
          useSafeArea: false,
          onPressed: widget.onClose,
          child: const Text('닫기'),
        ),
      ],
    );
  }
}

class _MultipleFieldSheetContent extends StatelessWidget
    implements FitBottomSheetSelfManagedBody {
  const _MultipleFieldSheetContent({
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Multiple'),
              SizedBox(height: 12),
              TextField(),
              SizedBox(height: 12),
              TextField(),
              SizedBox(height: 12),
              TextField(maxLines: 3),
            ],
          ),
        ),
        FitAnimatedBottomButton(
          useSafeArea: false,
          onPressed: onClose,
          child: const Text('제출'),
        ),
      ],
    );
  }
}
