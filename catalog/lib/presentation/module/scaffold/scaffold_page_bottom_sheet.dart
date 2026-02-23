part of 'scaffold_page.dart';

extension _ScaffoldPageBottomSheetMethods on _ScaffoldPageState {
  /// Show FitBottomSheet
  void _showFitBottomSheet(BuildContext context) {
    final config = FitBottomSheetConfig(
      isShowTopBar: _bottomSheetShowTopBar,
      isShowCloseButton: _bottomSheetShowCloseButton,
      isDismissible: _bottomSheetIsDismissible,
      dismissOnBarrierTap: _bottomSheetDismissOnBarrierTap,
      dismissOnBackKeyPress: _bottomSheetIsDismissible,
      enableSnap: _bottomSheetEnableSnap,
    );

    FitBottomSheet.show(
      context,
      config: config,
      content: (sheetContext) => _buildBottomSheetContent(sheetContext),
    );
  }

  Widget _buildBottomSheetContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bottom Sheet',
            style: context.h2(),
          ),
          const SizedBox(height: 16),
          Text(
            '단일 show API 정책을 검증하는 샘플입니다.',
            style: context.body2(),
          ),
          const SizedBox(height: 20),
          for (int i = 1; i <= 20; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.list, color: context.fitColors.main, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Item $i',
                      style: context.body2(),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          FitButton(
            isExpanded: true,
            onPressed: () => Navigator.pop(context),
            child: Text(
              '닫기',
              style: context.button1(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
