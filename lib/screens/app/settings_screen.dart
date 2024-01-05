import 'package:eurokey2/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nastavení a informace'),
        centerTitle: true,
      ),
      body: const SettingsScreenBody(),
    );
  }
}

///The Settings screen where the user can adjust various app settings
///or look up information.
class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  Icon themeSelector(
    BuildContext context,
    PreferencesProvider preferencesProvider,
  ) {
    switch (preferencesProvider.themeMode) {
      case ThemeMode.system:
        return const Icon(Icons.settings);
      case ThemeMode.dark:
        return const Icon(Icons.dark_mode);
      case ThemeMode.light:
        return const Icon(Icons.light_mode);
      default:
        throw Exception("invalid themeMode");
    }
  }

  void themeTap(
    BuildContext context,
    PreferencesProvider preferencesProvider,
  ) {
    switch (preferencesProvider.themeMode) {
      case ThemeMode.system:
        preferencesProvider.themeMode = ThemeMode.dark;
      case ThemeMode.dark:
        preferencesProvider.themeMode = ThemeMode.light;
      case ThemeMode.light:
        preferencesProvider.themeMode = ThemeMode.system;
      default:
        throw Exception("invalid themeMode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, preferencesProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        ListTile(
                          onTap: () => themeTap(context, preferencesProvider),
                          title: const Text('Motiv rozhraní'),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: themeSelector(context, preferencesProvider),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const DividerOptions(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DividerOptions extends StatelessWidget {
  const DividerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 10,
      endIndent: 10,
    );
  }
}
