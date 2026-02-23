part of 'lottie_page.dart';

/// Lottie 카탈로그의 제어 패널 빌더 모음입니다.
extension _LottieControlPanels on _LottiePageState {
  Widget _buildControlsCard(BuildContext context) {
    return _LottieSectionCard(
      title: 'Controls',
      subtitle: 'source / sample / playback',
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSourceSelector(context),
          const SizedBox(height: 12),
          _buildSourceDetailPanel(context),
          const SizedBox(height: 12),
          _buildFitSelector(context),
          const SizedBox(height: 12),
          _buildSizeSliders(context),
          const SizedBox(height: 8),
          _LottieSwitchRow(
            title: 'Animate',
            subtitle: 'animate',
            value: _animate,
            onChanged: (next) => _updateState(() => _animate = next),
          ),
          const SizedBox(height: 8),
          _LottieSwitchRow(
            title: 'Repeat',
            subtitle: 'repeat',
            value: _repeat,
            onChanged: (next) => _updateState(() => _repeat = next),
          ),
          const SizedBox(height: 8),
          _LottieSwitchRow(
            title: 'Custom Controller',
            subtitle: 'external controller',
            value: _useCustomController,
            onChanged: _onUseCustomControllerChanged,
          ),
          if (_useCustomController) ...[
            const SizedBox(height: 12),
            _buildControllerActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSourceSelector(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final source in _LottieCatalogSource.values)
          _LottieSelectableChip(
            label: _sourceLabelByType[source]!,
            selected: source == _source,
            onTap: () => _setSource(source),
          ),
      ],
    );
  }

  Widget _buildSourceDetailPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.fitColors.backgroundBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.fitColors.dividerPrimary),
      ),
      child: switch (_source) {
        _LottieCatalogSource.network => _buildNetworkControls(context),
        _LottieCatalogSource.asset => _buildAssetControls(context),
        _LottieCatalogSource.file => _buildFileControls(context),
      },
    );
  }

  Widget _buildNetworkControls(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Network URL',
          style: context.caption1().copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _networkUrlController,
          style: context.body3().copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: 'https://...',
            filled: true,
            fillColor: colors.backgroundElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.dividerPrimary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.dividerPrimary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            isDense: true,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Samples',
          style: context.caption1().copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final sample in _networkSamples)
              _LottieSelectableChip(
                label: sample.label,
                selected: _networkUrl == sample.value,
                onTap: () {
                  _networkUrlController.text = sample.value;
                  _checkCache();
                },
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FitButton(
                type: FitButtonType.secondary,
                onPressed: _downloadAndCache,
                child: Text('다운로드', style: context.button2()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FitButton(
                type: FitButtonType.tertiary,
                onPressed: _checkCache,
                child: Text('캐시 확인', style: context.button2()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssetControls(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asset Samples',
          style: context.caption1().copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final sample in _assetSamples)
              _LottieSelectableChip(
                label: sample.label,
                selected: _assetPath == sample.keyName,
                onTap: () => _selectAssetSample(sample.keyName),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFileControls(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File Samples (chip_assets)',
          style: context.caption1().copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final sample in _fileSamples)
              _LottieSelectableChip(
                label: sample.label,
                selected: _fileAssetPath == sample.keyName,
                onTap: () => _selectFileSample(sample.keyName),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.backgroundElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.dividerPrimary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isPreparingFile)
                Text(
                  '임시 파일 준비 중...',
                  style:
                      context.caption1().copyWith(color: colors.textSecondary),
                )
              else if (_fileError != null)
                Text(
                  _fileError!,
                  style: context.caption1().copyWith(color: colors.red500),
                )
              else ...[
                Text(
                  '임시 파일 경로',
                  style: context.caption1().copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _resolvedFilePath ?? '-',
                  style:
                      context.caption1().copyWith(color: colors.textTertiary),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        FitButton(
          type: FitButtonType.secondary,
          isExpanded: true,
          onPressed: () =>
              _prepareFilePathFromAsset(_fileAssetPath, force: true),
          child: Text('임시 파일 다시 생성', style: context.button2()),
        ),
      ],
    );
  }

  Widget _buildFitSelector(BuildContext context) {
    final selectedValue = _boxFitToValue(_fit);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fit',
          style: context.caption1().copyWith(
                color: context.fitColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in _fitOptions)
              _LottieSelectableChip(
                label: option.label,
                selected: selectedValue == option.value,
                onTap: () =>
                    _updateState(() => _fit = _boxFitFromValue(option.value)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizeSliders(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LottieSliderField(
            title: 'Width',
            valueLabel: '${_width.toStringAsFixed(0)}px',
            value: _width,
            min: 80,
            max: 220,
            divisions: 14,
            onChanged: (next) => _updateState(() => _width = next),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _LottieSliderField(
            title: 'Height',
            valueLabel: '${_height.toStringAsFixed(0)}px',
            value: _height,
            min: 80,
            max: 220,
            divisions: 14,
            onChanged: (next) => _updateState(() => _height = next),
          ),
        ),
      ],
    );
  }

  Widget _buildControllerActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Controller Playback',
          style: context.caption1().copyWith(
                color: context.fitColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FitButton(
                type: FitButtonType.secondary,
                onPressed: _playController,
                child: Text('Play', style: context.button2()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FitButton(
                type: FitButtonType.secondary,
                onPressed: _repeatController,
                child: Text('Repeat', style: context.button2()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FitButton(
                type: FitButtonType.tertiary,
                onPressed: _stopController,
                child: Text('Stop', style: context.button2()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FitButton(
                type: FitButtonType.tertiary,
                onPressed: _resetController,
                child: Text('Reset', style: context.button2()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 토글 항목 공통 행 위젯입니다.
class _LottieSwitchRow extends StatelessWidget {
  const _LottieSwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.body3().copyWith(color: colors.textPrimary),
                ),
                Text(
                  subtitle,
                  style:
                      context.caption1().copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          FitSwitchButton(
            isOn: value,
            onToggle: onChanged,
            activeColor: colors.main,
            inactiveColor: colors.grey300,
          ),
        ],
      ),
    );
  }
}

/// 숫자 슬라이더와 현재 값을 같이 표시하는 필드입니다.
class _LottieSliderField extends StatelessWidget {
  const _LottieSliderField({
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.caption1().copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.main.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                valueLabel,
                style: context.caption1().copyWith(
                      color: colors.main,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: colors.main,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// 카탈로그에서 사용하는 칩 선택 UI입니다.
class _LottieSelectableChip extends StatelessWidget {
  const _LottieSelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return FitChip(
      isSelected: selected,
      onTap: onTap,
      backgroundColor: colors.backgroundBase,
      selectedBackgroundColor: colors.main.withValues(alpha: 0.12),
      borderColor: colors.dividerPrimary,
      selectedBorderColor: colors.main,
      borderWidth: 1,
      selectedBorderWidth: 1,
      borderRadius: 10,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        label,
        style: context.caption1().copyWith(
              color: selected ? colors.main : colors.textSecondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
      ),
    );
  }
}
