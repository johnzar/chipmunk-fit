import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/component/catalog_menu_widgets.dart';

/// Foundation main page
class FoundationPage extends StatelessWidget {
  const FoundationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.fitColors.backgroundBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CatalogMenuHeader(
              title: 'Foundation',
              subtitle: '디자인 시스템의 기본 토큰과 사용 기준',
            ),
            _buildGuideSection(context),
            _buildMenuList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.fitColors.backgroundElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.fitColors.dividerPrimary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Foundation Guide',
                style: context.subtitle4().copyWith(
                  color: context.fitColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Colors와 Typography는 Light/Dark 환경에서 동일한 토큰 규칙으로 동작합니다.',
                style: context.caption1().copyWith(
                  color: context.fitColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 메뉴 리스트
  Widget _buildMenuList(BuildContext context) {
    final menus = [
      _MenuItem(
        icon: Icons.palette_outlined,
        iconColor: const Color(0xFF3182F6),
        title: 'Colors',
        subtitle: '다크/라이트 모드의 컬러 시스템을 정의합니다.',
        route: '/color',
      ),
      _MenuItem(
        icon: Icons.text_fields_outlined,
        iconColor: const Color(0xFFF76B1C),
        title: 'Typography',
        subtitle: '텍스트 토큰과 접근성 대응 SP scale 규칙을 검증합니다.',
        route: '/textstyle',
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          const CatalogMenuSectionTitle(title: 'Foundation'),
          ...menus.map((menu) => _buildMenuCard(context, menu)),
          SizedBox(height: catalogBottomMenuSpacing(context)),
        ]),
      ),
    );
  }

  /// 메뉴 카드
  Widget _buildMenuCard(BuildContext context, _MenuItem menu) {
    return CatalogMenuCard(
      icon: menu.icon,
      iconColor: menu.iconColor,
      title: menu.title,
      subtitle: menu.subtitle,
      onTap: () => context.go(menu.route),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String route;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
