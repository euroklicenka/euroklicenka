
import 'package:euk2_project/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroGuideScreen extends StatelessWidget {
  IntroGuideScreen({super.key});

  final List<PageViewModel> pages = [

    PageViewModel(

        title: 'O EuroKlíčence',
        body: 'Pokud jste majitelem Euroklíče, můžete použít aplikaci EuroKlíčenka k nalezení nejbližšího sociálního zařízení, které Euroklíč umí otevřít.Euroklíče distrubuuje Národní rada osob se zdravotním postižením ČR.',
        footer: const SizedBox(
          height: 45,
          width: 300,

        ),
        image: Center(
          child: Image.asset('assets/images/logo_eu.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            )
        )
    ),
    PageViewModel(
        title: 'Síť pro rodinu',
        body: 'akjfkjdhjksdhfkjasdhfkajsdhfkjasdhfkjasdhfkjasdhfkjasdhfkasjdfhaksdjf',
        footer: const SizedBox(
          height: 45,
          width: 300,

        ),
        image: Center(
          child: Image.asset('assets/images/logo_sit.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            )
        )
    ),
    PageViewModel(
        title: 'O vývoji aplikace',
        body: 'Za vývojem aplikace stojí studentí z Katedry informatiky a počítačů, Přírodvědecké fakulty Ostravské univerzity.'
            'Na tým vývojářů: Bc. Jan Sonnek, Bc. Jan Kunetka, Bc. Ondřej Sládek a Ondřej Zeman, '
            'dohlíželi vyučující: Doc. RNDr. Martin Kotyrba, Ph.D., PhDr. RNDr. Martin Žáček, Ph.D. a RNDr. Marek Vajgl, Ph.D.',
        footer: const SizedBox(
          height: 45,
          width: 300,

        ),
        image: Center(
          child: Image.asset('assets/images/prf_logo.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,

            )
        )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O aplikaci'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 80, 12, 12),
        child: IntroductionScreen(
          pages: pages,
          dotsDecorator: const DotsDecorator(
            size: Size(15,15),
            color: Colors.amber,
            activeSize: Size.square(20),
            activeColor: Colors.lightGreen,
          ),
          showDoneButton: true,
          done: const Text('Start', style: TextStyle(fontSize: 20),),
          showSkipButton: true,
          skip: const Text('Skip', style: TextStyle(fontSize: 20),),
          showNextButton: true,
          next: const Icon(Icons.arrow_forward, size: 25,),
          onDone: () => context.read<MainScreenBloc>().add(OnInitFinish()),
          curve: Curves.bounceOut,
        ),
      ),
    );
  }
}