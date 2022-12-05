import 'package:euk2_project/pages/map_page/map_page.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';


class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: const MapPage(),
      backgroundColor: Colors.white,

      title: const Text('EuroKlíčenka',textScaleFactor: 2,),
      image: Image.asset('assets/images/logo_key.png', scale: 0.5,),
      loadingText: Text("Loading"),
      photoSize: 150.0,
      loaderColor: Colors.green,
    );
  }
}