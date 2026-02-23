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
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) {
        Widget sheet = builder(sheetContext);

        if (!config.dismissOnBackKeyPress) {
          sheet = BackButtonListener(
            onBackButtonPressed: () async => true,
            child: sheet,
          );
        }

        return sheet;
      },
    );
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
      child: ChipAssets.icons.icXcircleFill24.svg(
        width: _kCloseButtonSize,
        height: _kCloseButtonSize,
      ),
    );
  }
}
