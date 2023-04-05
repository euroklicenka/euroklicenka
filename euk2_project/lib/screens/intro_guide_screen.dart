import 'package:euk2_project/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<GuideScreen> {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'VÍTEJTE V EUROKLÍČENCE',
              body:
                  "Díky mobilní aplikace EuroKlíčenka máte možnost najít všechna nejbližší sociální zařízení, která jsou osazena Eurozámkem.",
              image: buildImage('assets/images/logo_key.png'),
              decoration: getDecoration(),
            ),
            PageViewModel(
              title: 'MAPA',
              body:
                  "Po kliknutí na jednu z ikon se zobrazí informační okno s možností navigovat k danému místu.",
              image: buildImage('assets/images/maps.png'),
              decoration: getDecoration(),
            ),
            PageViewModel(
              title: 'NEJBLIŽŠÍ MÍSTA',
              body:
                  "Pomocí  Wi-fi a GPS se v listu lokací zobrazí místa, která jsou od aktuálí polohy uživatele nejblížě.",
              image: buildImage('assets/images/list_of_place.png'),
              decoration: getDecoration(),
            ),
          ],
          done: const Text("Start"),
          onDone: () => gotoHome(context),
          showNextButton: true,
          next: const Icon(Icons.arrow_forward),
          showSkipButton: true,
          skip: const Text("Skip"),
          onSkip: () => gotoHome(context),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print("Your in $index Screen."),
          isProgressTap: false,
          nextFlex: 0,
        ),
      );
}

void gotoHome(BuildContext context) => context.read<MainScreenBloc>().add(OnInitFinish());

Widget buildImage(String path) => Center(
      child: Image.asset(path),
    ); // just use arrow function { => }

DotsDecorator getDotDecoration() => DotsDecorator(
      //color: Color(0xffbdbdbd),
      size: const Size(10, 10),
      activeSize: const Size(25, 15),
      activeColor: Colors.amber,
      activeShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );

PageDecoration getDecoration() => const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(fontSize: 18),
      bodyPadding: EdgeInsets.all(5),
      imagePadding: EdgeInsets.all(15),
      pageColor: Colors.white,
    );
