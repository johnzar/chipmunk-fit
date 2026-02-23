import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_component/button/fit_button.dart';
import 'package:chip_component/button/fit_switch_button.dart';
import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/fit_dialog.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _subTitleController;

  bool _dismissOnTouchOutside = false;
  bool _dismissOnBackKeyPress = true;
  bool _showCancelButton = false;
  FitButtonType _confirmButtonType = FitButtonType.primary;
  FitButtonType _cancelButtonType = FitButtonType.tertiary;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: '알림');
    _subTitleController = TextEditingController(text: '다이얼로그 내용입니다.');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitDialog',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          children: [
            _SectionCard(
              title: 'Global Controls',
              child: Column(
                children: [
                  _SwitchRow(
                    title: 'Dismiss Outside',
                    techKey: 'dismissOnTouchOutside',
                    value: _dismissOnTouchOutside,
                    onChanged: (value) =>
                        setState(() => _dismissOnTouchOutside = value),
                  ),
                  _SwitchRow(
                    title: 'Dismiss Back Key',
                    techKey: 'dismissOnBackKeyPress',
                    value: _dismissOnBackKeyPress,
                    onChanged: (value) =>
                        setState(() => _dismissOnBackKeyPress = value),
                  ),
                  _SwitchRow(
                    title: 'Show Cancel',
                    techKey: 'showCancelButton',
                    value: _showCancelButton,
                    onChanged: (value) =>
                        setState(() => _showCancelButton = value),
                    isLast: true,
                  ),
                  const SizedBox(height: 12),
                  _ButtonTypeSelector(
                    title: 'Confirm Type',
                    value: _confirmButtonType,
                    onChanged: (value) =>
                        setState(() => _confirmButtonType = value),
                  ),
                  const SizedBox(height: 8),
                  _ButtonTypeSelector(
                    title: 'Cancel Type',
                    value: _cancelButtonType,
                    onChanged: (value) =>
                        setState(() => _cancelButtonType = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Dialog Content',
              child: Column(
                children: [
                  _InputField(
                    label: 'Title',
                    controller: _titleController,
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    label: 'Subtitle',
                    controller: _subTitleController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Scenarios',
              child: Column(
                children: [
                  _ScenarioButton(
                    label: 'Basic Confirm',
                    onPressed: _openBasicConfirm,
                  ),
                  const SizedBox(height: 8),
                  _ScenarioButton(
                    label: 'Confirm + Cancel',
                    onPressed: _openConfirmCancel,
                  ),
                  const SizedBox(height: 8),
                  _ScenarioButton(
                    label: 'Top/Bottom Content',
                    onPressed: _openTopBottomContent,
                  ),
                  const SizedBox(height: 8),
                  _ScenarioButton(
                    label: 'Error (wrapper)',
                    onPressed: _openErrorWrapper,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.fillAlternative,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '권장 API: FitDialog.show\n호환 API: showFitDialog/showErrorDialog (deprecated)',
                style: context.caption1().copyWith(color: colors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBasicConfirm() {
    FitDialog.show(
      context: context,
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      subTitle: _subTitleController.text.trim().isEmpty
          ? null
          : _subTitleController.text.trim(),
      confirmText: '확인',
      cancelText: _showCancelButton ? '취소' : null,
      onConfirm: () => _showResultSnackBar('확인 클릭'),
      onCancel: _showCancelButton ? () => _showResultSnackBar('취소 클릭') : null,
      onDismiss: () => _showResultSnackBar('다이얼로그 닫힘'),
      dismissOnTouchOutside: _dismissOnTouchOutside,
      dismissOnBackKeyPress: _dismissOnBackKeyPress,
      confirmButtonType: _confirmButtonType,
      cancelButtonType: _cancelButtonType,
    );
  }

  void _openConfirmCancel() {
    FitDialog.show(
      context: context,
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      subTitle: '이 작업을 계속하시겠습니까?',
      confirmText: '확인',
      cancelText: '취소',
      onConfirm: () => _showResultSnackBar('확인됨'),
      onCancel: () => _showResultSnackBar('취소됨'),
      dismissOnTouchOutside: _dismissOnTouchOutside,
      dismissOnBackKeyPress: _dismissOnBackKeyPress,
      confirmButtonType: _confirmButtonType,
      cancelButtonType: _cancelButtonType,
    );
  }

  void _openTopBottomContent() {
    FitDialog.show(
      context: context,
      title: '커스텀 컨텐츠',
      subTitle: _subTitleController.text.trim().isEmpty
          ? '상단/하단 컨텐츠가 포함된 다이얼로그입니다.'
          : _subTitleController.text.trim(),
      topContent: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Icon(
          Icons.info_outline,
          size: 52,
          color: context.fitColors.main,
        ),
      ),
      bottomContent: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          '* 하단 경고/가이드 컨텐츠',
          style: context
              .caption1()
              .copyWith(color: context.fitColors.textTertiary),
          textAlign: TextAlign.center,
        ),
      ),
      confirmText: '확인',
      cancelText: _showCancelButton ? '취소' : null,
      onConfirm: () => _showResultSnackBar('확인 클릭'),
      onCancel: _showCancelButton ? () => _showResultSnackBar('취소 클릭') : null,
      dismissOnTouchOutside: _dismissOnTouchOutside,
      dismissOnBackKeyPress: _dismissOnBackKeyPress,
      confirmButtonType: _confirmButtonType,
      cancelButtonType: _cancelButtonType,
    );
  }

  void _openErrorWrapper() {
    // Deprecated wrapper 회귀 검증 시나리오
    // ignore: deprecated_member_use
    FitDialog.showErrorDialog(
      context: context,
      message: '에러가 발생했습니다.',
      description: _subTitleController.text.trim().isEmpty
          ? '잠시 후 다시 시도해 주세요.'
          : _subTitleController.text.trim(),
      onPress: () => _showResultSnackBar('에러 확인 클릭'),
      onDismiss: () => _showResultSnackBar('에러 다이얼로그 닫힘'),
      dismissOnTouchOutside: _dismissOnTouchOutside,
      dismissOnBackKeyPress: _dismissOnBackKeyPress,
    );
  }

  void _showResultSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
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

class _ButtonTypeSelector extends StatelessWidget {
  const _ButtonTypeSelector({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final FitButtonType value;
  final ValueChanged<FitButtonType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;
    final options = <FitButtonType>[
      FitButtonType.primary,
      FitButtonType.secondary,
      FitButtonType.tertiary,
      FitButtonType.destructive,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.body3().copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((type) {
              final selected = type == value;
              return FitChip(
                isSelected: selected,
                onSelected: (_) => onChanged(type),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                borderRadius: 8,
                borderWidth: 1,
                backgroundColor: colors.fillAlternative,
                selectedBackgroundColor: colors.main.withValues(alpha: 0.16),
                borderColor: Colors.transparent,
                selectedBorderColor: colors.main,
                child: Text(
                  type.name,
                  style: context.caption1().copyWith(
                        color: selected ? colors.main : colors.textTertiary,
                      ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.caption1().copyWith(color: colors.textTertiary),
          ),
          TextField(
            controller: controller,
            style: context.body3().copyWith(color: colors.textPrimary),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
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
      child: Text(
        label,
        style: context.button1().copyWith(
              color: FitButtonStyle.textColorOf(
                context,
                FitButtonType.secondary,
                isEnabled: true,
              ),
            ),
      ),
    );
  }
}
