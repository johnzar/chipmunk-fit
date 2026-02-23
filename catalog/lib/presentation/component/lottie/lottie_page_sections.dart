part of 'lottie_page.dart';

/// Lottie 카탈로그의 미리보기/시나리오 섹션 빌더입니다.
extension _LottieSections on _LottiePageState {
  Widget _buildPreviewCard(BuildContext context) {
    final colors = context.fitColors;
    final sourceLabel = _sourceLabelByType[_source]!;

    return _LottieSectionCard(
      title: 'Preview',
      subtitle: 'live render / state',
      icon: Icons.movie_creation_outlined,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: colors.backgroundBase,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.dividerPrimary),
            ),
            child: Center(child: _buildLottiePlayer()),
          ),
          const SizedBox(height: 10),
          _StatusRow(label: 'Source', value: sourceLabel),
          _StatusRow(
              label: 'Size', value: '${_width.toInt()} x ${_height.toInt()}'),
          _StatusRow(label: 'Repeat', value: _repeat ? 'ON' : 'OFF'),
          _StatusRow(label: 'Animate', value: _animate ? 'ON' : 'OFF'),
          if (_source == _LottieCatalogSource.network)
            _StatusRow(label: 'Cached', value: _isCached ? 'YES' : 'NO'),
          if (_source == _LottieCatalogSource.network && _cachedPath != null)
            _StatusRow(label: 'Cache Path', value: _cachedPath!),
          if (_source == _LottieCatalogSource.file && _resolvedFilePath != null)
            _StatusRow(label: 'File Path', value: _resolvedFilePath!),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context) {
    return _LottieSectionCard(
      title: 'Scenarios',
      subtitle: '핵심 검증',
      icon: Icons.rule_folder_outlined,
      child: Column(
        children: [
          _ScenarioButton(
              label: 'Network Basic', onPressed: _applyNetworkBasic),
          const SizedBox(height: 8),
          _ScenarioButton(label: 'Asset Basic', onPressed: _applyAssetBasic),
          const SizedBox(height: 8),
          _ScenarioButton(
            label: 'File from chip_assets',
            onPressed: _applyFileFromAssets,
          ),
          const SizedBox(height: 8),
          _ScenarioButton(
            label: 'Cache Validation',
            onPressed: _applyCacheValidation,
          ),
          const SizedBox(height: 8),
          _ScenarioButton(
            label: 'Controller Playback',
            onPressed: _applyControllerPlayback,
          ),
          const SizedBox(height: 8),
          FitButton(
            type: FitButtonType.destructive,
            isExpanded: true,
            onPressed: _clearCache,
            child: Text('Clear All Cache', style: context.button1()),
          ),
        ],
      ),
    );
  }
}

/// 공통 카드 레이아웃 위젯입니다.
class _LottieSectionCard extends StatelessWidget {
  const _LottieSectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colors.main),
              const SizedBox(width: 8),
              Text(
                title,
                style: context.subtitle4().copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: context.caption1().copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// 미리보기 하단 상태 텍스트 행입니다.
class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: context.caption1().copyWith(color: colors.textTertiary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.caption1().copyWith(color: colors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// 시나리오 실행 버튼입니다.
class _ScenarioButton extends StatelessWidget {
  const _ScenarioButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FitButton(
      type: FitButtonType.secondary,
      isExpanded: true,
      onPressed: onPressed,
      child: Text(label, style: context.button1()),
    );
  }
}
