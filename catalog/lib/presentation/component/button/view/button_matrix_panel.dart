import 'package:catalog/presentation/component/button/model/button_catalog_models.dart';
import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

class ButtonMatrixPanel extends StatelessWidget {
  const ButtonMatrixPanel({
    super.key,
    required this.buttonText,
    required this.maxLines,
    required this.selectedType,
  });

  final String buttonText;
  final int maxLines;
  final FitButtonType selectedType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MatrixCard(
          title: 'Spec & Matrix',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeMatrix(context),
              const SizedBox(height: 16),
              _buildStateMatrix(context),
              const SizedBox(height: 16),
              _buildCustomStyleCase(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeMatrix(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type Matrix',
          style: context.subtitle5().copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        ...buttonTypeMetas.map((meta) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(
                    meta.label,
                    style: context
                        .caption1()
                        .copyWith(color: colors.textSecondary),
                  ),
                ),
                Expanded(
                  child: FitButton(
                    type: meta.type,
                    maxLines: maxLines,
                    isExpanded: true,
                    onPressed: () {},
                    child: Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: context.button1(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStateMatrix(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: colors.dividerPrimary),
        const SizedBox(height: 12),
        Text(
          'State Matrix (${buttonTypeLabel(selectedType)})',
          style: context.subtitle5().copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        ...buttonStateMetas.map((meta) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(
                    meta.label,
                    style: context
                        .caption1()
                        .copyWith(color: colors.textSecondary),
                  ),
                ),
                Expanded(
                  child: FitButton(
                    type: selectedType,
                    maxLines: maxLines,
                    isExpanded: true,
                    isEnabled: meta.isEnabled,
                    isLoading: meta.isLoading,
                    onPressed: () {},
                    child: Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: context.button1(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCustomStyleCase(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: colors.dividerPrimary),
        const SizedBox(height: 12),
        Text(
          'Custom Style Case',
          style: context.subtitle5().copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        FitButton(
          type: selectedType,
          maxLines: maxLines,
          isExpanded: true,
          onPressed: () {},
          style: FitButtonStyle.styleFrom(
            backgroundColor: colors.violet500,
            foregroundColor: colors.staticWhite,
            disabledBackgroundColor: colors.violet50,
            disabledForegroundColor: colors.textDisabled,
            borderRadius: 14,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          child: Text(
            '$buttonText (custom style)',
            textAlign: TextAlign.center,
            style: context.button1(),
          ),
        ),
      ],
    );
  }
}

class _MatrixCard extends StatelessWidget {
  const _MatrixCard({
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
