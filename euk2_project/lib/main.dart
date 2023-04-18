import 'package:euk2_project/blocs/external_map_bloc/external_map_bloc.dart';
import 'package:euk2_project/blocs/list_sorting_bloc/list_sorting_bloc.dart';
import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:euk2_project/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:euk2_project/features/snack_bars/snack_bar_management.dart';
import 'package:euk2_project/screens/main_screen.dart';
import 'package:euk2_project/themes/theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ScreenNavigationBloc(),
        ),
        BlocProvider(
          create: (context) => LocationManagementBloc(navigationBloc: BlocProvider.of<ScreenNavigationBloc>(context)),
        ),
        BlocProvider(
          create: (context) => MainScreenBloc(locationBloc: BlocProvider.of<LocationManagementBloc>(context))..add(OnAppInit()),
        ),
        BlocProvider(
          create: (context) => ListSortingBloc(locManager: BlocProvider.of<LocationManagementBloc>(context).locationManager),
        ),
        BlocProvider(
          create: (context) => ExternalMapBloc(dataManager: BlocProvider.of<MainScreenBloc>(context).dataManager),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: defaultLightTheme,
        themeMode: ThemeMode.light,
        scaffoldMessengerKey: snackBarKey,
        home: const MainScreen(),
      ),
    );
  }
}
