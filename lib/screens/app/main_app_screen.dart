import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppScreen extends StatelessWidget {
  final Widget child;
  final int index;

  const MainAppScreen({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    if (index < 0 || index >= 3) {
      // Just in case someone tries to pass an invalid index in the url.
      GoRouter.of(context).go('/');
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/list');
              break;
            case 1:
              context.go('/map');
              break;
            case 2:
              context.go('/settings');
              break;
          }
        },
        indicatorColor: Colors.amber,
        selectedIndex: index,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.view_list_outlined),
            icon: Icon(Icons.view_list),
            label: "Seznam",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.map_outlined),
            icon: Icon(Icons.map),
            label: "Mapa",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.format_align_center),
            icon: Icon(Icons.format_list_bulleted),
            label: "Více",
          ),
        ],
      ),
    );
  }
}
