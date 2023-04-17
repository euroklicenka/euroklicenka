import 'package:flutter/material.dart';

/// A Selection menu, where the user can pick a Theme from available themes.
///
/// It displays all [themes] in a grid, shows a [headerText] above the window,
/// allows an action to be taken [onSelect].
void openThemeSwitchingDialog({
  required BuildContext context,
  required List<ThemeData> themes,
  required Function(ThemeData theme) onSelect,
  String headerText = 'Switch Theme',
}) {
  /// Builds a Grid Tile for a theme.
  Widget buildGridTile(BuildContext context, int index) {
    return MaterialButton(
      onPressed: () => onSelect(themes[index]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add a widget to represent the theme here, e.g., a colored container or an icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: themes[index].primaryColor,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(height: 8),
          Text('Theme ${index + 1}'),
        ],
      ),
    );
  }

  showModalBottomSheet(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.33),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                headerText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: GridView.builder(
                    itemCount: themes.length,
                    itemBuilder: buildGridTile,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
