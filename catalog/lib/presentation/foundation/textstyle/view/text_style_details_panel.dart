import 'dart:math';

import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/text_style_catalog_models.dart';

class TextStyleDetailsPanel extends StatelessWidget {
  const TextStyleDetailsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final systemSpValue = 16.sp;
    final systemSpMinValue = min(16.0, systemSpValue);
    final systemSpMaxValue = max(16.0, systemSpValue);
    final screenSize = MediaQuery.of(context).size;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

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
            style: context.subtitle5().copyWith(color: context.fitColors.textPrimary),
          ),
          subtitle: Text(
            "FitTextSp · Device · Simulation",
            style: context.caption1().copyWith(color: context.fitColors.textSecondary),
          ),
          leading: Icon(Icons.tune, color: context.fitColors.main, size: 20),
          children: [
            _SectionTitle(title: "FitTextSp"),
            const SizedBox(height: 8),
            const _TypeDescription(
              item: TextTypeDescription(
                type: "MIN",
                description: "기본값(16.0)과 화면 비례값 중 작은 값",
                usage: "작은 화면에서 텍스트가 너무 커지는 것을 방지",
              ),
            ),
            const SizedBox(height: 10),
            const _TypeDescription(
              item: TextTypeDescription(
                type: "MAX",
                description: "기본값(16.0)과 화면 비례값 중 큰 값",
                usage: "큰 화면에서 텍스트가 너무 작아지는 것을 방지",
              ),
            ),
            const SizedBox(height: 10),
            const _TypeDescription(
              item: TextTypeDescription(
                type: "SP",
                description: "화면 크기에 비례한 값 그대로 사용",
                usage: "모든 화면 크기에 완벽하게 비례",
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: context.fitColors.dividerPrimary),
            const SizedBox(height: 12),
            _SectionTitle(title: "Device"),
            const SizedBox(height: 8),
            _SystemValue(
              label: "화면 크기",
              value: "${screenSize.width.toStringAsFixed(0)} × ${screenSize.height.toStringAsFixed(0)}",
            ),
            _SystemValue(label: "화면 배율", value: "${devicePixelRatio}x"),
            const SizedBox(height: 6),
            _SystemValue(label: "16.sp (SP)", value: systemSpValue.toStringAsFixed(2)),
            _SystemValue(label: "16.sp (MIN)", value: systemSpMinValue.toStringAsFixed(2)),
            _SystemValue(label: "16.sp (MAX)", value: systemSpMaxValue.toStringAsFixed(2)),
            if (systemSpValue == systemSpMinValue && systemSpValue == systemSpMaxValue) ...[
              const SizedBox(height: 6),
              Text(
                "현재 화면에서는 MIN/MAX/SP 값이 동일합니다.",
                style: context.caption1().copyWith(
                  color: context.fitColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Divider(color: context.fitColors.dividerPrimary),
            const SizedBox(height: 12),
            _SectionTitle(title: "Simulation"),
            const SizedBox(height: 8),
            const _SimulationList(),
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

  const _SystemValue({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: context.caption1().copyWith(color: context.fitColors.textSecondary),
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

class _TypeDescription extends StatelessWidget {
  final TextTypeDescription item;

  const _TypeDescription({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.type,
                style: context.caption1().copyWith(color: context.fitColors.textPrimary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.description,
                  style: context.caption1().copyWith(
                    color: context.fitColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            item.usage,
            style: context.caption1().copyWith(
              color: context.fitColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulationList extends StatelessWidget {
  const _SimulationList();

  static const _devices = [
    SimulationDevice(name: "iPhone SE", width: 375, height: 667),
    SimulationDevice(name: "iPhone 14", width: 390, height: 844),
    SimulationDevice(name: "iPhone 14 Pro Max", width: 430, height: 932),
    SimulationDevice(name: "Galaxy S24", width: 412, height: 915),
    SimulationDevice(name: "Galaxy S24 Ultra", width: 480, height: 1067),
    SimulationDevice(name: "iPad Air", width: 820, height: 1180),
    SimulationDevice(name: "iPad Pro 12.9", width: 1024, height: 1366),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.fitColors.backgroundBase,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _devices.map((device) => _SimulationRow(device: device)).toList(),
      ),
    );
  }
}

class _SimulationRow extends StatelessWidget {
  final SimulationDevice device;

  const _SimulationRow({required this.device});

  @override
  Widget build(BuildContext context) {
    final scaleWidth = device.width / 375.0;
    final scaleHeight = device.height / 812.0;
    final scale = min(scaleWidth, scaleHeight);

    final spValue = 16.0 * scale;
    final minValue = min(16.0, spValue);
    final maxValue = max(16.0, spValue);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.fitColors.dividerPrimary),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                device.width < 700 ? Icons.phone_iphone : Icons.tablet_mac,
                size: 14,
                color: context.fitColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  device.name,
                  style: context.caption1().copyWith(color: context.fitColors.textPrimary),
                ),
              ),
              Text(
                "${device.width.toInt()}×${device.height.toInt()}",
                style: context.caption1().copyWith(
                  color: context.fitColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _ValueChip(label: "MIN", value: minValue, highlight: minValue != spValue),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ValueChip(label: "MAX", value: maxValue, highlight: maxValue != spValue),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ValueChip(label: "SP", value: spValue, highlight: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueChip extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _ValueChip({
    required this.label,
    required this.value,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return FitChip(
      isSelected: highlight,
      onTap: () {},
      backgroundColor: context.fitColors.backgroundBase,
      selectedBackgroundColor: context.fitColors.main.withValues(alpha: 0.08),
      borderColor: context.fitColors.dividerPrimary,
      selectedBorderColor: context.fitColors.main.withValues(alpha: 0.4),
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      pressedScale: 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.caption1().copyWith(
              color: context.fitColors.textSecondary,
              fontSize: 9,
            ),
          ),
          Text(
            value.toStringAsFixed(1),
            style: context.caption1().copyWith(
              color: highlight ? context.fitColors.main : context.fitColors.textPrimary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
