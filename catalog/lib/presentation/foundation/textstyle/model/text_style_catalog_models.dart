import 'package:flutter/material.dart';

typedef TextStyleBuilder = TextStyle Function(BuildContext context);

class TextStyleCatalogItem {
  final String name;
  final TextStyleBuilder styleBuilder;

  const TextStyleCatalogItem(this.name, this.styleBuilder);
}

class TextTypeDescription {
  final String type;
  final String description;
  final String usage;

  const TextTypeDescription({
    required this.type,
    required this.description,
    required this.usage,
  });
}

class SimulationDevice {
  final String name;
  final double width;
  final double height;

  const SimulationDevice({
    required this.name,
    required this.width,
    required this.height,
  });
}
