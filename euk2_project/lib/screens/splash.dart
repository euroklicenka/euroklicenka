import 'package:euk2_project/screens/map_page/map_page.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';



class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: const MapScreen(),
      backgroundColor: Colors.white,

      title: const Text('EuroKlíčenka',textScaleFactor: 2,),
      image: Image.asset('assets/images/logo_key.png', scale: 0.5,),
      loadingText: Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.green,
    );
  }
}

class TestSplashScreen extends StatelessWidget {
  const TestSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/images/logo_key.png', height: screenHeight * 0.25,),
            const SizedBox(height: 16,),
            const Text('EuroKlíčenka', textScaleFactor: 2,),
            const SizedBox(height: 150,),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
