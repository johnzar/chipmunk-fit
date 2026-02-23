part of 'fit_image_page.dart';

/// 이미지 소스 타입입니다.
enum _ImageSource {
  network('Network'),
  asset('Asset'),
  file('File');

  const _ImageSource(this.label);
  final String label;
}

/// `BoxFit` 선택 UI에서 사용하는 표현 모델입니다.
class _FitOption {
  const _FitOption(this.label, this.fit);
  final String label;
  final BoxFit fit;
}

const _fitOptions = [
  _FitOption('cover', BoxFit.cover),
  _FitOption('contain', BoxFit.contain),
  _FitOption('fill', BoxFit.fill),
];
