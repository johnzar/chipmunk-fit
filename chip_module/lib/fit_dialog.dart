import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 공통 다이얼로그 생성 유틸리티.
class FitDialog {
  /// 범용 다이얼로그를 표시합니다.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? subTitle,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    VoidCallback? onDismiss,
    bool dismissOnTouchOutside = false,
    bool dismissOnBackKeyPress = false,
    Widget? topContent,
    Widget? bottomContent,
    double borderRadius = 32.0,
    Color? backgroundColor,
    FitButtonType? confirmButtonType,
    FitButtonType? cancelButtonType,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    Color? confirmTextColor,
    Color? cancelTextColor,
  }) {
    return _showInternal<T>(
      context: context,
      title: title,
      subTitle: subTitle,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      onDismiss: onDismiss,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      topContent: topContent,
      bottomContent: bottomContent,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      confirmButtonType: confirmButtonType,
      cancelButtonType: cancelButtonType,
      confirmButtonColor: confirmButtonColor,
      cancelButtonColor: cancelButtonColor,
      confirmTextColor: confirmTextColor,
      cancelTextColor: cancelTextColor,
    );
  }

  /// Deprecated: [show]를 사용하세요.
  @Deprecated('Use FitDialog.show')
  static Future<T?> showFitDialog<T>({
    required BuildContext context,
    String? title,
    String? subTitle,
    String? btnOkText,
    VoidCallback? btnOkPressed,
    VoidCallback? btnCancelPressed,
    VoidCallback? onDismiss,
    String? btnCancelText,
    Color? titleTextColor,
    Color? subTitleTextColor,
    bool dismissOnTouchOutside = false,
    bool dismissOnBackKeyPress = false,
    Widget? topContent,
    Widget? bottomContent,
    double borderRadius = 32.0,
    Color? dialogBackgroundColor,
    FitButtonType? okButtonType,
    FitButtonType? cancelButtonType,
    Color? btnOkColor,
    Color? btnCancelColor,
    Color? btnOkTextColor,
    Color? btnCancelTextColor,
  }) {
    return _showInternal<T>(
      context: context,
      title: title,
      subTitle: subTitle,
      confirmText: btnOkText,
      cancelText: btnCancelText,
      onConfirm: btnOkPressed,
      onCancel: btnCancelPressed,
      onDismiss: onDismiss,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      topContent: topContent,
      bottomContent: bottomContent,
      borderRadius: borderRadius,
      backgroundColor: dialogBackgroundColor,
      confirmButtonType: okButtonType,
      cancelButtonType: cancelButtonType,
      confirmButtonColor: btnOkColor,
      cancelButtonColor: btnCancelColor,
      confirmTextColor: btnOkTextColor,
      cancelTextColor: btnCancelTextColor,
      titleStyle: titleTextColor == null
          ? null
          : context.h2().copyWith(color: titleTextColor),
      subTitleStyle: subTitleTextColor == null
          ? null
          : context.body1().copyWith(color: subTitleTextColor),
    );
  }

  /// Deprecated: [show]를 사용하세요.
  @Deprecated('Use FitDialog.show')
  static Future<T?> showErrorDialog<T>({
    required BuildContext context,
    required String message,
    String? description,
    required VoidCallback onPress,
    VoidCallback? onDismiss,
    Color? dialogBackgroundColor,
    TextStyle? textStyle,
    Color? btnOkColor,
    Color? btnOkTextColor,
    String? btnOkText,
    double borderRadius = 32.0,
    bool dismissOnTouchOutside = false,
    bool dismissOnBackKeyPress = false,
  }) {
    return _showInternal<T>(
      context: context,
      subTitle: description?.isNotEmpty == true ? description! : message,
      confirmText: btnOkText,
      onConfirm: onPress,
      onDismiss: onDismiss,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      borderRadius: borderRadius,
      backgroundColor: dialogBackgroundColor,
      confirmButtonColor: btnOkColor,
      confirmTextColor: btnOkTextColor,
      subTitleStyle: textStyle,
    );
  }

  static Future<T?> _showInternal<T>({
    required BuildContext context,
    String? title,
    String? subTitle,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    VoidCallback? onDismiss,
    bool dismissOnTouchOutside = false,
    bool dismissOnBackKeyPress = false,
    Widget? topContent,
    Widget? bottomContent,
    double borderRadius = 32.0,
    Color? backgroundColor,
    FitButtonType? confirmButtonType,
    FitButtonType? cancelButtonType,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    Color? confirmTextColor,
    Color? cancelTextColor,
    TextStyle? titleStyle,
    TextStyle? subTitleStyle,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: _slideTransition,
      pageBuilder: (context, animation, secondaryAnimation) => PopScope(
        canPop: dismissOnBackKeyPress,
        child: Stack(
          children: [
            if (dismissOnTouchOutside)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox.expand(),
                ),
              ),
            Center(
              child: Dialog(
                backgroundColor:
                    backgroundColor ?? context.fitColors.backgroundElevated,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius.r),
                ),
                child: ConstrainedBox(
                  key: const ValueKey('fit_dialog_height_cap'),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.82,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (topContent != null) topContent,
                                if (title != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    title,
                                    style: titleStyle ??
                                        context.h2().copyWith(
                                              color:
                                                  context.fitColors.textPrimary,
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                if (subTitle != null) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    subTitle,
                                    style: subTitleStyle ??
                                        context.body1().copyWith(
                                              color: context
                                                  .fitColors.textSecondary,
                                            ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                if (bottomContent != null) ...[
                                  const SizedBox(height: 12),
                                  bottomContent,
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildButtons(
                          context,
                          onConfirm: onConfirm,
                          onCancel: onCancel,
                          confirmText: confirmText,
                          cancelText: cancelText,
                          confirmButtonType: confirmButtonType,
                          cancelButtonType: cancelButtonType,
                          confirmButtonColor: confirmButtonColor,
                          cancelButtonColor: cancelButtonColor,
                          confirmTextColor: confirmTextColor,
                          cancelTextColor: cancelTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((value) {
      onDismiss?.call();
      return value;
    });
  }

  /// 슬라이드 트랜지션 (위에서 아래로 나타나고, 아래로 사라지는 애니메이션)
  static Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final isDismissing = animation.status == AnimationStatus.reverse ||
            animation.status == AnimationStatus.dismissed;

        late final Offset offset;
        late final double opacity;

        if (isDismissing) {
          // 사라질 때: 중앙(0) → 아래(0.5)
          // animation.value: 1 → 0
          final curvedValue =
              Curves.easeInCubic.transform(1.0 - animation.value);
          offset = Offset(0, curvedValue * 0.5);
          opacity = animation.value;
        } else {
          // 나타날 때: 위(-0.3) → 중앙(0)
          // animation.value: 0 → 1
          final curvedValue = Curves.easeOutCubic.transform(animation.value);
          offset = Offset(0, -0.3 + (curvedValue * 0.3));
          opacity = animation.value;
        }

        return Transform.translate(
          offset: Offset(
            offset.dx * MediaQuery.of(context).size.width,
            offset.dy * MediaQuery.of(context).size.height,
          ),
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// 버튼 영역 빌드
  static Widget _buildButtons(
    BuildContext context, {
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? confirmText,
    String? cancelText,
    FitButtonType? confirmButtonType,
    FitButtonType? cancelButtonType,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    Color? confirmTextColor,
    Color? cancelTextColor,
  }) {
    final hasCancel = onCancel != null || cancelText != null;

    if (!hasCancel) {
      // 확인 버튼만
      return FitButton(
        onPressed: () {
          Navigator.of(context).pop();
          onConfirm?.call();
        },
        isExpanded: true,
        type: confirmButtonType ?? FitButtonType.primary,
        style: confirmButtonColor != null
            ? FitButtonStyle.styleFrom(backgroundColor: confirmButtonColor)
            : null,
        child: Text(
          confirmText ?? '확인',
          style: context.button1().copyWith(
                color: confirmTextColor ??
                    FitButtonStyle.textColorOf(
                      context,
                      confirmButtonType ?? FitButtonType.primary,
                      isEnabled: true,
                    ),
              ),
        ),
      );
    }

    // 확인 + 취소 버튼
    return Row(
      children: [
        Expanded(
          child: FitButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            isExpanded: true,
            type: cancelButtonType ?? FitButtonType.tertiary,
            style: cancelButtonColor != null
                ? FitButtonStyle.styleFrom(backgroundColor: cancelButtonColor)
                : null,
            child: Text(
              cancelText ?? '취소',
              style: context.button1().copyWith(
                    color: cancelTextColor ??
                        FitButtonStyle.textColorOf(
                          context,
                          cancelButtonType ?? FitButtonType.tertiary,
                          isEnabled: true,
                        ),
                  ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FitButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            isExpanded: true,
            type: confirmButtonType ?? FitButtonType.primary,
            style: confirmButtonColor != null
                ? FitButtonStyle.styleFrom(backgroundColor: confirmButtonColor)
                : null,
            child: Text(
              confirmText ?? '확인',
              style: context.button1().copyWith(
                    color: confirmTextColor ??
                        FitButtonStyle.textColorOf(
                          context,
                          confirmButtonType ?? FitButtonType.primary,
                          isEnabled: true,
                        ),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
