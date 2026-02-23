part of 'bottom_sheet_page.dart';

extension _BottomSheetPagePanelMethods on _BottomSheetPageState {
  Widget _buildControlCard(BuildContext context) {
    return _SectionCard(
      title: 'Controls',
      child: Column(
        children: [
          _SwitchRow(
            title: 'Top Bar',
            techKey: 'isShowTopBar',
            value: _isShowTopBar,
            onChanged: (value) => _updateState(() => _isShowTopBar = value),
          ),
          _SwitchRow(
            title: 'Close Button',
            techKey: 'isShowCloseButton',
            value: _isShowCloseButton,
            onChanged: (value) =>
                _updateState(() => _isShowCloseButton = value),
          ),
          _SwitchRow(
            title: 'Dismissible',
            techKey: 'isDismissible',
            value: _isDismissible,
            onChanged: (value) => _updateState(() => _isDismissible = value),
          ),
          _SwitchRow(
            title: 'Barrier Tap Dismiss',
            techKey: 'dismissOnBarrierTap',
            value: _dismissOnBarrierTap,
            onChanged: (value) =>
                _updateState(() => _dismissOnBarrierTap = value),
          ),
          _SwitchRow(
            title: 'Back Dismiss',
            techKey: 'dismissOnBackKeyPress',
            value: _dismissOnBackKeyPress,
            onChanged: (value) =>
                _updateState(() => _dismissOnBackKeyPress = value),
          ),
          _SwitchRow(
            title: 'Snap',
            techKey: 'enableSnap',
            value: _enableSnap,
            onChanged: (value) => _updateState(() => _enableSnap = value),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPresetCard(BuildContext context) {
    return _SectionCard(
      title: 'Scenarios',
      child: Column(
        children: [
          _ScenarioButton(label: 'Default', onPressed: _openDefault),
          const SizedBox(height: 8),
          _ScenarioButton(label: 'Overflow Scroll', onPressed: _openOverflow),
          const SizedBox(height: 8),
          _ScenarioButton(
              label: 'Keyboard TextField', onPressed: _openKeyboard),
          const SizedBox(height: 8),
          _ScenarioButton(label: 'Nested', onPressed: _openNested),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.subtitle4().copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.techKey,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  final String title;
  final String techKey;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
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
            activeColor: colors.main,
            inactiveColor: colors.grey300,
          ),
        ],
      ),
    );
  }
}

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
