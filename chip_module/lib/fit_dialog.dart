import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _kDialogTransitionDuration = Duration(milliseconds: 300);
const _kDialogMaxHeightFactor = 0.82;
const _kDialogPadding = 20.0;
const _kDialogTitleSpacing = 8.0;
const _kDialogBodySpacing = 12.0;
const _kDialogActionsTopSpacing = 20.0;
const _kDialogActionSpacing = 8.0;
const _kDialogActionBorderRadius = 32.0;

/// 공통 다이얼로그 생성 유틸리티.
class FitDialog {
  static const double defaultMaxWidth = 420.0;

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
      request: _FitDialogRequest(
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
      ),
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
      request: _FitDialogRequest(
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
      ),
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
      request: _FitDialogRequest(
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
      ),
    );
  }

  static Future<T?> _showInternal<T>({
    required BuildContext context,
    required _FitDialogRequest request,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: _kDialogTransitionDuration,
      transitionBuilder: _slideTransition,
      pageBuilder: (context, animation, secondaryAnimation) =>
          _buildDialogPage(context, request),
    ).then((value) {
      request.onDismiss?.call();
      return value;
    });
  }

  static Widget _buildDialogPage(
    BuildContext context,
    _FitDialogRequest request,
  ) {
    return PopScope(
      canPop: request.dismissOnBackKeyPress,
      child: Stack(
        children: [
          if (request.dismissOnTouchOutside) _buildBarrierDismissLayer(context),
          Center(child: _buildDialogShell(context, request)),
        ],
      ),
    );
  }

  static Widget _buildBarrierDismissLayer(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: const SizedBox.expand(),
      ),
    );
  }

  static Widget _buildDialogShell(
    BuildContext context,
    _FitDialogRequest request,
  ) {
    return Dialog(
      backgroundColor:
          request.backgroundColor ?? context.fitColors.backgroundElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(request.borderRadius.r),
      ),
      child: ConstrainedBox(
        key: const ValueKey('fit_dialog_height_cap'),
        constraints: BoxConstraints(
          maxWidth: defaultMaxWidth,
          maxHeight:
              MediaQuery.of(context).size.height * _kDialogMaxHeightFactor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(_kDialogPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildScrollableContent(context, request),
              const SizedBox(height: _kDialogActionsTopSpacing),
              _buildButtons(context, request: request),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildScrollableContent(
    BuildContext context,
    _FitDialogRequest request,
  ) {
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildContentChildren(context, request),
        ),
      ),
    );
  }

  static List<Widget> _buildContentChildren(
    BuildContext context,
    _FitDialogRequest request,
  ) {
    final children = <Widget>[];

    if (request.topContent != null) {
      children.add(request.topContent!);
    }

    if (request.title != null) {
      children
        ..add(const SizedBox(height: _kDialogTitleSpacing))
        ..add(
          Text(
            request.title!,
            style:
                request.titleStyle ??
                context.h2().copyWith(color: context.fitColors.textPrimary),
            textAlign: TextAlign.center,
          ),
        );
    }

    if (request.subTitle != null) {
      children
        ..add(const SizedBox(height: _kDialogBodySpacing))
        ..add(
          Text(
            request.subTitle!,
            style:
                request.subTitleStyle ??
                context.body1().copyWith(color: context.fitColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        );
    }

    if (request.bottomContent != null) {
      children
        ..add(const SizedBox(height: _kDialogBodySpacing))
        ..add(request.bottomContent!);
    }

    return children;
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
        final phase = _transitionPhaseOf(animation.status);
        final metrics = _transitionMetricsFor(
          animationValue: animation.value,
          phase: phase,
        );

        return Transform.translate(
          offset: Offset(
            metrics.offset.dx * MediaQuery.of(context).size.width,
            metrics.offset.dy * MediaQuery.of(context).size.height,
          ),
          child: Opacity(
            opacity: metrics.opacity.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static _FitDialogTransitionPhase _transitionPhaseOf(AnimationStatus status) {
    if (status == AnimationStatus.reverse ||
        status == AnimationStatus.dismissed) {
      return _FitDialogTransitionPhase.dismissing;
    }
    return _FitDialogTransitionPhase.entering;
  }

  static _FitDialogTransitionMetrics _transitionMetricsFor({
    required double animationValue,
    required _FitDialogTransitionPhase phase,
  }) {
    if (phase == _FitDialogTransitionPhase.dismissing) {
      final curvedValue = Curves.easeInCubic.transform(1.0 - animationValue);
      return _FitDialogTransitionMetrics(
        offset: Offset(0, curvedValue * 0.5),
        opacity: animationValue,
      );
    }

    final curvedValue = Curves.easeOutCubic.transform(animationValue);
    return _FitDialogTransitionMetrics(
      offset: Offset(0, -0.3 + (curvedValue * 0.3)),
      opacity: animationValue,
    );
  }

  /// 버튼 영역 빌드
  static Widget _buildButtons(
    BuildContext context, {
    required _FitDialogRequest request,
  }) {
    final hasCancel = request.onCancel != null || request.cancelText != null;

    if (!hasCancel) {
      return _buildActionButton(
        context,
        type: request.confirmButtonType ?? FitButtonType.primary,
        label: request.confirmText ?? '확인',
        buttonColor: request.confirmButtonColor,
        textColor: request.confirmTextColor,
        onTapAfterClose: request.onConfirm,
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            type: request.cancelButtonType ?? FitButtonType.tertiary,
            label: request.cancelText ?? '취소',
            buttonColor: request.cancelButtonColor,
            textColor: request.cancelTextColor,
            onTapAfterClose: request.onCancel,
          ),
        ),
        const SizedBox(width: _kDialogActionSpacing),
        Expanded(
          child: _buildActionButton(
            context,
            type: request.confirmButtonType ?? FitButtonType.primary,
            label: request.confirmText ?? '확인',
            buttonColor: request.confirmButtonColor,
            textColor: request.confirmTextColor,
            onTapAfterClose: request.onConfirm,
          ),
        ),
      ],
    );
  }

  static Widget _buildActionButton(
    BuildContext context, {
    required FitButtonType type,
    required String label,
    VoidCallback? onTapAfterClose,
    Color? buttonColor,
    Color? textColor,
  }) {
    return FitButton(
      onPressed: () {
        Navigator.of(context).pop();
        onTapAfterClose?.call();
      },
      isExpanded: true,
      type: type,
      style: ButtonStyle(
        backgroundColor: buttonColor != null
            ? WidgetStatePropertyAll(buttonColor)
            : null,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_kDialogActionBorderRadius.r),
          ),
        ),
      ),
      child: Text(
        label,
        style: context.button1().copyWith(
          color:
              textColor ??
              FitButtonStyle.textColorOf(context, type, isEnabled: true),
        ),
      ),
    );
  }
}

@immutable
class _FitDialogRequest {
  const _FitDialogRequest({
    this.title,
    this.subTitle,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.onDismiss,
    this.dismissOnTouchOutside = false,
    this.dismissOnBackKeyPress = false,
    this.topContent,
    this.bottomContent,
    this.borderRadius = 32.0,
    this.backgroundColor,
    this.confirmButtonType,
    this.cancelButtonType,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.confirmTextColor,
    this.cancelTextColor,
    this.titleStyle,
    this.subTitleStyle,
  });

  final String? title;
  final String? subTitle;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onDismiss;
  final bool dismissOnTouchOutside;
  final bool dismissOnBackKeyPress;
  final Widget? topContent;
  final Widget? bottomContent;
  final double borderRadius;
  final Color? backgroundColor;
  final FitButtonType? confirmButtonType;
  final FitButtonType? cancelButtonType;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final Color? confirmTextColor;
  final Color? cancelTextColor;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
}

enum _FitDialogTransitionPhase { entering, dismissing }

@immutable
class _FitDialogTransitionMetrics {
  const _FitDialogTransitionMetrics({
    required this.offset,
    required this.opacity,
  });

  final Offset offset;
  final double opacity;
}
