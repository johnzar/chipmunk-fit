import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

import '../model/text_style_catalog_models.dart';

class TextStyleTable extends StatelessWidget {
  final String category;
  final String previewText;
  final List<TextStyleCatalogItem> items;

  const TextStyleTable({
    super.key,
    required this.category,
    required this.previewText,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$category Styles",
          style: context.subtitle4().copyWith(color: context.fitColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                "Style",
                style: context.caption1().copyWith(color: context.fitColors.textSecondary),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                "Size",
                style: context.caption1().copyWith(color: context.fitColors.textSecondary),
              ),
            ),
            Expanded(
              child: Text(
                "Preview",
                style: context.caption1().copyWith(color: context.fitColors.textSecondary),
              ),
            ),
            Text(
              "LH",
              style: context.caption1().copyWith(color: context.fitColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...items.map((item) => _StyleRow(item: item, previewText: previewText)),
      ],
    );
  }
}

class _StyleRow extends StatelessWidget {
  final TextStyleCatalogItem item;
  final String previewText;

  const _StyleRow({
    required this.item,
    required this.previewText,
  });

  @override
  Widget build(BuildContext context) {
    final style = item.styleBuilder(context);
    final fontSize = style.fontSize ?? 14;
    final lineHeight = style.height ?? 1.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.fitColors.dividerPrimary),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              item.name,
              style: context.caption1().copyWith(color: context.fitColors.textSecondary),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              "${fontSize.toStringAsFixed(0)}sp",
              style: context.caption1().copyWith(color: context.fitColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              previewText,
              style: style.copyWith(color: context.fitColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            lineHeight.toStringAsFixed(2),
            style: context.caption1().copyWith(color: context.fitColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
