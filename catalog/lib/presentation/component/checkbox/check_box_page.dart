import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_component/checkbox/fit_checkbox_style.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

import 'check_box_page_controls.dart';
import 'check_box_page_sections.dart';

/// FitCheckbox 테스트 페이지
class CheckBoxPage extends StatefulWidget {
  const CheckBoxPage({super.key});

  @override
  State<CheckBoxPage> createState() => _CheckBoxPageState();
}

class _CheckBoxPageState extends State<CheckBoxPage> {
  FitCheckboxStyle _selectedStyle = FitCheckboxStyle.material;
  double _size = 24.0;
  double _borderWidth = 1.6;

  bool _basicChecked = false;
  bool _labelLeftChecked = true;
  bool _errorChecked = false;
  final bool _disabledChecked = true;

  @override
  Widget build(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitCheckbox',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            CheckBoxPageControls(
              selectedStyle: _selectedStyle,
              onStyleChanged: (style) => setState(() => _selectedStyle = style),
              size: _size,
              onSizeChanged: (size) => setState(() => _size = size),
              borderWidth: _borderWidth,
              onBorderWidthChanged: (width) =>
                  setState(() => _borderWidth = width),
            ),
            const SizedBox(height: 16),
            CheckBoxPageSections(
              style: _selectedStyle,
              size: _size,
              borderWidth: _borderWidth,
              basicChecked: _basicChecked,
              onBasicChanged: (value) => setState(() => _basicChecked = value),
              labelLeftChecked: _labelLeftChecked,
              onLabelLeftChanged: (value) =>
                  setState(() => _labelLeftChecked = value),
              errorChecked: _errorChecked,
              onErrorChanged: (value) => setState(() => _errorChecked = value),
              disabledChecked: _disabledChecked,
            ),
          ],
        ),
      ),
    );
  }
}
