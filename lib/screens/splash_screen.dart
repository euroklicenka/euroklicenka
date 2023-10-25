import 'package:eurokey2/models/eurolock_model.dart';
import 'package:eurokey2/models/location_model.dart';
import 'package:eurokey2/models/preferences_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Represents the EUK2 Splash screen.
class EUKSplashScreen extends StatelessWidget {
  const EUKSplashScreen({super.key});

  Future<bool> _onInitApp(BuildContext context) async {
    final eukModel = context.read<EurolockModel>();
    final preferencesModel = context.read<PreferencesModel>();
    final locationModel = Provider.of<LocationModel>(context, listen: false);

    await eukModel.onInitApp();
    await preferencesModel.onInitApp();

    locationModel.currentPosition = await locationModel.determinePosition();

    return true;
  }

  Widget splashScreen(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
                textScaler: TextScaler.linear(2),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _onInitApp(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<PreferencesModel>(context, listen: false).onInitFinish();
        } else if (snapshot.hasError) {
          throw snapshot.error.toString();
        }
        return splashScreen(context);
      },
    );
  }
}
