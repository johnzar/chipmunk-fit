import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

import 'model/color_catalog_models.dart';
import 'view/color_category_tabs.dart';
import 'view/color_token_list.dart';

class ColorPage extends StatefulWidget {
  const ColorPage({super.key});

  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  String _selectedCategory = "Semantic";

  static const _categories = [
    ColorCategoryItem(name: "Semantic", icon: Icons.palette),
    ColorCategoryItem(name: "Static", icon: Icons.contrast),
    ColorCategoryItem(name: "Grey", icon: Icons.gradient),
    ColorCategoryItem(name: "Green", icon: Icons.eco),
    ColorCategoryItem(name: "Leaf Green", icon: Icons.spa),
    ColorCategoryItem(name: "Periwinkle", icon: Icons.water_drop),
    ColorCategoryItem(name: "Violet", icon: Icons.auto_awesome),
    ColorCategoryItem(name: "Red", icon: Icons.favorite),
    ColorCategoryItem(name: "Yellow", icon: Icons.sunny),
    ColorCategoryItem(name: "Brick", icon: Icons.square),
    ColorCategoryItem(name: "Alpha Red", icon: Icons.circle),
    ColorCategoryItem(name: "Alpha Blue", icon: Icons.circle),
    ColorCategoryItem(name: "Alpha Yellow", icon: Icons.circle),
    ColorCategoryItem(name: "Alpha Green", icon: Icons.circle),
    ColorCategoryItem(name: "Alpha Periwinkle", icon: Icons.circle),
    ColorCategoryItem(name: "Alpha Violet", icon: Icons.circle),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final palette = isDarkTheme ? darkFitColors : lightFitColors;
    final colorItems = _colorsByCategory();

    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: "Colors",
        actions: const [
          CatalogThemeSwitcher(),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColorCategoryTabs(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                  const SizedBox(height: 16),
                  ColorTokenList(
                    selectedCategory: _selectedCategory,
                    items: colorItems,
                    palette: palette,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ColorTokenItem> _colorsByCategory() {
    switch (_selectedCategory) {
      case "Semantic":
        return _semanticColors();
      case "Static":
        return _staticColors();
      case "Grey":
        return _greyColors();
      case "Green":
        return _greenColors();
      case "Leaf Green":
        return _leafGreenColors();
      case "Periwinkle":
        return _periwinkleColors();
      case "Violet":
        return _violetColors();
      case "Red":
        return _redColors();
      case "Yellow":
        return _yellowAlphaColors();
      case "Brick":
        return _brickColors();
      case "Alpha Red":
        return _redAlphaColors();
      case "Alpha Blue":
        return _blueAlphaColors();
      case "Alpha Yellow":
        return _yellowAlphaColors();
      case "Alpha Green":
        return _greenAlphaColors();
      case "Alpha Periwinkle":
        return _periwinkleAlphaColors();
      case "Alpha Violet":
        return _violetAlphaColors();
      default:
        return const [];
    }
  }

  List<ColorTokenItem> _semanticColors() {
    return [
      ColorTokenItem(name: "Main", color: _currentPalette().main),
      ColorTokenItem(name: "Sub", color: _currentPalette().sub),
      ColorTokenItem(name: "Background Base", color: _currentPalette().backgroundBase),
      ColorTokenItem(name: "Background Alternative", color: _currentPalette().backgroundAlternative),
      ColorTokenItem(name: "Background Elevated", color: _currentPalette().backgroundElevated),
      ColorTokenItem(
        name: "Background Elevated Alternative",
        color: _currentPalette().backgroundElevatedAlternative,
      ),
      ColorTokenItem(name: "Text Primary", color: _currentPalette().textPrimary),
      ColorTokenItem(name: "Text Secondary", color: _currentPalette().textSecondary),
      ColorTokenItem(name: "Text Tertiary", color: _currentPalette().textTertiary),
      ColorTokenItem(name: "Text Disabled", color: _currentPalette().textDisabled),
      ColorTokenItem(name: "Fill Base", color: _currentPalette().fillBase),
      ColorTokenItem(name: "Fill Alternative", color: _currentPalette().fillAlternative),
      ColorTokenItem(name: "Fill Strong", color: _currentPalette().fillStrong),
      ColorTokenItem(name: "Fill Emphasize", color: _currentPalette().fillEmphasize),
      ColorTokenItem(name: "Divider Primary", color: _currentPalette().dividerPrimary),
      ColorTokenItem(name: "Divider Secondary", color: _currentPalette().dividerSecondary),
      ColorTokenItem(name: "Inverse Background", color: _currentPalette().inverseBackground),
      ColorTokenItem(name: "Inverse Text", color: _currentPalette().inverseText),
      ColorTokenItem(name: "Inverse Disabled", color: _currentPalette().inverseDisabled),
      ColorTokenItem(name: "Dim Background", color: _currentPalette().dimBackground),
      ColorTokenItem(name: "Dim Overlay", color: _currentPalette().dimOverlay),
      ColorTokenItem(name: "Dim Card", color: _currentPalette().dimCard),
    ];
  }

  List<ColorTokenItem> _staticColors() {
    return [
      ColorTokenItem(name: "Static Black", color: _currentPalette().staticBlack),
      ColorTokenItem(name: "Static White", color: _currentPalette().staticWhite),
    ];
  }

  List<ColorTokenItem> _greyColors() {
    return [
      ColorTokenItem(name: "Grey 0", color: _currentPalette().grey0),
      ColorTokenItem(name: "Grey 50", color: _currentPalette().grey50),
      ColorTokenItem(name: "Grey 100", color: _currentPalette().grey100),
      ColorTokenItem(name: "Grey 200", color: _currentPalette().grey200),
      ColorTokenItem(name: "Grey 300", color: _currentPalette().grey300),
      ColorTokenItem(name: "Grey 400", color: _currentPalette().grey400),
      ColorTokenItem(name: "Grey 500", color: _currentPalette().grey500),
      ColorTokenItem(name: "Grey 600", color: _currentPalette().grey600),
      ColorTokenItem(name: "Grey 700", color: _currentPalette().grey700),
      ColorTokenItem(name: "Grey 800", color: _currentPalette().grey800),
      ColorTokenItem(name: "Grey 900", color: _currentPalette().grey900),
    ];
  }

  List<ColorTokenItem> _greenColors() {
    return [
      ColorTokenItem(name: "Green 50", color: _currentPalette().green50),
      ColorTokenItem(name: "Green 200", color: _currentPalette().green200),
      ColorTokenItem(name: "Green 500", color: _currentPalette().green500),
      ColorTokenItem(name: "Green 600", color: _currentPalette().green600),
      ColorTokenItem(name: "Green 700", color: _currentPalette().green700),
    ];
  }

  List<ColorTokenItem> _leafGreenColors() {
    return [
      ColorTokenItem(name: "Leaf Green 50", color: _currentPalette().leafGreen50),
      ColorTokenItem(name: "Leaf Green 200", color: _currentPalette().leafGreen200),
      ColorTokenItem(name: "Leaf Green 500", color: _currentPalette().leafGreen500),
      ColorTokenItem(name: "Leaf Green 600", color: _currentPalette().leafGreen600),
      ColorTokenItem(name: "Leaf Green 700", color: _currentPalette().leafGreen700),
    ];
  }

  List<ColorTokenItem> _periwinkleColors() {
    return [
      ColorTokenItem(name: "Periwinkle 50", color: _currentPalette().periwinkle50),
      ColorTokenItem(name: "Periwinkle 200", color: _currentPalette().periwinkle200),
      ColorTokenItem(name: "Periwinkle 500", color: _currentPalette().periwinkle500),
      ColorTokenItem(name: "Periwinkle 600", color: _currentPalette().periwinkle600),
      ColorTokenItem(name: "Periwinkle 700", color: _currentPalette().periwinkle700),
    ];
  }

  List<ColorTokenItem> _violetColors() {
    return [
      ColorTokenItem(name: "Violet 50", color: _currentPalette().violet50),
      ColorTokenItem(name: "Violet 200", color: _currentPalette().violet200),
      ColorTokenItem(name: "Violet 500", color: _currentPalette().violet500),
      ColorTokenItem(name: "Violet 600", color: _currentPalette().violet600),
      ColorTokenItem(name: "Violet 700", color: _currentPalette().violet700),
    ];
  }

  List<ColorTokenItem> _redColors() {
    return [
      ColorTokenItem(name: "Red 50", color: _currentPalette().red50),
      ColorTokenItem(name: "Red 200", color: _currentPalette().red200),
      ColorTokenItem(name: "Red 500", color: _currentPalette().red500),
      ColorTokenItem(name: "Red 600", color: _currentPalette().red600),
      ColorTokenItem(name: "Red 700", color: _currentPalette().red700),
    ];
  }

  List<ColorTokenItem> _brickColors() {
    return [
      ColorTokenItem(name: "Brick 50", color: _currentPalette().brick50),
      ColorTokenItem(name: "Brick 200", color: _currentPalette().brick200),
      ColorTokenItem(name: "Brick 500", color: _currentPalette().brick500),
      ColorTokenItem(name: "Brick 600", color: _currentPalette().brick600),
      ColorTokenItem(name: "Brick 700", color: _currentPalette().brick700),
    ];
  }

  List<ColorTokenItem> _redAlphaColors() {
    return [
      ColorTokenItem(name: "Red Base", color: _currentPalette().redBase),
      ColorTokenItem(name: "Red Alpha 72", color: _currentPalette().redAlpha72),
      ColorTokenItem(name: "Red Alpha 48", color: _currentPalette().redAlpha48),
      ColorTokenItem(name: "Red Alpha 24", color: _currentPalette().redAlpha24),
      ColorTokenItem(name: "Red Alpha 12", color: _currentPalette().redAlpha12),
    ];
  }

  List<ColorTokenItem> _blueAlphaColors() {
    return [
      ColorTokenItem(name: "Blue Alpha Base", color: _currentPalette().blueAlphaBase),
      ColorTokenItem(name: "Blue Alpha 72", color: _currentPalette().blueAlpha72),
      ColorTokenItem(name: "Blue Alpha 48", color: _currentPalette().blueAlpha48),
      ColorTokenItem(name: "Blue Alpha 24", color: _currentPalette().blueAlpha24),
      ColorTokenItem(name: "Blue Alpha 12", color: _currentPalette().blueAlpha12),
    ];
  }

  List<ColorTokenItem> _yellowAlphaColors() {
    return [
      ColorTokenItem(name: "Yellow Base", color: _currentPalette().yellowBase),
      ColorTokenItem(name: "Yellow Alpha 72", color: _currentPalette().yellowAlpha72),
      ColorTokenItem(name: "Yellow Alpha 48", color: _currentPalette().yellowAlpha48),
      ColorTokenItem(name: "Yellow Alpha 24", color: _currentPalette().yellowAlpha24),
      ColorTokenItem(name: "Yellow Alpha 12", color: _currentPalette().yellowAlpha12),
    ];
  }

  List<ColorTokenItem> _greenAlphaColors() {
    return [
      ColorTokenItem(name: "Green Base", color: _currentPalette().greenBase),
      ColorTokenItem(name: "Green Alpha 72", color: _currentPalette().greenAlpha72),
      ColorTokenItem(name: "Green Alpha 48", color: _currentPalette().greenAlpha48),
      ColorTokenItem(name: "Green Alpha 24", color: _currentPalette().greenAlpha24),
      ColorTokenItem(name: "Green Alpha 12", color: _currentPalette().greenAlpha12),
    ];
  }

  List<ColorTokenItem> _periwinkleAlphaColors() {
    return [
      ColorTokenItem(name: "Periwinkle Base", color: _currentPalette().periwinkleBase),
      ColorTokenItem(name: "Periwinkle Alpha 72", color: _currentPalette().periwinkleAlpha72),
      ColorTokenItem(name: "Periwinkle Alpha 48", color: _currentPalette().periwinkleAlpha48),
      ColorTokenItem(name: "Periwinkle Alpha 24", color: _currentPalette().periwinkleAlpha24),
      ColorTokenItem(name: "Periwinkle Alpha 12", color: _currentPalette().periwinkleAlpha12),
    ];
  }

  List<ColorTokenItem> _violetAlphaColors() {
    return [
      ColorTokenItem(name: "Violet Base", color: _currentPalette().violetBase),
      ColorTokenItem(name: "Violet Alpha 72", color: _currentPalette().violetAlpha72),
      ColorTokenItem(name: "Violet Alpha 48", color: _currentPalette().violetAlpha48),
      ColorTokenItem(name: "Violet Alpha 24", color: _currentPalette().violetAlpha24),
      ColorTokenItem(name: "Violet Alpha 12", color: _currentPalette().violetAlpha12),
    ];
  }

  FitColors _currentPalette() {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return isDarkTheme ? darkFitColors : lightFitColors;
  }
}
