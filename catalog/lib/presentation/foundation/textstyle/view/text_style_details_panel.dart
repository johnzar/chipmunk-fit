import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyleDetailsPanel extends StatelessWidget {
  const TextStyleDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);
    final systemSpValue = 16.sp;

    return Container(
      decoration: BoxDecoration(
        color: context.fitColors.backgroundElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.fitColors.dividerPrimary),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            "Details",
            style: context.subtitle5().copyWith(
              color: context.fitColors.textPrimary,
            ),
          ),
          subtitle: Text(
            "Typography scale policy (SP only)",
            style: context.caption1().copyWith(
              color: context.fitColors.textSecondary,
            ),
          ),
          leading: Icon(Icons.tune, color: context.fitColors.main, size: 20),
          children: [
            _SectionTitle(title: "Policy"),
            const SizedBox(height: 8),
            Text(
              "FitTextSp 타입은 제거되었고 모든 텍스트는 base.sp 단일 정책으로 동작합니다.",
              style: context.caption1().copyWith(
                color: context.fitColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: context.fitColors.dividerPrimary),
            const SizedBox(height: 12),
            _SectionTitle(title: "Device"),
            const SizedBox(height: 8),
            _SystemValue(
              label: "화면 크기",
              value:
                  "${screenSize.width.toStringAsFixed(0)} × ${screenSize.height.toStringAsFixed(0)}",
            ),
            _SystemValue(label: "화면 배율", value: "${devicePixelRatio}x"),
            _SystemValue(
              label: "시스템 텍스트 배율",
              value: textScaleFactor.toStringAsFixed(2),
            ),
            _SystemValue(
              label: "16.sp (SP)",
              value: systemSpValue.toStringAsFixed(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.caption1().copyWith(color: context.fitColors.textSecondary),
    );
  }
}

class _SystemValue extends StatelessWidget {
  final String label;
  final String value;

  const _SystemValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: context.caption1().copyWith(
              color: context.fitColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: context.caption1().copyWith(color: context.fitColors.main),
          ),
        ],
      ),
    );
  }
}
