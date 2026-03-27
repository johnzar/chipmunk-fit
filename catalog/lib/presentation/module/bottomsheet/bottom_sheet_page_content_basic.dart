part of 'bottom_sheet_page.dart';

class _DefaultSheetContent extends StatelessWidget {
  const _DefaultSheetContent({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Default', style: context.h2()),
              const SizedBox(height: 8),
              Text(
                'wrap-content 시작, 초과 시 body 스크롤 정책을 검증합니다.',
                style: context.body3(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FitAnimatedBottomButton(
          useSafeArea: false,
          backgroundColor: colors.backgroundElevated,
          onPressed: onClose,
          child: Text('닫기', style: context.button1()),
        ),
      ],
    );
  }
}

class _OverflowSheetContent extends StatelessWidget
    implements FitBottomSheetSelfManagedBody {
  const _OverflowSheetContent({required this.onClose});

  final VoidCallback onClose;

  Widget _buildList(
    BuildContext context,
    FitColors colors, {
    required bool scrollable,
  }) {
    final primaryController = PrimaryScrollController.maybeOf(context);

    return ListView.builder(
      controller: scrollable ? primaryController : null,
      primary: false,
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      itemCount: 50,
      itemBuilder: (context, index) {
        final i = index + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.fillAlternative,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.list, size: 16, color: colors.main),
                const SizedBox(width: 8),
                Text('Item $i', style: context.body3()),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final scrollable = constraints.hasBoundedHeight;

        return Column(
          mainAxisSize: scrollable ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overflow Scroll', style: context.h2()),
                  const SizedBox(height: 8),
                  Text('콘텐츠가 길어지면 body만 스크롤됩니다.', style: context.body3()),
                ],
              ),
            ),
            if (scrollable)
              Expanded(child: _buildList(context, colors, scrollable: true))
            else
              _buildList(context, colors, scrollable: false),
            const SizedBox(height: 16),
            FitAnimatedBottomButton(
              useSafeArea: false,
              backgroundColor: colors.backgroundElevated,
              onPressed: onClose,
              child: Text('닫기', style: context.button1()),
            ),
          ],
        );
      },
    );
  }
}
