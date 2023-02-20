import 'package:euk2_project/blocs/location_management_bloc/location_management_bloc.dart';
import 'package:euk2_project/blocs/main_screen_bloc/main_screen_bloc.dart';
import 'package:euk2_project/blocs/screen_navigation_bloc/screen_navigation_bloc.dart';
import 'package:euk2_project/screens/main_screen.dart';
import 'package:euk2_project/themes/theme_collection.dart';
import 'package:euk2_project/themes/theme_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeManager _themeManager = ThemeManager();

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: yellowTheme,
        darkTheme: darkTheme,
        themeMode: _themeManager.themeMode,
        home: const MainScreen(),
      ),
    );
  }
}
