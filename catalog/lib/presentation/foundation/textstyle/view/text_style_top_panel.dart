import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/text_style_catalog_models.dart';

class TextStyleTopPanel extends StatelessWidget {
  final String previewText;
  final ValueChanged<String> onPreviewTextChanged;
  final List<TextStyleCatalogItem> previewItems;

  const TextStyleTopPanel({
    super.key,
    required this.previewText,
    required this.onPreviewTextChanged,
    required this.previewItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.fitColors.backgroundElevated,
        border: Border(
          bottom: BorderSide(color: context.fitColors.dividerPrimary, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _buildPreview(context)),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: double.infinity,
            color: context.fitColors.dividerPrimary,
          ),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _buildControls(context)),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Preview",
            style: context.caption1().copyWith(
              color: context.fitColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: previewItems.length,
              separatorBuilder: (context, index) =>
                  Divider(color: context.fitColors.dividerPrimary, height: 16),
              itemBuilder: (context, index) {
                final item = previewItems[index];
                final style = item.styleBuilder(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.toUpperCase(),
                      style: context.caption1().copyWith(
                        color: context.fitColors.textSecondary,
                        fontSize: 10,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      previewText,
                      style: style.copyWith(
                        color: context.fitColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Settings",
            style: context.caption1().copyWith(
              color: context.fitColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: onPreviewTextChanged,
            style: context.body4().copyWith(
              color: context.fitColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: "미리보기 텍스트",
              hintStyle: context.body4().copyWith(
                color: context.fitColors.textSecondary,
              ),
              filled: true,
              fillColor: context.fitColors.backgroundBase,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: context.fitColors.dividerPrimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: context.fitColors.dividerPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: context.fitColors.main,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
