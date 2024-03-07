// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:eurokey2/features/icon_management/icon_manager.dart';
import 'package:eurokey2/features/snack_bars/snack_bar_management.dart';
import 'package:eurokey2/providers/eurolock_provider.dart';
import 'package:eurokey2/providers/location_provider.dart';
import 'package:eurokey2/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Represents the EUK2 Splash screen.
class EUKSplashScreen extends StatelessWidget {
  const EUKSplashScreen({super.key});

  Future<bool> _onInitApp(BuildContext context) async {
    final eurolockProvider = context.read<EurolockProvider>();
    final preferencesProvider = context.read<PreferencesProvider>();
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    await precacheMarkerIcon(context);

    await eurolockProvider.onInitApp();
    await preferencesProvider.onInitApp();

    await locationProvider.handlePermissions().catchError((e) {
      showSnackBar(message: e.toString());
    });

    await locationProvider.getCurrentPosition().catchError((e) {
      showSnackBar(message: e.toString());
      return null;
    });

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
          Provider.of<PreferencesProvider>(context, listen: false)
              .onInitFinish();
        } else if (snapshot.hasError) {
          throw snapshot.error.toString();
        }
        return splashScreen(context);
      },
    );
  }
}
