import 'package:eurokey2/features/internet_access/allowed_urls.dart';
import 'package:eurokey2/features/internet_access/http_communicator.dart';
import 'package:eurokey2/models/preferences_model.dart';
import 'package:eurokey2/utils/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<GuideScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'VÍTEJTE V EUROKLÍČENCE',
            image: _buildImage('assets/images/logo_key.png', context),
            body:
                'Díky této aplikace máte možnost najít \nv České republice všechna eurozámkem osazená sociální zařízení.',
            footer: _buildButton(
              onPressed: () => openURL(url: aboutEuroKeyURL),
              text: 'Co je to eurozámek?',
            ),
            decoration: _getDecoration(),
          ),
          PageViewModel(
            title: 'MAPA',
            image: _buildImage(
              context.isAppInDarkMode
                  ? 'assets/images/img_guide_map_dark.jpg'
                  : 'assets/images/img_guide_map_light.jpg',
              context,
            ),
            body:
                'Po spuštění aplikace se zobrazí mapa nejbližšího okolí, na němž jsou vyznačena místa pro Euroklíč.',
            footer: _buildButton(onPressed: null, text: ''),
            decoration: _getDecoration(),
          ),
          PageViewModel(
            title: 'INFORMACE O MÍSTĚ',
            image: _buildImage(
              context.isAppInDarkMode
                  ? 'assets/images/img_guide_popup_dark.jpg'
                  : 'assets/images/img_guide_popup_light.jpg',
              context,
            ),
            body:
                'Po kliknutí na jeden z bodů se zobrazí informační okno s možností navigovat\nk danému místu.',
            footer: _buildButton(onPressed: null, text: ''),
            decoration: _getDecoration(),
          ),
          PageViewModel(
            title: 'NEJBLIŽŠÍ MÍSTA',
            body:
                'Na listě lokací se zobrazují nejbližší místa \nk aktuální poloze uživatele. Volbou položky dojde k jejímu zobrazení na mapě.',
            image: _buildImage(
              context.isAppInDarkMode
                  ? 'assets/images/img_guide_list_dark.jpg'
                  : 'assets/images/img_guide_list_light.jpg',
              context,
            ),
            footer: _buildButton(onPressed: null, text: ''),
            decoration: _getDecoration(),
          ),
        ],
        animationDuration: 150,
        done: const Text("Start"),
        onDone: () => _gotoHome(context),
        next: const Icon(Icons.arrow_forward),

        // showing skip button
        showSkipButton: true,
        skip: const Text("Skip"),
        onSkip: () => _gotoHome(context),
        dotsDecorator: _getDotDecoration(context),
        isProgressTap: false,
      ),
    );
  }

  void _gotoHome(BuildContext context) =>
      Provider.of<PreferencesModel>(context, listen: false).onInitFinish();

  Widget? _buildImage(String path, BuildContext context) {
    final bool isTooSmall = MediaQuery.of(context).size.height < 490;
    return !isTooSmall
        ? Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                path,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          )
        : null;
  }

  Widget _buildButton({required Function()? onPressed, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: OutlinedButton(
        onPressed: onPressed,
        style: (onPressed == null)
            ? const ButtonStyle(
                side: MaterialStatePropertyAll(BorderSide.none),
              )
            : OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
        child: Text(text),
      ),
    );
  }

  DotsDecorator _getDotDecoration(BuildContext context) => DotsDecorator(
        size: const Size(10, 10),
        activeSize: const Size(25, 15),
        activeColor: Theme.of(context).colorScheme.secondary,
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      );

  PageDecoration _getDecoration() => const PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: TextStyle(fontSize: 18),
        bodyPadding: EdgeInsets.all(5),
        imagePadding: EdgeInsets.all(15),
        bodyAlignment: Alignment.center,
        imageFlex: 2,
        footerFlex: 0,
      );
}
