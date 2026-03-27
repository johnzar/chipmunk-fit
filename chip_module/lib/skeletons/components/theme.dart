import 'package:flutter/material.dart';

class FitSkeletonTheme extends InheritedWidget {
  final LinearGradient? shimmerGradient;
  final LinearGradient? darkShimmerGradient;
  final ThemeMode? themeMode;

  const FitSkeletonTheme({
    super.key,
    required super.child,
    this.shimmerGradient,
    this.darkShimmerGradient,
    this.themeMode,
  });

  static FitSkeletonTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FitSkeletonTheme>();

  @override
  bool updateShouldNotify(FitSkeletonTheme oldWidget) =>
      oldWidget.themeMode != themeMode ||
      oldWidget.shimmerGradient != shimmerGradient ||
      oldWidget.darkShimmerGradient != darkShimmerGradient;
}
