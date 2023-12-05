import 'package:eurokey2/models/preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Represents the EUK2 Splash screen.
class EUKSplashScreen extends StatelessWidget {
  const EUKSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    // Don't show this more than once
    Provider.of<PreferencesModel>(context, listen: false).onInitFinish();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (MediaQuery.of(context).size.height > 310)
                Image.asset(
                  'assets/images/logo_key.png',
                  height: screenHeight * 0.25,
                ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'EuroKlíčenka',
                textScaleFactor: 2,
              ),
              SizedBox(height: screenHeight * 0.1),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
