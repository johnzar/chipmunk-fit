import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:catalog/theme/catalog_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatalogThemeSwitcher extends StatelessWidget {
  const CatalogThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return GestureDetector(
          onTap: () {
            final theme = isDark
                ? catalogLightTheme(context)
                : catalogDarkTheme(context);
            ThemeSwitcher.of(context).changeTheme(theme: theme);
          },
          child: Icon(
            isDark ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        );
      },
    );
  }
}
