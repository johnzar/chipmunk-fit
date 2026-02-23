import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/component/catalog_menu_widgets.dart';

/// Component 메인 페이지 (토스 스타일)
class ComponentPage extends StatelessWidget {
  const ComponentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.fitColors.backgroundBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CatalogMenuHeader(
              title: 'Components',
              subtitle: 'UI 컴포넌트 라이브러리',
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
        delegate: SliverChildListDelegate([
          _buildCategory(
            context,
            title: 'Inputs',
            items: [
              _ComponentItem(
                icon: Icons.smart_button_outlined,
                iconColor: const Color(0xFF3182F6),
                title: 'Button',
                subtitle: '버튼 컴포넌트',
                route: '/button',
              ),
              _ComponentItem(
                icon: Icons.keyboard_hide_outlined,
                iconColor: const Color(0xFF6366F1),
                title: 'AnimatedBottomButton',
                subtitle: '키보드 반응형 하단 버튼',
                route: '/animated_bottom_button',
              ),
              _ComponentItem(
                icon: Icons.check_box_outlined,
                iconColor: const Color(0xFF9B51E0),
                title: 'CheckBox',
                subtitle: '체크박스',
                route: '/check_box',
              ),
              _ComponentItem(
                icon: Icons.toggle_on_outlined,
                iconColor: const Color(0xFF6D78FF),
                title: 'SwitchButton',
                subtitle: 'adaptive 스위치 버튼',
                route: '/switch_button',
              ),
              _ComponentItem(
                icon: Icons.radio_button_checked,
                iconColor: const Color(0xFF00C7BE),
                title: 'RadioButton',
                subtitle: 'material 라디오 버튼',
                route: '/radio_button',
              ),
              _ComponentItem(
                icon: Icons.label,
                iconColor: const Color(0xFFFF6B9D),
                title: 'Chip',
                subtitle: 'iOS 스타일 칩 (태그, 필터, 입력)',
                route: '/chip',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCategory(
            context,
            title: 'Display',
            items: [
              _ComponentItem(
                icon: Icons.image_outlined,
                iconColor: const Color(0xFFF76B1C),
                title: 'Image',
                subtitle: '이미지 컴포넌트',
                route: '/image',
              ),
              _ComponentItem(
                icon: Icons.text_fields,
                iconColor: const Color(0xFFE91E63),
                title: 'AnimatedText',
                subtitle: '타이핑 애니메이션 텍스트',
                route: '/animation_text',
              ),
              _ComponentItem(
                icon: Icons.animation,
                iconColor: const Color(0xFF00BFA5),
                title: 'Lottie',
                subtitle: 'Lottie 애니메이션 (Network, Asset, File)',
                route: '/lottie',
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
      {required String title, required List<_ComponentItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CatalogMenuSectionTitle(title: title),
        ...items.map((item) => _buildComponentCard(context, item)),
      ],
    );
  }

  /// 컴포넌트 카드
  Widget _buildComponentCard(BuildContext context, _ComponentItem item) {
    return CatalogMenuCard(
      icon: item.icon,
      iconColor: item.iconColor,
      title: item.title,
      subtitle: item.subtitle,
      onTap: () => context.go(item.route),
    );
  }
}

class _ComponentItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String route;

  const _ComponentItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
