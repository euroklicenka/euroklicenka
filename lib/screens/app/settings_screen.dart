// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:eurokey2/providers/preferences_provider.dart';
import 'package:eurokey2/screens/app/information_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

// AppLocalizations.of(context)!.mapAppBarTitle

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // _initIntl();
  }

  Future<void> _initIntl() async {
    final Locale appLocale = Localizations.localeOf(context);
    await initializeDateFormatting(appLocale.toString());
  }

  final languagesMap = <String, String>{
    "_": "Systémový", // FIXME I18N
    "en": "English",
    "cs": "Čeština",
    "sk": "Slovenčina",
  };

  Widget settingsList() {
    return Consumer<PreferencesProvider>(
      builder: (context, sharedPreferencesProvider, child) {
        Locale? locale = sharedPreferencesProvider.locale;
        String selectedLanguage = (locale != null) ? locale.languageCode : "_";

        return SettingsList(
          sections: [
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.generalSectionLabel),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: Text(
                      AppLocalizations.of(context)!.languageSettingsTileLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onPressed: (context) async {
                    final String? language = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LanguagePickerScreen(
                          language: selectedLanguage,
                          languages: languagesMap,
                        ),
                      ),
                    );

                    if (language == "_") {
                      sharedPreferencesProvider.locale = null;
                    } else if (language != null) {
                      sharedPreferencesProvider.locale = Locale(language);
                    }
                  },
                  value: Text(languagesMap[selectedLanguage] ?? "undefined"),
                ),
                SettingsTile.switchTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(
                      AppLocalizations.of(context)!.darkModeSettingsTileLabel),
                  initialValue: false,
                  onToggle: (bool value) {},
                ),
              ],
            ),
            SettingsSection(
              title: const Text("Aplikace"), // FIXME i18n
              tiles: [
                SettingsTile.navigation(
                  title: const Text("Průvodce aplikací"), // FIXME i18n
                  onPressed: (context) async {
                    await Navigator.of(context).pushNamed("/guide");
                  },
                ),
                SettingsTile.navigation(
                  title: const Text("O aplikaci"), // FIXME i18n
                  onPressed: (context) async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const InformationScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const Text("Zdroj dat"),
              tiles: [
                SettingsTile.navigation(
                  title: const Text(
                      "Datum poslední aktualizace databáze"), // FIXME i18n
                  value: Consumer<EurolockProvider>(
                    builder: (
                      context,
                      eurolockProvider,
                      child,
                    ) {
                      final lastModified = DateFormat('d.M.y')
                          .format(eurolockProvider.lastModified);
                      return Text(
                        lastModified,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
// Locale.fromSubtags

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsLabel,
            textAlign: TextAlign.center),
      ),
      body: settingsList(),
    );
  }
}

class LanguagePickerScreen extends StatelessWidget {
  const LanguagePickerScreen({
    super.key,
    required this.language,
    required this.languages,
  });

  final String language;
  final Map<String, String> languages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Languages')), // FIXME i18n
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Select the language you want'), // FIXME i18n
            tiles: languages.keys.map((e) {
              final language = languages[e];

              return SettingsTile(
                title: Text(language!),
                onPressed: (_) {
                  Navigator.of(context).pop(e);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
