import 'dart:io';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';

import 'fit_lottie_renderer.dart';
import 'fit_lottie_playback_mixin.dart';

/// 로컬 파일 Lottie 플레이어
/// - 캐시된 파일 또는 로컬 파일 재생
/// - 내부 또는 외부 컨트롤러 지원
class FitFileLottiePlayer extends StatefulWidget {
  final String filePath;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final BoxFit fit;
  final bool repeat;
  final bool animate;
  final AnimationController? controller;

  const FitFileLottiePlayer({
    super.key,
    required this.filePath,
    this.width,
    this.height,
    this.errorWidget,
    required this.fit,
    required this.repeat,
    required this.animate,
    this.controller,
  });

  @override
  State<FitFileLottiePlayer> createState() => _FitFileLottiePlayerState();
}

class _FitFileLottiePlayerState extends State<FitFileLottiePlayer>
    with
        SingleTickerProviderStateMixin,
        FitLottiePlaybackMixin<FitFileLottiePlayer> {
  @override
  AnimationController? get externalController => widget.controller;

  @override
  bool get animate => widget.animate;

  @override
  bool get repeat => widget.repeat;

  @override
  void initState() {
    super.initState();
    initPlaybackController();
  }

  @override
  void didUpdateWidget(FitFileLottiePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // animate/repeat/controller 변경 시 현재 composition 기준으로 동기화.
    if (oldWidget.animate != widget.animate ||
        oldWidget.repeat != widget.repeat ||
        oldWidget.controller != widget.controller) {
      applyPlaybackSettings();
    }
  }

  @override
  void dispose() {
    disposePlaybackController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final file = File(widget.filePath);

    // 파일 존재 확인
    if (!file.existsSync()) {
      return widget.errorWidget ?? const SizedBox.shrink();
    }

    return DotLottieLoader.fromFile(
      file,
      frameBuilder: (context, dotLottie) {
        // 로딩 중 (dotLottie이 아직 null)
        if (dotLottie == null) {
          return const SizedBox.shrink(); // 로딩 중에는 빈 공간
        }

        // 애니메이션이 없는 경우 (실제 에러)
        if (dotLottie.animations.isEmpty) {
          return widget.errorWidget ?? const SizedBox.shrink();
        }

        return FitLottieRenderer(
          animationBytes: dotLottie.animations.values.first,
          controller: effectiveController,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorWidget: widget.errorWidget,
          onCompositionLoaded: configureComposition,
        );
      },
      errorBuilder: (_, __, ___) =>
          widget.errorWidget ?? const SizedBox.shrink(),
    );
  }
}
