import 'dart:math' as math;

import 'package:chip_assets/gen/assets.gen.dart';
import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'fit_bottom_sheet_config.dart';
part 'fit_bottom_sheet_sheet.dart';

/// 단일 정책 기반 BottomSheet 유틸리티입니다.
///
/// 정책:
/// - [show] 단일 API 제공
/// - wrap-content로 시작하고, 최대 높이는 status bar 아래로 제한
/// - 콘텐츠가 최대 높이를 초과하면 body만 스크롤
/// - SafeArea(top/bottom)와 키보드 inset 기본 지원
/// - `enableSnap`이 true면 접힘/펼침 snap + 접힌 상태에서 아래 드래그 시 닫기 지원
class FitBottomSheet {
  FitBottomSheet._();

  static const _kBorderRadius = 32.0;
  static const _kTopBarHeight = 8.0;
  static const _kTopBarSpacing = 20.0;
  static const _kDragHandleWidth = 40.0;
  static const _kDragHandleHeight = 4.0;
  static const _kCloseButtonSize = 28.0;

  /// 기본 BottomSheet를 표시합니다.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget Function(BuildContext bottomSheetContext) content,
    FitBottomSheetConfig config = const FitBottomSheetConfig(),
    VoidCallback? onClosed,
  }) async {
    final result = await _showBase<T>(
      context: context,
      config: config,
      builder: (ctx) => _FitSingleBottomSheet(
        config: config,
        contentBuilder: content,
      ),
    );

    onClosed?.call();
    return result;
  }

  static Future<T?> _showBase<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    required FitBottomSheetConfig config,
  }) {
    final navigator = Navigator.of(context);
    final navigatorContext = navigator.context;
    final localizations = MaterialLocalizations.of(context);
    // showModalBottomSheet는 InheritedTheme.capture()로 호출 시점의 테마를
    // 스냅샷하여, 이후 다크모드 전환 등 테마 변경이 반영되지 않습니다.
    // ModalBottomSheetRoute를 직접 사용하고 capturedThemes를 전달하지 않아
    // 라이브 테마를 상속받도록 합니다.
    // 추가로 _ThemeTrackingWrapper가 Navigator context에서 라이브 테마를
    // 읽어 바텀시트에 명시적으로 전달합니다.
    return navigator.push(ModalBottomSheetRoute<T>(
      builder: (sheetContext) {
        Widget sheet = builder(sheetContext);

        if (!config.dismissOnBackKeyPress) {
          sheet = BackButtonListener(
            onBackButtonPressed: () async => true,
            child: sheet,
          );
        }

        return _ThemeTrackingWrapper(
          navigatorContext: navigatorContext,
          child: sheet,
        );
      },
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      barrierLabel: localizations.scrimLabel,
    ));
  }

  static BoxDecoration buildDecoration(
    BuildContext context,
    Color? backgroundColor,
  ) {
    return BoxDecoration(
      color: backgroundColor ?? context.fitColors.backgroundElevated,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_kBorderRadius.r),
        topRight: Radius.circular(_kBorderRadius.r),
      ),
    );
  }

  static Widget buildTopBar(
    BuildContext context, {
    Key? handleKey,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: _kTopBarHeight),
        Center(
          child: Container(
            key: handleKey,
            width: _kDragHandleWidth,
            height: _kDragHandleHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: context.fitColors.fillEmphasize,
            ),
          ),
        ),
        SizedBox(height: _kTopBarSpacing),
      ],
    );
  }

  static Widget buildCloseButton(
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Bounceable(
      onTap: onTap ?? () => Navigator.pop(context),
      child: ChipAssets.icons.icCloseCircle24.svg(
        width: _kCloseButtonSize,
        height: _kCloseButtonSize,
      ),
    );
  }
}

/// Navigator의 context에서 라이브 테마를 읽어 하위 위젯에 전달하는 래퍼.
///
/// overlay 안의 바텀시트가 테마 변경 InheritedWidget 알림을
/// 안정적으로 수신하지 못하는 경우를 대비하여,
/// Navigator 위의 Theme에서 직접 읽어 적용합니다.
class _ThemeTrackingWrapper extends StatefulWidget {
  const _ThemeTrackingWrapper({
    required this.navigatorContext,
    required this.child,
  });

  final BuildContext navigatorContext;
  final Widget child;

  @override
  State<_ThemeTrackingWrapper> createState() => _ThemeTrackingWrapperState();
}

class _ThemeTrackingWrapperState extends State<_ThemeTrackingWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
    // AnimatedTheme 애니메이션 완료 후 최종 테마로 한번 더 rebuild
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // overlay 경유 InheritedWidget 전파가 정상이면
    // AnimatedTheme 갱신 시 자동 rebuild 됩니다.
    Theme.of(context);

    final liveTheme = Theme.of(widget.navigatorContext);
    return Theme(data: liveTheme, child: widget.child);
  }
}
