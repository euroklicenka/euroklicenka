// SPDX-FileCopyrightText: 2024 Ostravská Univerzita
//
// SPDX-License-Identifier: MPL-2.0

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
              if (MediaQuery.of(context).size.height > 310)
                Padding(
                  padding: const EdgeInsets.only(right: 21),
                  child: Image.asset(
                    'assets/images/logo_key.png',
                    height: screenHeight * 0.25,
                  ),
                ),
              SizedBox(height: screenHeight * 0.02),
              const Text(
                'EuroKlíčenka', // FIXME
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
}
