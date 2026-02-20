import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

import '../model/color_catalog_models.dart';

class ColorCategoryTabs extends StatelessWidget {
  final List<ColorCategoryItem> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const ColorCategoryTabs({
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
          "Color Categories",
          style: context.subtitle4().copyWith(color: context.fitColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategory == category.name;
            return FitChip(
              isSelected: isSelected,
              onTap: () => onCategorySelected(category.name),
              backgroundColor: context.fitColors.backgroundElevated,
              selectedBackgroundColor: context.fitColors.main.withValues(alpha: 0.14),
              borderColor: context.fitColors.dividerPrimary,
              selectedBorderColor: context.fitColors.main,
              borderRadius: 8,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 16,
                    color: isSelected
                        ? context.fitColors.main
                        : context.fitColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.name,
                    style: context.body4().copyWith(
                      color: isSelected
                          ? context.fitColors.main
                          : context.fitColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
