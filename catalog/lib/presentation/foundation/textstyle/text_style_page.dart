import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

import 'model/text_style_catalog_models.dart';
import 'view/text_style_category_tabs.dart';
import 'view/text_style_details_panel.dart';
import 'view/text_style_table.dart';
import 'view/text_style_top_panel.dart';

/// 타이포그래피 시스템 테스트 페이지
class TextStylePage extends StatefulWidget {
  const TextStylePage({super.key});

  @override
  State<TextStylePage> createState() => _TextStylePageState();
}

class _TextStylePageState extends State<TextStylePage> {
  String _previewText = "안녕하세요 Hello 123";
  FitTextSp _selectedType = FitTextSp.MIN;
  String _selectedCategory = "Headline";

  static const _categories = [
    "Headline",
    "Subtitle",
    "Body",
    "Caption",
    "Button",
    "Custom",
  ];

  @override
  Widget build(BuildContext context) {
    final styles = _stylesByCategory();

    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: "Typography",
        actions: [
          const CatalogThemeSwitcher(),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          TextStyleTopPanel(
            previewText: _previewText,
            onPreviewTextChanged: (value) => setState(() => _previewText = value),
            selectedType: _selectedType,
            onTypeSelected: (type) => setState(() => _selectedType = type),
            previewItems: styles.take(3).toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextStyleCategoryTabs(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextStyleTable(
                    category: _selectedCategory,
                    previewText: _previewText,
                    items: styles,
                  ),
                  const SizedBox(height: 16),
                  const TextStyleDetailsPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextStyleCatalogItem> _stylesByCategory() {
    switch (_selectedCategory) {
      case "Headline":
        return [
          TextStyleCatalogItem("h1", (c) => c.h1(type: _selectedType)),
          TextStyleCatalogItem("h2", (c) => c.h2(type: _selectedType)),
          TextStyleCatalogItem("h3", (c) => c.h3(type: _selectedType)),
          TextStyleCatalogItem("h4", (c) => c.h4(type: _selectedType)),
        ];
      case "Subtitle":
        return [
          TextStyleCatalogItem("subtitle1", (c) => c.subtitle1(type: _selectedType)),
          TextStyleCatalogItem("subtitle2", (c) => c.subtitle2(type: _selectedType)),
          TextStyleCatalogItem("subtitle3", (c) => c.subtitle3(type: _selectedType)),
          TextStyleCatalogItem("subtitle4", (c) => c.subtitle4(type: _selectedType)),
          TextStyleCatalogItem("subtitle5", (c) => c.subtitle5(type: _selectedType)),
          TextStyleCatalogItem("subtitle6", (c) => c.subtitle6(type: _selectedType)),
          TextStyleCatalogItem("subtitle7", (c) => c.subtitle7(type: _selectedType)),
        ];
      case "Body":
        return [
          TextStyleCatalogItem("body1", (c) => c.body1(type: _selectedType)),
          TextStyleCatalogItem("body2", (c) => c.body2(type: _selectedType)),
          TextStyleCatalogItem("body3", (c) => c.body3(type: _selectedType)),
          TextStyleCatalogItem("body4", (c) => c.body4(type: _selectedType)),
          TextStyleCatalogItem("body5", (c) => c.body5(type: _selectedType)),
          TextStyleCatalogItem("body6", (c) => c.body6(type: _selectedType)),
        ];
      case "Caption":
        return [
          TextStyleCatalogItem("caption1", (c) => c.caption1(type: _selectedType)),
          TextStyleCatalogItem("caption2", (c) => c.caption2(type: _selectedType)),
          TextStyleCatalogItem("caption3", (c) => c.caption3(type: _selectedType)),
          TextStyleCatalogItem("caption4", (c) => c.caption4(type: _selectedType)),
          TextStyleCatalogItem("caption5", (c) => c.caption5(type: _selectedType)),
        ];
      case "Button":
        return [
          TextStyleCatalogItem("button1", (c) => c.button1(type: _selectedType)),
          TextStyleCatalogItem("button2", (c) => c.button2(type: _selectedType)),
        ];
      case "Custom":
        return [
          TextStyleCatalogItem("neodgm", (c) => c.neodgm()),
        ];
      default:
        return const [];
    }
  }
}
