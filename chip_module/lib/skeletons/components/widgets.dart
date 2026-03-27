import 'dart:math';

import 'package:flutter/material.dart';

import 'shimmer.dart';
import 'stylings.dart';

part 'skeleton.dart';

class FitSkeletonItem extends StatelessWidget {
  final Widget child;

  const FitSkeletonItem({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (FitShimmer.of(context) == null) {
      return FitShimmerWidget(
        child: _FitSkeletonWidget(
          isLoading: true, skeleton: child,
          //  child: SizedBox()
        ),
      );
    }

    return child;
  }
}

class FitSkeletonAvatar extends StatelessWidget {
  final FitSkeletonAvatarStyle style;

  const FitSkeletonAvatar({super.key, this.style = const FitSkeletonAvatarStyle()});

  @override
  Widget build(BuildContext context) {
    return FitSkeletonItem(
      child: Padding(
        padding: style.padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: ((style.randomWidth != null && style.randomWidth!) ||
                      (style.randomWidth == null && (style.minWidth != null && style.maxWidth != null)))
                  ? doubleInRange(style.minWidth ?? ((style.maxWidth ?? constraints.maxWidth) / 3),
                      style.maxWidth ?? constraints.maxWidth)
                  : style.width,
              height: ((style.randomHeight != null && style.randomHeight!) ||
                      (style.randomHeight == null && (style.minHeight != null && style.maxHeight != null)))
                  ? doubleInRange(style.minHeight ?? ((style.maxHeight ?? constraints.maxHeight) / 3),
                      style.maxHeight ?? constraints.maxHeight)
                  : style.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: style.shape,
                borderRadius: style.shape != BoxShape.circle ? style.borderRadius : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class FitSkeletonLine extends StatelessWidget {
  final FitSkeletonLineStyle style;

  const FitSkeletonLine({super.key, this.style = const FitSkeletonLineStyle()});

  @override
  Widget build(BuildContext context) {
    return FitSkeletonItem(
      child: Align(
        alignment: style.alignment,
        child: Padding(
            // padding: style.randomLength
            //     ? EdgeInsetsDirectional.only(
            //         end: 0.0 +
            //             Random().nextInt(
            //                 (MediaQuery.of(context).size.width / 2).round()))
            padding: style.padding,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: ((style.randomLength != null && style.randomLength!) ||
                          (style.randomLength == null && (style.minLength != null && style.maxLength != null)))
                      ? doubleInRange(style.minLength ?? ((style.maxLength ?? constraints.maxWidth) / 3),
                          style.maxLength ?? constraints.maxWidth)
                      : style.width,
                  height: style.height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: style.borderRadius,
                  ),
                );
              },
            )),
      ),
    );
  }
}

class FitSkeletonParagraph extends StatelessWidget {
  final FitSkeletonParagraphStyle style;

  const FitSkeletonParagraph({
    super.key,
    this.style = const FitSkeletonParagraphStyle(),
  });

  @override
  Widget build(BuildContext context) {
    return FitSkeletonItem(
      child: Padding(
        padding: style.padding,
        child: Column(
          children: [
            for (var i = 1; i <= style.lines; i++) ...[
              FitSkeletonLine(
                style: style.lineStyle,
              ),
              if (i != style.lines)
                SizedBox(
                  height: style.spacing,
                )
            ]
          ],
        ),
      ),
    );
  }
}

class FitSkeletonListTile extends StatelessWidget {
  final bool hasLeading;
  final FitSkeletonAvatarStyle? leadingStyle;
  final FitSkeletonLineStyle? titleStyle;
  final bool hasSubtitle;
  final FitSkeletonLineStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final double? contentSpacing;
  final double? verticalSpacing;
  final Widget? trailing;

  // final FitSkeletonListTileStyle style;

  const FitSkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.leadingStyle, //  = const FitSkeletonAvatarStyle(padding: EdgeInsets.all(0)),
    this.titleStyle = const FitSkeletonLineStyle(
      padding: EdgeInsets.all(0),
      height: 22,
    ),
    this.subtitleStyle = const FitSkeletonLineStyle(
      height: 16,
      padding: EdgeInsetsDirectional.only(end: 32),
    ),
    this.hasSubtitle = false,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.contentSpacing = 8,
    this.verticalSpacing = 8,
    this.trailing,
  });

  // : assert(height >= lineHeight + spacing + (padding?.vertical ?? 16) + 2);

  @override
  Widget build(BuildContext context) {
    return FitSkeletonItem(
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasLeading)
              FitSkeletonAvatar(
                style: leadingStyle ?? const FitSkeletonAvatarStyle(),
              ),
            SizedBox(
              width: contentSpacing,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FitSkeletonLine(
                    style: titleStyle ?? const FitSkeletonLineStyle(),
                  ),
                  if (hasSubtitle) ...[
                    SizedBox(
                      height: verticalSpacing,
                    ),
                    FitSkeletonLine(
                      style: subtitleStyle ?? const FitSkeletonLineStyle(),
                    ),
                  ]
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class FitSkeletonListView extends StatelessWidget {
  final Widget? item;
  final Widget Function(BuildContext, int)? itemBuilder;
  final int? itemCount;
  final bool scrollable;
  final EdgeInsets? padding;
  final double? spacing;

  const FitSkeletonListView({
    super.key,
    this.item,
    this.itemBuilder,
    this.itemCount,
    this.scrollable = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return FitSkeletonItem(
      child: ListView.builder(
        padding: padding,
        physics: scrollable ? null : const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: itemBuilder ??
            (context, index) =>
                item ??
                const FitSkeletonListTile(
                  hasSubtitle: true,
                ),
      ),
    );
  }
}

double doubleInRange(num start, num end) => Random().nextDouble() * (end - start) + start;
