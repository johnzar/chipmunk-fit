import 'dart:io';

import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_assets/gen/assets.gen.dart';
import 'package:chip_component/button/fit_button.dart';
import 'package:chip_component/button/fit_switch_button.dart';
import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_component/lottie/fit_lottie_widget.dart';
import 'package:chip_core/fit_cache_helper.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'lottie_page_controls.dart';
part 'lottie_page_models.dart';
part 'lottie_page_sections.dart';

/// `FitLottieWidget`의 핵심 시나리오를 검증하는 카탈로그 페이지입니다.
class LottiePage extends StatefulWidget {
  const LottiePage({super.key});

  @override
  State<LottiePage> createState() => _LottiePageState();
}

class _LottiePageState extends State<LottiePage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _networkUrlController;
  late final AnimationController _animationController;

  _LottieCatalogSource _source = _LottieCatalogSource.network;
  String _networkUrl = _networkSamples.first.value;
  String _assetPath = _assetSamples.first.keyName;
  String _fileAssetPath = _fileSamples.first.keyName;

  String? _resolvedFilePath;
  String? _fileError;
  bool _isPreparingFile = false;
  final Map<String, String> _preparedFilePathByAsset = {};

  double _width = 140;
  double _height = 140;
  BoxFit _fit = BoxFit.contain;
  bool _repeat = true;
  bool _animate = true;
  bool _useCustomController = false;

  bool _isCached = false;
  String? _cachedPath;

  /// 안전한 상태 갱신 헬퍼입니다.
  void _updateState(VoidCallback updater) {
    if (!mounted) return;
    setState(updater);
  }

  @override
  void initState() {
    super.initState();
    _networkUrlController = TextEditingController(text: _networkUrl)
      ..addListener(_handleNetworkUrlChanged);
    _animationController = AnimationController(vsync: this);

    _checkCache();
    _prepareFilePathFromAsset(_fileAssetPath);
  }

  @override
  void dispose() {
    _networkUrlController
      ..removeListener(_handleNetworkUrlChanged)
      ..dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// 네트워크 URL 입력 변경 시 캐시 상태를 함께 갱신합니다.
  void _handleNetworkUrlChanged() {
    final nextUrl = _networkUrlController.text.trim();
    if (nextUrl == _networkUrl) return;

    _updateState(() {
      _networkUrl = nextUrl;
    });

    if (_source == _LottieCatalogSource.network) {
      _checkCache();
    }
  }

  /// 소스 전환 시 필요한 상태를 정리하고 후속 준비 작업을 수행합니다.
  Future<void> _setSource(_LottieCatalogSource source) async {
    if (_source == source) return;

    _updateState(() {
      _source = source;
      _fileError = null;
      if (source != _LottieCatalogSource.network) {
        _isCached = false;
        _cachedPath = null;
      }
    });

    if (source == _LottieCatalogSource.network) {
      await _checkCache();
      return;
    }

    if (source == _LottieCatalogSource.file) {
      await _prepareFilePathFromAsset(_fileAssetPath);
    }
  }

  Future<void> _selectAssetSample(String assetKey) async {
    if (_assetPath == assetKey) return;

    _updateState(() {
      _assetPath = assetKey;
    });
  }

  /// File 소스는 `chip_assets` 에셋 키를 선택한 뒤 임시 파일로 변환합니다.
  Future<void> _selectFileSample(String assetKey) async {
    if (_fileAssetPath == assetKey && _resolvedFilePath != null) return;

    _updateState(() {
      _fileAssetPath = assetKey;
      _fileError = null;
    });

    await _prepareFilePathFromAsset(assetKey);
  }

  /// `.lottie` 에셋을 임시 디렉터리 파일로 복사해 file source에 전달합니다.
  Future<void> _prepareFilePathFromAsset(
    String assetKey, {
    bool force = false,
  }) async {
    final cachedPath = _preparedFilePathByAsset[assetKey];
    if (!force && cachedPath != null && File(cachedPath).existsSync()) {
      if (!mounted) return;
      setState(() {
        _resolvedFilePath = cachedPath;
        _fileError = null;
        _isPreparingFile = false;
      });
      return;
    }

    _updateState(() {
      _isPreparingFile = true;
      _fileError = null;
    });

    try {
      final data = await rootBundle.load(assetKey);
      final tempDir = await getTemporaryDirectory();
      final sampleDir = Directory('${tempDir.path}/fit_lottie_samples');
      if (!sampleDir.existsSync()) {
        await sampleDir.create(recursive: true);
      }

      final fileName = assetKey.split('/').last;
      final file = File('${sampleDir.path}/$fileName');
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      final shouldWrite =
          force || !file.existsSync() || file.lengthSync() != bytes.length;
      if (shouldWrite) {
        await file.writeAsBytes(bytes, flush: true);
      }

      _preparedFilePathByAsset[assetKey] = file.path;

      if (!mounted) return;
      _updateState(() {
        _resolvedFilePath = file.path;
        _fileError = null;
        _isPreparingFile = false;
      });
    } catch (e) {
      if (!mounted) return;
      _updateState(() {
        _resolvedFilePath = null;
        _isPreparingFile = false;
        _fileError = 'file source 준비 실패: $e';
      });
    }
  }

  /// 네트워크 샘플 다운로드/캐시를 강제 수행합니다.
  Future<void> _downloadAndCache() async {
    if (_networkUrl.isEmpty) return;

    await FitCacheHelper.downloadAndCache(_networkUrl);
    await _checkCache();
  }

  /// 현재 네트워크 URL의 캐시 존재 여부를 확인합니다.
  Future<void> _checkCache() async {
    if (_source != _LottieCatalogSource.network || _networkUrl.isEmpty) {
      if (!mounted) return;
      _updateState(() {
        _isCached = false;
        _cachedPath = null;
      });
      return;
    }

    final cached = await FitCacheHelper.isCached(_networkUrl);
    final path = await FitCacheHelper.getCachedFilePath(_networkUrl);
    final validCachedFile =
        cached && path != null && path.isNotEmpty && File(path).existsSync();

    if (!mounted) return;
    _updateState(() {
      _isCached = validCachedFile;
      _cachedPath = validCachedFile ? path : null;
    });
  }

  Future<void> _clearCache() async {
    await FitCacheHelper.clearAllCaches();
    await _checkCache();
  }

  Future<void> _applyNetworkBasic() async {
    await _setSource(_LottieCatalogSource.network);
    _networkUrlController.text = _networkSamples.first.value;
    _updateState(() {
      _fit = BoxFit.contain;
      _width = 140;
      _height = 140;
      _repeat = true;
      _animate = true;
      _useCustomController = false;
    });
  }

  Future<void> _applyAssetBasic() async {
    await _setSource(_LottieCatalogSource.asset);
    _updateState(() {
      _assetPath = _assetSamples.first.keyName;
      _fit = BoxFit.contain;
      _width = 140;
      _height = 140;
      _repeat = true;
      _animate = true;
      _useCustomController = false;
    });
  }

  Future<void> _applyFileFromAssets() async {
    await _setSource(_LottieCatalogSource.file);
    _updateState(() {
      _fileAssetPath = _fileSamples.first.keyName;
      _fit = BoxFit.contain;
      _width = 140;
      _height = 140;
      _repeat = true;
      _animate = true;
      _useCustomController = false;
    });
    await _prepareFilePathFromAsset(_fileAssetPath);
  }

  Future<void> _applyCacheValidation() async {
    await _setSource(_LottieCatalogSource.network);
    _networkUrlController.text = _networkSamples.first.value;
    await _checkCache();
  }

  /// 컨트롤러 데모를 위해 외부 컨트롤러 모드를 활성화합니다.
  Future<void> _applyControllerPlayback() async {
    await _setSource(_LottieCatalogSource.asset);
    _updateState(() {
      _assetPath = _assetSamples.last.keyName;
      _useCustomController = true;
      _repeat = true;
      _animate = true;
      _fit = BoxFit.contain;
    });
    _animationController
      ..stop()
      ..reset();
  }

  void _onUseCustomControllerChanged(bool nextValue) {
    _updateState(() {
      _useCustomController = nextValue;
    });

    _animationController
      ..stop()
      ..reset();
  }

  void _playController() {
    if (_animationController.duration == null) return;
    _animationController
      ..stop()
      ..forward(from: 0);
  }

  void _repeatController() {
    if (_animationController.duration == null) return;
    _animationController
      ..stop()
      ..repeat();
  }

  void _stopController() {
    _animationController.stop();
  }

  void _resetController() {
    _animationController
      ..stop()
      ..reset();
  }

  /// 현재 source 설정에 맞는 `FitLottieWidget` 인스턴스를 생성합니다.
  Widget _buildLottiePlayer() {
    final controller = _useCustomController ? _animationController : null;
    final hasCachedFile =
        _cachedPath != null && File(_cachedPath!).existsSync();

    switch (_source) {
      case _LottieCatalogSource.network:
        // 캐시 파일이 있으면 즉시 file 플레이어로 보여줘서 체감 지연을 줄입니다.
        if (hasCachedFile) {
          return FitLottieWidget.file(
            key: ValueKey('network-cached:$_cachedPath'),
            filePath: _cachedPath!,
            width: _width,
            height: _height,
            fit: _fit,
            repeat: _repeat,
            animate: _animate,
            controller: controller,
            errorWidget: _buildLottieError('캐시 파일 로드 실패'),
          );
        }

        return FitLottieWidget.network(
          key: ValueKey('network:$_networkUrl'),
          url: _networkUrl,
          width: _width,
          height: _height,
          fit: _fit,
          repeat: _repeat,
          animate: _animate,
          controller: controller,
          placeholder: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: _buildLottieError('네트워크 로드 실패'),
        );
      case _LottieCatalogSource.asset:
        return FitLottieWidget.asset(
          key: ValueKey('asset:$_assetPath'),
          assetPath: _assetPath,
          width: _width,
          height: _height,
          fit: _fit,
          repeat: _repeat,
          animate: _animate,
          controller: controller,
          errorWidget: _buildLottieError('에셋 로드 실패'),
        );
      case _LottieCatalogSource.file:
        if (_isPreparingFile) {
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }
        if (_fileError != null || _resolvedFilePath == null) {
          return Text(
            _fileError ?? 'file source 준비 실패',
            textAlign: TextAlign.center,
            style: context.caption1().copyWith(color: context.fitColors.red500),
          );
        }
        return FitLottieWidget.file(
          key: ValueKey('file:$_resolvedFilePath'),
          filePath: _resolvedFilePath!,
          width: _width,
          height: _height,
          fit: _fit,
          repeat: _repeat,
          animate: _animate,
          controller: controller,
          errorWidget: _buildLottieError('파일 로드 실패'),
        );
    }
  }

  Widget _buildLottieError(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 28, color: context.fitColors.red500),
        const SizedBox(height: 6),
        Text(
          message,
          style: context.caption1().copyWith(color: context.fitColors.red500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitLottieWidget',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: _buildPreviewCard(context),
          ),
          Container(
            height: 8,
            margin: const EdgeInsets.only(top: 16),
            color: colors.backgroundAlternative,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                24 + MediaQuery.of(context).viewPadding.bottom,
              ),
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
