import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/component/catalog_menu_widgets.dart';

/// Module 메인 페이지
class ModulePage extends StatelessWidget {
  const ModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.fitColors.backgroundBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CatalogMenuHeader(
              title: 'Modules',
              subtitle: '컴포넌트 조합 기반 UI 패턴',
            ),
            _buildModuleList(context),
          ],
        ),
      ),
    );
  }

  /// 모듈 리스트
  Widget _buildModuleList(BuildContext context) {
    final modules = [
      _ModuleItem(
        icon: Icons.web_outlined,
        iconColor: const Color(0xFF9C27B0),
        title: 'Scaffold',
        subtitle: '스캐폴드 & 앱바',
        route: '/scaffold',
      ),
      _ModuleItem(
        icon: Icons.chat_bubble_outline,
        iconColor: const Color(0xFFE91E63),
        title: 'Dialog',
        subtitle: '다이얼로그',
        route: '/dialog',
      ),
      _ModuleItem(
        icon: Icons.view_agenda_outlined,
        iconColor: const Color(0xFF3182F6),
        title: 'BottomSheet',
        subtitle: '바텀시트',
        route: '/bottom_sheet',
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          const CatalogMenuSectionTitle(title: 'Module'),
          ...modules.map((module) => _buildModuleCard(context, module)),
          SizedBox(height: catalogBottomMenuSpacing(context)),
        ]),
      ),
    );
  }

  /// 모듈 카드
  Widget _buildModuleCard(BuildContext context, _ModuleItem item) {
    return CatalogMenuCard(
      icon: item.icon,
      iconColor: item.iconColor,
      title: item.title,
      subtitle: item.subtitle,
      onTap: () => context.go(item.route),
    );
  }
}

class _ModuleItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String route;

  const _ModuleItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
