import 'package:eurokey2/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              BlocBuilder<LocationManagementBloc, LocationManagementState>(
                builder: (context, state) {
                  if (state is LocationManagementUpdatingDatabaseState) {
                    return (context
                            .read<LocationManagementBloc>()
                            .checkForDataOnline)
                        ? const Text('Stahování lokací z internetu')
                        : const Text('Načítání lokací z úložiště');
                  } else if (state is LocationManagementLoadingPositionState) {
                    return const Text('Příprava polohy');
                  } else {
                    return const Text('Načítání');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
