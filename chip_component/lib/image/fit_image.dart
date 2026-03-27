import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'fit_image_shape.dart';
import 'squircle/fit_squircle_border_painter.dart';
import 'squircle/fit_squircle_clipper.dart';

/// `network / asset / file` 소스를 통합한 이미지 컴포넌트입니다.
///
/// 기존 `FitCachedNetworkImage`, `FitLocalImage`는 하위 호환을 위해 유지되며,
/// 신규 사용처는 이 API를 권장합니다.
class FitImage extends StatelessWidget {
  static const _cacheKey = 'fortune_caching_key';

  /// 기본 네트워크 캐시 매니저(30일 만료)입니다.
  static final CacheManager defaultCacheManager = CacheManager(
    Config(
      _cacheKey,
      stalePeriod: const Duration(days: 30),
      repo: JsonCacheInfoRepository(databaseName: _cacheKey),
    ),
  );

  final _FitImageSourceType sourceType;
  final String source;

  final double? width;
  final double? height;
  final BoxFit fit;

  final FitImageShape imageShape;
  final double? borderWidth;
  final Color? borderColor;

  final Duration fadeInDuration;
  final Widget? placeholder;
  final Widget? errorWidget;

  final int? memCacheWidth;
  final int? memCacheHeight;
  final CacheManager? cacheManager;

  const FitImage._({
    super.key,
    required this.sourceType,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.imageShape = FitImageShape.SQUIRCLE,
    this.borderWidth,
    this.borderColor,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheManager,
  });

  /// 네트워크 이미지 생성자입니다.
  const FitImage.network({
    Key? key,
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    FitImageShape imageShape = FitImageShape.SQUIRCLE,
    double? borderWidth,
    Color? borderColor,
    Duration fadeInDuration = const Duration(milliseconds: 300),
    Widget? placeholder,
    Widget? errorWidget,
    int? memCacheWidth,
    int? memCacheHeight,
    CacheManager? cacheManager,
  }) : this._(
          key: key,
          sourceType: _FitImageSourceType.network,
          source: imageUrl,
          width: width,
          height: height,
          fit: fit,
          imageShape: imageShape,
          borderWidth: borderWidth,
          borderColor: borderColor,
          fadeInDuration: fadeInDuration,
          placeholder: placeholder,
          errorWidget: errorWidget,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          cacheManager: cacheManager,
        );

  /// 에셋 이미지 생성자입니다.
  const FitImage.asset({
    Key? key,
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    FitImageShape imageShape = FitImageShape.SQUIRCLE,
    double? borderWidth,
    Color? borderColor,
    Widget? errorWidget,
  }) : this._(
          key: key,
          sourceType: _FitImageSourceType.asset,
          source: assetPath,
          width: width,
          height: height,
          fit: fit,
          imageShape: imageShape,
          borderWidth: borderWidth,
          borderColor: borderColor,
          errorWidget: errorWidget,
        );

  /// 로컬 파일 이미지 생성자입니다.
  const FitImage.file({
    Key? key,
    required String filePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    FitImageShape imageShape = FitImageShape.SQUIRCLE,
    double? borderWidth,
    Color? borderColor,
    Widget? errorWidget,
  }) : this._(
          key: key,
          sourceType: _FitImageSourceType.file,
          source: filePath,
          width: width,
          height: height,
          fit: fit,
          imageShape: imageShape,
          borderWidth: borderWidth,
          borderColor: borderColor,
          errorWidget: errorWidget,
        );

  @override
  Widget build(BuildContext context) {
    final image = _buildImageBySource();
    return _wrapWithShape(image);
  }

  Widget _buildImageBySource() {
    switch (sourceType) {
      case _FitImageSourceType.network:
        return _buildNetworkImage();
      case _FitImageSourceType.asset:
        return _buildAssetImage();
      case _FitImageSourceType.file:
        return _buildFileImage();
    }
  }

  Widget _buildNetworkImage() {
    if (source.isEmpty) {
      return _defaultErrorWidget;
    }

    return CachedNetworkImage(
      imageUrl: source,
      width: width,
      height: height,
      fit: fit,
      cacheManager: cacheManager ?? defaultCacheManager,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholderFadeInDuration: Duration.zero,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: placeholder != null ? (_, __) => placeholder! : null,
      errorWidget: errorWidget != null ? (_, __, ___) => errorWidget! : null,
    );
  }

  Widget _buildAssetImage() {
    if (source.isEmpty) {
      return _defaultErrorWidget;
    }

    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.low,
      errorBuilder: (_, __, ___) => _defaultErrorWidget,
    );
  }

  Widget _buildFileImage() {
    if (source.isEmpty) {
      return _defaultErrorWidget;
    }

    final file = File(source);
    if (!file.existsSync()) {
      return _defaultErrorWidget;
    }

    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.low,
      errorBuilder: (_, __, ___) => _defaultErrorWidget,
      cacheWidth: _calculateCacheSize(width),
      cacheHeight: _calculateCacheSize(height),
    );
  }

  Widget get _defaultErrorWidget => errorWidget ?? const SizedBox.shrink();

  /// 소스 위젯에 shape/border 규칙을 공통 적용합니다.
  Widget _wrapWithShape(Widget child) {
    switch (imageShape) {
      case FitImageShape.SQUIRCLE:
        return SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            painter: FitSquircleBorderPainter(
              borderWidth: borderWidth,
              borderColor: borderColor,
            ),
            child: ClipPath(
              clipper: const FitSquircleClipper(),
              child: child,
            ),
          ),
        );

      case FitImageShape.CIRCLE:
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: _resolvedBorder,
            shape: BoxShape.circle,
          ),
          child: ClipOval(child: child),
        );

      case FitImageShape.RECTANGLE:
        if (_resolvedBorder != null) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(border: _resolvedBorder),
            child: child,
          );
        }
        return child;

      case FitImageShape.NONE:
        return child;
    }
  }

  BoxBorder? get _resolvedBorder {
    if (borderWidth != null && borderWidth! > 0 && borderColor != null) {
      return Border.all(color: borderColor!, width: borderWidth!);
    }
    return null;
  }

  /// 메모리 최적화를 위한 캐시 크기 계산입니다.
  int? _calculateCacheSize(double? size) {
    if (size == null) return null;

    const maxDevicePixelRatio = 3.0;
    final cacheSize = (size * maxDevicePixelRatio).toInt();
    return cacheSize > 2048 ? 2048 : cacheSize;
  }
}

enum _FitImageSourceType { network, asset, file }
