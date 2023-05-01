import 'package:flutter/material.dart';

/// Represents the EUK2 Splash screen.
class EUKSplashScreen extends StatelessWidget {
  const EUKSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (MediaQuery.of(context).size.height > 310) Image.asset('assets/images/logo_key.png', height: screenHeight * 0.25,),
                SizedBox(height: screenHeight * 0.03),
                const Text('EuroKlíčenka', textScaleFactor: 2,),
                SizedBox(height: screenHeight * 0.1),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
    );
  }
}
