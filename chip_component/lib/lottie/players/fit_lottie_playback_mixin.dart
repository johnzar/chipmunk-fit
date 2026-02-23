import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Asset/File 플레이어에서 공통으로 사용하는 재생 상태 믹스인입니다.
///
/// composition 로드 이후 duration을 동기화하고, `animate/repeat` 정책을
/// 일관되게 적용합니다.
mixin FitLottiePlaybackMixin<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late final AnimationController _internalController;
  LottieComposition? _composition;
  bool _disposed = false;

  AnimationController? get externalController;
  bool get animate;
  bool get repeat;

  /// 외부에서 주입한 컨트롤러가 있으면 우선 사용합니다.
  AnimationController get effectiveController =>
      externalController ?? _internalController;

  /// State 초기화 시 내부 컨트롤러를 생성합니다.
  @mustCallSuper
  void initPlaybackController() {
    _internalController = AnimationController(vsync: this);
  }

  /// dispose 시 내부 상태를 종료합니다.
  @mustCallSuper
  void disposePlaybackController() {
    _disposed = true;
    _internalController.dispose();
  }

  /// Lottie composition 로드 시 duration 동기화 후 재생 정책을 적용합니다.
  @protected
  void configureComposition(LottieComposition? composition) {
    if (_disposed || composition == null) return;

    _composition = composition;
    final duration = composition.duration;
    if (duration.inMilliseconds <= 0) return;

    effectiveController.duration = duration;
    applyPlaybackSettings();
  }

  /// 현재 animate/repeat 설정에 맞춰 컨트롤러 상태를 갱신합니다.
  @protected
  void applyPlaybackSettings() {
    if (_disposed || _composition == null) return;

    final controller = effectiveController;
    final duration = _composition!.duration;
    if (duration.inMilliseconds <= 0) return;
    controller.duration = duration;

    controller.stop();
    controller.reset();

    if (!animate) return;
    if (repeat) {
      controller.repeat();
    } else {
      controller.forward();
    }
  }
}
