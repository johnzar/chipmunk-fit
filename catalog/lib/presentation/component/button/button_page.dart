import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:catalog/presentation/component/button/view/button_control_panel.dart';
import 'package:catalog/presentation/component/button/view/button_matrix_panel.dart';
import 'package:catalog/presentation/component/button/view/button_preview_panel.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  FitButtonType _selectedType = FitButtonType.primary;
  bool _isEnabled = true;
  bool _isLoading = false;
  bool _isExpanded = false;
  bool _enableRipple = false;
  int _maxLines = 1;
  late final TextEditingController _textController;

  String get _buttonText {
    final value = _textController.text.trim();
    return value.isEmpty ? '버튼' : value;
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '버튼');
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  void _showPressedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedType.name} 버튼 클릭됨'),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _showDisabledSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('비활성화된 버튼 클릭됨'),
        backgroundColor: context.fitColors.red500,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitButton',
        actions: const [
          CatalogThemeSwitcher(),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: ButtonPreviewPanel(
              buttonText: _buttonText,
              maxLines: _maxLines,
              selectedType: _selectedType,
              isEnabled: _isEnabled,
              isLoading: _isLoading,
              isExpanded: _isExpanded,
              enableRipple: _enableRipple,
              onPressed: _showPressedSnackBar,
              onDisabledPressed: _showDisabledSnackBar,
            ),
          ),
          Container(height: 8, color: colors.backgroundAlternative),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  ButtonControlPanel(
                    selectedType: _selectedType,
                    onTypeSelected: (type) =>
                        setState(() => _selectedType = type),
                    maxLines: _maxLines,
                    onMaxLinesChanged: (value) =>
                        setState(() => _maxLines = value),
                    isEnabled: _isEnabled,
                    onEnabledChanged: (value) =>
                        setState(() => _isEnabled = value),
                    isLoading: _isLoading,
                    onLoadingChanged: (value) =>
                        setState(() => _isLoading = value),
                    isExpanded: _isExpanded,
                    onExpandedChanged: (value) =>
                        setState(() => _isExpanded = value),
                    enableRipple: _enableRipple,
                    onRippleChanged: (value) =>
                        setState(() => _enableRipple = value),
                    textController: _textController,
                  ),
                  const SizedBox(height: 16),
                  ButtonMatrixPanel(
                    buttonText: _buttonText,
                    maxLines: _maxLines,
                    selectedType: _selectedType,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
