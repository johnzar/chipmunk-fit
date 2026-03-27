part of 'widgets.dart';

class FitSkeleton2 extends StatefulWidget {
  const FitSkeleton2({
    super.key,
    required this.isLoading,
    required this.skeleton,
    required this.child,
    this.shimmerGradient,
    this.darkShimmerGradient,
    this.duration,
    this.themeMode,
  });

  final bool isLoading;
  final Widget skeleton;
  final Widget child;
  final LinearGradient? shimmerGradient;
  final LinearGradient? darkShimmerGradient;
  final Duration? duration;
  final ThemeMode? themeMode;

  @override
  _FitSkeletonState createState() => _FitSkeletonState();
}

class _FitSkeletonState extends State<FitSkeleton2> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: widget.isLoading
          ? FitShimmerWidget(
              shimmerGradient: widget.shimmerGradient,
              darkShimmerGradient: widget.darkShimmerGradient,
              duration: widget.duration,
              themeMode: widget.themeMode,
              child: _FitSkeletonWidget(
                isLoading: widget.isLoading,
                // child: widget.child,
                skeleton: widget.skeleton,
              ),
            )
          : widget.child,
    );
  }
}

class _FitSkeletonWidget extends StatefulWidget {
  const _FitSkeletonWidget({
    required this.isLoading,
    required this.skeleton,
    // required this.child,
  });

  final bool isLoading;
  final Widget skeleton;

  // final Widget child;

  @override
  __FitSkeletonWidgetState createState() => __FitSkeletonWidgetState();
}

class __FitSkeletonWidgetState extends State<_FitSkeletonWidget> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = FitShimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {
        // update the shimmer painting.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (!widget.isLoading) {
    //   return widget.child;
    // }

    // Collect ancestor shimmer info.
    final shimmer = FitShimmer.of(context)!;
    if (!shimmer.isSized) {
      // The ancestor Shimmer widget has not laid
      // itself out yet. Return an empty box.
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.currentGradient;

    if (context.findRenderObject() == null) return const SizedBox();

    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.skeleton,
    );
  }
}
