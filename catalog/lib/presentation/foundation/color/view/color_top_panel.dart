import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/color_contrast.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorTopPanel extends StatelessWidget {
  final FitColors colors;
  final String selectedCategory;
  final int totalColors;
  final bool isDarkTheme;

  const ColorTopPanel({
    super.key,
    required this.colors,
    required this.selectedCategory,
    required this.totalColors,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: context.fitColors.backgroundElevated,
        border: Border(
          bottom: BorderSide(
            color: context.fitColors.dividerPrimary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildPreview(context),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: context.fitColors.dividerPrimary,
                    width: 1,
                  ),
                ),
              ),
              child: _buildControls(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Color Preview",
            style: context.subtitle5().copyWith(color: context.fitColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _previewBox(context, colors.main, "Main"),
                _previewBox(context, colors.backgroundBase, "BG"),
                _previewBox(context, colors.textPrimary, "Text1"),
                _previewBox(context, colors.textSecondary, "Text2"),
                _previewBox(context, colors.grey500, "Grey"),
                _previewBox(context, colors.green500, "Green"),
                _previewBox(context, colors.red500, "Red"),
                _previewBox(context, colors.yellowBase, "Yellow"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewBox(BuildContext context, Color color, String label) {
    final labelColor = colors.resolvePrimaryTextOn(
      color,
      blendOn: colors.backgroundBase,
    );
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: context.fitColors.dividerPrimary.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: context.caption1().copyWith(color: labelColor, fontSize: 10),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Settings",
            style: context.subtitle5().copyWith(color: context.fitColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.tune, color: context.fitColors.main, size: 18),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: context.fitColors.fillAlternative,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: context.fitColors.dividerPrimary),
                ),
                child: Text(
                  isDarkTheme ? "Theme: Dark" : "Theme: Light",
                  style: context.caption1().copyWith(color: context.fitColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: context.fitColors.dividerPrimary),
          const SizedBox(height: 12),
          _statusRow(context, "Category", selectedCategory, Icons.category),
          const SizedBox(height: 8),
          _statusRow(context, "Total Colors", "$totalColors", Icons.palette),
        ],
      ),
    );
  }

  Widget _statusRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 14, color: context.fitColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: context.caption1().copyWith(color: context.fitColors.textSecondary),
              children: [
                TextSpan(text: "$label: "),
                TextSpan(
                  text: value,
                  style: context.caption1().copyWith(color: context.fitColors.main),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
