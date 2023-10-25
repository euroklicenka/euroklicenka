import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:flutter/material.dart';

class ThemeDependentIcon extends StatelessWidget {
  final IconData icon;

  const ThemeDependentIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: context.isAppInDarkMode ? Theme.of(context).colorScheme.secondary : Colors.grey[600],
    );
  }
}
