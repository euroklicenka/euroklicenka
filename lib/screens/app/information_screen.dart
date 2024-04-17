// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/internet_access/allowed_urls.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:eurokey2/widgets/information_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

///The information screen, that shows general info about the app as well as
///it's version.
class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _initIntl();
  }

  Future<void> _initIntl() async {
    await initializeDateFormatting('cs_CZ');
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final backgroundColor = appBarTheme.backgroundColor ?? theme.primaryColor;
    final foregroundColor = appBarTheme.foregroundColor;
    final titleTextStyle = appBarTheme.titleTextStyle ??
        theme.textTheme.titleLarge!.copyWith(color: foregroundColor);

    String tooltipMessage() => Intl.message(
          'Obnovit seznam míst',
          name: 'InformationScreenState_tooltipMessage',
          args: [],
          desc: 'A tooltip for refresh button',
        );

    String refreshDatabaseMessage() => Intl.message('Obnovuji databázi',
        name: 'InformationScreenState_refreshDatabaseMessage',
        args: [],
        desc: 'A snackbar message that informs user about database refresh');

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '${_packageInfo.appName} ${_packageInfo.version}',
          ),
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
                                    'EuroKlíčenka je majetkem Přírodovědecké fakulty ',
                                hyperText: 'Ostravské univerzity',
                                trailingText: ' v\u{00A0}Ostravě.',
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
                                    'Vývoj nové aplikace provedl tým studentů z\u{00A0}',
                                hyperText:
                                    'katedry informatiky a\u{00A0}počítačů',
                                trailingText:
                                    ' OU, do kterého patří Barbora Hajíčková a\u{00A0}Ondřej Surý.  Vývoj původní aplikace provedl Jan Sonnek, Jan Kunetka a\u{00A0}Ondřej Sládek.',
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
                                  leadingText:
                                      'Data o umístění eurozámků jsou veřejně dostupná na ',
                                  hyperText: 'oficiálních stránkách Euroklíče',
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
              Consumer<EurolockProvider>(
                builder: (
                  context,
                  eurolockProvider,
                  child,
                ) {
                  final lastModified =
                      DateFormat('d.M.y').format(eurolockProvider.lastModified);
                  return Text(
                    '.\n\nDatum poslední aktualizace dat: $lastModified',
                  );
                },
              ),
              const Text(
                'Copyright © 2023 Ostravská univerzita',
                textAlign: TextAlign.left,
                style: TextStyle(
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
