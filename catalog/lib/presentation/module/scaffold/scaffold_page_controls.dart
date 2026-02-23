part of 'scaffold_page.dart';

extension _ScaffoldPageControlMethods on _ScaffoldPageState {
  /// 컨트롤 패널 (공통)
  Widget _buildControlPanel(
      BuildContext context, String title, List<Widget> controls) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Scenario selector
          Container(
            color: context.fitColors.backgroundAlternative,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test Scenario',
                  style: context.caption1().copyWith(
                        color: context.fitColors.grey600,
                      ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scenarioScrollController,
                  child: Row(
                    children: List.generate(
                      _scenarios.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildScenarioChip(context, index),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Controls
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.h2().copyWith(
                        color: context.fitColors.grey900,
                      ),
                ),
                const SizedBox(height: 24),
                ...controls,
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 시나리오 칩
  Widget _buildScenarioChip(BuildContext context, int index) {
    final isSelected = _currentScenario == index;
    return GestureDetector(
      onTap: () {
        _updateState(() => _currentScenario = index);
        _scrollToScenario(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? context.fitColors.main : context.fitColors.grey200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _scenarios[index],
          style: context.body2().copyWith(
                color: isSelected ? Colors.white : context.fitColors.grey700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }

  /// TextField
  Widget _buildTextField(BuildContext context, String label, String value,
      ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.subtitle5().copyWith(
                color: context.fitColors.grey900,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: context.body2(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// Switch
  Widget _buildSwitch(BuildContext context, String label, bool value,
      ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.body2().copyWith(
                  color: context.fitColors.grey700,
                ),
          ),
        ),
        FitSwitchButton(
          isOn: value,
          onToggle: onChanged,
          activeColor: context.fitColors.main,
          inactiveColor: context.fitColors.grey300,
          debounceDuration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  /// Info box
  Widget _buildInfoBox(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.fitColors.main.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.fitColors.main.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: context.fitColors.main,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: context.caption1().copyWith(
                    color: context.fitColors.grey700,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Color info
  Widget _buildColorInfo(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.fitColors.grey300,
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: context.body2().copyWith(
                color: context.fitColors.grey700,
              ),
        ),
      ],
    );
  }

  /// Chip
  Widget _buildChip(
      BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected ? context.fitColors.main : context.fitColors.grey200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: context.caption1().copyWith(
                color: isSelected ? Colors.white : context.fitColors.grey700,
              ),
        ),
      ),
    );
  }

  /// Color chip
  Widget _buildColorChip(
      BuildContext context, String label, Color color, bool isSelected) {
    return GestureDetector(
      onTap: () => _updateState(() => _extendedBackgroundColor = color),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: context.caption1().copyWith(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
      ),
    );
  }

  /// Back button
  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back),
      label: const Text('Back'),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.fitColors.grey200,
        foregroundColor: context.fitColors.grey900,
      ),
    );
  }

  /// Drawer
  Widget _buildDrawer(BuildContext context, String title) {
    return Drawer(
      child: Container(
        color: context.fitColors.backgroundAlternative,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  title,
                  style: context.h2().copyWith(
                        color: context.fitColors.grey900,
                      ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: context.fitColors.grey700),
                title: Text('Home', style: context.body2()),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: context.fitColors.grey700),
                title: Text('Settings', style: context.body2()),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.help, color: context.fitColors.grey700),
                title: Text('Help', style: context.body2()),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// FAB Location
  FloatingActionButtonLocation _getFABLocation() {
    switch (_fabLocationIndex) {
      case 0:
        return FloatingActionButtonLocation.endDocked;
      case 1:
        return FloatingActionButtonLocation.centerDocked;
      case 2:
        return FloatingActionButtonLocation.endFloat;
      case 3:
        return FloatingActionButtonLocation.centerFloat;
      default:
        return FloatingActionButtonLocation.endDocked;
    }
  }
}
