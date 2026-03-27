part of 'fit_bottom_sheet.dart';

class _FitSingleBottomSheet extends StatefulWidget {
  const _FitSingleBottomSheet({
    required this.config,
    required this.contentBuilder,
  });

  final FitBottomSheetConfig config;
  final Widget Function(BuildContext) contentBuilder;

  @override
  State<_FitSingleBottomSheet> createState() => _FitSingleBottomSheetState();
}

class _FitSingleBottomSheetState extends State<_FitSingleBottomSheet> {
  static const _kCollapsedCapRatio = 0.72;
  static const _kExtentEpsilon = 0.004;
  static const _kSnapAnimationDuration = Duration(milliseconds: 220);
  static const _kFlingVelocityThreshold = 700.0;
  static const _kDismissDragThreshold = 32.0;

  final GlobalKey _measureKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();
  final GlobalKey _sheetSurfaceKey = GlobalKey();
  final GlobalKey _dragHandleKey = GlobalKey();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  double? _measuredHeight;
  double _collapsedSize = 0.0;
  bool _dismissGestureStartedAtCollapsed = false;
  double _dismissDragDistance = 0.0;
  double _handleDragCloseOffset = 0.0;
  bool _isHandleDragging = false;
  bool _isClosing = false;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  bool _isAtCollapsedExtent() {
    if (!_sheetController.isAttached) return false;
    return (_sheetController.size - _collapsedSize).abs() <= _kExtentEpsilon;
  }

  void _closeSheet() {
    if (_isClosing || !mounted) return;
    _isClosing = true;
    Navigator.of(context).maybePop().then((didPop) {
      if (!didPop && mounted) {
        _isClosing = false;
      }
    });
  }

  /// dim 영역 탭 시 키보드가 열려 있으면 먼저 키보드만 내립니다.
  void _handleDismissAreaTap() {
    final viewInsets = MediaQueryData.fromView(View.of(context)).viewInsets;
    if (viewInsets.bottom > 0) {
      FocusManager.instance.primaryFocus?.unfocus();
      return;
    }
    _closeSheet();
  }

  bool _isOutsideSheet(Offset globalPosition) {
    final dragHandleContext = _dragHandleKey.currentContext;
    if (dragHandleContext != null) {
      final handleRender = dragHandleContext.findRenderObject();
      if (handleRender is RenderBox && handleRender.hasSize) {
        final handleTop = handleRender.localToGlobal(Offset.zero).dy;
        return globalPosition.dy < handleTop;
      }
    }

    final surfaceContext = _sheetSurfaceKey.currentContext;
    if (surfaceContext == null) return false;

    final renderObject = surfaceContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return false;

    final topLeft = renderObject.localToGlobal(Offset.zero);
    final rect = topLeft & renderObject.size;
    return !rect.contains(globalPosition);
  }

  Widget _wrapWithDismissPointerLayer({required Widget child}) {
    if (!widget.config.dismissOnBarrierTap) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if (_isOutsideSheet(event.position)) {
                _handleDismissAreaTap();
              }
            },
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }

  void _handleDismissGestureStart() {
    _dismissGestureStartedAtCollapsed = _isAtCollapsedExtent();
    _dismissDragDistance = 0.0;
  }

  void _handleDismissGestureMove(PointerMoveEvent event) {
    if (!widget.config.isDismissible) {
      return;
    }

    // 펼쳐진 상태에서 시작했더라도, 드래그 중 접힘 extent에 도달하면
    // 같은 제스처에서 바로 닫힘 드래그를 이어받습니다.
    if (!_dismissGestureStartedAtCollapsed &&
        _isAtCollapsedExtent() &&
        event.delta.dy > 0) {
      _dismissGestureStartedAtCollapsed = true;
    }

    if (!_dismissGestureStartedAtCollapsed) {
      return;
    }

    if (event.delta.dy > 0) {
      _dismissDragDistance += event.delta.dy;
      return;
    }

    if (event.delta.dy < 0) {
      _dismissDragDistance = 0.0;
    }
  }

  void _handleDismissGestureEnd() {
    final shouldDismiss =
        widget.config.isDismissible &&
        _dismissGestureStartedAtCollapsed &&
        _dismissDragDistance >= _kDismissDragThreshold;

    _dismissGestureStartedAtCollapsed = false;
    _dismissDragDistance = 0.0;

    if (shouldDismiss) {
      _closeSheet();
    }
  }

  /// 현재 레이아웃 높이를 측정해 snap / scroll 전환 기준으로 사용합니다.
  void _captureMeasuredHeight(double maxSheetHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final renderObject = _measureKey.currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) return;

      final measured = renderObject.size.height.clamp(0.0, maxSheetHeight);
      if (measured <= 0) return;

      final next = measured.toDouble();
      final prev = _measuredHeight;
      if (prev == null || (prev - next).abs() > 0.5) {
        setState(() => _measuredHeight = next);
      }
    });
  }

  double _resolveCollapsedHeight(double maxSheetHeight) {
    final measured = (_measuredHeight ?? maxSheetHeight).clamp(
      0.0,
      maxSheetHeight,
    );

    if (!widget.config.enableSnap) return measured.toDouble();
    return math.min(measured.toDouble(), maxSheetHeight * _kCollapsedCapRatio);
  }

  bool _canUseSnap(double maxSheetHeight) {
    if (!widget.config.enableSnap || _measuredHeight == null) return false;
    final measured = _measuredHeight!;
    final collapsedCap = maxSheetHeight * _kCollapsedCapRatio;
    if (measured <= collapsedCap + 1.0) {
      // wrap-content가 충분히 작은 경우에는 snap을 켜지 않습니다.
      return false;
    }

    final collapsed = _resolveCollapsedHeight(maxSheetHeight);
    return maxSheetHeight - collapsed > 1.0;
  }

  bool _isSelfManagedScrollableLayout(Widget content) {
    if (content is FitBottomSheetSelfManagedBody) {
      return true;
    }
    if (content is KeyedSubtree) {
      return _isSelfManagedScrollableLayout(content.child);
    }
    if (content is! Flex) return false;
    return content.children.any((child) => child is Expanded);
  }

  Widget _buildAutoBody(Widget content, {required bool useNaturalSize}) {
    if (content is ScrollView) return content;
    if (_isSelfManagedScrollableLayout(content)) return content;
    if (useNaturalSize) return content;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: content,
    );
  }

  Widget _buildSnapBody(Widget content, ScrollController scrollController) {
    if (content is ScrollView || _isSelfManagedScrollableLayout(content)) {
      return PrimaryScrollController(
        controller: scrollController,
        child: content,
      );
    }

    return PrimaryScrollController(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        child: content,
      ),
    );
  }

  void _onTopBarDragUpdate(DragUpdateDetails details, double maxSheetHeight) {
    if (maxSheetHeight <= 0) return;

    final delta = details.primaryDelta ?? 0.0;
    if (delta == 0) return;

    if (!_sheetController.isAttached) {
      final next = (_handleDragCloseOffset + delta).clamp(
        0.0,
        maxSheetHeight * 0.4,
      );
      if (next != _handleDragCloseOffset) {
        setState(() => _handleDragCloseOffset = next.toDouble());
      }
      return;
    }

    if (_isAtCollapsedExtent() && delta > 0) {
      setState(() {
        _handleDragCloseOffset = (_handleDragCloseOffset + delta).clamp(
          0.0,
          maxSheetHeight * 0.4,
        );
      });
      return;
    }

    if (_handleDragCloseOffset > 0) {
      final nextOffset = (_handleDragCloseOffset + delta).clamp(
        0.0,
        double.infinity,
      );
      setState(() => _handleDragCloseOffset = nextOffset.toDouble());
      if (_handleDragCloseOffset > 0) {
        return;
      }
    }

    final next = (_sheetController.size - (delta / maxSheetHeight))
        .clamp(_collapsedSize, 1.0)
        .toDouble();
    _sheetController.jumpTo(next);
  }

  void _onTopBarDragEnd(DragEndDetails details) {
    _isHandleDragging = false;

    if (widget.config.isDismissible &&
        _handleDragCloseOffset >= _kDismissDragThreshold) {
      _closeSheet();
      return;
    }

    if (_handleDragCloseOffset > 0) {
      setState(() => _handleDragCloseOffset = 0.0);
      return;
    }

    if (!_sheetController.isAttached || !widget.config.enableSnap) return;

    final velocity = details.primaryVelocity ?? 0.0;
    final current = _sheetController.size;

    if (velocity < -_kFlingVelocityThreshold) {
      _sheetController.animateTo(
        1.0,
        duration: _kSnapAnimationDuration,
        curve: Curves.easeOutCubic,
      );
      return;
    }

    if (widget.config.isDismissible &&
        _isAtCollapsedExtent() &&
        velocity > _kFlingVelocityThreshold) {
      _closeSheet();
      return;
    }

    final collapseMid = (_collapsedSize + 1.0) / 2.0;

    final target = current >= collapseMid ? 1.0 : _collapsedSize;
    _sheetController.animateTo(
      target,
      duration: _kSnapAnimationDuration,
      curve: Curves.easeOutCubic,
    );
  }

  void _onTopBarDragStart(DragStartDetails _) {
    _isHandleDragging = true;
  }

  void _onTopBarDragCancel() {
    _isHandleDragging = false;
    if (_handleDragCloseOffset > 0) {
      setState(() => _handleDragCloseOffset = 0.0);
    }
  }

  Widget _buildSheetShell({
    required BuildContext context,
    required Widget body,
    required double bottomInset,
    bool expandBody = true,
    bool enableTopBarDrag = false,
    bool enableBodyDrag = false,
    void Function(DragStartDetails)? onTopBarDragStart,
    void Function(DragUpdateDetails)? onTopBarDragUpdate,
    void Function(DragEndDetails)? onTopBarDragEnd,
    VoidCallback? onTopBarDragCancel,
  }) {
    final topBar = !widget.config.isShowTopBar
        ? null
        : enableTopBarDrag
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragStart: onTopBarDragStart,
            onVerticalDragUpdate: onTopBarDragUpdate,
            onVerticalDragEnd: onTopBarDragEnd,
            onVerticalDragCancel: onTopBarDragCancel,
            child: FitBottomSheet.buildTopBar(
              context,
              handleKey: _dragHandleKey,
            ),
          )
        : FitBottomSheet.buildTopBar(context, handleKey: _dragHandleKey);

    final draggableBody = enableBodyDrag
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragStart: onTopBarDragStart,
            onVerticalDragUpdate: onTopBarDragUpdate,
            onVerticalDragEnd: onTopBarDragEnd,
            onVerticalDragCancel: onTopBarDragCancel,
            child: body,
          )
        : body;

    return Listener(
      onPointerDown: (_) => _handleDismissGestureStart(),
      onPointerMove: _handleDismissGestureMove,
      onPointerUp: (_) => _handleDismissGestureEnd(),
      onPointerCancel: (_) => _handleDismissGestureEnd(),
      child: Container(
        key: _sheetSurfaceKey,
        clipBehavior: Clip.hardEdge,
        decoration: FitBottomSheet.buildDecoration(
          context,
          widget.config.backgroundColor,
        ),
        child: Stack(
          children: [
            if (expandBody)
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (topBar != null) topBar,
                  Expanded(child: draggableBody),
                  SizedBox(height: bottomInset),
                ],
              )
            else
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (topBar != null) topBar,
                    draggableBody,
                    SizedBox(height: bottomInset),
                  ],
                ),
              ),
            if (widget.config.isShowCloseButton)
              Positioned(
                top: 16,
                right: 20,
                child: FitBottomSheet.buildCloseButton(
                  context,
                  onTap: _closeSheet,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSheet({
    required double maxSheetHeight,
    required double keyboardInset,
    required Widget child,
  }) {
    // 키보드 인셋은 플랫폼 애니메이션을 그대로 따라가고,
    // 시트 자체는 닫기 드래그 오프셋만 애니메이션 처리합니다.
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: AnimatedSlide(
        duration: _isHandleDragging
            ? Duration.zero
            : const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        offset: Offset(
          0,
          maxSheetHeight <= 0 ? 0 : (_handleDragCloseOffset / maxSheetHeight),
        ),
        child: SizedBox(
          height: maxSheetHeight,
          child: _wrapWithDismissPointerLayer(child: child),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rootQuery = MediaQueryData.fromView(View.of(context));
    final topInset = rootQuery.padding.top;
    final safeBottomInset = rootQuery.padding.bottom;
    final keyboardInset = rootQuery.viewInsets.bottom;
    final isKeyboardVisible = keyboardInset > 0;

    // 키보드 전환 중에도 하단 safe 영역을 유지해
    // 시트가 네비게이션 바 영역을 침범했다가 복귀하는 덜컹임을 방지합니다.
    final bottomInset = safeBottomInset;
    final maxSheetHeight = math.max(
      0.0,
      rootQuery.size.height - topInset - keyboardInset,
    );

    if (maxSheetHeight <= 0) return const SizedBox.shrink();

    final content = widget.contentBuilder(context);
    final isSelfManagedContent = _isSelfManagedScrollableLayout(content);
    final persistedContent = KeyedSubtree(key: _contentKey, child: content);

    if (!isKeyboardVisible) {
      _captureMeasuredHeight(maxSheetHeight);
    }

    final canSnap = !isKeyboardVisible && _canUseSnap(maxSheetHeight);
    if (!canSnap) {
      final needsScrollBody =
          isKeyboardVisible ||
          (_measuredHeight != null &&
              _measuredHeight! >= (maxSheetHeight - 1.0));

      final sheetContent = Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          key: _measureKey,
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          child: _buildSheetShell(
            context: context,
            body: _buildAutoBody(
              persistedContent,
              useNaturalSize: !needsScrollBody,
            ),
            bottomInset: bottomInset,
            expandBody: isSelfManagedContent && needsScrollBody,
            enableTopBarDrag: true,
            enableBodyDrag: !needsScrollBody,
            onTopBarDragStart: _onTopBarDragStart,
            onTopBarDragUpdate: (details) =>
                _onTopBarDragUpdate(details, maxSheetHeight),
            onTopBarDragEnd: _onTopBarDragEnd,
            onTopBarDragCancel: _onTopBarDragCancel,
          ),
        ),
      );

      return _buildAnimatedSheet(
        maxSheetHeight: maxSheetHeight,
        keyboardInset: keyboardInset,
        child: sheetContent,
      );
    }

    final collapsedSize =
        (_resolveCollapsedHeight(maxSheetHeight) / maxSheetHeight)
            .clamp(0.08, 1.0)
            .toDouble();
    _collapsedSize = collapsedSize;

    final snapEnabled = widget.config.enableSnap && collapsedSize < 0.999;

    return _buildAnimatedSheet(
      maxSheetHeight: maxSheetHeight,
      keyboardInset: keyboardInset,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: DraggableScrollableSheet(
          controller: _sheetController,
          expand: false,
          initialChildSize: collapsedSize,
          minChildSize: collapsedSize,
          maxChildSize: 1.0,
          snap: snapEnabled,
          snapSizes: snapEnabled ? <double>[collapsedSize, 1.0] : null,
          shouldCloseOnMinExtent: false,
          builder: (sheetContext, scrollController) {
            return _buildSheetShell(
              context: sheetContext,
              body: _buildSnapBody(persistedContent, scrollController),
              bottomInset: bottomInset,
              enableTopBarDrag: true,
              onTopBarDragStart: _onTopBarDragStart,
              onTopBarDragUpdate: (details) =>
                  _onTopBarDragUpdate(details, maxSheetHeight),
              onTopBarDragEnd: _onTopBarDragEnd,
              onTopBarDragCancel: _onTopBarDragCancel,
            );
          },
        ),
      ),
    );
  }
}
