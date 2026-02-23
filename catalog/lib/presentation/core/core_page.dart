import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/component/catalog_menu_widgets.dart';

/// Core 메인 페이지
class CorePage extends StatelessWidget {
  const CorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.fitColors.backgroundBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CatalogMenuHeader(
              title: 'Core',
              subtitle: '핵심 유틸리티 라이브러리',
            ),
            _buildCategoryList(context),
          ],
        ),
      ),
    );
  }

  /// 카테고리 리스트
  Widget _buildCategoryList(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          _buildCategory(
            context,
            title: 'Utils',
            items: [
              _CoreItem(
                icon: Icons.cached,
                iconColor: const Color(0xFF00BCD4),
                title: 'Cache Helper',
                subtitle: '파일 다운로드 및 캐싱',
                route: '/cache_helper',
              ),
              _CoreItem(
                icon: Icons.text_snippet_outlined,
                iconColor: const Color(0xFF4CAF50),
                title: 'Delta Viewer',
                subtitle: 'Quill Delta JSON 뷰어',
                route: '/delta_viewer',
              ),
            ],
          ),
          SizedBox(height: catalogBottomMenuSpacing(context)),
        ]),
      ),
    );
  }

  /// 카테고리 섹션
  Widget _buildCategory(BuildContext context,
      {required String title, required List<_CoreItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CatalogMenuSectionTitle(title: title),
        ...items.map((item) => _buildCoreCard(context, item)),
      ],
    );
  }

  /// Core 카드
  Widget _buildCoreCard(BuildContext context, _CoreItem item) {
    return CatalogMenuCard(
      icon: item.icon,
      iconColor: item.iconColor,
      title: item.title,
      subtitle: item.subtitle,
      onTap: () => context.go(item.route),
    );
  }
}

class _CoreItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String route;

  const _CoreItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
