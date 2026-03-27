import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:catalog/presentation/component/button/view/animated_bottom_button_bottomsheet_panel.dart';
import 'package:catalog/presentation/component/button/view/animated_bottom_button_control_panel.dart';
import 'package:catalog/presentation/component/button/view/animated_bottom_button_keyboard_panel.dart';
import 'package:chip_component/button/fit_animated_bottom_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/bottomsheet/fit_bottom_sheet.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

class AnimatedBottomButtonPage extends StatefulWidget {
  const AnimatedBottomButtonPage({super.key});

  @override
  State<AnimatedBottomButtonPage> createState() =>
      _AnimatedBottomButtonPageState();
}

class _AnimatedBottomButtonPageState extends State<AnimatedBottomButtonPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _keyboardController;
  late final FocusNode _keyboardFocusNode;

  FitButtonType _selectedType = FitButtonType.primary;
  bool _isEnabled = true;
  bool _isLoading = false;
  bool _useSafeArea = true;
  bool _isKeyboardFocused = false;
  int _maxLines = 1;

  String get _buttonLabel {
    final text = _labelController.text.trim();
    return text.isEmpty ? '확인' : text;
  }

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: '확인');
    _keyboardController = TextEditingController();
    _keyboardFocusNode = FocusNode();

    _labelController.addListener(_onStateChanged);
    _keyboardFocusNode.addListener(_onKeyboardFocusChanged);
  }

  @override
  void dispose() {
    _labelController
      ..removeListener(_onStateChanged)
      ..dispose();
    _keyboardController.dispose();
    _keyboardFocusNode
      ..removeListener(_onKeyboardFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _onKeyboardFocusChanged() {
    if (!mounted) return;
    setState(() => _isKeyboardFocused = _keyboardFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      resizeToAvoidBottomInset: true,
      appBar: FitLeadingAppBar(
        title: 'AnimatedBottomButton',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
              child: Column(
                children: [
                  AnimatedBottomButtonControlPanel(
                    selectedType: _selectedType,
                    onTypeChanged: (value) =>
                        setState(() => _selectedType = value),
                    maxLines: _maxLines,
                    onMaxLinesChanged: (value) =>
                        setState(() => _maxLines = value),
                    isEnabled: _isEnabled,
                    onEnabledChanged: (value) =>
                        setState(() => _isEnabled = value),
                    isLoading: _isLoading,
                    onLoadingChanged: (value) =>
                        setState(() => _isLoading = value),
                    useSafeArea: _useSafeArea,
                    onUseSafeAreaChanged: (value) =>
                        setState(() => _useSafeArea = value),
                    labelController: _labelController,
                  ),
                  const SizedBox(height: 16),
                  AnimatedBottomButtonKeyboardPanel(
                    controller: _keyboardController,
                    focusNode: _keyboardFocusNode,
                    onRequestFocus: _keyboardFocusNode.requestFocus,
                    onClearFocus: () => FocusScope.of(context).unfocus(),
                    isFocused: _isKeyboardFocused,
                  ),
                  const SizedBox(height: 16),
                  AnimatedBottomButtonBottomSheetPanel(
                    onShowBasic: _showBasicBottomSheet,
                    onShowOverflow: _showOverflowBottomSheet,
                  ),
                ],
              ),
            ),
          ),
          FitAnimatedBottomButton(
            type: _selectedType,
            isEnabled: _isEnabled,
            isLoading: _isLoading,
            useSafeArea: _useSafeArea,
            maxLines: _maxLines,
            onPressed: () => _showSnackBar('버튼 클릭됨'),
            child: Text(_buttonLabel, style: context.button1()),
          ),
        ],
      ),
    );
  }

  void _showBasicBottomSheet() {
    _lockKeyboardTestFocus();

    FitBottomSheet.show(
      context,
      config: const FitBottomSheetConfig(
        isShowTopBar: true,
        isShowCloseButton: false,
      ),
      onClosed: _unlockKeyboardTestFocus,
      content: (sheetContext) {
        return _BasicBottomSheetContent(
          buttonType: _selectedType,
          buttonLabel: _buttonLabel,
          maxLines: _maxLines,
          onSubmit: (value) {
            Navigator.pop(sheetContext);
            _showSnackBar('입력값: $value');
          },
        );
      },
    );
  }

  void _showOverflowBottomSheet() {
    _lockKeyboardTestFocus();

    FitBottomSheet.show(
      context,
      config: const FitBottomSheetConfig(isShowCloseButton: true),
      onClosed: _unlockKeyboardTestFocus,
      content: (sheetContext) {
        return _DraggableBottomSheetContent(
          onSubmit: (value) {
            Navigator.pop(sheetContext);
            _showSnackBar('입력값: $value');
          },
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _lockKeyboardTestFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    _keyboardFocusNode.unfocus();
    _keyboardFocusNode.canRequestFocus = false;
  }

  void _unlockKeyboardTestFocus() {
    if (!mounted) return;
    _keyboardFocusNode.canRequestFocus = true;
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class _BasicBottomSheetContent extends StatefulWidget {
  const _BasicBottomSheetContent({
    required this.buttonType,
    required this.buttonLabel,
    required this.maxLines,
    required this.onSubmit,
  });

  final FitButtonType buttonType;
  final String buttonLabel;
  final int maxLines;
  final ValueChanged<String> onSubmit;

  @override
  State<_BasicBottomSheetContent> createState() =>
      _BasicBottomSheetContentState();
}

class _BasicBottomSheetContentState extends State<_BasicBottomSheetContent> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Basic + TextField', style: context.h2()),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                decoration: _textFieldDecoration(context),
                style: context.body3().copyWith(color: colors.textPrimary),
              ),
            ],
          ),
        ),
        FitAnimatedBottomButton(
          type: widget.buttonType,
          maxLines: widget.maxLines,
          useSafeArea: false,
          backgroundColor: colors.backgroundElevated,
          onPressed: () => widget.onSubmit(_controller.text),
          child: Text(widget.buttonLabel, style: context.button1()),
        ),
      ],
    );
  }
}

class _DraggableBottomSheetContent extends StatefulWidget
    implements FitBottomSheetSelfManagedBody {
  const _DraggableBottomSheetContent({required this.onSubmit});

  final ValueChanged<String> onSubmit;

  @override
  State<_DraggableBottomSheetContent> createState() =>
      _DraggableBottomSheetContentState();
}

class _DraggableBottomSheetContentState
    extends State<_DraggableBottomSheetContent> {
  late final TextEditingController _controller;

  Widget _buildOverflowList(
    BuildContext context,
    FitColors colors, {
    required bool scrollable,
  }) {
    final primaryController = PrimaryScrollController.maybeOf(context);

    return ListView.builder(
      controller: scrollable ? primaryController : null,
      primary: false,
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      itemCount: 20,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colors.fillAlternative,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('Item ${index + 1}', style: context.body3()),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight = constraints.hasBoundedHeight;

        return Column(
          mainAxisSize: hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overflow Scroll + TextField', style: context.h2()),
                  const SizedBox(height: 10),
                  Text(
                    '콘텐츠가 길면 body 스크롤, 스냅은 접힘/펼침으로 동작합니다.',
                    style: context.body4().copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    decoration: _textFieldDecoration(context),
                    style: context.body3().copyWith(color: colors.textPrimary),
                  ),
                ],
              ),
            ),
            if (hasBoundedHeight)
              Expanded(
                child: _buildOverflowList(context, colors, scrollable: true),
              )
            else
              SizedBox(
                height: 240,
                child: _buildOverflowList(context, colors, scrollable: true),
              ),
            SizedBox(height: keyboardVisible ? 0 : 16),
            FitAnimatedBottomButton(
              type: FitButtonType.secondary,
              useSafeArea: false,
              backgroundColor: colors.backgroundElevated,
              onPressed: () => widget.onSubmit(_controller.text),
              child: Text('닫기', style: context.button1()),
            ),
          ],
        );
      },
    );
  }
}

InputDecoration _textFieldDecoration(BuildContext context, {String? hintText}) {
  final colors = context.fitColors;

  return InputDecoration(
    hintText: hintText ?? '입력하세요',
    hintStyle: context.body4().copyWith(color: colors.textTertiary),
    filled: true,
    fillColor: colors.fillAlternative,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    isDense: true,
  );
}
