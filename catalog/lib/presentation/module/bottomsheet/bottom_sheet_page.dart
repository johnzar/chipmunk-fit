import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_component/button/fit_animated_bottom_button.dart';
import 'package:chip_component/button/fit_button.dart';
import 'package:chip_component/button/fit_switch_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/bottomsheet/fit_bottom_sheet.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

part 'bottom_sheet_page_panels.dart';
part 'bottom_sheet_page_content_basic.dart';
part 'bottom_sheet_page_content_interactive.dart';

class BottomSheetPage extends StatefulWidget {
  const BottomSheetPage({super.key});

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> {
  bool _isShowTopBar = true;
  bool _isShowCloseButton = false;
  bool _isDismissible = true;
  bool _dismissOnBarrierTap = true;
  bool _dismissOnBackKeyPress = true;
  bool _enableSnap = true;

  FitBottomSheetConfig get _config => FitBottomSheetConfig(
        isShowTopBar: _isShowTopBar,
        isShowCloseButton: _isShowCloseButton,
        isDismissible: _isDismissible,
        dismissOnBarrierTap: _dismissOnBarrierTap,
        dismissOnBackKeyPress: _dismissOnBackKeyPress,
        enableSnap: _enableSnap,
      );

  void _updateState(VoidCallback update) {
    if (!mounted) return;
    setState(update);
  }

  @override
  Widget build(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitBottomSheet',
        actions: const [
          CatalogThemeSwitcher(),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            _buildControlCard(context),
            const SizedBox(height: 16),
            _buildPresetCard(context),
          ],
        ),
      ),
    );
  }

  void _openDefault() {
    FitBottomSheet.show(
      context,
      config: _config,
      content: (sheetContext) => _DefaultSheetContent(
        onClose: () => Navigator.pop(sheetContext),
      ),
    );
  }

  void _openOverflow() {
    FitBottomSheet.show(
      context,
      config: _config,
      content: (sheetContext) => _OverflowSheetContent(
        onClose: () => Navigator.pop(sheetContext),
      ),
    );
  }

  void _openKeyboard() {
    FitBottomSheet.show(
      context,
      config: _config,
      content: (sheetContext) => _KeyboardSheetContent(
        onClose: () => Navigator.pop(sheetContext),
      ),
    );
  }

  void _openNested() {
    FitBottomSheet.show(
      context,
      config: _config,
      content: (sheetContext) => _NestedSheetContent(
        config: _config,
        onClose: () => Navigator.pop(sheetContext),
      ),
    );
  }
}
