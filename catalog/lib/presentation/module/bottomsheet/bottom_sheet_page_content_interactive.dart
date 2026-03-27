part of 'bottom_sheet_page.dart';

class _KeyboardSheetContent extends StatefulWidget {
  const _KeyboardSheetContent({required this.onClose});

  final VoidCallback onClose;

  @override
  State<_KeyboardSheetContent> createState() => _KeyboardSheetContentState();
}

class _KeyboardSheetContentState extends State<_KeyboardSheetContent> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              Text('Keyboard TextField', style: context.h2()),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '입력하세요',
                  hintStyle: context.body4().copyWith(
                    color: colors.textTertiary,
                  ),
                  filled: true,
                  fillColor: colors.fillAlternative,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                style: context.body3().copyWith(color: colors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FitAnimatedBottomButton(
          useSafeArea: false,
          backgroundColor: colors.backgroundElevated,
          onPressed: widget.onClose,
          child: Text('닫기', style: context.button1()),
        ),
      ],
    );
  }
}

class _NestedSheetContent extends StatelessWidget {
  const _NestedSheetContent({required this.config, required this.onClose});

  final FitBottomSheetConfig config;
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
              Text('Nested', style: context.h2()),
              const SizedBox(height: 12),
              FitButton(
                isExpanded: true,
                type: FitButtonType.secondary,
                onPressed: () {
                  FitBottomSheet.show(
                    context,
                    config: config,
                    content: (innerContext) => _DefaultSheetContent(
                      onClose: () => Navigator.pop(innerContext),
                    ),
                  );
                },
                child: Text('내부 BottomSheet 열기', style: context.button1()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FitAnimatedBottomButton(
          useSafeArea: false,
          backgroundColor: colors.backgroundElevated,
          onPressed: onClose,
          child: Text('현재 BottomSheet 닫기', style: context.button1()),
        ),
      ],
    );
  }
}
