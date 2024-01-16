// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/internet_access/allowed_urls.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:eurokey2/widgets/information_tile.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    Color? backgroundColor = appBarTheme.backgroundColor ?? theme.primaryColor;

    final textColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('O aplikaci')),
        backgroundColor: backgroundColor,
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
                        const SizedBox(height: 56),
                        Image.asset(
                          'assets/images/logo_key.png',
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${_packageInfo.appName} ${_packageInfo.version}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: textColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 64, bottom: 8),
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
                              infoTile(
                                context: context,
                                leadingText:
                                    'Data o umístění eurozámků jsou veřejně dostupná na ',
                                hyperText: 'oficiálních stránkách Euroklíče',
                                trailingText: '.',
                                imageFilePath: 'assets/images/logo_eurokey.png',
                                launchURL: aboutEuroKeyWebURL,
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
              Text(
                'Copyright © 2023 Ostravská univerzita',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
