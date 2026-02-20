import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorGuidePanel extends StatelessWidget {
  const ColorGuidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.fitColors.backgroundElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.fitColors.dividerPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: context.fitColors.main, size: 20),
              const SizedBox(width: 8),
              Text(
                "컬러 시스템 가이드",
                style: context.subtitle5().copyWith(color: context.fitColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "• Semantic: 배경/텍스트/구분선 등 역할 기반 토큰\n"
            "• Grey Scale: 중성 톤 단계 (0-900)\n"
            "• Brand Colors: Green, Blue, Red, Yellow, Brick\n"
            "• 컬러 타일을 탭하면 HEX 코드가 복사됩니다",
            style: context.body4().copyWith(color: context.fitColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
