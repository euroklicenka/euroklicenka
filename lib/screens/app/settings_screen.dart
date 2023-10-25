import 'package:eurokey2/models/preferences_model.dart';
import 'package:eurokey2/widgets/theme_dependent_icon.dart';
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

  ThemeDependentIcon themeSelector(
    BuildContext context,
    PreferencesModel preferencesModel,
  ) {
    switch (preferencesModel.themeMode) {
      case ThemeMode.system:
        return const ThemeDependentIcon(Icons.settings);
      case ThemeMode.dark:
        return const ThemeDependentIcon(Icons.dark_mode);
      case ThemeMode.light:
        return const ThemeDependentIcon(Icons.light_mode);
      default:
        throw Exception("invalid themeMode");
    }
  }

  void themeTap(
    BuildContext context,
    PreferencesModel preferencesModel,
  ) {
    switch (preferencesModel.themeMode) {
      case ThemeMode.system:
        preferencesModel.themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        preferencesModel.themeMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        preferencesModel.themeMode = ThemeMode.system;
        break;
      default:
        throw Exception("invalid themeMode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesModel>(
      builder: (context, preferencesModel, child) {
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
                          onTap: () => themeTap(context, preferencesModel),
                          title: const Text('Motiv rozhraní'),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: themeSelector(context, preferencesModel),
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
