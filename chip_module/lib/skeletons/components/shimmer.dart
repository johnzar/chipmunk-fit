// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'stylings.dart';
import 'theme.dart';

class FitShimmerWidget extends StatefulWidget {
  // static FitShimmerState? of(BuildContext context) {
  //   return context.findAncestorStateOfType<FitShimmerState>();
  // }

  const FitShimmerWidget({
    super.key,
    this.shimmerGradient,
    this.darkShimmerGradient,
    this.themeMode,
    this.duration,
    this.child,
  });

  final LinearGradient? shimmerGradient;
  final LinearGradient? darkShimmerGradient;
  final ThemeMode? themeMode;
  final Duration? duration;
  final Widget? child;

  @override
  FitShimmerState createState() => FitShimmerState();
}

class FitShimmerState extends State<FitShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  // late LinearGradient _linearGradient;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((_) => _setGradient());
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(
          min: -2.0,
          max: 2,
          period: widget.duration ?? const Duration(milliseconds: 1000));
  }

  // _setGradient() {
  //   _linearGradient = widget.linearGradient ??
  //       FitSkeletonTheme.of(context)?.shimmerGradient ??
  //       shimmerGradient;
  // }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  ThemeMode get _appThemeMode => Theme.of(context).brightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;

  @visibleForTesting
  LinearGradient get gradient => ((widget.themeMode ??
              FitSkeletonTheme.of(context)?.themeMode ??
              _appThemeMode) ==
          ThemeMode.dark)
      ? _darkGradient
      : _lightGradient;

  LinearGradient get _lightGradient =>
      widget.shimmerGradient ??
      FitSkeletonTheme.of(context)?.shimmerGradient ??
      SHIMMER_GRADIENT;

  LinearGradient get _darkGradient =>
      widget.darkShimmerGradient ??
      FitSkeletonTheme.of(context)?.darkShimmerGradient ??
      DARK_SHIMMER_GRADIENT;

  LinearGradient get currentGradient => LinearGradient(
        colors: gradient.colors,
        stops: gradient.stops,
        begin: gradient.begin,
        end: gradient.end,
        transform:
            _FitSlidingGradientTransform(slidePercent: _shimmerController.value),
      );

  bool get isSized => context.findRenderObject() != null
      ? (context.findRenderObject() as RenderBox).hasSize
      : false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return widget.child != null
        ? FitShimmer(
            shimmer: this,
            child: widget.child!,
          )
        : const SizedBox();
  }
}

class _FitSlidingGradientTransform extends GradientTransform {
  const _FitSlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class FitShimmer extends InheritedWidget {
  final FitShimmerState shimmer;
  const FitShimmer({
    super.key,
    required super.child,
    required this.shimmer,
  });

  static FitShimmerState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FitShimmer>()?.shimmer;

  @override
  bool updateShouldNotify(FitShimmer oldWidget) => shimmer != oldWidget.shimmer;
}
