import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/color_contrast.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/color_catalog_models.dart';

class ColorTokenList extends StatelessWidget {
  final String selectedCategory;
  final List<ColorTokenItem> items;
  final FitColors palette;

  const ColorTokenList({
    super.key,
    required this.selectedCategory,
    required this.items,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$selectedCategory Colors",
          style: context.subtitle4().copyWith(color: context.fitColors.textPrimary),
        ),
        const SizedBox(height: 12),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ColorTile(item: item, palette: palette),
          );
        }),
      ],
    );
  }
}

class _ColorTile extends StatelessWidget {
  final ColorTokenItem item;
  final FitColors palette;

  const _ColorTile({
    required this.item,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final hexColor = '#${item.color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    final primaryText = palette.resolvePrimaryTextOn(
      item.color,
      blendOn: palette.backgroundBase,
    );
    final secondaryText = palette.resolveSecondaryTextOn(
      item.color,
      primary: primaryText,
      blendOn: palette.backgroundBase,
    );

    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: hexColor));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$hexColor copied'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: context.fitColors.dividerPrimary, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: context.caption1().copyWith(color: primaryText),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hexColor,
                    style: context.caption1().copyWith(
                      color: secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.copy,
              color: secondaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
