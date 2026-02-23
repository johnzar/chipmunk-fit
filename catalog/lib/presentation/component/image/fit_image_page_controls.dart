part of 'fit_image_page.dart';

/// Image 카탈로그 제어 패널 빌더입니다.
extension _FitImageControls on _FitImagePageState {
  Widget _buildControlsCard(BuildContext context) {
    return _SectionCard(
      title: 'Controls',
      subtitle: '빠른 수동 검증',
      icon: Icons.tune_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(context, 'Source'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final source in _ImageSource.values)
                _SelectableChip(
                  label: source.label,
                  selected: source == _source,
                  onTap: () => _updateState(() => _source = source),
                ),
            ],
          ),
          if (_source == _ImageSource.network) ...[
            const SizedBox(height: 12),
            _buildLabel(context, 'Network URL'),
            const SizedBox(height: 8),
            TextField(
              controller: _networkUrlController,
              decoration: InputDecoration(
                hintText: 'https://...',
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
          if (_source == _ImageSource.file && _filePath != null) ...[
            const SizedBox(height: 12),
            _StatusRow(label: 'File Path', value: _filePath!),
          ],
          const SizedBox(height: 12),
          _buildLabel(context, 'Shape'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final shape in FitImageShape.values)
                _SelectableChip(
                  label: shape.name,
                  selected: shape == _shape,
                  onTap: () => _updateState(() => _shape = shape),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLabel(context, 'Fit'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in _fitOptions)
                _SelectableChip(
                  label: option.label,
                  selected: option.fit == _fit,
                  onTap: () => _updateState(() => _fit = option.fit),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _ImageSwitchRow(
            title: 'Border',
            techKey: 'showBorder',
            value: _showBorder,
            onChanged: (next) => _updateState(() => _showBorder = next),
          ),
          const SizedBox(height: 10),
          _buildLabel(context, 'Size (${_size.toInt()}px)'),
          Slider(
            min: 100,
            max: 240,
            value: _size,
            onChanged: (next) => _updateState(() => _size = next),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: context.caption1().copyWith(
            color: context.fitColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
