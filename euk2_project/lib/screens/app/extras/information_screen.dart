import 'package:eurokey2/features/internet_access/allowed_urls.dart';
import 'package:eurokey2/themes/theme_utils.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:eurokey2/version_label.dart';
import 'package:eurokey2/widgets/information_tile.dart';
import 'package:flutter/material.dart';

///The information screen, that shows general info about the app as well as
///it's version.
class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Scaffold(
      appBar: AppBar(
        title: const Text('O aplikaci'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 16, left: 24, right: 24),
          child: Column(
              children: [
          Expanded(
          child: Scrollbar(
          child: SingleChildScrollView(
          child: Column(
          children: [
          const SizedBox(height: 56),
          Image.asset('assets/images/logo_key.png', width: screenSize.width * 0.25),
          const SizedBox(height: 12),
          Text(
            'EuroKlíčenka $appVersion',
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
                InfoTile(
                  screenSize: screenSize,
                  leadingText: 'EuroKlíčenka je majetkem Přírodovědecké fakulty',
                  hyperText: 'Ostravské univerzity',
                  trailingText: 'v Ostravě.',
                  imageFilePath: context.isAppInDarkMode ? 'assets/images/logo_prf_dark.png' : 'assets/images/logo_prf_light.png',
                  launchURL: universityOfOstravaURL,
                ),
                const Divider(),
                InfoTile(
                  screenSize: screenSize,
                  leadingText: 'Vývoj provedl tým studentů z ',
                  hyperText: 'katedry informatiky a počítačů',
                  trailingText: ' OU, do kterého patří Jan Sonnek, Jan Kunetka\na Ondřej Sládek.',
                  imageFilePath: 'assets/images/logo_kip.png',
                  launchURL: universityOfOstravaKIPURL,
                ),
                const Divider(),
                InfoTile(
                  screenSize: screenSize,
                  leadingText: 'Data o umístění eurozámků jsou veřejně dostupná',
                  hyperText: '\nna oficiálních stránkách Euroklíče',
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
                  copyrightInfo,
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