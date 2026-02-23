import 'package:chip_assets/gen/assets.gen.dart';
import 'package:chip_component/button/fit_button.dart';
import 'package:chip_component/button/fit_switch_button.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/bottomsheet/fit_bottom_sheet.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

part 'scaffold_page_scenarios.dart';
part 'scaffold_page_controls.dart';
part 'scaffold_page_bottom_sheet.dart';

/// ScaffoldPage - FitScaffold와 FitAppBar 테스트 페이지
///
/// 실제 전체 화면으로 Scaffold 기능을 테스트
class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({super.key});

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  // Test scenarios
  int _currentScenario = 0;
  final List<String> _scenarios = [
    'Leading AppBar',
    'Basic AppBar',
    'Empty AppBar',
    'Extended AppBar',
    'Loading States',
    'Bottom Elements',
    'SafeArea Test',
  ];

  // ScrollController for scenario chips
  final ScrollController _scenarioScrollController = ScrollController();

  // FitLeadingAppBar options
  String _leadingTitle = 'Leading AppBar';
  bool _leadingCenterTitle = false;
  bool _leadingLeftAlign = true;
  bool _leadingHasActions = false;
  bool _leadingCustomIcon = false;

  // FitBasicAppBar options
  String _basicTitle = 'Main Screen';
  bool _basicCenterTitle = false;
  bool _basicHasActions = false;

  // FitEmptyAppBar options
  bool _emptyCustomColors = false;

  // FitExtendedAppBar options
  String _extendedTitle = 'Extended AppBar';
  bool _extendedCenterTitle = false;
  bool _extendedLeftAlign = true;
  bool _extendedHasActions = false;
  Color? _extendedBackgroundColor;

  // Loading options
  bool _isLoading = false;
  bool _customLoadingWidget = false;

  // Bottom elements
  bool _hasBottomNavBar = false;
  bool _hasFAB = false;
  int _fabLocationIndex = 0;

  // Bottom Sheet configuration
  bool _bottomSheetShowTopBar = true;
  bool _bottomSheetShowCloseButton = false;
  bool _bottomSheetIsDismissible = true;
  bool _bottomSheetDismissOnBarrierTap = true;
  bool _bottomSheetEnableSnap = true;

  // SafeArea
  bool _safeAreaTop = true;
  bool _safeAreaBottom = true;

  // Drawer
  bool _hasDrawer = false;
  bool _hasEndDrawer = false;

  @override
  void dispose() {
    _scenarioScrollController.dispose();
    super.dispose();
  }

  void _updateState(VoidCallback update) {
    if (!mounted) return;
    setState(update);
  }

  void _scrollToScenario(int index) {
    // 다음 프레임에서 스크롤 실행 (렌더링 후)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scenarioScrollController.hasClients) return;

      // 각 chip의 실제 너비를 계산 (텍스트 길이에 따라 다름)
      final chipWidths = _scenarios.map((scenario) {
        // 대략적인 너비 계산: 텍스트 길이 * 8 + padding 32
        return (scenario.length * 8.0) + 32.0 + 8.0; // 8px spacing
      }).toList();

      // 선택된 chip까지의 총 너비 계산
      double totalWidth = 0;
      for (int i = 0; i < index; i++) {
        totalWidth += chipWidths[i];
      }

      // 선택된 chip의 중앙 위치 계산
      final selectedChipWidth = chipWidths[index];
      final selectedChipCenter = totalWidth + (selectedChipWidth / 2);

      // 화면 중앙으로 스크롤
      final screenWidth = MediaQuery.of(context).size.width;
      final targetOffset = selectedChipCenter - (screenWidth / 2);

      _scenarioScrollController.animateTo(
        targetOffset.clamp(
            0.0, _scenarioScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentScenario,
      children: [
        _buildLeadingAppBarScenario(context),
        _buildBasicAppBarScenario(context),
        _buildEmptyAppBarScenario(context),
        _buildExtendedAppBarScenario(context),
        _buildLoadingScenario(context),
        _buildBottomElementsScenario(context),
        _buildSafeAreaScenario(context),
      ],
    );
  }
}
