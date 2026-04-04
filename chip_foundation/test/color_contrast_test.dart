import 'package:chip_foundation/color_contrast.dart';
import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FitColorContrast', () {
    test('returns textPrimary when contrast meets minimum', () {
      final palette = lightFitColors;
      final resolved = palette.resolvePrimaryTextOn(palette.grey0);

      expect(resolved, palette.textPrimary);
      expect(palette.contrastRatio(palette.grey0, resolved), greaterThanOrEqualTo(4.5));
    });

    test('falls back to inverseText when textPrimary fails', () {
      final palette = lightFitColors;
      final resolved = palette.resolvePrimaryTextOn(palette.grey900);

      expect(resolved, palette.inverseText);
      expect(palette.contrastRatio(palette.grey900, resolved), greaterThanOrEqualTo(4.5));
    });

    test('secondary excludes primary and picks best available candidate', () {
      final palette = darkFitColors;
      final background = palette.violet500;
      final primary = palette.resolvePrimaryTextOn(background);
      final resolved = palette.resolveSecondaryTextOn(
        background,
        primary: primary,
      );

      final candidates = <Color>[
        palette.textSecondary,
        palette.textTertiary,
        palette.textDisabled,
        palette.inverseDisabled,
        palette.inverseText,
      ].where((c) => c != primary).toList();

      Color expected = candidates.first;
      double best = palette.contrastRatio(background, expected);
      for (final candidate in candidates.skip(1)) {
        final ratio = palette.contrastRatio(background, candidate);
        if (ratio > best) {
          expected = candidate;
          best = ratio;
        }
      }

      expect(resolved, expected);
      expect(resolved == primary, isFalse);
    });

    test('blendOn uses alpha-blended background for resolution', () {
      final palette = darkFitColors;
      final alphaColor = palette.violetAlpha12;
      final blended = Color.alphaBlend(alphaColor, palette.backgroundBase);

      final withBlend = palette.resolvePrimaryTextOn(
        alphaColor,
        blendOn: palette.backgroundBase,
      );
      final manual = palette.resolvePrimaryTextOn(blended);
      final withoutBlend = palette.resolvePrimaryTextOn(alphaColor);

      expect(withBlend, manual);
      expect(
        palette.contrastRatio(alphaColor, withBlend),
        isNot(palette.contrastRatio(blended, withBlend)),
      );
      // Ensure both paths are exercised, even if selected color matches in some palettes.
      expect(withoutBlend, isNotNull);
    });
  });
}
