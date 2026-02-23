import 'dart:io';

import 'package:chip_core/fit_cache_helper.dart';
import 'package:flutter/material.dart';

import 'fit_file_lottie_player.dart';

/// 네트워크 Lottie 플레이어입니다.
///
/// URL 유효성을 먼저 검사하고, 다운로드/캐시 성공 시 파일 플레이어로 위임합니다.
class FitNetworkLottiePlayer extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit fit;
  final bool repeat;
  final bool animate;
  final AnimationController? controller;

  const FitNetworkLottiePlayer({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    required this.fit,
    required this.repeat,
    required this.animate,
    this.controller,
  });

  @override
  State<FitNetworkLottiePlayer> createState() => _FitNetworkLottiePlayerState();
}

class _FitNetworkLottiePlayerState extends State<FitNetworkLottiePlayer> {
  late Future<File?> _cachedFileFuture;

  @override
  void initState() {
    super.initState();
    _cachedFileFuture = _downloadAndCache(widget.url);
  }

  @override
  void didUpdateWidget(covariant FitNetworkLottiePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _cachedFileFuture = _downloadAndCache(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidNetworkUrl(widget.url)) {
      return errorWidget ?? _buildFallbackBox();
    }

    return FutureBuilder<File?>(
      future: _cachedFileFuture,
      builder: (context, snapshot) {
        // 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ?? _buildFallbackBox();
        }

        // 에러 또는 파일 없음
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return errorWidget ?? _buildFallbackBox();
        }

        // 캐시된 파일로 재생
        return FitFileLottiePlayer(
          filePath: snapshot.data!.path,
          width: widget.width,
          height: widget.height,
          errorWidget: errorWidget,
          fit: widget.fit,
          repeat: widget.repeat,
          animate: widget.animate,
          controller: widget.controller,
        );
      },
    );
  }

  /// FitCacheHelper를 사용한 다운로드 및 캐싱
  Future<File?> _downloadAndCache(String url) async {
    return FitCacheHelper.downloadAndCache(url);
  }

  /// 네트워크 URL 기본 유효성 검사입니다.
  bool _isValidNetworkUrl(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null) return false;
    return uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  /// 로딩/에러 시 레이아웃 흔들림을 막기 위한 fallback 박스입니다.
  Widget _buildFallbackBox() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
    );
  }

  Widget? get errorWidget => widget.errorWidget;

  Widget? get placeholder => widget.placeholder;
}
