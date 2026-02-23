part of 'fit_bottom_sheet.dart';

/// 내부 scroll/body 레이아웃을 콘텐츠에서 직접 관리함을 나타내는 마커입니다.
///
/// [FitBottomSheet]는 이 마커가 있는 콘텐츠를 추가 스크롤 래핑하지 않습니다.
abstract interface class FitBottomSheetSelfManagedBody {}

/// BottomSheet 설정 옵션입니다.
class FitBottomSheetConfig {
  const FitBottomSheetConfig({
    this.isShowCloseButton = false,
    this.isDismissible = true,
    this.dismissOnBarrierTap = true,
    this.isShowTopBar = true,
    this.dismissOnBackKeyPress = true,
    this.enableSnap = true,
    this.backgroundColor,
  });

  /// 닫기 버튼 표시 여부
  final bool isShowCloseButton;

  /// 드래그(스냅-닫힘)로 닫기 가능 여부
  final bool isDismissible;

  /// dim(배리어) 영역 탭으로 닫기 가능 여부
  final bool dismissOnBarrierTap;

  /// 상단 핸들(TopBar) 표시 여부
  final bool isShowTopBar;

  /// 뒤로가기 버튼으로 닫기 가능 여부
  final bool dismissOnBackKeyPress;

  /// body/handle 드래그로 접힘/펼침 snap 사용 여부
  final bool enableSnap;

  /// 배경색
  final Color? backgroundColor;

  FitBottomSheetConfig copyWith({
    bool? isShowCloseButton,
    bool? isDismissible,
    bool? dismissOnBarrierTap,
    bool? isShowTopBar,
    bool? dismissOnBackKeyPress,
    bool? enableSnap,
    Color? backgroundColor,
  }) {
    return FitBottomSheetConfig(
      isShowCloseButton: isShowCloseButton ?? this.isShowCloseButton,
      isDismissible: isDismissible ?? this.isDismissible,
      dismissOnBarrierTap: dismissOnBarrierTap ?? this.dismissOnBarrierTap,
      isShowTopBar: isShowTopBar ?? this.isShowTopBar,
      dismissOnBackKeyPress:
          dismissOnBackKeyPress ?? this.dismissOnBackKeyPress,
      enableSnap: enableSnap ?? this.enableSnap,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FitBottomSheetConfig &&
        other.isShowCloseButton == isShowCloseButton &&
        other.isDismissible == isDismissible &&
        other.dismissOnBarrierTap == dismissOnBarrierTap &&
        other.isShowTopBar == isShowTopBar &&
        other.dismissOnBackKeyPress == dismissOnBackKeyPress &&
        other.enableSnap == enableSnap &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode => Object.hash(
        isShowCloseButton,
        isDismissible,
        dismissOnBarrierTap,
        isShowTopBar,
        dismissOnBackKeyPress,
        enableSnap,
        backgroundColor,
      );
}
