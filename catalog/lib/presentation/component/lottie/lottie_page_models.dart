part of 'lottie_page.dart';

/// Lottie 샘플 소스 타입입니다.
enum _LottieCatalogSource { network, asset, file }

/// 라벨/값 형태의 단순 옵션 모델입니다.
class _LottieOption {
  const _LottieOption({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class _LottieAssetSample {
  const _LottieAssetSample({
    required this.label,
    required this.asset,
  });

  final String label;
  final LottieGenImage asset;

  /// `rootBundle` 로딩에 사용하는 키 경로입니다.
  String get keyName => asset.keyName;
}

const _sourceLabelByType = <_LottieCatalogSource, String>{
  _LottieCatalogSource.network: 'Network',
  _LottieCatalogSource.asset: 'Asset',
  _LottieCatalogSource.file: 'File',
};

const _fitOptions = <_LottieOption>[
  _LottieOption(label: 'Contain', value: 'contain'),
  _LottieOption(label: 'Cover', value: 'cover'),
  _LottieOption(label: 'Fill', value: 'fill'),
  _LottieOption(label: 'Fit Width', value: 'fitWidth'),
  _LottieOption(label: 'Fit Height', value: 'fitHeight'),
];

final _networkSamples = <_LottieOption>[
  const _LottieOption(
    label: 'Pigeon',
    value:
        'https://raw.githubusercontent.com/LottieFiles/dotlottie-ios/main/Example/Example/Animations/pigeon.lottie',
  ),
  const _LottieOption(
    label: 'Adding Guests',
    value:
        'https://raw.githubusercontent.com/LottieFiles/dotlottie-ios/main/Example/Example/Animations/adding-guests.lottie',
  ),
  const _LottieOption(
    label: 'Star Marked',
    value:
        'https://raw.githubusercontent.com/LottieFiles/dotlottie-ios/main/Example/Example/Animations/star-marked.lottie',
  ),
  const _LottieOption(
    label: 'Smiley Slider',
    value:
        'https://raw.githubusercontent.com/LottieFiles/dotlottie-ios/main/Example/Example/Animations/smiley-slider.lottie',
  ),
];

final _assetSamples = <_LottieAssetSample>[
  _LottieAssetSample(label: 'Loading', asset: ChipAssets.lottie.loading),
  _LottieAssetSample(label: 'Dot Loading', asset: ChipAssets.lottie.dotLoading),
  _LottieAssetSample(label: 'Gift Box', asset: ChipAssets.lottie.giftBox),
  _LottieAssetSample(label: 'Coin Pig', asset: ChipAssets.lottie.coinPig),
];

final _fileSamples = <_LottieAssetSample>[
  _LottieAssetSample(label: 'Loading', asset: ChipAssets.lottie.loading),
  _LottieAssetSample(label: 'Dot Loading', asset: ChipAssets.lottie.dotLoading),
  _LottieAssetSample(label: 'Gift Box', asset: ChipAssets.lottie.giftBox),
  _LottieAssetSample(label: 'Coin Pig', asset: ChipAssets.lottie.coinPig),
];

BoxFit _boxFitFromValue(String value) {
  return switch (value) {
    'cover' => BoxFit.cover,
    'fill' => BoxFit.fill,
    'fitWidth' => BoxFit.fitWidth,
    'fitHeight' => BoxFit.fitHeight,
    _ => BoxFit.contain,
  };
}

String _boxFitToValue(BoxFit fit) {
  return switch (fit) {
    BoxFit.cover => 'cover',
    BoxFit.fill => 'fill',
    BoxFit.fitWidth => 'fitWidth',
    BoxFit.fitHeight => 'fitHeight',
    _ => 'contain',
  };
}
