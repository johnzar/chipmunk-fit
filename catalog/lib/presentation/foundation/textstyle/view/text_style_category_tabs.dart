import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

class TextStyleCategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const TextStyleCategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Text Styles",
          style: context.subtitle4().copyWith(color: context.fitColors.textPrimary),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((name) {
              final isSelected = selectedCategory == name;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FitChip(
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(name),
                  backgroundColor: context.fitColors.backgroundBase,
                  selectedBackgroundColor: context.fitColors.main.withValues(alpha: 0.14),
                  borderColor: context.fitColors.dividerPrimary,
                  selectedBorderColor: context.fitColors.main,
                  borderRadius: 12,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    name,
                    style: context.body4().copyWith(
                      color: isSelected
                          ? context.fitColors.main
                          : context.fitColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
