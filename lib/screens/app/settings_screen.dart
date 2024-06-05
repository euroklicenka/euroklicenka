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

  // ignore: unused_element
  Future<void> _initIntl() async {
    final Locale appLocale = Localizations.localeOf(context);
    await initializeDateFormatting(appLocale.toString());
  }

  Widget settingsList() {
    final languagesMap = <String, String>{
      "_": AppLocalizations.of(context)!.systemLanguage,
      "en": "English",
      "cs": "Čeština",
      "sk": "Slovenčina",
    };

    final themeModesMap = <ThemeMode, String>{
      ThemeMode.system: AppLocalizations.of(context)!.systemMode,
      ThemeMode.dark: AppLocalizations.of(context)!.darkMode,
      ThemeMode.light: AppLocalizations.of(context)!.lightMode,
    };

    return Consumer<PreferencesProvider>(
      builder: (context, sharedPreferencesProvider, child) {
        Locale? locale = sharedPreferencesProvider.locale;
        String selectedLanguage = (locale != null) ? locale.languageCode : "_";
        ThemeMode selectedThemeMode = sharedPreferencesProvider.themeMode;

        return SettingsList(
          sections: [
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.generalSectionLabel,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(245, 43, 43, 43),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language,
                      color: Color.fromARGB(245, 228, 132, 87)),
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
                SettingsTile.navigation(
                  leading: const Icon(Icons.dark_mode,
                      color: Color.fromARGB(245, 228, 132, 87)),
                  title: Text(
                      AppLocalizations.of(context)!.darkModeSettingsTileLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onPressed: (context) async {
                    final ThemeMode? themeMode =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ThemeModePickerScreen(
                          themeMode: selectedThemeMode,
                          themeModes: themeModesMap,
                        ),
                      ),
                    );

                    if (themeMode != null) {
                      sharedPreferencesProvider.themeMode = themeMode;
                    }
                  },
                  value: Text(themeModesMap[selectedThemeMode] ?? "undefined"),
                ),
              ],
            ),
            SettingsSection(
              title: Text(
                AppLocalizations.of(context)!.applicationLabel,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(245, 43, 43, 43),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Icons.auto_fix_high,
                      color: Color.fromARGB(245, 228, 132, 87)),
                  title:
                      Text(AppLocalizations.of(context)!.applicationGuideLabel),
                  onPressed: (context) async {
                    await Navigator.of(context).pushNamed("/guide");
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.info_outline,
                      color: Color.fromARGB(245, 228, 132, 87)),
                  title:
                      Text(AppLocalizations.of(context)!.aboutApplicationLabel),
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
              title: Text(
                AppLocalizations.of(context)!.dataSourceLabel,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromARGB(245, 43, 43, 43),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              tiles: [
                SettingsTile.navigation(
                  title: const SizedBox.shrink(),
                  value: Consumer<EurolockProvider>(
                    builder: (
                      context,
                      eurolockProvider,
                      child,
                    ) {
                      final lastModified = DateFormat('d.M.y')
                          .format(eurolockProvider.lastModified);
                      return Text(
                        "${AppLocalizations.of(context)!.dateOfUpdate}: $lastModified",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(245, 0, 0, 0),
                        ),
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
        title: Text(AppLocalizations.of(context)!.settingsLabel),
        backgroundColor: const Color.fromARGB(245, 255, 107, 38),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 5.5,
        shadowColor: const Color.fromARGB(255, 209, 209, 209),
        centerTitle: true,
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.languagesLabel),
        backgroundColor: const Color.fromARGB(245, 255, 107, 38),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 5.5,
        shadowColor: const Color.fromARGB(255, 209, 209, 209),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
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

class ThemeModePickerScreen extends StatelessWidget {
  const ThemeModePickerScreen({
    super.key,
    required this.themeMode,
    required this.themeModes,
  });

  final ThemeMode themeMode;
  final Map<ThemeMode, String> themeModes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.modesLabel),
        backgroundColor: const Color.fromARGB(245, 255, 107, 38),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 5.5,
        shadowColor: const Color.fromARGB(255, 209, 209, 209),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: themeModes.keys.map((e) {
              final mode = themeModes[e];
              return SettingsTile(
                title: Text(mode!),
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
