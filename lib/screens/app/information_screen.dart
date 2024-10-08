// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/internet_access/allowed_urls.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:eurokey2/widgets/information_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///The information screen, that shows general info about the app as well as
///it's version.
class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final backgroundColor = appBarTheme.backgroundColor ?? theme.primaryColor;
    final foregroundColor = appBarTheme.foregroundColor;
    final titleTextStyle = appBarTheme.titleTextStyle ??
        theme.textTheme.titleLarge!.copyWith(color: foregroundColor);

    String tooltipMessage() => Intl.message(
          AppLocalizations.of(context)!.languageSettingsTileLabel,
          name: 'InformationScreenState_tooltipMessage',
          args: [],
          desc: 'A tooltip for refresh button',
        );

    String refreshDatabaseMessage() => Intl.message(
        AppLocalizations.of(context)!.refreshDatabaseMessage,
        name: 'InformationScreenState_refreshDatabaseMessage',
        args: [],
        desc: 'A snackbar message that informs user about database refresh');

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(AppLocalizations.of(context)!.aboutApplicationLabel),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: tooltipMessage(),
            onPressed: () {
              final eurolockProvider =
                  Provider.of<EurolockProvider>(context, listen: false);
              eurolockProvider.sync(true);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(refreshDatabaseMessage())),
              );
            },
          ),
        ],
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        titleTextStyle: titleTextStyle,
        elevation: 5.5,
        shadowColor: const Color.fromARGB(255, 209, 209, 209),
      ),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 24, bottom: 16, left: 24, right: 24),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Column(
                            children: [
                              infoTile(
                                context: context,
                                leadingText:
                                    AppLocalizations.of(context)!.leadingText1,
                                hyperText:
                                    AppLocalizations.of(context)!.hyperText1,
                                trailingText:
                                    '${AppLocalizations.of(context)!.trailingText1a}${'\u{00A0}'}${AppLocalizations.of(context)!.trailingText1b}',
                                imageFilePath: context.isAppInDarkMode
                                    ? 'assets/images/logo_prf_dark.png'
                                    : 'assets/images/logo_prf_light.png',
                                launchURL: universityOfOstravaURL,
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                color: Color.fromARGB(255, 151, 151, 151),
                                thickness: 0.5,
                              ),
                              const SizedBox(height: 10),
                              infoTile(
                                context: context,
                                leadingText:
                                    '${AppLocalizations.of(context)!.leadingText2}${'\u{00A0}'}',
                                hyperText:
                                    '${'\u{00A0}'}${AppLocalizations.of(context)!.hyperText2}',
                                trailingText:
                                    '${AppLocalizations.of(context)!.trailingText2a}${'\u{00A0}'}${AppLocalizations.of(context)!.trailingText2b}${'\u{00A0}'}${AppLocalizations.of(context)!.trailingText2c}',
                                imageFilePath: 'assets/images/logo_kip.png',
                                launchURL: universityOfOstravaKIPURL,
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                color: Color.fromARGB(255, 151, 151, 151),
                                thickness: 0.5,
                              ),
                              const SizedBox(height: 10),
                              Consumer<EurolockProvider>(
                                builder: (
                                  context,
                                  eurolockProvider,
                                  child,
                                ) =>
                                    infoTile(
                                  context: context,
                                  leadingText: AppLocalizations.of(context)!
                                      .leadingText3,
                                  hyperText:
                                      AppLocalizations.of(context)!.hyperText3,
                                  imageFilePath:
                                      'assets/images/logo_eurokey.png',
                                  launchURL: aboutEuroKeyWebURL,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Color.fromARGB(255, 151, 151, 151),
                thickness: 0.5,
              ),
              const SizedBox(height: 1),
              Text(
                AppLocalizations.of(context)!.copyrightLabel,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
