part of 'fit_image_page.dart';

/// Image 카탈로그 공통 섹션 카드입니다.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
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
              Text(title, style: context.subtitle4()),
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

/// `FitChip` 기반 선택 버튼입니다.
class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FitChip(
      isSelected: selected,
      onSelected: (_) => onTap(),
      child: Text(label, style: context.button2()),
    );
  }
}

/// 미리보기 하단 상태 라인입니다.
class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: context
                  .caption1()
                  .copyWith(color: context.fitColors.textTertiary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context
                  .caption1()
                  .copyWith(color: context.fitColors.textSecondary),
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
      isExpanded: true,
      type: FitButtonType.secondary,
      onPressed: onPressed,
      child: Text(label, style: context.button1()),
    );
  }
}

/// 스위치 제어용 행 위젯입니다.
class _ImageSwitchRow extends StatelessWidget {
  const _ImageSwitchRow({
    required this.title,
    required this.techKey,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String techKey;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;
    return Container(
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
                Text(title, style: context.body3()),
                Text(
                  techKey,
                  style:
                      context.caption1().copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          FitSwitchButton(
            isOn: value,
            onToggle: onChanged,
          ),
        ],
      ),
    );
  }
}

/// 이미지 외곽을 확인하기 위한 미리보기 프레임입니다.
class _ImagePreviewFrame extends StatelessWidget {
  const _ImagePreviewFrame({
    required this.size,
    required this.child,
  });

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.fillAlternative,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.dividerSecondary),
      ),
      child: Center(child: child),
    );
  }
}
