import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'fit_image.dart';
import 'fit_image_shape.dart';

/// 캐시된 네트워크 이미지 호환 래퍼입니다.
///
/// 신규 코드에서는 `FitImage.network` 사용을 권장합니다.
@Deprecated('Use FitImage.network instead.')
class FitCachedNetworkImage extends StatelessWidget {
  /// 이미지 URL
  final String imageUrl;

  /// 이미지 너비
  final double? width;

  /// 이미지 높이
  final double? height;

  /// 이미지 fit 방식
  final BoxFit fit;

  /// 이미지 형태
  final FitImageShape imageShape;

  /// 테두리 두께
  final double? borderWidth;

  /// 테두리 색상
  final Color? borderColor;

  /// Fade-in 애니메이션 시간
  final Duration fadeInDuration;

  /// 로딩 중 표시할 위젯
  final Widget? placeholder;

  /// 에러 시 표시할 위젯
  final Widget? errorWidget;

  /// 메모리 캐시 너비 (성능 최적화)
  final int? memCacheWidth;

  /// 메모리 캐시 높이 (성능 최적화)
  final int? memCacheHeight;

  /// 하위 호환을 위한 기본 캐시 매니저(30일).
  static CacheManager get cacheManager => FitImage.defaultCacheManager;

  const FitCachedNetworkImage({
    super.key,
    required this.imageUrl,
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
  });

  @override
  Widget build(BuildContext context) {
    return FitImage.network(
      imageUrl: imageUrl,
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
  }
}
