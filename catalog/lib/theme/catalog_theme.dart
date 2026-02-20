import 'package:chip_assets/gen/colors.gen.dart';
import 'package:chip_foundation/theme.dart';
import 'package:flutter/material.dart';

ThemeData catalogLightTheme(BuildContext context) {
  return fitLightTheme(
    context,
    mainColor: ChipColors.violet500,
    subColor: ChipColors.blue500,
    buttonForegroundColor: ChipColors.staticWhite,
    buttonDisabledBackgroundColor: ChipColors.violet50,
  );
}

ThemeData catalogDarkTheme(BuildContext context) {
  return fitDarkTheme(
    context,
    mainColor: ChipColors.violet500Dark,
    subColor: ChipColors.blue500Dark,
    buttonForegroundColor: ChipColors.staticWhite,
    buttonDisabledBackgroundColor: ChipColors.violet50Dark,
  );
}
