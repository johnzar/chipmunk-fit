import 'package:flutter/material.dart';

import 'fit_lottie_source_type.dart';
import 'players/fit_asset_lottie_player.dart';
import 'players/fit_file_lottie_player.dart';
import 'players/fit_network_lottie_player.dart';

/// `network / asset / file` 3가지 소스를 통합한 Lottie 위젯입니다.
///
/// - `network`는 내부적으로 캐시 다운로드 경로를 사용합니다.
/// - `asset`/`file`은 동일한 재생 정책(animate/repeat/controller)을 따릅니다.
/// - 외부 [controller]가 전달되면 해당 컨트롤러에 재생 상태를 반영합니다.
class FitLottieWidget extends StatelessWidget {
  final String source;
  final FitLottieSourceType sourceType;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit fit;
  final bool repeat;
  final bool animate;
  final AnimationController? controller;

  const FitLottieWidget._({
    Key? key,
    required this.source,
    required this.sourceType,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.fit = BoxFit.contain,
    this.repeat = true,
    this.animate = true,
    this.controller,
  }) : super(key: key);

  /// 네트워크 Lottie (자동 캐싱)
  const FitLottieWidget.network({
    Key? key,
    required String url,
    double? width,
    double? height,
    Widget? placeholder,
    Widget? errorWidget,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
    bool animate = true,
    AnimationController? controller,
  }) : this._(
          key: key,
          source: url,
          sourceType: FitLottieSourceType.network,
          width: width,
          height: height,
          placeholder: placeholder,
          errorWidget: errorWidget,
          fit: fit,
          repeat: repeat,
          animate: animate,
          controller: controller,
        );

  /// 앱 번들 에셋(.lottie) 기반 재생 생성자입니다.
  const FitLottieWidget.asset({
    Key? key,
    required String assetPath,
    double? width,
    double? height,
    Widget? errorWidget,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
    bool animate = true,
    AnimationController? controller,
  }) : this._(
          key: key,
          source: assetPath,
          sourceType: FitLottieSourceType.asset,
          width: width,
          height: height,
          errorWidget: errorWidget,
          fit: fit,
          repeat: repeat,
          animate: animate,
          controller: controller,
        );

  /// 로컬 파일 Lottie
  const FitLottieWidget.file({
    Key? key,
    required String filePath,
    double? width,
    double? height,
    Widget? errorWidget,
    BoxFit fit = BoxFit.contain,
    bool repeat = true,
    bool animate = true,
    AnimationController? controller,
  }) : this._(
          key: key,
          source: filePath,
          sourceType: FitLottieSourceType.file,
          width: width,
          height: height,
          errorWidget: errorWidget,
          fit: fit,
          repeat: repeat,
          animate: animate,
          controller: controller,
        );

  @override
  Widget build(BuildContext context) {
    return switch (sourceType) {
      FitLottieSourceType.network => FitNetworkLottiePlayer(
          url: source,
          width: width,
          height: height,
          placeholder: placeholder,
          errorWidget: errorWidget,
          fit: fit,
          repeat: repeat,
          animate: animate,
          controller: controller,
        ),
      FitLottieSourceType.asset => FitAssetLottiePlayer(
          assetPath: source,
          width: width,
          height: height,
          errorWidget: errorWidget,
          fit: fit,
          repeat: repeat,
          animate: animate,
          controller: controller,
        ),
      FitLottieSourceType.file => FitFileLottiePlayer(
          filePath: source,
          width: width,
          height: height,
          errorWidget: errorWidget,
          fit: fit,
          repeat: repeat,
          animate: animate,
          controller: controller,
        ),
    };
  }
}
