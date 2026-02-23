part of 'scaffold_page.dart';

extension _ScaffoldPageScenarioMethods on _ScaffoldPageState {
  /// Leading AppBar 시나리오
  Widget _buildLeadingAppBarScenario(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: _leadingTitle,
        centerTitle: _leadingCenterTitle,
        leftAlignTitle: _leadingLeftAlign,
        leadingIcon: _leadingCustomIcon
            ? Icon(Icons.close, color: context.fitColors.grey900)
            : null,
        onLeadingPressed: () => Navigator.of(context).pop(),
        actions: _leadingHasActions
            ? [
                IconButton(
                  icon: Icon(Icons.settings, color: context.fitColors.grey900),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: context.fitColors.grey900),
                  onPressed: () {},
                ),
              ]
            : null,
      ),
      body: _buildControlPanel(
        context,
        'Leading AppBar',
        [
          _buildTextField(
            context,
            'Title',
            _leadingTitle,
            (value) => _updateState(() => _leadingTitle = value),
          ),
          const SizedBox(height: 16),
          _buildSwitch(
            context,
            'Center Title',
            _leadingCenterTitle,
            (value) => _updateState(() => _leadingCenterTitle = value),
          ),
          const SizedBox(height: 12),
          _buildSwitch(
            context,
            'Left Align Title',
            _leadingLeftAlign,
            (value) => _updateState(() => _leadingLeftAlign = value),
          ),
          const SizedBox(height: 12),
          _buildSwitch(
            context,
            'Custom Icon (Close)',
            _leadingCustomIcon,
            (value) => _updateState(() => _leadingCustomIcon = value),
          ),
          const SizedBox(height: 12),
          _buildSwitch(
            context,
            'Show Actions',
            _leadingHasActions,
            (value) => _updateState(() => _leadingHasActions = value),
          ),
        ],
      ),
    );
  }

  /// Basic AppBar 시나리오
  Widget _buildBasicAppBarScenario(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitBasicAppBar(
        title: _basicTitle,
        centerTitle: _basicCenterTitle,
        actions: _basicHasActions
            ? [
                IconButton(
                  icon: Icon(Icons.search, color: context.fitColors.grey900),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.notifications_none,
                      color: context.fitColors.grey900),
                  onPressed: () {},
                ),
              ]
            : null,
      ),
      body: _buildControlPanel(
        context,
        'Basic AppBar',
        [
          Row(
            children: [
              Expanded(
                child: _buildBackButton(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            context,
            'Title',
            _basicTitle,
            (value) => _updateState(() => _basicTitle = value),
          ),
          const SizedBox(height: 16),
          _buildSwitch(
            context,
            'Center Title',
            _basicCenterTitle,
            (value) => _updateState(() => _basicCenterTitle = value),
          ),
          const SizedBox(height: 12),
          _buildSwitch(
            context,
            'Show Actions',
            _basicHasActions,
            (value) => _updateState(() => _basicHasActions = value),
          ),
          const SizedBox(height: 16),
          _buildInfoBox(
            context,
            'Basic AppBar는 자동 뒤로가기 버튼이 없습니다. 메인 화면에 적합합니다.',
          ),
        ],
      ),
    );
  }

  /// Empty AppBar 시나리오
  Widget _buildEmptyAppBarScenario(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: _emptyCustomColors
          ? FitEmptyAppBar.custom(
              statusBarColor: context.fitColors.main,
              systemNavigationBarColor: context.fitColors.red500,
              backgroundColor: context.fitColors.backgroundAlternative,
            )
          : FitEmptyAppBar(context.fitColors.backgroundAlternative),
      body: _buildControlPanel(
        context,
        'Empty AppBar',
        [
          Row(
            children: [
              Expanded(
                child: _buildBackButton(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoBox(
            context,
            'Empty AppBar는 높이 0으로 보이지 않지만, Android에서 상태바와 네비게이션바 색상을 제어합니다.',
          ),
          const SizedBox(height: 16),
          _buildSwitch(
            context,
            'Custom Colors',
            _emptyCustomColors,
            (value) => _updateState(() => _emptyCustomColors = value),
          ),
          if (_emptyCustomColors) ...[
            const SizedBox(height: 16),
            _buildColorInfo(context, 'Status Bar', context.fitColors.main),
            const SizedBox(height: 8),
            _buildColorInfo(
                context, 'Navigation Bar', context.fitColors.red500),
            const SizedBox(height: 8),
            _buildColorInfo(
                context, 'Background', context.fitColors.backgroundAlternative),
          ] else ...[
            const SizedBox(height: 16),
            _buildColorInfo(context, 'All Same Color',
                context.fitColors.backgroundAlternative),
          ],
        ],
      ),
    );
  }

  /// Extended AppBar 시나리오
  Widget _buildExtendedAppBarScenario(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // MediaQuery padding을 제거하여 상태바 영역부터 시작
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: EdgeInsets.zero,
        viewPadding: EdgeInsets.zero,
      ),
      child: Material(
        color: _extendedBackgroundColor ?? context.fitColors.main,
        child: Column(
          children: [
            // Extended AppBar (상태바 영역 포함)
            Container(
              color: _extendedBackgroundColor ?? context.fitColors.main,
              child: Column(
                children: [
                  SizedBox(height: statusBarHeight),
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        if (_extendedCenterTitle) const Spacer(),
                        if (_extendedTitle.isNotEmpty)
                          Expanded(
                            child: Text(
                              _extendedTitle,
                              style: context
                                  .subtitle2()
                                  .copyWith(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: _extendedCenterTitle
                                  ? TextAlign.center
                                  : TextAlign.left,
                            ),
                          ),
                        if (_extendedCenterTitle) const Spacer(),
                        if (_extendedHasActions) ...[
                          IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Expanded(
              child: Container(
                color: context.fitColors.backgroundAlternative,
                child: _buildControlPanel(
                  context,
                  'Extended AppBar',
                  [
                    _buildInfoBox(
                      context,
                      'Extended AppBar는 iOS처럼 상태바 영역까지 배경색이 확장됩니다. 실제 컨텐츠(아이콘, 타이틀)는 SafeArea 안쪽에 배치됩니다.',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      context,
                      'Title',
                      _extendedTitle,
                      (value) => _updateState(() => _extendedTitle = value),
                    ),
                    const SizedBox(height: 16),
                    _buildSwitch(
                      context,
                      'Center Title',
                      _extendedCenterTitle,
                      (value) =>
                          _updateState(() => _extendedCenterTitle = value),
                    ),
                    const SizedBox(height: 12),
                    _buildSwitch(
                      context,
                      'Left Align Title',
                      _extendedLeftAlign,
                      (value) => _updateState(() => _extendedLeftAlign = value),
                    ),
                    const SizedBox(height: 12),
                    _buildSwitch(
                      context,
                      'Show Actions',
                      _extendedHasActions,
                      (value) =>
                          _updateState(() => _extendedHasActions = value),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Background Colors',
                      style: context.subtitle5().copyWith(
                            color: context.fitColors.grey900,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildColorChip(
                            context,
                            'Main',
                            context.fitColors.main,
                            _extendedBackgroundColor == null ||
                                _extendedBackgroundColor ==
                                    context.fitColors.main),
                        _buildColorChip(
                            context,
                            'Periwinkle',
                            context.fitColors.periwinkle500,
                            _extendedBackgroundColor ==
                                context.fitColors.periwinkle500),
                        _buildColorChip(
                            context,
                            'Red',
                            context.fitColors.red500,
                            _extendedBackgroundColor ==
                                context.fitColors.red500),
                        _buildColorChip(
                            context,
                            'Green',
                            context.fitColors.green500,
                            _extendedBackgroundColor ==
                                context.fitColors.green500),
                        _buildColorChip(
                            context,
                            'Grey',
                            context.fitColors.grey700,
                            _extendedBackgroundColor ==
                                context.fitColors.grey700),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Loading 시나리오
  Widget _buildLoadingScenario(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'Loading States',
        onLeadingPressed: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        children: [
          // 컨트롤 패널 (항상 표시)
          _buildControlPanel(
            context,
            'Loading States',
            [
              _buildSwitch(
                context,
                'Show Loading',
                _isLoading,
                (value) => _updateState(() => _isLoading = value),
              ),
              const SizedBox(height: 12),
              _buildSwitch(
                context,
                'Custom Loading Widget',
                _customLoadingWidget,
                (value) => _updateState(() => _customLoadingWidget = value),
              ),
              const SizedBox(height: 16),
              _buildInfoBox(
                context,
                '로딩을 활성화하면 컨텐츠 영역 위에 로딩 오버레이가 표시됩니다. 컨트롤은 항상 접근 가능합니다.',
              ),
              const SizedBox(height: 24),
              // 로딩 프리뷰 영역
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: context.fitColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.fitColors.grey300,
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        'Content Area',
                        style: context.body2().copyWith(
                              color: context.fitColors.grey500,
                            ),
                      ),
                    ),
                    // 로딩 오버레이
                    if (_isLoading)
                      Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: Center(
                          child: _customLoadingWidget
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: context.fitColors.red500,
                                      strokeWidth: 3,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Custom Loading...',
                                      style: context.subtitle5().copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                )
                              : CircularProgressIndicator(
                                  color: context.fitColors.main,
                                ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Bottom Elements 시나리오
  Widget _buildBottomElementsScenario(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'Bottom Elements',
        onLeadingPressed: () => Navigator.of(context).pop(),
      ),
      drawer: _hasDrawer ? _buildDrawer(context, 'Drawer') : null,
      endDrawer: _hasEndDrawer ? _buildDrawer(context, 'End Drawer') : null,
      bottomNavigationBar: _hasBottomNavBar
          ? BottomNavigationBar(
              currentIndex: 0,
              selectedItemColor: context.fitColors.main,
              unselectedItemColor: context.fitColors.grey400,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
      floatingActionButton: _hasFAB
          ? FloatingActionButton(
              backgroundColor: context.fitColors.main,
              onPressed: () {},
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: _getFABLocation(),
      body: _buildControlPanel(
        context,
        'Bottom Elements',
        [
          Text(
            'Drawers',
            style: context.subtitle5().copyWith(
                  color: context.fitColors.grey900,
                ),
          ),
          const SizedBox(height: 12),
          _buildSwitch(
            context,
            'Drawer (Left)',
            _hasDrawer,
            (value) => _updateState(() => _hasDrawer = value),
          ),
          const SizedBox(height: 12),
          _buildSwitch(
            context,
            'End Drawer (Right)',
            _hasEndDrawer,
            (value) => _updateState(() => _hasEndDrawer = value),
          ),
          const SizedBox(height: 20),
          Text(
            'FitBottomSheet',
            style: context.subtitle5().copyWith(
                  color: context.fitColors.grey900,
                ),
          ),
          const SizedBox(height: 12),
          _buildInfoBox(
            context,
            'FitBottomSheet는 단일 show API를 사용합니다. wrap-content로 시작하고, 초과 시 body 스크롤로 동작합니다.',
          ),
          const SizedBox(height: 12),
          // Bottom Sheet Options
          _buildSwitch(
            context,
            'Show Top Bar',
            _bottomSheetShowTopBar,
            (value) => _updateState(() => _bottomSheetShowTopBar = value),
          ),
          const SizedBox(height: 8),
          _buildSwitch(
            context,
            'Show Close Button',
            _bottomSheetShowCloseButton,
            (value) => _updateState(() => _bottomSheetShowCloseButton = value),
          ),
          const SizedBox(height: 8),
          _buildSwitch(
            context,
            'Is Dismissible',
            _bottomSheetIsDismissible,
            (value) => _updateState(() => _bottomSheetIsDismissible = value),
          ),
          const SizedBox(height: 8),
          _buildSwitch(
            context,
            'Dismiss On Barrier Tap',
            _bottomSheetDismissOnBarrierTap,
            (value) =>
                _updateState(() => _bottomSheetDismissOnBarrierTap = value),
          ),
          const SizedBox(height: 8),
          _buildSwitch(
            context,
            'Enable Snap',
            _bottomSheetEnableSnap,
            (value) => _updateState(() => _bottomSheetEnableSnap = value),
          ),
          const SizedBox(height: 12),
          // Show Bottom Sheet Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showFitBottomSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.fitColors.main,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Show Bottom Sheet',
                style: context.body2().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Other Bottom Elements',
            style: context.subtitle5().copyWith(
                  color: context.fitColors.grey900,
                ),
          ),
          const SizedBox(height: 12),
          _buildSwitch(
            context,
            'Bottom Navigation Bar',
            _hasBottomNavBar,
            (value) => _updateState(() => _hasBottomNavBar = value),
          ),
          const SizedBox(height: 20),
          Text(
            'Floating Action Button',
            style: context.subtitle5().copyWith(
                  color: context.fitColors.grey900,
                ),
          ),
          const SizedBox(height: 12),
          _buildSwitch(
            context,
            'Show FAB',
            _hasFAB,
            (value) => _updateState(() => _hasFAB = value),
          ),
          if (_hasFAB) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip(context, 'End Docked', _fabLocationIndex == 0,
                    () => _updateState(() => _fabLocationIndex = 0)),
                _buildChip(context, 'Center Docked', _fabLocationIndex == 1,
                    () => _updateState(() => _fabLocationIndex = 1)),
                _buildChip(context, 'End Float', _fabLocationIndex == 2,
                    () => _updateState(() => _fabLocationIndex = 2)),
                _buildChip(context, 'Center Float', _fabLocationIndex == 3,
                    () => _updateState(() => _fabLocationIndex = 3)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// SafeArea 시나리오
  Widget _buildSafeAreaScenario(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return FitScaffold(
      padding: EdgeInsets.zero,
      removeAppBar: true, // AppBar 제거하여 SafeArea 효과 확인
      top: _safeAreaTop,
      bottom: _safeAreaBottom,
      body: Column(
        children: [
          // Top status bar indicator (상태바 영역 표시)
          Container(
            height: _safeAreaTop ? 0 : statusBarHeight,
            color: context.fitColors.red500.withValues(alpha: 0.5),
            child: _safeAreaTop
                ? null
                : Center(
                    child: Text(
                      'Status Bar Area',
                      style: context.caption1().copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
          ),

          // Custom AppBar (for navigation)
          Container(
            height: 56,
            color: context.fitColors.backgroundAlternative,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                IconButton(
                  icon: ChipAssets.icons.icArrowLeft.svg(
                    colorFilter: ColorFilter.mode(
                      context.fitColors.grey900,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  'SafeArea Test',
                  style: context.subtitle2().copyWith(
                        color: context.fitColors.grey900,
                      ),
                ),
              ],
            ),
          ),

          // Top content indicator
          Container(
            height: 80,
            color: context.fitColors.main.withValues(alpha: 0.2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SafeArea Top: $_safeAreaTop',
                    style: context.body2().copyWith(
                          color: context.fitColors.grey900,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (!_safeAreaTop)
                    Text(
                      '위에 빨간 영역이 상태바 영역입니다',
                      style: context.caption1().copyWith(
                            color: context.fitColors.grey600,
                          ),
                    ),
                ],
              ),
            ),
          ),

          // Control panel
          Expanded(
            child: _buildControlPanel(
              context,
              'SafeArea Test',
              [
                _buildInfoBox(
                  context,
                  'AppBar를 제거하여 SafeArea 효과를 확인합니다. Top을 false로 설정하면 빨간색 상태바 영역이 표시됩니다.',
                ),
                const SizedBox(height: 16),
                _buildSwitch(
                  context,
                  'SafeArea Top',
                  _safeAreaTop,
                  (value) => _updateState(() => _safeAreaTop = value),
                ),
                const SizedBox(height: 12),
                _buildSwitch(
                  context,
                  'SafeArea Bottom',
                  _safeAreaBottom,
                  (value) => _updateState(() => _safeAreaBottom = value),
                ),
                const SizedBox(height: 16),
                _buildInfoBox(
                  context,
                  'SafeArea를 비활성화하면 콘텐츠가 노치, 상태바, 홈 인디케이터 영역까지 확장됩니다.',
                ),
              ],
            ),
          ),

          // Bottom indicator
          Container(
            height: 80,
            color: context.fitColors.main.withValues(alpha: 0.2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SafeArea Bottom: $_safeAreaBottom',
                    style: context.body2().copyWith(
                          color: context.fitColors.grey900,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (!_safeAreaBottom)
                    Text(
                      '아래에 초록색 영역이 홈 인디케이터 영역입니다',
                      style: context.caption1().copyWith(
                            color: context.fitColors.grey600,
                          ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom home indicator area (홈 인디케이터 영역 표시)
          Container(
            height: _safeAreaBottom ? 0 : bottomPadding,
            color: context.fitColors.green500.withValues(alpha: 0.5),
            child: _safeAreaBottom
                ? null
                : Center(
                    child: Text(
                      'Home Indicator Area',
                      style: context.caption1().copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
