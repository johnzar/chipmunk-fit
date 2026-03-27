import 'dart:io';

import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_assets/gen/assets.gen.dart';
import 'package:chip_component/button/fit_button.dart';
import 'package:chip_component/button/fit_switch_button.dart';
import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_component/image/fit_image.dart';
import 'package:chip_component/image/fit_image_shape.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'fit_image_page_controls.dart';
part 'fit_image_page_models.dart';
part 'fit_image_page_sections.dart';
part 'fit_image_page_widgets.dart';

/// `FitImage`의 핵심 시나리오를 검증하는 카탈로그 페이지입니다.
class FitImagePage extends StatefulWidget {
  const FitImagePage({super.key});

  @override
  State<FitImagePage> createState() => _FitImagePageState();
}

class _FitImagePageState extends State<FitImagePage> {
  static const _kNetworkSample =
      'https://placehold.co/640x640/7C3AED/FFFFFF/png?text=FitImage+Sample';
  static const _kNetworkErrorSample = 'https://example.invalid/fit-image.png';

  _ImageSource _source = _ImageSource.network;
  FitImageShape _shape = FitImageShape.SQUIRCLE;
  BoxFit _fit = BoxFit.cover;
  double _size = 180;
  bool _showBorder = false;
  String _networkUrl = _kNetworkSample;
  late final TextEditingController _networkUrlController;

  final String _assetPath = ChipAssets.images.icSneakers.keyName;
  final String _fileSampleAssetPath = ChipAssets.images.icSneakers.keyName;
  String? _filePath;
  String? _fileError;
  bool _preparingFile = false;

  double get _borderWidth => _showBorder ? 2.0 : 0.0;

  /// extension 영역에서도 안전하게 상태를 갱신하기 위한 헬퍼입니다.
  void _updateState(VoidCallback updater) => setState(updater);

  @override
  void initState() {
    super.initState();
    _networkUrlController = TextEditingController(text: _networkUrl)
      ..addListener(_onNetworkUrlChanged);
    _prepareSampleFile();
  }

  @override
  void dispose() {
    _networkUrlController
      ..removeListener(_onNetworkUrlChanged)
      ..dispose();
    super.dispose();
  }

  /// URL 입력값 변경을 상태에 동기화합니다.
  void _onNetworkUrlChanged() {
    final next = _networkUrlController.text.trim();
    if (next == _networkUrl) return;
    setState(() {
      _networkUrl = next;
    });
  }

  /// `chip_assets` 샘플 이미지를 임시 파일로 준비합니다.
  Future<void> _prepareSampleFile() async {
    setState(() {
      _preparingFile = true;
      _fileError = null;
    });

    try {
      final data = await rootBundle.load(_fileSampleAssetPath);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/fit_image_sample.png');
      await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );

      if (!mounted) return;
      setState(() {
        _filePath = file.path;
        _preparingFile = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _fileError = '파일 준비 실패: $e';
        _preparingFile = false;
      });
    }
  }

  /// 네트워크 기본 케이스로 빠르게 복원합니다.
  void _applyNetworkBasic() {
    setState(() {
      _source = _ImageSource.network;
      _networkUrl = _kNetworkSample;
      _networkUrlController.text = _kNetworkSample;
      _shape = FitImageShape.SQUIRCLE;
      _fit = BoxFit.cover;
      _size = 180;
      _showBorder = false;
    });
  }

  /// Shape 구분 검증용 상태를 적용합니다.
  void _applyShapeVariants() {
    setState(() {
      _source = _ImageSource.asset;
      _shape = FitImageShape.CIRCLE;
      _fit = BoxFit.cover;
      _size = 180;
      _showBorder = false;
    });
  }

  /// Border 분기 검증용 상태를 적용합니다.
  void _applyBorderVariants() {
    setState(() {
      _source = _ImageSource.network;
      _networkUrl = _kNetworkSample;
      _networkUrlController.text = _kNetworkSample;
      _shape = FitImageShape.RECTANGLE;
      _fit = BoxFit.cover;
      _size = 180;
      _showBorder = true;
    });
  }

  /// Fit 모드 차이 확인용 상태를 적용합니다.
  void _applyFitModes() {
    setState(() {
      _source = _ImageSource.asset;
      _shape = FitImageShape.SQUIRCLE;
      _fit = BoxFit.contain;
      _size = 200;
      _showBorder = false;
    });
  }

  /// 에러/플레이스홀더 동작 확인용 상태를 적용합니다.
  void _applyErrorPlaceholder() {
    setState(() {
      _source = _ImageSource.network;
      _networkUrl = _kNetworkErrorSample;
      _networkUrlController.text = _kNetworkErrorSample;
      _shape = FitImageShape.SQUIRCLE;
      _fit = BoxFit.cover;
      _size = 180;
      _showBorder = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitImage',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: _buildPreviewCard(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                children: [
                  _buildControlsCard(context),
                  const SizedBox(height: 16),
                  _buildScenarioCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
