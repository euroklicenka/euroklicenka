# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

EuroKlíčenka (Dart package `eurokey2`, Android/iOS id `cz.osu.euroklicenka`) is a Flutter app for Android and iOS that helps Euroklíč holders find the nearest places fitted with a Eurolock (WC, elevator, gate, platform) in Czechia and Slovakia. Most project documentation (`Dokumenty/`, `meetingminutes/`, README) is in Czech.

## Commands

```sh
flutter pub get                                      # install deps; also regenerates l10n (flutter: generate: true)
dart format --output=none --set-exit-if-changed .    # CI format check (.github/workflows/dart.yml)
dart analyze                                         # CI static analysis (flutter_lints, avoid_print disabled)
dart run dependency_validator                         # check for unused/missing deps (config: dart_dependency_validator.yaml)
flutter run                                          # run on a connected device/emulator
flutter build apk --debug                            # what CI builds (apk.yml); also `flutter build appbundle`
flutter build ios --release --no-codesign            # what CI builds on macOS (ios.yml); also `flutter build ipa`
```

There is no `test/` directory and the test steps in CI are commented out. If you add tests, run one with `flutter test test/<file>_test.dart` (optionally `--name "<test name>"`).

## Architecture

**State management is `provider`.** `lib/main.dart` registers three `ChangeNotifier`s in a `MultiProvider` and wraps the app in a `FutureBuilder` that shows `SplashScreen` until `EurolockProvider.onInitApp()` and `PreferencesProvider.initialize()` complete:

- `EurolockProvider` (`lib/providers/eurolock_provider.dart`) — owns the list of locations, the map `Marker`s, the search filter, the currently selected location (`currentEUK`, whose setter also moves the shared `MapController`), and builds the list-item widgets.
- `LocationProvider` — user GPS position (via `geolocator`), current map center/zoom, and the follow-location stream used by `flutter_map_location_marker`.
- `PreferencesProvider` — `shared_preferences`-backed locale and theme, first-launch guide flag, and `mainScreenState`.

**Navigation between the three main tabs is state-driven, not route-driven.** `MainAppScreen` renders an `IndexedStack` of `ListScreen` / `MapScreen` / `SettingsScreen` selected by `PreferencesProvider.mainScreenState`. To jump to a tab (e.g. tapping a list item opens it on the map), set `mainScreenState` and `EurolockProvider.currentEUK` rather than pushing a route. Location permission is requested via `permission_handler` in `MainAppScreen.initialize`.

**Location data flow.** The countries list (`cz`, `sk`) lives in `eurolock_provider.dart`. On startup `onInitApp()` loads the bundled `assets/data-<country>.json` and seeds it into `flutter_cache_manager` under the URL `https://cdn.euroklicenka.cz/data-<country>.json` with a 1-day max age; `sync()` then reads through the cache manager, so the app uses bundled data first and refreshes from the CDN once a day. Updating data therefore means either regenerating the bundled assets and releasing, or uploading new JSON files to the CDN.

**Location JSON schema** (parsed by `EUKLocationData.fromJson` in `lib/features/location_data/euk_location_data.dart`): `id`, `lat`, `lng`, `place`, `street`, `region`, `city`, `zip`, `type`. `type` must be one of `wc`, `elevator`, `gate`, `platform`; anything else throws `FormatException`. Slovak ids start at 1000. Each type maps to a list icon and a map marker PNG in `markers/` via `lib/features/icon_management/icon_manager.dart`. Adding a type means updating the `EUKLocationType` enum, `fromJson`, both icon functions, and the marker assets.

**Map.** `flutter_map` with OSM tiles cached by `flutter_map_tile_caching` (ObjectBox backend; store `mapStore` is created in `main()` before `runApp`). The map screen's search bar uses `osm_nominatim` for place suggestions (throttled in `MapScreenState.asyncSuggestions`), while the list screen's search filters locations by diacritic-insensitive text match.

## Regenerating location data

See `Dokumenty/aktualizace.md`. In short:

```sh
# Czech data: download the XLSX from euroklic.cz ("Kde mohu použít Euroklíč")
python3 -m venv venv && . venv/bin/activate && pip3 install pandas openpyxl
bin/xlsx2json.py <input>.xlsx assets/data-cz.json   # prints SKIP: for rows it cannot parse; fix the input or the regexes

# Slovak data: parse the HTML table
curl -sSLO http://www.eurokluc.sk/euro-wc-Sk.html
python3 bin/parse-sk.py euro-wc-Sk.html assets/data-sk.json
```

`Manuály/Project Adjustments Guide.md` is outdated: it describes `assets/url_addresses.yaml` and an in-app Excel parser, and neither exists any more.

## Conventions

- Every Dart source file starts with the REUSE/SPDX header:
  ```dart
  // SPDX-FileCopyrightText: 2024 Ostravská Univerzita
  //
  // SPDX-License-Identifier: MPL-2.0
  ```
- Localization: ARB files in `lib/l10n/` (`app_en.arb` is the template; `app_cs.arb` and `app_sk.arb` must get the same keys). Access strings through `AppLocalizations.of(context)!` from `package:flutter_gen/gen_l10n/app_localizations.dart`. iOS permission prompts and the display name are localized separately in `ios/Runner/{en,cs,sk}.lproj/Localizable.strings`. `Intl.defaultLocale` is `cs_CZ`.
- Errors meant for the user go through `showSnackBar()` (`lib/features/snack_bars/snack_bar_management.dart`), which uses the global `snackBarKey` and works without a `BuildContext`.
- Releases: bump `version:` in `pubspec.yaml` (`X.Y.Z+build`, and the build number must increase for every store upload) in a separate commit titled `Bump version to X.Y.Z+N`. Android release signing reads `android/key.properties`, which is not committed. Android `minSdkVersion`/`targetSdkVersion` are set in `android/app/build.gradle` to meet Google Play requirements.
- Two dependencies are pinned to git sources: `easy_search_bar` (pinned to a specific commit) and `flutter_compass` (overridden with a fork in `dependency_overrides`). Keep these pins when upgrading.
