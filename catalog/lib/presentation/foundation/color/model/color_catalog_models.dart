import 'package:flutter/material.dart';

class ColorTokenItem {
  final String name;
  final Color color;

  const ColorTokenItem({
    required this.name,
    required this.color,
  });
}

class ColorCategoryItem {
  final String name;
  final IconData icon;

  const ColorCategoryItem({
    required this.name,
    required this.icon,
  });
}
