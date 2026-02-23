import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Lottie Composition 렌더러
/// - 모든 플레이어에서 공유하는 렌더링 로직
/// - LottieComposition 파싱 및 에러 처리
class FitLottieRenderer extends StatefulWidget {
  final Uint8List animationBytes;
  final AnimationController controller;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;
  final ValueChanged<LottieComposition?>? onCompositionLoaded;

  const FitLottieRenderer({
    super.key,
    required this.animationBytes,
    required this.controller,
    this.width,
    this.height,
    required this.fit,
    this.errorWidget,
    this.onCompositionLoaded,
  });

  @override
  State<FitLottieRenderer> createState() => _FitLottieRendererState();
}

class _FitLottieRendererState extends State<FitLottieRenderer> {
  late Future<LottieComposition> _compositionFuture;
  LottieComposition? _notifiedComposition;

  @override
  void initState() {
    super.initState();
    _compositionFuture = _parseComposition();
  }

  @override
  void didUpdateWidget(FitLottieRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animationBytes != oldWidget.animationBytes) {
      _compositionFuture = _parseComposition();
      _notifiedComposition = null;
    }
  }

  Future<LottieComposition> _parseComposition() {
    return LottieComposition.fromBytes(widget.animationBytes);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LottieComposition>(
      future: _compositionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return widget.errorWidget ?? const SizedBox.shrink();
        }

        final composition = snapshot.data!;
        if (_notifiedComposition != composition) {
          _notifiedComposition = composition;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onCompositionLoaded?.call(composition);
            }
          });
        }

        return Lottie(
          composition: composition,
          controller: widget.controller,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
    );
  }
}
