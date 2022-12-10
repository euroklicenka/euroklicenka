import 'package:flutter/material.dart';

/// Represents the EUK2 Splash screen.
class EUKSplashScreen extends StatelessWidget {
  const EUKSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ColoredBox(
        color: Colors.white,
        child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/images/logo_key.png', height: screenHeight * 0.25,),
                  const SizedBox(height: 16,),
                  const Text('EuroKlíčenka', textScaleFactor: 2,),
                  const SizedBox(height: 86,),
                  const CircularProgressIndicator(),
                  SizedBox(height: screenHeight * 0.15,)
                ],
              ),
            ),
          ),
      ),
    );
  }
}
