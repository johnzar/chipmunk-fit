import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:catalog/presentation/component/button/view/animated_bottom_button_bottomsheet_panel.dart';
import 'package:catalog/presentation/component/button/view/animated_bottom_button_control_panel.dart';
import 'package:catalog/presentation/component/button/view/animated_bottom_button_keyboard_panel.dart';
import 'package:chip_component/button/fit_animated_bottom_button.dart';
import 'package:chip_component/button/fit_button.dart';
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
        actions: const [
          CatalogThemeSwitcher(),
          SizedBox(width: 16),
        ],
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
                    onShowDraggable: _showDraggableBottomSheet,
                    onShowMultiple: _showMultipleFieldBottomSheet,
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
            child: Text(
              _buttonLabel,
              style: context.button1(),
            ),
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

  void _showDraggableBottomSheet() {
    _lockKeyboardTestFocus();

    FitBottomSheet.showDraggable(
      context,
      config: const FitBottomSheetConfig(
        isShowCloseButton: true,
        heightFactor: 0.55,
        minHeightFactor: 0.35,
        maxHeightFactor: 0.97,
      ),
      onClosed: _unlockKeyboardTestFocus,
      topContent: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 60, 0),
        child: Text(
          'Draggable/Full Test',
          style: sheetContext.h2(),
        ),
      ),
      scrollContent: (sheetContext) {
        return _DraggableBottomSheetContent(
          onSubmit: (value) {
            Navigator.pop(sheetContext);
            _showSnackBar('입력값: $value');
          },
        );
      },
    );
  }

  void _showMultipleFieldBottomSheet() {
    _lockKeyboardTestFocus();

    FitBottomSheet.showFull(
      context,
      config: const FitBottomSheetConfig(
        isShowCloseButton: true,
        isShowTopBar: false,
        heightFactor: 0.97,
      ),
      onClosed: _unlockKeyboardTestFocus,
      topContent: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 60, 0),
        child: Text(
          'Multiple TextFields',
          style: sheetContext.h2(),
        ),
      ),
      scrollContent: (sheetContext) {
        return _MultipleFieldBottomSheetContent(
          onSubmit: (name, email, _) {
            Navigator.pop(sheetContext);
            _showSnackBar('이름: $name, 이메일: $email');
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
              Text(
                'Basic + TextField',
                style: context.h2(),
              ),
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
          backgroundColor: colors.backgroundBase,
          onPressed: () => widget.onSubmit(_controller.text),
          child: Text(
            widget.buttonLabel,
            style: context.button1(),
          ),
        ),
      ],
    );
  }
}

class _DraggableBottomSheetContent extends StatefulWidget {
  const _DraggableBottomSheetContent({
    required this.onSubmit,
  });

  final ValueChanged<String> onSubmit;

  @override
  State<_DraggableBottomSheetContent> createState() =>
      _DraggableBottomSheetContentState();
}

class _DraggableBottomSheetContentState
    extends State<_DraggableBottomSheetContent> {
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '드래그 중에도 입력 필드와 키보드 배치가 안정적인지 확인합니다.',
            style: context.body4().copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: _textFieldDecoration(context),
            style: context.body3().copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 16),
          FitButton(
            isExpanded: true,
            type: FitButtonType.secondary,
            onPressed: () => widget.onSubmit(_controller.text),
            child: Text(
              '닫기',
              style: context.button1(),
            ),
          ),
          const SizedBox(height: 240),
        ],
      ),
    );
  }
}

class _MultipleFieldBottomSheetContent extends StatefulWidget {
  const _MultipleFieldBottomSheetContent({
    required this.onSubmit,
  });

  final void Function(String name, String email, String message) onSubmit;

  @override
  State<_MultipleFieldBottomSheetContent> createState() =>
      _MultipleFieldBottomSheetContentState();
}

class _MultipleFieldBottomSheetContentState
    extends State<_MultipleFieldBottomSheetContent> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTextField(
            controller: _nameController,
            label: 'Name',
            hint: '이름 입력',
          ),
          const SizedBox(height: 12),
          _SheetTextField(
            controller: _emailController,
            label: 'Email',
            hint: '이메일 입력',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _SheetTextField(
            controller: _messageController,
            label: 'Message',
            hint: '메시지 입력',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          FitButton(
            isExpanded: true,
            onPressed: () => widget.onSubmit(
              _nameController.text,
              _emailController.text,
              _messageController.text,
            ),
            child: Text(
              '제출',
              style: context.button1(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.subtitle6().copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: _textFieldDecoration(context, hintText: hint),
          style: context.body3().copyWith(color: colors.textPrimary),
        ),
      ],
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
