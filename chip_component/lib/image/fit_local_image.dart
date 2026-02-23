import 'package:flutter/material.dart';

import 'fit_image.dart';
import 'fit_image_shape.dart';

/// 로컬 파일 이미지 호환 래퍼입니다.
///
/// 신규 코드에서는 `FitImage.file` 사용을 권장합니다.
@Deprecated('Use FitImage.file instead.')
class FitLocalImage extends StatelessWidget {
  /// 로컬 파일 경로
  final String filePath;

  /// 이미지 너비
  final double? width;

  /// 이미지 높이
  final double? height;

  /// 이미지 fit 방식
  final BoxFit fit;

  /// 에러 위젯
  final Widget? errorWidget;

  const FitLocalImage({
    super.key,
    required this.filePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // 기존 FitLocalImage는 shape/border를 지원하지 않았으므로 NONE으로 고정합니다.
    return FitImage.file(
      filePath: filePath,
      width: width,
      height: height,
      fit: fit,
      imageShape: FitImageShape.NONE,
      errorWidget: errorWidget,
    );
  }
}
