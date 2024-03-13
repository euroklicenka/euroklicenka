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

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '${_packageInfo.appName} ${_packageInfo.version}',
          ),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        titleTextStyle: titleTextStyle,
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
                              const Divider(),
                              infoTile(
                                context: context,
                                leadingText:
                                    'Vývoj nové aplikace provedl tým studentů z\u{00A0}',
                                hyperText:
                                    'katedry informatiky a\u{00A0}počítačů',
                                trailingText:
                                    ' OU, do kterého patří Barbora Hájičková a\u{00A0}Ondřej Surý.  Vývoj původní aplikace provedl Jan Sonnek, Jan Kunetka a\u{00A0}Ondřej Sládek.',
                                imageFilePath: 'assets/images/logo_kip.png',
                                launchURL: universityOfOstravaKIPURL,
                              ),
                              const Divider(),
                              Consumer<EurolockProvider>(
                                builder: (
                                  context,
                                  eurolockProvider,
                                  child,
                                ) {
                                  final lastModified = DateFormat('d.M.y')
                                      .format(eurolockProvider.lastModified);
                                  return infoTile(
                                    context: context,
                                    leadingText:
                                        'Data o umístění eurozámků jsou veřejně dostupná na ',
                                    hyperText:
                                        'oficiálních stránkách Euroklíče',
                                    trailingText:
                                        '.\n\nDatum poslední aktualizace dat: $lastModified',
                                    imageFilePath:
                                        'assets/images/logo_eurokey.png',
                                    launchURL: aboutEuroKeyWebURL,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 4),
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
