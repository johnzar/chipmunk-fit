part of 'fit_image_page.dart';

/// Image 카탈로그 미리보기/시나리오 섹션 빌더입니다.
extension _FitImageSections on _FitImagePageState {
  Widget _buildPreviewCard(BuildContext context) {
    final colors = context.fitColors;

    return _SectionCard(
      title: 'Preview',
      subtitle: 'source / shape / fit result',
      icon: Icons.image_outlined,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: colors.backgroundBase,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.dividerPrimary),
            ),
            child: Center(child: _buildCurrentImage()),
          ),
          const SizedBox(height: 10),
          _StatusRow(label: 'Source', value: _source.label),
          _StatusRow(label: 'Shape', value: _shape.name),
          _StatusRow(label: 'Fit', value: _fit.name),
          _StatusRow(
            label: 'Size',
            value: '${_size.toInt()} x ${_size.toInt()}',
          ),
          _StatusRow(label: 'Border', value: _showBorder ? 'ON' : 'OFF'),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context) {
    return _SectionCard(
      title: 'Scenarios',
      subtitle: '핵심 5개',
      icon: Icons.fact_check_outlined,
      child: Column(
        children: [
          _ScenarioButton(
              label: 'Network Basic', onPressed: _applyNetworkBasic),
          const SizedBox(height: 8),
          _ScenarioButton(
              label: 'Shape Variants', onPressed: _applyShapeVariants),
          const SizedBox(height: 8),
          _ScenarioButton(
            label: 'Border Variants',
            onPressed: _applyBorderVariants,
          ),
          const SizedBox(height: 8),
          _ScenarioButton(label: 'Fit Modes', onPressed: _applyFitModes),
          const SizedBox(height: 8),
          _ScenarioButton(
            label: 'Error/Placeholder',
            onPressed: _applyErrorPlaceholder,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentImage() {
    final errorWidget = _buildErrorWidget();
    final placeholder = _buildPlaceholder();

    Widget image;
    switch (_source) {
      case _ImageSource.network:
        image = FitImage.network(
          imageUrl: _networkUrl,
          width: _size,
          height: _size,
          fit: _fit,
          imageShape: _shape,
          borderWidth: _borderWidth,
          borderColor: Colors.deepPurple,
          placeholder: placeholder,
          errorWidget: errorWidget,
        );
      case _ImageSource.asset:
        image = FitImage.asset(
          assetPath: _assetPath,
          width: _size,
          height: _size,
          fit: _fit,
          imageShape: _shape,
          borderWidth: _borderWidth,
          borderColor: Colors.deepPurple,
          errorWidget: errorWidget,
        );
      case _ImageSource.file:
        if (_preparingFile) {
          image = _buildPlaceholder();
          break;
        }
        if (_fileError != null) {
          image = _buildErrorWidget(message: _fileError!);
          break;
        }
        if (_filePath == null) {
          image = _buildErrorWidget(message: '파일 경로 없음');
          break;
        }
        image = FitImage.file(
          filePath: _filePath!,
          width: _size,
          height: _size,
          fit: _fit,
          imageShape: _shape,
          borderWidth: _borderWidth,
          borderColor: Colors.deepPurple,
          errorWidget: errorWidget,
        );
    }

    return _ImagePreviewFrame(
      size: _size,
      child: image,
    );
  }

  Widget _buildPlaceholder() {
    return const SizedBox(
      width: 36,
      height: 36,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _buildErrorWidget({String message = '이미지 로드 실패'}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.broken_image_outlined, size: 28),
        const SizedBox(height: 6),
        Text(
          message,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
